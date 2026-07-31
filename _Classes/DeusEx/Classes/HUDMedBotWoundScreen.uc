//=============================================================================
// HUDMedBotWoundScreen
// SARGE: Handles dealing with traumas.
//=============================================================================

class HUDMedBotWoundScreen extends HUDMedBotHealthScreen;

function CreateButtons()
{
    super.CreateButtons();
    btnHealAll.SetButtonText(CureAllButtonLabel);
}

function bool ButtonActivated(Window buttonPressed)
{
	local bool bHandled;

	bHandled = True;

	switch(buttonPressed)
	{
		case btnHealAll:
            MedBotCurePlayer();
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
// MedBotCurePlayer()
// ----------------------------------------------------------------------

function MedBotCurePlayer()
{
    local int i;
	medBot.CurePlayer(player);
	UpdateMedBotDisplay();
	//UpdateRegionWindows();
    
    //Update all wound buttons
    for(i = 0;i < ArrayCount(traumaButtons);i++)
    {
        Log("traumaButtons[i]: " $ traumaButtons[i]);
        if (traumaButtons[i] != None)
            traumaButtons[i].RefreshWoundInfo();
    }
    
	
	player.HealScreenEffect(8.0, false);
}

//Dirty Hack
function bool IsPlayerDamaged()
{
    return IsPlayerWounded();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	if (medBot != None)
        btnHealAll.EnableWindow(medBot.CanHeal() && IsPlayerWounded());
	else
		btnHealAll.EnableWindow(False);
	
    if (HUDMedBotNavBarWindow(winNavBar).btnWounds != None)
        HUDMedBotNavBarWindow(winNavBar).btnWounds.SetSensitivity(False);
    
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateNavBarWindow();
	CreateClientBorderWindow();
	CreateClientWindow();

	CreateTitleWindow(9, 5, HealthTitleText);
	CreateInfoWindow();
	CreateButtons();
	CreateMedbotLabel();
	CreateMedBotDisplay();
	CreateStatusWindow();
	CreateTraumasHeaders();
    CreateTraumaTileWindow();
    CreateTraumasList();
    
    winTraumaLevel.Show();
    winMedkitsNeeded.Show();
    winTrauma.Show();
}

// ----------------------------------------------------------------------
// UpdateStatusText()
// SARGE: Updated for Wound display
// ----------------------------------------------------------------------

function UpdateStatusText()
{
    if (selectedTrauma != None)
        selectedTrauma.UpdateInfo(winInfo);
}

defaultproperties
{
    clientTextures(0)=Texture'RSDCrap.UserInterface.HUDMedBotTraumaBackground_1'
    clientTextures(1)=Texture'RSDCrap.UserInterface.HUDMedBotTraumaBackground_2'
    clientTextures(3)=Texture'RSDCrap.UserInterface.HUDMedBotTraumaBackground_4'
    clientTextures(4)=Texture'RSDCrap.UserInterface.HUDMedBotTraumaBackground_5'
     
     HealthInfoTextLabel="The MedBot will cure all traumas currently sustained. Progress is also reset, preventing them from being acquired again for some time."
     MedBotReadyLabel="|nThe MedBot is Ready, you may now be Cured."
     MedBotYouAreHealed="|nYou are not currently suffering from any Traumas."
}
