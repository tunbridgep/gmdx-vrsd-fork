//=============================================================================
// ComputerScreenSpecialOptions
//=============================================================================

class ComputerScreenSpecialOptions expands ComputerUIWindow;

struct S_OptionButtons
{
	var int specialIndex;
	var MenuUIChoiceButton btnSpecial;
};

var S_OptionButtons optionButtons[4];

var MenuUIActionButtonWindow btnReturn;
var MenuUIActionButtonWindow btnLogout;
var MenuUISmallLabelWindow   winSpecialInfo;

var int buttonLeftMargin;
var int firstButtonPosY;
var int specialOffsetY;
var int statusPosYOffset;
var int TopTextureHeight;
var int MiddleTextureHeight;
var int BottomTextureHeight;

var localized String SecurityButtonLabel;
var localized String EmailButtonLabel;

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateSpecialInfoWindow();
}

// ----------------------------------------------------------------------
// CreateClientWindow()
// ----------------------------------------------------------------------

function CreateClientWindow()
{
	Super.CreateClientWindow();

	if (winClient != None)
		ComputerUIScaleClientWindow(winClient).SetTextureHeights(TopTextureHeight, MiddleTextureHeight, BottomTextureHeight);
}

// ----------------------------------------------------------------------
// CreateSpecialInfoWindow()
// ----------------------------------------------------------------------

function CreateSpecialInfoWindow()
{
	winSpecialInfo = MenuUISmallLabelWindow(winClient.NewChild(Class'MenuUISmallLabelWindow'));

	winSpecialInfo.SetPos(10, 97);
	winSpecialInfo.SetSize(315, 25);
	winSpecialInfo.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	winSpecialInfo.SetTextMargins(0, 0);
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

//SARGE: Rewritten to take into account replacing the logout button
function SetNetworkTerminal(NetworkTerminal newTerm)
{
    local string buttonText, emailName;
    local bool bLeft;

	Super.SetNetworkTerminal(newTerm);
        
	if (winTerm.IsA('NetworkTerminalPersonal'))
        buttonText = EmailButtonLabel;
	else if (winTerm.IsA('NetworkTerminalSecurity'))
        buttonText = SecurityButtonLabel;
    
    bLeft = !player.bStreamlinedComputerInterface;

    //For personal computers it's dependent on emails.
    if (winTerm.IsA('NetworkTerminalPersonal') && player.bStreamlinedComputerInterface)
    {
        ProcessEmails();
        if (emailIndex == -1)
            bLeft = true;
    }

    //For security computers, it's dependent on having at least 1 camera or turret
    else if (ComputerSecurity(CompOwner) != None && player.bStreamlinedComputerInterface)
    {
        DeusExPlayer(GetPlayerPawn()).DebugMessage("We got here");
        bLeft = !ComputerSecurity(CompOwner).HasSecurityOptions();
    }

    if (bLeft)
    {
        btnLogout = winButtonBar.AddButton(ButtonLabelLogout, HALIGN_Right);
        btnReturn = winButtonBar.AddButton(buttonText, HALIGN_Left);
        CreateLeftEdgeWindow();
    }
    else
    {
        btnLogout = winButtonBar.AddButton(ButtonLabelLogout, HALIGN_Left);
        btnReturn = winButtonBar.AddButton(buttonText, HALIGN_Right);
        CreateLeftEdgeWindow();
    }
}

// ----------------------------------------------------------------------
// SetCompOwner()
//
// Loop through the special options and create 'em, baby!
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	Super.SetCompOwner(newCompOwner);

	CreateOptionButtons();
}

// ----------------------------------------------------------------------
// CreateOptionButtons()
// ----------------------------------------------------------------------

