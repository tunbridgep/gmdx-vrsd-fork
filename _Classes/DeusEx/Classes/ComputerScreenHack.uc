//=============================================================================
// ComputerScreenHack
//=============================================================================
class ComputerScreenHack extends HUDBaseWindow;

var PersonaNormalTextWindow   winDigits;
var PersonaHeaderTextWindow   winHackMessage;
var PersonaActionButtonWindow btnHack;
var ProgressBarWindow         barHackProgress;

var NetworkTerminal           winTerm;
var Float					  detectionProbability; // eshkrm
var Float                     detectionTime;
var Float                     saveDetectionTime;
var Float                     hackTime;
var Float                     saveHackTime;
var Float                     blinkTimer;
var Float                     digitUpdateTimer;
var Float                     hackDetectedDelay;
var Bool                      bHacking;
var Bool		              bHacked;
var Bool                      bHackDetected;
var Bool                      bHackDetectedNotified;

var Int    digitWidth;
var String digitStrings[4];
var String digitFillerChars;
var Color  colDigits;
var Color  colRed;

// Defaults
var Texture texBackground;
var Texture texBorder;

// Text
var localized String HackButtonLabel;
var localized String ReturnButtonLabel;
var localized String HackReadyLabel;
var localized String HackInitializingLabel;
var localized String HackSuccessfulLabel;
var localized String HackDetectedLabel;
var localized String MPHackInitializingLabel;

var int passedSecLevel; //CyberP:
var PersonaActionButtonWindow btnWorm;
var PersonaActionButtonWindow btnNuke;
var bool bTimePaused;
var float wormTime;
var localized String hackRequirement1;
var localized String hackRequirement2;
// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(215, 112);

	CreateControls();

	SetHackMessage(HackReadyLabel);
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Destroys the Window
// ----------------------------------------------------------------------

event DestroyWindow()
{
	if ((bHackDetected) && (!bHackDetectedNotified) && (winTerm != None))
		winTerm.HackDetected(True);

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateTextDigits();
	CreateHackMessageWindow();
	CreateHackProgressBar();
	CreateHackButton();
	//CreateWormButton();
	//CreateNukeButton();
}

// ----------------------------------------------------------------------
// CreateHackMessageWindow()
// ----------------------------------------------------------------------

function CreateHackMessageWindow()
{
	winHackMessage = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winHackMessage.SetPos(22, 19);
	winHackMessage.SetSize(168, 47);
	winHackMessage.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winHackMessage.SetBackgroundStyle(DSTY_Modulated);
	winHackMessage.SetBackground(Texture'HackInfoBackground');
}

// ----------------------------------------------------------------------
// CreateTextDigits()
// ----------------------------------------------------------------------

function CreateTextDigits()
{
	winDigits = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
	winDigits.SetPos(22, 19);
	winDigits.SetSize(168, 47);
	winDigits.SetFont(Font'FontFixedWidthSmall');
	winDigits.SetTextColor(colDigits);
	winDigits.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winDigits.SetTextMargins(0, 0);
}

// ----------------------------------------------------------------------
// CreateHackProgressBar()
// ----------------------------------------------------------------------

function CreateHackProgressBar()
{
	barHackProgress = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));
	barHackProgress.SetPos(22, 71);
	barHackProgress.SetSize(169, 12);
	barHackProgress.SetValues(0, 100);
	barHackProgress.SetVertical(False);
	barHackProgress.UseScaledColor(True);
	barHackProgress.SetDrawBackground(False);
	barHackProgress.SetCurrentValue(100);
}

// ----------------------------------------------------------------------
// CreateHackButton()
// ----------------------------------------------------------------------

function CreateHackButton()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(20, 86);
	winActionButtons.SetWidth(90);
	winActionButtons.FillAllSpace(True);

	btnHack = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnHack.SetButtonText(HackButtonLabel);
}

function CreateWormButton()
{
	local PersonaButtonBarWindow winActionButtons2;

    if (btnWorm == None)
    {
        winActionButtons2 = PersonaButtonBarWindow(NewChild(Class'PersonaButtonBarWindow'));
        winActionButtons2.SetPos(116, 86);
        winActionButtons2.SetWidth(76);
        winActionButtons2.FillAllSpace(True);
        btnWorm = PersonaActionButtonWindow(winActionButtons2.NewChild(Class'PersonaActionButtonWindow'));
        btnWorm.SetButtonText("Use Worm");
    }
}

