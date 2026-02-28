//=============================================================================
// NetworkTerminal.
//=============================================================================
class NetworkTerminal extends DeusExBaseWindow
	abstract;

var ComputerUIWindow           winComputer;		// Currently active computer screen
var ComputerScreenHack         winHack;			// Ice Breaker Hack Window
var ShadowWindow               winHackShadow;
var ComputerScreenHackAccounts winHackAccounts; // Hack Accounts Window, used for email
var ShadowWindow               winHackAccountsShadow;
var ElectronicDevices          compOwner;		// what computer owns this window?

var Class<ComputerUIWindow> FirstScreen;	// First screen to push
var Class<ComputerUIWindow> LockoutScreen;	// Lockout Screen

// Hacking related variables
var float loginTime;			// time that the user logged in
var float detectionTime;		// total time a user may be logged on
var int   kickTimerID;			// timer ID for kicking the user off
var int   skillLevel;			// player's computer skill level (0-3)
var bool  bHacked;				// this computer has been hacked
var bool  bNoHack;				// this computer has been purposely not hacked
var bool  bUsesHackWindow;		// True if Hack Window created by default.
var float liveDetectionTime;                                                    //RSD: Added for tracking the detection time when we finish hacking

// Login related variables
var string userName;
var int    userIndex;

// Shadow stuff
var int shadowOffsetX;
var int shadowOffsetY;

var HUDKeypadNotesWindow winNotes;

var const bool bShowNotes;         //SARGE: Added. Show the notes on the first screen(usually login).

//This sucks.
//So basically, we have to check EVERY username from a given note, to see if it's our current username.
//If it is, then we need to get the NEXT valid username/password from the note.
function GetNextAutofillUsername(DeusExNote note, out string code1, out string code2)
{
    local string typedUsername;
    local int i, j, valid;
    local string validUsernames[8];
    local string validPasswords[8];
    local string u1, p1;
    local bool bNext;
    local Computers C;
    local ATM A;

    //First, get the user name
    if (winComputer != None && ComputerScreenLogin(winComputer) != None)
        typedUsername = ComputerScreenLogin(winComputer).editUserName.GetText();
    else if (winComputer != None && ComputerScreenATM(winComputer) != None)
        typedUsername = ComputerScreenATM(winComputer).editAccount.GetText();
    
    C = Computers(compOwner);
    A = ATM(compOwner);
    
    //Get all the possible codes for the note.
    //We will only get the first 8, no note has more than that...
    for (i = 0;i < 8;i++)
    {
        class'CodeUtils'.static.GetCodeFromNote(note,i,u1,p1);
        if (u1 != "")
        {
            validUsernames[valid] = u1;
            validPasswords[valid] = p1;
            valid++;
        }
    }

    //In non-hardcore mode, if we haven't typed anything, just get the first valid code
    if ((!player.bHardCoreMode && player.iNoKeypadCheese == 0) || player.bGMDXDebug)
    {
        if (typedUsername == "")
        {
            for (i = 0;i < valid;i++)
            {
                for (j = 0;j < 8;j++)
                {
                    if (C != None && caps(validUsernames[i]) == caps(C.GetUserName(j)) && caps(validPasswords[i]) == caps(C.GetPassword(j)))
                    {
                        code1 = validUsernames[i];
                        code2 = validPasswords[i];
                        return;
                    }
                    else if (A != None && caps(validUsernames[i]) == caps(A.GetAccountNumber(j)) && caps(validPasswords[i]) == caps(A.GetPIN(j)))
                    {
                        code1 = validUsernames[i];
                        code2 = validPasswords[i];
                        return;
                    }
                }
            }
        }
    }

    //Now go through the usernames list and find if we have one that matches our typed username.
    //If so, select the NEXT one
    for (i = 0;i < 8;i++)
    {
        if (bNext)
        {
            code1 = validUsernames[i];
            code2 = validPasswords[i];
            return;
        }

        if (caps(typedUsername) == caps(validUsernames[i]))
            bNext = true;
    }
    
    //If we needed to wrap around, or none were valid, just get the first one.
    if (valid > 0)
    {
        code1 = validUsernames[0];
        code2 = validPasswords[0];
    }
}

