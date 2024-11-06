//=============================================================================
// ComputerSecurityChoice_Camera
//=============================================================================

class ComputerSecurityChoice_Camera extends ComputerCameraUIChoice;

// ----------------------------------------------------------------------
// SetCameraView()
// ----------------------------------------------------------------------

function SetCameraView(ComputerSecurityCameraWindow newCamera)
{
	Super.SetCameraView(newCamera);

	if (winCamera != None)
	{
		if (winCamera.camera != None)
		{
			if (winCamera.camera.bActive)
				SetValue(0);
			else
				SetValue(1);

			EnableWindow();
		}
		else
		{
			// Disable!
			DisableWindow();
			btnInfo.SetButtonText("");
		}

		if (securityWindow != None)
			securityWindow.EnableCameraButtons(winCamera.camera != None);
	}
	else
	{
		// Disable!
		DisableWindow();
		btnInfo.SetButtonText("");

		if (securityWindow != None)
			securityWindow.EnableCameraButtons(False);
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
//
// If the action button was pressed, cycle to the next available
// choice (if any)
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	securityWindow.ToggleCameraState();
	Super.ButtonActivated(buttonPressed);
	return True;
}

// ----------------------------------------------------------------------
// ButtonActivatedRight()
// ----------------------------------------------------------------------

function bool ButtonActivatedRight( Window buttonPressed )
{
	securityWindow.ToggleCameraState();
	Super.ButtonActivated(buttonPressed);
	return True;
}

//SARGE: When hacked, replace Off with the Rebooting text
function UpdateText(bool bHacking)
{
    local int disableTime;
    if (winCamera.camera.bRebooting && !winCamera.camera.bActive)
    {
        if (!bHacking)
            SetValue(0); //If not hacked, Next choice will be Off.
        disableTime = winCamera.camera.disableTime - player.saveTime;
        btnInfo.SetButtonText(sprintf(strRebooting,disableTime));
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     enumText(0)="On"
     enumText(1)="Off"
     actionText="|&Camera Status"
}