function CreateNukeButton()
{
	local PersonaButtonBarWindow winActionButtons3;

    if (btnNuke == None)
    {
        winActionButtons3 = PersonaButtonBarWindow(NewChild(Class'PersonaButtonBarWindow'));
        winActionButtons3.SetPos(116, 86);
        winActionButtons3.SetWidth(72);
        winActionButtons3.FillAllSpace(True);
        btnNuke = PersonaActionButtonWindow(winActionButtons3.NewChild(Class'PersonaActionButtonWindow'));
        btnNuke.SetButtonText("Use Virus");
    }
}
// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawTexture(
		backgroundPosX, backgroundPosY,
		backgroundWidth, backgroundHeight,
		0, 0, texBackground);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		gc.SetStyle(borderDrawStyle);
		gc.SetTileColor(colBorder);
		gc.DrawTexture(0, 0, 221, 112, 0, 0, texBorder);
	}
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	winTerm = newTerm;
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	switch( buttonPressed )
	{
		case btnHack:
			if (winTerm != None)
			{
				if (bHacked)
					winTerm.ComputerHacked();
				else
					StartHack();

				btnHack.SetSensitivity(False);
			}
			break;

		case btnWorm:
		    if (winTerm != None)
			{
			    decrementSoftwareWorm();
			    bTimePaused = True;
			    Player.PlaySound(Sound'biomodoff',SLOT_None,,,,1.7);
			    if (btnWorm != None)
			        btnWorm.SetSensitivity(false);
		    }
            break;

        case btnNuke:
            if (winTerm != None)
			{
			   bHacking     = True;
	           bTickEnabled = True;
               decrementSoftwareNuke();
	           // Display hack message
               if (Player.Level.NetMode == NM_Standalone)
                SetHackMessage(HackInitializingLabel);
                else
                SetHackMessage(MPHackInitializingLabel);
              Player.PlaySound(sound'hacking4',SLOT_None);
               btnNuke.SetSensitivity(false);
            }
            break;

		default:
			bHandled = False;
			break;
	}

	if (bHandled)
		return True;
	else
		return Super.ButtonActivated(buttonPressed);
}

// ----------------------------------------------------------------------
// StartHack()
// ----------------------------------------------------------------------

function StartHack()
{
local int compSkill;

    compSkill = Player.SkillSystem.GetSkillLevel(class'SkillComputer');

    if (compSkill >= passedSecLevel)
    {
	bHacking     = True;
	bTickEnabled = True;

	// Display hack message
   if (Player.Level.NetMode == NM_Standalone)
      SetHackMessage(HackInitializingLabel);
   else
      SetHackMessage(MPHackInitializingLabel);
    }
    else
    {               //CyberP: hack denied
      winHackMessage.SetTextColor(colRed);
      if (passedSecLevel == 2)
         SetHackMessage(hackRequirement1);
      else if (passedSecLevel == 3)
         SetHackMessage(hackRequirement2);
      Player.PlaySound(sound'cantdrophere',SLOT_None,2.0,,,0.8);
      UpdateSoftwareNuke();
      return;
    }
}

function UpdateSoftwareWorm()
{
	local Inventory anItem;
	local int softCount;

		anItem = player.Inventory;

		while(anItem != None)
		{
			if (anItem.IsA('SoftwareStop'))
				softCount++;

            if (softCount == 1)
			CreateWormButton();

			anItem = anItem.Inventory;
		}

        if (softCount == 0 && btnWorm != none)
            btnWorm.SetSensitivity(false);
        else if (softCount > 0 && btnWorm != None)
            btnWorm.SetSensitivity(True);
		//winAugCans.SetCount(augCanCount);
}

function UpdateSoftwareNuke()
{
	local Inventory anItem;
	local int softCount;

		anItem = player.Inventory;

		while(anItem != None)
		{
			if (anItem.IsA('SoftwareNuke'))
				softCount++;

            if (softCount == 1)
			CreateNukeButton();

			anItem = anItem.Inventory;
		}
        if (softCount == 0 && btnNuke != none)
            btnNuke.SetSensitivity(false);
		//winAugCans.SetCount(augCanCount);
}

function decrementSoftwareWorm()
{
	local Inventory anItem;

		anItem = player.Inventory;

		while(anItem != None)
		{
			if (anItem.IsA('SoftwareStop'))
			{
				SoftwareStop(anItem).NumCopies -= 1;
				player.UpdateBeltText(SoftwareStop(anItem));
				if (SoftwareStop(anItem).NumCopies<=0)
                     Player.DeleteInventory(SoftwareStop(anItem));
				return;
            }

			anItem = anItem.Inventory;
		}
}