function AutofillNote(DeusExNote note)
{
    local string code1, code2;

    //If we already have a username/password, get the next one
    //from the note. This lets us "loop" through note autofill
    GetNextAutofillUsername(note,code1,code2);

    if (winComputer != None && ComputerScreenLogin(winComputer) != None)
    {
        if (code1 != "")
            ComputerScreenLogin(winComputer).editUserName.SetText(code1);
        if (code2 != "")
            ComputerScreenLogin(winComputer).editPassword.SetText(code2);
    }
    
    else if (winComputer != None && ComputerScreenATM(winComputer) != None)
    {
        if (code1 != "")
            ComputerScreenATM(winComputer).editAccount.SetText(code1);
        if (code2 != "")
            ComputerScreenATM(winComputer).editPIN.SetText(code2);
    }

    if (code1 != "" || code2 != "")
        PlaySound(Sound'Menu_Activate', 0.25);
}

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
    Super.InitWindow();

	SetWindowAlignments(HALIGN_Full, VALIGN_Full);

	// Draw a black background for now
	//if (!player.bRealUI && !player.bHardcoreMode)                               //RSD: only if we don't have realtime UI (Hardcore)
	//{
	SetBackgroundStyle(DSTY_Normal);
	SetBackground(Texture'Solid');
	SetTileColorRGB(0, 0, 0);
	//}

	SetMouseFocusMode(MFOCUS_Click);

	root.ShowHUD(False);

	CreateHackWindow();

	bTickEnabled = True;
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Destroys the Window
// ----------------------------------------------------------------------

event DestroyWindow()
{
    //SARGE: Destroy the notes window too
    if (winNotes != None)
    {
        winNotes.DestroyWindow();
        winNotes.DestroyAllChildren();
        winNotes.Destroy();
        winNotes = None;
    }

	if (compOwner != None && compOwner.IsA('Computers'))
	{
      if (Player != Player.GetPlayerPawn())
      {
         log("==============>Player mismatch!!!!");
      }
		// Keep track of the last time this computer was hacked
      else if (player.ActiveComputer == CompOwner)
      {
         if (bHacked)
            player.SetComputerHackTime(Computers(compOwner),player.level.TimeSeconds-liveDetectionTime, player.level.TimeSeconds); //RSD: Subtracting current detection time so we don't start at 0
         player.CloseComputerScreen(Computers(compOwner));
         player.ActiveComputer = None;
      }

		Computers(compOwner).termWindow = None;
	}
	else if (compOwner.IsA('ATM'))
	{
		// Keep track of the last time this computer was hacked
		if (bHacked)
			ATM(compOwner).lastHackTime = player.Level.TimeSeconds - liveDetectionTime; //RSD: Subtracting current detection time so we don't start at 0

		ATM(compOwner).atmWindow = None;
	}

	// Show the HUD again
	root.ShowHUD(True);

	// Now finish destroy us.
	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// Tick()
//
// Checks to see if the player has died, and if so, gets us the
// hell out of this screen!!
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	if ((player != None) && (player.IsInState('Dying')))
	{
		bTickEnabled = False;
		CloseScreen("EXIT");
   }
   else
   {
      // DEUS_EX AMSD Put this in an else.  Don't do this if you are dead and have
      // closed the screen!
      // Update the hack bar detection time
      UpdateHackDetectionTime();
   }
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
//
// Used to Manually place the computer screen if the Hack window
// is visible and the computer screen's position would overlap
// the hack window.
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float hackWidth, hackHeight;
	local float hackAccountsWidth, hackAccountsHeight;
	local float compWidth, compHeight;
	local float compX;

	// First look for the hack window.  If it's not visible, then
	// our work here is done!

	if (winHack != None)
	{
		winHack.QueryPreferredSize(hackWidth, hackHeight);

		// Shove in upper-right hand corner
		winHack.ConfigureChild(
			width - hackWidth, 0,
			hackWidth, hackHeight);

		// Place shadow
		winHackShadow.ConfigureChild(
			width - hackWidth + winHack.backgroundPosX - shadowOffsetX,
			winHack.backgroundPosY - shadowOffsetY,
			winHack.backgroundWidth + (shadowOffsetX * 2),
			winHack.backgroundHeight + (shadowOffsetY * 2));
	}

	// Check for the Hack Accounts window, which is displayed
	// underneath the Hack window.  Position under the Hack Window

	if (winHackAccounts != None)
	{
		winHackAccounts.QueryPreferredSize(hackAccountsWidth, hackAccountsHeight);
		winHackAccounts.ConfigureChild(
			width - hackAccountsWidth, hackHeight + 20,
			hackAccountsWidth, hackAccountsHeight);

		// Place shadow
		winHackAccountsShadow.ConfigureChild(
			width - hackAccountsWidth + winHackAccounts.backgroundPosX - shadowOffsetX,
			hackHeight + 20 + winHackAccounts.backgroundPosY - shadowOffsetY,
			winHackAccounts.backgroundWidth + (shadowOffsetX * 2),
			winHackAccounts.backgroundHeight + (shadowOffsetY * 2));
	}

	// Now check to see if we have a computer screen.  If so,
	// center it in relation to the hack window.  Don't force
	// position if the window has been dragged somewhere else
	// by the user.

	if ((winComputer != None) && (!winComputer.bWindowDragged))
	{
		winComputer.QueryPreferredSize(compWidth, compHeight);

		// Center the window, but move it left if the height of the
		// hack window would infringe on the window (unless the
		// "bAlwaysCenter" flag is set)

		if (((hackHeight + hackAccountsHeight + 20) > ((height / 2) - (compHeight / 2))) &&
		    (!winComputer.bAlwaysCenter))
		{
			compX = (width - hackWidth) / 2 - (compWidth / 2);
		}
		else
		{
			compX = (width / 2) - (compWidth / 2);
		}

		winComputer.ConfigureChild(
			compX, (height / 2) - (compHeight / 2),
			compWidth, compHeight);
	}
}

