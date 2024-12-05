//=============================================================================
// ComputerSecurityChoice_Turret
//=============================================================================

class ComputerSecurityChoice_Turret extends ComputerCameraUIChoice;

// ----------------------------------------------------------------------
// SetCameraView()
// ----------------------------------------------------------------------

function SetCameraView(ComputerSecurityCameraWindow newCamera)
{
	Super.SetCameraView(newCamera);

	if (winCamera != None)
	{
		if (winCamera.turret != None)
		{
			EnableWindow();		// In case was previously disabled

         // DEUS_EX AMSD Multiplayer support
         if (winCamera.player.Level.NetMode == NM_Standalone)
         {
            if (winCamera.turret.bDisabled)
               SetValue(0);
            else if (winCamera.turret.bTrackPlayersOnly)
               SetValue(1);
            else if (winCamera.turret.bTrackPawnsOnly)
               SetValue(2);
            else
               SetValue(3);
         }
         else
         {
            if (winCamera.turret.bDisabled)
               SetValue(0);
            else if (DeusExPlayer(winCamera.turret.safetarget) == winCamera.player)
               SetValue(2);
            else if ( (winCamera.player.DXGame.IsA('TeamDMGame')) && (winCamera.player.PlayerReplicationInfo.team == winCamera.turret.team) )
               SetValue(2);
            else
               SetValue(1);
         }
		}
		else
		{
			// Disable!
			DisableWindow();
			btnInfo.SetButtonText("");
		}
	}
	else
	{
		// Disable!
		DisableWindow();
		btnInfo.SetButtonText("");
	}
}

// ----------------------------------------------------------------------
// SetMPEnumState()
// ----------------------------------------------------------------------

function SetMPEnumState()
{
   local int CameraState;
	if (winCamera != None)
	{
		if (winCamera.turret != None)
		{
         CameraState = SecurityWindow.choiceWindows[0].GetValue();

         if (CameraState == 0)
            SetValue(0);
         else if (CameraState == 1)
            SetValue(2);
         else
            SetValue(1);
      }
   }
}


// ----------------------------------------------------------------------
// ButtonActivated()
//
// If the action button was pressed, cycle to the next available
// choice (if any)
// ----------------------------------------------------------------------

function bool ButtonActivated(Window buttonPressed)
{
	Super.ButtonActivated(buttonPressed);
	SetTurretState();
	return True;
}

// ----------------------------------------------------------------------
// ButtonActivatedRight()
// ----------------------------------------------------------------------

function bool ButtonActivatedRight( Window buttonPressed )
{
	Super.ButtonActivated(buttonPressed);
	SetTurretState();
	return True;
}

// ----------------------------------------------------------------------
// SetTurretState()
// ----------------------------------------------------------------------

function SetTurretState()
{
   //DEUS_EX AMSD In multiplayer, skip attack allies and attack everything settings.
   if (securitywindow.Player.Level.Netmode != NM_Standalone)
   {
      if (GetValue() == 1)
         SetValue(2);
      else if (GetValue() == 3)
         SetValue(0);
   }
	switch(GetValue())
	{
		case 0:			// Disabled
			securityWindow.SetTurretState(False, True);
			break;

		case 1:			// Attack Allies
			securityWindow.SetTurretState(True, False);
			securityWindow.SetTurretTrackMode(True, False);
			break;

		case 2:			// Attack Enemies
			securityWindow.SetTurretState(True, False);
			securityWindow.SetTurretTrackMode(False, True);
			break;

		case 3:			// Attack Everything
			securityWindow.SetTurretState(True, False);
			securityWindow.SetTurretTrackMode(False, False);
			break;
	}
}

function SetValue(int newValue)                                                 //RSD: Overrides the parent routine from MenuiUIChoiceEnum.uc
{
	if (Player.PerkManager.GetPerkWithClass(class'DeusEx.PerkTurretDomination').bPerkObtained == false && newValue > 1)                         //RSD: If the player does not have the Turret Domination perk, they can't reconfigure turret alliances
		currentValue = 0;                                                       //RSD: (replaces Neat Hack)
	else
    	currentValue = newValue;
	UpdateInfoButton();
}

//SARGE: When hacked, replace Off with the Rebooting text
//Since we have multiple states here, and not much room on the button,
//we will only show the Rebooting text if we log-in normally, and set the next state to Off
function UpdateText(bool bHacking)
{
    local int disableTime;
    if (winCamera != None && winCamera.turret != None && winCamera.turret.bRebooting && !bHacking)
    {
        SetValue(1); //Next value goes to either Enemies or Bypassed
        disableTime = winCamera.turret.disableTime - player.saveTime;
        btnInfo.SetButtonText(sprintf(strRebooting,disableTime));
    }
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     enumText(0)="Bypassed"
     enumText(1)="Default"
     enumText(2)="Enemies"
     enumText(3)="Everything"
     actionText="|&Turret Status"
}