function decrementSoftwareNuke()
{
	local Inventory anItem;

		anItem = player.Inventory;

		while(anItem != None)
		{
			if (anItem.IsA('SoftwareNuke'))
			{
				SoftwareNuke(anItem).NumCopies -= 1;
				player.UpdateBeltText(SoftwareNuke(anItem));
				if (SoftwareNuke(anItem).NumCopies<=0)
                     Player.DeleteInventory(SoftwareNuke(anItem));
				return;
            }

			anItem = anItem.Inventory;
		}
}
// ----------------------------------------------------------------------
// FinishHack()
// ----------------------------------------------------------------------

function FinishHack()
{
	bHacked = True;

	// Display hack message
	SetHackMessage(HackSuccessfulLabel);

	winDigits.SetText("");
    UpdateSoftwareWorm();
	if (winTerm != None)
		winTerm.ComputerHacked();
}

// ----------------------------------------------------------------------
// HackDetected()
// ----------------------------------------------------------------------

function HackDetected()
{
	bHackDetected = True;
	blinkTimer    = Default.blinkTimer;
	detectionTime = hackDetectedDelay;
	bTickEnabled  = True;
	SetHackMessage(HackDetectedLabel);
	winHackMessage.SetTextColor(colRed);
	if (btnWorm != None)
	    btnWorm.SetSensitivity(False);
}

// ----------------------------------------------------------------------
// SetHackMessage()
// ----------------------------------------------------------------------

function SetHackMessage(String newHackMessage)
{
	if (newHackMessage == "")
		winHackMessage.Hide();
	else
		winHackMessage.Show();

	winHackMessage.SetText(newHackMessage);
}

// ----------------------------------------------------------------------
// SetDetectionProbability() -- eshkrm
// ----------------------------------------------------------------------

function SetDetectionProbability(Float newDetectionProbability)
{
	detectionProbability = newDetectionProbability;
}

// ----------------------------------------------------------------------
// SetDetectionTime()
// ----------------------------------------------------------------------

function SetDetectionTime(Float newDetectionTime, Float newHackTime)
{
	// The detection time is how long it takes before the user is
	// caught and electrified.  This now includes the Hack time to
	// give the player the perception that he's being tracked
	// immediately (a little more tense).  When in reality he has the
	// same amount of "detection" time (once hacked) as before.

	detectionTime     = newDetectionTime + newHackTime;
	saveDetectionTime = detectionTime;

	// Hack time is also based on skill
	hackTime      = newHackTime;
	saveHackTime  = hackTime;
}

// ----------------------------------------------------------------------
// GetSaveDetectionTime()
// ----------------------------------------------------------------------

function Float GetSaveDetectionTime()
{
	return saveDetectionTime;
}

// ----------------------------------------------------------------------
// UpdateDetectionTime()
// ----------------------------------------------------------------------

function UpdateDetectionTime(Float newDetectionTime)
{
	detectionTime = newDetectionTime;

	// Update the progress bar
	UpdateHackBar();
}

// ----------------------------------------------------------------------
// UpdateDigits()
// ----------------------------------------------------------------------

function UpdateDigits()
{
	local bool bSpace;
	local int stringIndex;

	// First move down the existing strings

	for(stringIndex=arrayCount(digitStrings)-1; stringIndex>0;	stringIndex--)
		digitStrings[stringIndex] = digitStrings[stringIndex-1];

	// Now fill the string.  As we get closer to detection time,
	// will fill with more characters

	digitStrings[0] = "";

	for(stringIndex=0; stringIndex<digitWidth; stringIndex++)
	{
		// Calculate chance that this is a space
		bSpace = ((saveHackTime - hackTime) / saveHackTime) > FRand();

		if (bSpace)
			digitStrings[0] = digitStrings[0] $ " ";
		else
			digitStrings[0] = digitStrings[0] $ Mid(digitFillerChars, Rand(Len(digitFillerChars)) + 1, 1);
	}

	winDigits.SetText("");

	for(stringIndex=0; stringIndex<arrayCount(digitStrings); stringIndex++)
	{
		winDigits.AppendText(digitStrings[stringIndex]);
		if (stringIndex - 1 == arrayCount(digitStrings))
			winDigits.AppendText("|n");
	}
}

// ----------------------------------------------------------------------
// UpdateHackBar()
// ----------------------------------------------------------------------

function UpdateHackBar()
{
	local float percentRemaining;

	percentRemaining = (detectionTime / saveDetectionTime) * 100;
	barHackProgress.SetCurrentValue(percentRemaining);
}

// ----------------------------------------------------------------------
// SetHackButtonToReturn()
// ----------------------------------------------------------------------