// ----------------------------------------------------------------------------------
// VirtualKeyPressed
// ----------------------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local String KeyName, Alias;
	local bool bKeyHandled;

	bKeyHandled = False;

	if ( Player.Level.NetMode != NM_Standalone )
	{
		// Let them send chat messages while hacking
		KeyName = player.ConsoleCommand("KEYNAME "$key );
		Alias = 	player.ConsoleCommand( "KEYBINDING "$KeyName );

		if ( Alias ~= "Talk" )
		{
			log("===>trying to talk..." );
			Player.Player.Console.Talk();
			bKeyHandled = True;
		}
		else if ( Alias ~= "TeamTalk" )
		{
			log("===>trying to teamtalk..." );
			Player.Player.Console.TeamTalk();
			bKeyHandled = True;
		}
	}

	if ( bKeyHandled )
		return True;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}


// ----------------------------------------------------------------------
// ShowFirstScreen()
// ----------------------------------------------------------------------

function ShowFirstScreen()
{
    if (Computers(compOwner) != None && Computers(compOwner).allowHackingLockout && Computers(compOwner).timesHacked > player.SkillSystem.GetSkillLevel(class'SkillComputer') && (player.bHardcoreMode || player.bHackLockouts))
        ShowScreen(LockoutScreen);
    else
    	ShowScreen(FirstScreen);
    //Show the notes screen
    if (winNotes != None)
    {
        winNotes.Show();
        winNotes.ResetNotePosition();
    }
}

// ----------------------------------------------------------------------
// ShowScreen()
// ----------------------------------------------------------------------

function ShowScreen(Class<ComputerUIWindow> newScreen)
{
	// First close any existing screen
	if (winComputer != None)
	{
        winComputer.winNotes = None;
		winComputer.Destroy();
		winComputer = None;
	}

	// Now invoke the new screen
	if (newScreen != None)
	{
		winComputer = ComputerUIWindow(NewChild(newScreen));
		winComputer.SetWindowAlignments(HALIGN_Center, VALIGN_Center);

        //SARGE: 11th hour hack!
        if (compOwner.IsA('ComputerSecurity'))
        {
            winComputer.SetCompOwner(compOwner);
            winComputer.SetNetworkTerminal(Self);
        }
        else
        {
            winComputer.SetNetworkTerminal(Self);
            winComputer.SetCompOwner(compOwner);
        }

        if (winNotes != None)
        {
            winComputer.SetNotesWindow(winNotes);
        }
		winComputer.Lower();
	}
}

