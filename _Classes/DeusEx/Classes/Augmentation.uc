//=============================================================================
// Augmentation.
//=============================================================================
class Augmentation extends Actor
	intrinsic;

var() bool bAutomatic;
var() float EnergyRate;
var travel int CurrentLevel;
var int MaxLevel;
var texture icon;
var int IconWidth;
var int IconHeight;
var texture smallIcon;
var bool bAlwaysActive;
var travel bool bBoosted;
var travel int HotKeyNum;
var travel Augmentation next;
var bool bUsingMedbot;

var localized String EnergyRateLabel;
var localized string OccupiesSlotLabel;
var localized string AugLocsText[7];

var() localized string AugActivated;
var() localized string AugDeactivated;
var() localized string AugmentationName;
var() localized string Description;
var() localized string MPInfo;
var() localized string AugAlreadyHave;
var() localized string AugNowHave;
var() localized string AugNowHaveAtLevel;
var() localized string AlwaysActiveLabel;
var() localized String CanUpgradeLabel;
var() localized String CurrentLevelLabel;
var() localized String MaximumLabel;
var() localized String AugRecharging;

// which player am I attached to?
var DeusExPlayer Player;

var() float LevelValues[4];

// does the player have it?
var travel bool bHasIt;

// is it actually turned on?
var travel bool bIsActive;

// When deactivated, give a red icon for this long.
// THIS DOES NOT ACTUALLY DISABLE THE AUG, just gives a red icon
// Used by Spy Drone so we know when a new drone is ready
var travel float currentChargeTime;
var const float chargeTime;

var() enum EAugmentationLocation
{
	LOC_Cranial,
	LOC_Eye,
	LOC_Torso,
	LOC_Arm,
	LOC_Leg,
	LOC_Subdermal,
	LOC_Default
} AugmentationLocation;

// DEUS_EX AMSD In multiplayer, we have strict aug pairs, no two augs can have the
// same MPConflict slot value.
var() int MPConflictSlot;

var() sound ActivateSound;
var() sound DeactivateSound;
var() sound LoopSound;

// SARGE: Has this aug been added to the augmentation wheel?
var travel bool bAddedToWheel;

// ----------------------------------------------------------------------
// network replication
// ----------------------------------------------------------------------

replication
{
    //variables server to client
    reliable if ((Role == ROLE_Authority) && (bNetOwner))
        bHasIt, bIsActive, CurrentLevel, next, HotKeyNum, Player;

    //functions client to server
    reliable if (Role < ROLE_Authority)
        Activate, Deactivate, IncLevel;

}

// ----------------------------------------------------------------------
// state Active
//
// each augmentation should have its own version of this which actually
// implements the effects of having the augmentation on
// ----------------------------------------------------------------------

state Active
{
Begin:
	log("** AUGMENTATION: .Active should never be called!");
}

// ----------------------------------------------------------------------
// state Inactive
//
// don't do anything in this state
// ----------------------------------------------------------------------

auto state Inactive
{
    function Tick(float deltaTime)
    {
        //Update aug icon
        if (currentChargeTime > 0)
        {
            currentChargeTime = FMAX(0,currentChargeTime - deltaTime);

            if (currentChargeTime ~= 0)
            {
                if (Player.bHUDShowAllAugs)
                    Player.UpdateAugmentationDisplayStatus(Self);
                else if (!bIsActive)
                    Player.RemoveAugmentationDisplay(Self);
            }
        }

    }
}


// ----------------------------------------------------------------------
// Activate()
// ----------------------------------------------------------------------

//Sarge: Added a boolean so that individual augs can define their own activation conditions
function bool CanActivate(out string message)
{

    if (player.NanoVirusTimer > 0)                                              //RSD: If hit by nanovirus grenade, can't activate augs for seconds = damage
    {
    	message = Sprintf(player.NanoVirusLabel, int(player.NanoVirusTimer));
    	return false;
    }
    
	if (player.Energy == 0)
    {
        message = player.EnergyDepleted;
        return false;
    }

    if (IsCharging())
    {
        message = GetChargingMessage();
        return false;
    }

    return true;
}