function SetHackButtonToReturn()
{
	btnHack.SetSensitivity(True);
	btnHack.SetButtonText(ReturnButtonLabel);
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
//local float wormTimeModifier;                                                 //RSD: Now unused

	if (bHacking)	// manage initial hacking
	{
	    if (Player.bHardCoreMode)
	        hackTime     -= deltaTime*1.25;
	    else
		    hackTime     -= deltaTime;
		blinkTimer       -= deltaTime;
		digitUpdateTimer -= deltaTime;

		// Update blinking text
		if (blinkTimer < 0)
		{
			if (winHackMessage.GetText() == "")
			{
				blinkTimer = Default.blinkTimer;

				// Display hack message
				if (Player.Level.NetMode == NM_Standalone)
				   SetHackMessage(HackInitializingLabel);
				else
				   SetHackMessage(MPHackInitializingLabel);
			}
			else
			{
				blinkTimer = Default.blinkTimer / 3;
				winHackMessage.SetText("");
			}
		}

		// Update scrolling text
		if (digitUpdateTimer < 0)
		{
			digitUpdateTimer = Default.digitUpdateTimer;
			UpdateDigits();
		}

		if (hackTime < 0)
		{
			bHacking = False;

			if (FRand() < detectionProbability) // Will scale with Computer skill -- eshkrm
			{
				FinishHack();
			}
			else
			{
				bHackDetectedNotified = True; // So window won't close immediately -- eshkrm
				detectionTime = 0;
			}
		}
	}

	if (bHackDetected)
	{
		detectionTime -= deltaTime;
		blinkTimer    -= deltaTime;

		// Update blinking text
		if (blinkTimer < 0)
		{
			if (winHackMessage.GetText() == "")
			{
				blinkTimer = Default.blinkTimer;
				winHackMessage.SetText(HackDetectedLabel);
			}
			else
			{
				blinkTimer = Default.blinkTimer / 3;
				winHackMessage.SetText("");
			}
		}

		if (detectionTime < 0)
		{
			if (winTerm != None)
			{
				bHackDetectedNotified = True;
				winTerm.HackDetected();
			}
		}
	}
	else
	{
        if (bTimePaused)
	    {
	       /*if (player.PerkNamesArray[7] == 1)
                wormTimeModifier = 0.5;
	       else
                wormTimeModifier = 1;
		   wormTime += (deltaTime*wormTimeModifier);*/
		   if (player.PerkNamesArray[7] != 1)                                   //RSD: MODDER perk makes STOP worm effect permanent rather than +50% effective
		      wormTime += deltaTime;
		   if (wormTime > 7.0)
		   {
		      bTimePaused = False;
		      wormTime = 0;
		      UpdateSoftwareWorm();
		   }
		   return;
		}
		// manage detection
		detectionTime -= deltaTime;

		// Update the progress bar
		UpdateHackBar();

		if (detectionTime < 0)
		{
			detectionTime = 0;
			bTickEnabled = False;
			HackDetected();
		}
	}
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;
	bKeyHandled = True;

	switch( key )
	{
		case IK_Escape:
			winTerm.ForceCloseScreen();
			break;

		default:
			bKeyHandled = False;
	}

	if (bKeyHandled)
		return True;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}

function Float GetDetectionTime()                                               //RSD: For proper detectiontime reinitialization in UpdateHackDetectionTime() in NetworkTerminal.uc
{
	return detectionTime;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     blinkTimer=1.000000
     digitUpdateTimer=0.050000
     hackDetectedDelay=0.500000
     digitWidth=23
     digitFillerChars="01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_+-=][}{"
     colDigits=(G=128)
     colRed=(R=255)
     texBackground=Texture'DeusExUI.UserInterface.ComputerHackBackground'
     texBorder=Texture'DeusExUI.UserInterface.ComputerHackBorder'
     HackButtonLabel="|&Hack"
     ReturnButtonLabel="|&Return"
     HackReadyLabel="Ice Breaker Ready..."
     HackInitializingLabel="Initializing ICE Breaker..."
     HackSuccessfulLabel="ICE Breaker Hack Successful..."
     HackDetectedLabel="*** WARNING ***|nICE DETECTED! ABORT HACK!"
     MPHackInitializingLabel="Hacking... Hit ESC to Abort"
     hackRequirement1="Hacking Level ADVANCED Required"
     hackRequirement2="Hacking Level MASTER Required"
     backgroundWidth=187
     backgroundHeight=94
     backgroundPosX=14
     backgroundPosY=13
}