// ----------------------------------------------------------------------
// CloseScreen()
// ----------------------------------------------------------------------

function CloseScreen(String action)
{
	// First destroy the current screen
	if (winComputer != None)
	{
        winComputer.winNotes = None;
		winComputer.Destroy();
		winComputer = None;
	}

	// Based on the action, proceed!
	if (action == "EXIT")
	{
	
        // destroy notes
        if (winNotes != None)
        {
            winNotes.DestroyAllChildren();
            winNotes.DestroyWindow();
            winNotes.Destroy();
            winNotes = None;
        }

		if (Computers(compOwner) != None)
			player.CloseComputerScreen(Computers(compOwner));
		root.PopWindow();
		return;
	}

	// If the user is logging in and bypassing the Hack screen,
	// then destroy the Hack window

	if ((action == "LOGIN") && (winHack != None) && (!bHacked))
	{
		CloseHackWindow();
		bNoHack = True;
	}
	
    //SARGE: Hide notes screen when logging in
    if (action == "LOGIN")
    {
        if (winNotes != None)
            winNotes.Hide();
    }
	
    //SARGE: Re-show notes and the hack window when logging out.
    if (action == "LOGOUT")
    {
        if (winNotes != None)
        {
            winNotes.Show();
            winNotes.ResetNotePosition();
        }
        CreateHackWindow();
		bNoHack = False;
    }
}

// ----------------------------------------------------------------------
// CloseHackWindow()
// ----------------------------------------------------------------------

function CloseHackWindow()
{
	if (winHack != None)
	{
		winHack.Destroy();
		winHack = None;

		winHackShadow.Destroy();
		winHackShadow = None;
	}
}

// ----------------------------------------------------------------------
// ForceCloseScreen()
// ----------------------------------------------------------------------

function ForceCloseScreen()
{
	// If a screen is active, tell it to exit
	if (winComputer != None)
		winComputer.CloseScreen(winComputer.escapeAction);
}

// ----------------------------------------------------------------------
// CreateHackWindow()
// ----------------------------------------------------------------------

function CreateHackWindow()
{
	local Float hackTime;
	local Float skillLevelValue;
    local Inventory nuke;

	skillLevelValue = player.SkillSystem.GetSkillLevelValue(class'SkillComputer');
	skillLevel      = player.SkillSystem.GetSkillLevel(class'SkillComputer');
	nuke            = player.FindInventoryType(class'SoftwareNuke');

	// Check to see if the player is skilled in Hacking before
	// creating the window
	if ((skillLevel > 0 || nuke != None) && (bUsesHackWindow))
	{
	    //if (skillLevel <= 1 && IsA('NetworkTerminalATM'))
	    //return;         //CyberP: ATM's need advanced hacking
		// Base the detection and hack time on the skill level
		hackTime       = detectionTime / (skillLevelValue * 1.5);
		detectionTime *= skillLevelValue;

		// First create the shadow window
		winHackShadow = ShadowWindow(NewChild(Class'ShadowWindow'));

		winHack = ComputerScreenHack(NewChild(Class'ComputerScreenHack'));
		winHack.SetNetworkTerminal(Self);
		winHack.SetDetectionTime(detectionTime, hackTime);
				
        winHack.SetDetectionProbability(1.0);  //CyberP: set all to 1.0 to essentially remove this functionality

        //disable the "Hack" button if our skill level is untrained,
        //which means we're using a nuke
        if (skillLevel == 0)
        {
            winHack.btnHack.SetSensitivity(false);
            skillLevel = 1;
        }
	}
}

