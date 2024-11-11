//=============================================================================
// ComputerScreenDisabled
//=============================================================================
class ComputerScreenDisabled extends ComputerUIWindow;

var MenuUILabelWindow        winLoginInfo;
var MenuUIActionButtonWindow btnClose;
var MenuUIActionButtonWindow btnLogin;

var localized String ButtonLabelClose;
var localized String LoginInfoText;
var localized String StatusText;

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	btnClose = winButtonBar.AddButton(ButtonLabelClose, HALIGN_Right);
	btnLogin = winButtonBar.AddButton(ButtonLabelLogin, HALIGN_Right);

	CreateLoginInfoWindow();

	winTitle.SetTitle(Title);
	winStatus.SetText(StatusText);
}

// ----------------------------------------------------------------------
// CreateLoginInfoWindow()
// ----------------------------------------------------------------------

function CreateLoginInfoWindow()
{
	winLoginInfo = MenuUILabelWindow(winClient.NewChild(Class'MenuUILabelWindow'));

	winLoginInfo.SetPos(10, 12);
	winLoginInfo.SetSize(377, 122);
	winLoginInfo.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winLoginInfo.SetTextMargins(0, 0);
	winLoginInfo.SetText(LoginInfoText);
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	Super.SetNetworkTerminal(newTerm);

	// Hide the Hack window
	if (winTerm != None)
		winTerm.CloseHackWindow();
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
		case btnClose:
			CloseScreen("EXIT");
			break;
		
        case btnLogin:
			CloseScreen("LOGOUT");
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
// ----------------------------------------------------------------------

defaultproperties
{
     ButtonLabelClose="Close"
     LoginInfoText="Due to suspicious network activity, this terminal has been placed under quarantine by security policy. Special network access functions have been restricted.|nFor more information, please contact your network administrator.|n"
     StatusText="SECUR//GLOBAL//9571.2256"
     Title="Security Notice"
     ClientWidth=403
     ClientHeight=211
     verticalOffset=30
     clientTextures(0)=Texture'DeusExUI.UserInterface.ComputerGBSDisabledBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ComputerGBSDisabledBackground_2'
     textureRows=1
     textureCols=2
     bAlwaysCenter=True
     statusPosY=186
}