function CreateOptionButtons()
{
	local int specialIndex;
	local int numOptions;
	local MenuUIChoiceButton winButton;

	// Figure out how many special options we have

	numOptions = 0;
	for (specialIndex=0; specialIndex<ArrayCount(Computers(compOwner).specialOptions); specialIndex++)
	{
		if ((Computers(compOwner).specialOptions[specialIndex].userName == "") || (Caps(Computers(compOwner).specialOptions[specialIndex].userName) == winTerm.GetUserName()))
		{
			if (Computers(compOwner).specialOptions[specialIndex].Text != "")
			{
				// Create the button
				winButton = MenuUIChoiceButton(winClient.NewChild(Class'MenuUIChoiceButton'));
				winButton.SetPos(buttonLeftMargin, firstButtonPosY + (numOptions * MiddleTextureHeight));
				winButton.SetButtonText(Computers(compOwner).specialOptions[specialIndex].Text);
				winButton.SetSensitivity(!Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered);
				winButton.SetWidth(273);

				optionButtons[numOptions].specialIndex = specialIndex;
				optionButtons[numOptions].btnSpecial   = winButton;

				numOptions++;
			}
		}
	}

	ComputerUIScaleClientWindow(winClient).SetNumMiddleTextures(numOptions);

	// Update the location of the Special Info window and the Status window
	winSpecialInfo.SetPos(10, specialOffsetY + TopTextureHeight + (MiddleTextureHeight * numOptions));
	statusPosY = statusPosYOffset + TopTextureHeight + (MiddleTextureHeight * numOptions);
	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// UpdateOptionsButtons()
// ----------------------------------------------------------------------

function UpdateOptionsButtons()
{
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	// First check to see if one of our Special Options
	// buttons was pressed
	if (buttonPressed.IsA('MenuUIChoiceButton'))
	{
		ActivateSpecialOption(MenuUIChoiceButton(buttonPressed));
		bHandled = true;
	}
	else
	{
		bHandled = true;
		switch( buttonPressed )
		{
			case btnLogout:
				CloseScreen("LOGOUT");
				break;

			case btnReturn:
				CloseScreen("RETURN");
				break;

			default:
				bHandled = false;
				break;
		}
	}

	if (bHandled)
		return true;
	else
		return Super.ButtonActivated(buttonPressed);
}

// ----------------------------------------------------------------------
// ActivateSpecialOption()
// ----------------------------------------------------------------------

function ActivateSpecialOption(MenuUIChoiceButton buttonPressed)
{
	local int buttonIndex;
	local int specialIndex;
	local Actor A;
    local String N;
    local DeusExNote note;
    local DeusExLevelInfo info;

	specialIndex = -1;

	// Loop through the buttons and find a Match!
	for(buttonIndex=0; buttonIndex<arrayCount(optionButtons); buttonIndex++)
	{
		if (optionButtons[buttonIndex].btnSpecial == buttonPressed)
		{
			specialIndex = optionButtons[buttonIndex].specialIndex;

			// Disable this button so the user can't activate this
			// choice again
			optionButtons[buttonIndex].btnSpecial.SetSensitivity(false);

			break;
		}
	}

	// If we found the matching button, activate the option!
	if (specialIndex != -1)
	{
		// Make sure this option wasn't already triggered
		if (!Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered)
		{
			if (Computers(compOwner).specialOptions[specialIndex].TriggerEvent != '')
				foreach player.AllActors(class'Actor', A, Computers(compOwner).specialOptions[specialIndex].TriggerEvent)
					A.Trigger(None, player);

			if (Computers(compOwner).specialOptions[specialIndex].UnTriggerEvent != '')
				foreach player.AllActors(class'Actor', A, Computers(compOwner).specialOptions[specialIndex].UnTriggerEvent)
					A.UnTrigger(None, player);

			if (Computers(compOwner).specialOptions[specialIndex].bTriggerOnceOnly)
				Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered = true;

            //SARGE: Add a note if we're told to add a note
			if (Computers(compOwner).specialOptionsExtra[specialIndex].bAddNote)
            {
                if (Computers(compOwner).specialOptionsExtra[specialIndex].noteID != "")
                    N = Computers(compOwner).specialOptionsExtra[specialIndex].noteID;
                else
                {
                    info = player.GetLevelInfo();
                    if (info != None)
                        N = info.MapName $ "_" $ Computers(compOwner).name $ "_Special" $ specialIndex;
                }

                if (!player.HasNote(StringToName(N)))
                {
                    note = player.NoteAdd(Computers(compOwner).specialOptions[specialIndex].TriggerText,false,false,StringToName(N));
                    if (note != None)
                    {
                        note.textTag = StringToName(N);//StringToName(Computers(compOwner).Name $ "_Special" $ specialIndex);
                        note.bConNote = true;
                    }
                }
                //player.NoteAdd(Computers(compOwner).specialOptions[specialIndex].TriggerText);
            }

			// Display a message
			winSpecialInfo.SetText(Computers(compOwner).specialOptions[specialIndex].TriggerText);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     buttonLeftMargin=25
     firstButtonPosY=17
     specialOffsetY=16
     statusPosYOffset=50
     TopTextureHeight=12
     MiddleTextureHeight=30
     BottomTextureHeight=75
     SecurityButtonLabel="|&Security"
     EmailButtonLabel="|&Email"
     classClient=Class'DeusEx.ComputerUIScaleClientWindow'
     escapeAction="LOGOUT"
     Title="Special Options"
     ClientWidth=331
     clientTextures(0)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundTop_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundTop_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundMiddle_1'
     clientTextures(3)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundMiddle_2'
     clientTextures(4)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundBottom_1'
     clientTextures(5)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundBottom_2'
     textureCols=2
     bAlwaysCenter=true
     ComputerNodeFunctionLabel="SpecialOptions"
}