//SARGE: Add a notes window showing all relevant notes.
function AddNotesWindow()
{
    local DeusExNote codeNotes[10];
    local DeusExNote note;
    local int numCodes;
    local Computers C;
    local ATM A;
    local int i;

    if (!player.bShowCodeNotes || !bShowNotes || player.RandomizerEnabled())
        return;

    C = Computers(compOwner);
    A = ATM(compOwner);

    if (C != None)
    {
        for (i = 0; i < 8;i++)
        {
            note = player.GetCodeNote(C.GetUserName(i),C.GetPassword(i),true);
            
            if (note != None)
                codeNotes[numCodes++] = note;
        }
    }
    else if (A != None)
    {
        for (i = 0; i < 8;i++)
        {
            note = player.GetCodeNote(A.GetAccountNumber(i),A.GetPIN(i),true);

            if (note != None)
                codeNotes[numCodes++] = note;
        }
    }
    
    //SARGE: Dirty hack alert!!!!
    if (numCodes == 0 && ((!player.bHardCoreMode && player.iNoKeypadCheese == 0) || player.bGMDXDebug))
        return;

    if (!player.HasAnyNotes())
        return;

    if (winNotes == None)
    {
        winNotes = HUDKeypadNotesWindow(NewChild(Class'HUDKeypadNotesWindow'));
    }
    winNotes.bUseMenuColors = true;
    for (i = 0; i < numCodes;i++)
        winNotes.AddNote(codeNotes[i]);
    winNotes.SetEditable(!player.bAutofillPasswords);
    winNotes.CreateNotesList();
    winNotes.StyleChanged();
    winNotes.SetParentWindow(self);
    winNotes.Hide();
}

// ----------------------------------------------------------------------
// CreateHackAccountsWindow()
//
// Create the window used to hack email accounts, but only create it if
// the player hacked into the computer *and* there's more than one
// account to display
// ----------------------------------------------------------------------

function CreateHackAccountsWindow()
{
	if ((bHacked) && (winHackAccounts == None) && (Computers(compOwner).NumUsers() > 1))
	{
		// First create the shadow window
		winHackAccountsShadow = ShadowWindow(NewChild(Class'ShadowWindow'));

		winHackAccounts = ComputerScreenHackAccounts(NewChild(Class'ComputerScreenHackAccounts'));
		winHackAccounts.SetNetworkTerminal(Self);
		winHackAccounts.SetCompOwner(compOwner);
		winHackAccounts.AskParentForReconfigure();
	}
}

// ----------------------------------------------------------------------
// CloseHackAccountsWindow()
// ----------------------------------------------------------------------

function CloseHackAccountsWindow()
{
	if (winHackAccounts != None)
	{
		winHackAccounts.Destroy();
		winHackAccounts = None;

		winHackAccountsShadow.Destroy();
		winHackAccountsShadow = None;
	}
}

// ----------------------------------------------------------------------
// SetHackButtonToReturn()
// ----------------------------------------------------------------------

function SetHackButtonToReturn()
{
	if ((bHacked) && (winHack != None))
		winHack.SetHackButtonToReturn();
}

// ----------------------------------------------------------------------
// SetCompOwner()
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	compOwner = newCompOwner;

	if (winComputer != None)
		winComputer.SetCompOwner(compOwner);

        //CyberP: pass the computer's security level to the hack window
        if (winHack != None)
        {
		if (compOwner.IsA('ATM'))
		winHack.passedSecLevel = ATM(compOwner).ATMSecLevel;
		else if (compOwner.IsA('ComputerSecurity'))
		winHack.passedSecLevel = ComputerSecurity(compOwner).secLevel;
		else if (compOwner.IsA('ComputerPersonal'))
		winHack.passedSecLevel = ComputerPersonal(compOwner).secLevel;
		else
		winHack.passedSecLevel = 0;
		}
	// Update the hack bar detection time
	UpdateHackDetectionTime();
		
    AddNotesWindow();
}

// ----------------------------------------------------------------------
// UpdateHackDetectionTime()
// ----------------------------------------------------------------------

function UpdateHackDetectionTime()
{
	local Float diff;
	local Float detectionTime;

	// If the hack window is active, then we need to update
	// the detection time
	if ((winHack != None) && (!winhack.bHacking) && (compOwner != None) && (!bHacked))
	{
		detectionTime = winHack.GetSaveDetectionTime();

		if (compOwner.IsA('Computers'))
		{
			diff = player.Level.TimeSeconds - Computers(compOwner).lastHackTime;
		}
		else
			diff = player.Level.TimeSeconds - ATM(compOwner).lastHackTime;

		if (diff < detectionTime)
			winHack.UpdateDetectionTime(diff + 0.5);
	}
	else if (winHack != None)                                                   //RSD: Added for tracking the detection time when we finish hacking
	    liveDetectionTime = winHack.GetDetectionTime();
}

