//=============================================================================
// ComputerCameraUIChoice
//=============================================================================

class ComputerCameraUIChoice extends MenuUIChoiceEnum
	abstract;

var ComputerSecurityCameraWindow winCamera;
var ComputerScreenSecurity       securityWindow;
var localized string strRebooting;

// ----------------------------------------------------------------------
// SetCameraView()
// ----------------------------------------------------------------------

function SetCameraView(ComputerSecurityCameraWindow newCamera)
{
	winCamera = newCamera;
}

// ----------------------------------------------------------------------
// SetSecurityWindow()
// ----------------------------------------------------------------------

function SetSecurityWindow(ComputerScreenSecurity newScreen)
{
	securityWindow = newScreen;
}

// ----------------------------------------------------------------------
// DisableChoice()
// ----------------------------------------------------------------------

function DisableChoice()
{
	btnAction.DisableWindow();
	btnInfo.DisableWindow();
}

//We need to update the text for our button based on whether we are turning it off or simply making it reboot
function UpdateText(bool bHacking)
{
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=113
     defaultInfoPosX=154
     strRebooting="Reboot in %d"
}