function string GetChargingMessage()
{
    return Sprintf(AugRecharging, AugmentationName);
}

function Activate()
{
    local string deniedMessage;

	// can't do anything if we don't have it
	if (!bHasIt || player.IsInState('Dying'))
		return;

    if (!CanActivate(deniedMessage))
    {
        if (deniedMessage != "")
            player.ClientMessage(deniedMessage);
        return;
    }

    //TODO: Convert these to use the CanActivate() function
    else if (IsA('AugIcarus') && AugIcarus(self).bCooldown)
      { player.ClientMessage("Cooling Down..."); return; }

    //TODO: Move this to the AugLight Activate() function
    if (IsA('AugLight'))
    {
       if (CurrentLevel == 1)
         EnergyRate=5.000000;
       else
         EnergyRate=10.000000;
    }

	if (IsInState('Inactive'))
	{
		// this block needs to be before bIsActive is set to True, otherwise
		// NumAugsActive counts incorrectly and the sound won't work
		if (!IsA('AugHeartLung') && !IsA('AugPower'))
		   Player.PlaySound(ActivateSound, SLOT_None,0.7);
		if (Player.AugmentationSystem.NumAugsActive() == 0)
			Player.AmbientSound = LoopSound;

		bIsActive = True;

		Player.ClientMessage(Sprintf(AugActivated, AugmentationName));

		if (Player.bHUDShowAllAugs)
			Player.UpdateAugmentationDisplayStatus(Self);
		else
			Player.AddAugmentationDisplay(Self);
		Player.RadialMenuUpdateAug(Self);

		GotoState('Active');
	}
}

// ----------------------------------------------------------------------
// Deactivate()
// ----------------------------------------------------------------------

function Deactivate()
{
	// can't do anything if we don't have it
	if (!bHasIt)
		return;

	// If the 'bAlwaysActive' flag is set, this aug can't be
	// deactivated
	if (bAlwaysActive)
		return;

	if (IsInState('Active'))
	{
		bIsActive = False;

		Player.ClientMessage(Sprintf(AugDeactivated, AugmentationName));

        if (chargeTime > 0)
            currentChargeTime = chargeTime;

        Player.UpdateAugmentationDisplayStatus(Self);
		if (!Player.bHUDShowAllAugs && !IsCharging())
			Player.RemoveAugmentationDisplay(Self);
		Player.RadialMenuUpdateAug(Self);

		if (Player.AugmentationSystem.NumAugsActive() == 0)
			Player.AmbientSound = None;
        if (!IsA('AugHeartLung') && !IsA('AugPower'))
		   Player.PlaySound(DeactivateSound, SLOT_None,0.7);
		GotoState('Inactive');
	}
}

// ----------------------------------------------------------------------
// IncLevel()
// ----------------------------------------------------------------------

function bool IncLevel()
{
	if ( !CanBeUpgraded() )
	{
		Player.ClientMessage(Sprintf(AugAlreadyHave, AugmentationName));
		return False;
	}

	if (bIsActive)
		Deactivate();

	CurrentLevel++;

	Player.ClientMessage(Sprintf(AugNowHave, AugmentationName, CurrentLevel + 1));
}

// ----------------------------------------------------------------------
// CanBeUpgraded()
//
// Checks to see if the player has an Upgrade cannister for this
// augmentation, as well as making sure the augmentation isn't already
// at full strength.
// ----------------------------------------------------------------------

simulated function bool CanBeUpgraded()
{
	local bool bCanUpgrade;
	local Augmentation anAug;
	local AugmentationUpgradeCannister augCan;
	local AugmentationUpgradeCannisterOverdrive augCan2;

	bCanUpgrade = False;

	// Check to see if this augmentation is already at
	// the maximum level
	if ( CurrentLevel < MaxLevel )
	{
		// Now check to see if the player has a cannister that can
		// be used to upgrade this Augmentation
        augCan2 = AugmentationUpgradeCannisterOverdrive(player.FindInventoryType(Class'AugmentationUpgradeCannisterOverdrive'));

        if (augCan2 != None)
        {
           bCanUpgrade = True;
           player.bSpecialUpgrade = True;
        }
		else
        {
          augCan = AugmentationUpgradeCannister(player.FindInventoryType(Class'AugmentationUpgradeCannister'));
          if (augCan != None)
          {
			bCanUpgrade = True;
			player.bSpecialUpgrade = False;
		  }
        }
	}

	return bCanUpgrade;
}