// ----------------------------------------------------------------------
// SetLoginInfo()
// ----------------------------------------------------------------------

function SetLoginInfo(String newUserName, Int newUserIndex)
{
	userName  = newUserName;
	userIndex = newUserIndex;
}

// ----------------------------------------------------------------------
// ChangeAccount()
// ----------------------------------------------------------------------

function ChangeAccount(int newUserIndex)
{
	userIndex = newUserIndex;

	if (compOwner != None)
		userName  = Computers(compOwner).GetUserName(userIndex);

	// Notify the computer window
	if (winComputer != None)
		winComputer.ChangeAccount();
}

// ----------------------------------------------------------------------
// GetUserName()
// ----------------------------------------------------------------------

function String GetUserName()
{
	return userName;
}

// ----------------------------------------------------------------------
// GetUserIndex()
// ----------------------------------------------------------------------

function int GetUserIndex()
{
	return userIndex;
}

// ----------------------------------------------------------------------
// SetSkillLevel()
// ----------------------------------------------------------------------

function SetSkillLevel(int newSkillLevel)
{
	skillLevel = newSkillLevel;
}

// ----------------------------------------------------------------------
// GetSkillLevel()
// ----------------------------------------------------------------------

function int GetSkillLevel()
{
	return skillLevel;
}

// ----------------------------------------------------------------------
// ComputerHacked()
//
// Computer was hacked, allow user to login
// ----------------------------------------------------------------------

function ComputerHacked()
{
	bHacked = True;

	// Use the first login
	userIndex = 0;

	if (compOwner != None && compOwner.IsA('Computers'))
    {
		userName  = Computers(compOwner).GetUserName(userIndex);
        Computers(compOwner).timesHacked++;
        Computers(CompOwner).PerformLoginAction(player);
    }

	CloseScreen("LOGIN");
}

// ----------------------------------------------------------------------
// HackDetected()
// ----------------------------------------------------------------------

function HackDetected(optional bool bDamageOnly)
{
	if (compOwner.IsA('Computers'))
	{
		Computers(compOwner).bLockedOut = True;
		Computers(compOwner).lockoutTime = player.Level.TimeSeconds;
	}
	else
	{
		ATM(compOwner).bLockedOut = True;
		ATM(compOwner).lockoutTime = player.Level.TimeSeconds;
	}

	// Shock the crap out of the player (drain BE and play a sound)
	// Highly skilled players take less damage
   // DEUS_EX AMSD In multiplayer, don't damage.
   if (Player.Level.NetMode == NM_Standalone)
   {
      player.TakeDamage(10, None, Player.Location + vect(0,0,46), vect(0,0,0), 'Shocked');
      player.TakeDamage(24, None, Player.Location + vect(0,0,46), vect(0,0,0), 'EMP');
      PlaySound(sound'ProdFire');
   }
   else
   {
      player.PunishDetection(200 - 50 * skillLevel);
      PlaySound(sound'ProdFire');
   }

	if (!bDamageOnly)
		CloseScreen("EXIT");
}

// ----------------------------------------------------------------------
// AreSpecialOptionsAvailable()
// ----------------------------------------------------------------------

function bool AreSpecialOptionsAvailable(optional bool bCheckActivated)
{
	local int i;
	local bool bOK;

	bOK = False;
	for (i=0; i<ArrayCount(Computers(compOwner).specialOptions); i++)
	{
		if (Computers(compOwner).specialOptions[i].Text != "")
		{
			if ((Computers(compOwner).specialOptions[i].userName == "") || (Caps(Computers(compOwner).specialOptions[i].userName) == userName))
			{
				// Also check if the "bCheckActivated" bool is set, in which case we also
				// want to make sure the item hasn't already been triggered.

				if (!((bCheckActivated) && (Computers(compOwner).specialOptions[i].bAlreadyTriggered)))
				{
					bOK = True;
					break;
				}
			}
		}
	}

	return bOK;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     detectionTime=15.000000
     kickTimerID=-1
     bUsesHackWindow=True
     shadowOffsetX=15
     shadowOffsetY=15
     ScreenType=ST_Computer
	 LockoutScreen=Class'DeusEx.ComputerScreenDisabled'
     bShowNotes=true
}