// ----------------------------------------------------------------------
// UsingMedBot()
// ----------------------------------------------------------------------

function UsingMedBot(bool bNewUsingMedbot)
{
	bUsingMedbot = bNewUsingMedbot;
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local String strOut;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.Clear();
	winInfo.SetTitle(AugmentationName);

	if (bUsingMedbot)
	{
		winInfo.SetText(Sprintf(OccupiesSlotLabel, AugLocsText[AugmentationLocation]));
		winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ Description);
	}
	else
	{
		winInfo.SetText(Description);
	}

	// Energy Rate
	winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ Sprintf(EnergyRateLabel, Int(EnergyRate)));

	// Current Level
	strOut = Sprintf(CurrentLevelLabel, CurrentLevel + 1);

	// Can Upgrade / Is Active labels
	if (CanBeUpgraded())
		strOut = strOut @ CanUpgradeLabel;
	else if (CurrentLevel == MaxLevel )
		strOut = strOut @ MaximumLabel;

	winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ strOut);

	// Always Active?
	if (bAlwaysActive)
		winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ AlwaysActiveLabel);

	return True;
}

// ----------------------------------------------------------------------
// IsActive()
// ----------------------------------------------------------------------

simulated function bool IsActive()
{
	return bIsActive;
}

// ----------------------------------------------------------------------
// IsActive()
// ----------------------------------------------------------------------

function bool IsCharging()
{
	return currentChargeTime > 0.0;
}

// ----------------------------------------------------------------------
// IsAlwaysActive()
// ----------------------------------------------------------------------

simulated function bool IsAlwaysActive()
{
	return bAlwaysActive;
}

// ----------------------------------------------------------------------
// GetHotKey()
// ----------------------------------------------------------------------

simulated function int GetHotKey()
{
	return hotKeyNum;
}

// ----------------------------------------------------------------------
// GetCurrentLevel()
// ----------------------------------------------------------------------

simulated function int GetCurrentLevel()
{
	return CurrentLevel;
}

// ----------------------------------------------------------------------
// GetEnergyRate()
//
// Allows the individual augs to override their energy use
// ----------------------------------------------------------------------

simulated function float GetEnergyRate()
{
	return energyRate;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     EnergyRate=50.000000
     MaxLevel=3
     IconWidth=52
     IconHeight=52
     HotKeyNum=-1
     EnergyRateLabel="Energy Rate: %d Units/Minute"
     OccupiesSlotLabel="Occupies Slot: %s"
     AugLocsText(0)="Cranial"
     AugLocsText(1)="Eyes"
     AugLocsText(2)="Torso"
     AugLocsText(3)="Arms"
     AugLocsText(4)="Legs"
     AugLocsText(5)="Subdermal"
     AugLocsText(6)="Default"
     AugActivated="%s activated"
     AugRecharging="%s is recharging"
     AugDeactivated="%s deactivated"
     MPInfo="DEFAULT AUG MP INFO - REPORT THIS AS A BUG"
     AugAlreadyHave="You already have the %s at the maximum level"
     AugNowHave="%s upgraded to level %d"
     AugNowHaveAtLevel="Augmentation %s at level %d"
     AlwaysActiveLabel="[Always Active]"
     CanUpgradeLabel="(Can Upgrade)"
     CurrentLevelLabel="Current Level: %d"
     MaximumLabel="(Maximum)"
     ActivateSound=Sound'DeusExSounds.Augmentation.AugActivate'
     DeActivateSound=Sound'DeusExSounds.Augmentation.AugDeactivate'
     LoopSound=Sound'DeusExSounds.Augmentation.AugLoop'
     bHidden=True
     bTravel=True
     NetUpdateFrequency=5.000000
     bAddedToWheel=true;
     chargeTime=1.000000
}
