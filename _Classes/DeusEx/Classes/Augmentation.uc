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
var bool bAlwaysActive; //SARGE: Unused, but we can't remove it because Augmentation is an intrinsic actor. Use AugmentationType instead.
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

//SARGE: What type of augmentation is this?
//Added stuff for Toggle augs
enum EAugmentationType
{
    Aug_Passive,
    Aug_Active,
    Aug_Automatic,
    Aug_Toggle
};

var travel EAugmentationType AugmentationType;

//Appends (Active) etc at the end of each title
var localized String ActiveLabel;
var localized String AutomaticLabel;
var localized String ToggleLabel;
var localized String PassiveLabel;

//Type Descriptions, at the bottom of each augmentation
var localized String TypeDescriptorPassive;
var localized String TypeDescriptorActive;
var localized String TypeDescriptorToggle;
var localized String TypeDescriptorAutomatic;

var localized String EnergyReserveLabel;

var travel int EnergyReserved;         //Amount of energy this aug uses when active. Used for Toggled augs.

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
// Setup()
// Called every time we restart the game, and whenever we install/upgrade an augmentation
// ----------------------------------------------------------------------

function Setup()
{
    //log("Aug Setup: " $ GetCurrentLevel());
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
	
    if (player.Energy < GetAdjustedEnergyReserve())
    {
        message = player.EnergyCantReserve;
        return false;
    }
    
	if (player.Energy == 0 && !IsToggleAug())
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
    return Sprintf(AugRecharging, GetName());
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
        //Deduct Reserve energy
        if (GetAdjustedEnergyReserve() > 0)
            player.Energy -= GetAdjustedEnergyReserve();

		// this block needs to be before bIsActive is set to True, otherwise
		// NumAugsActive counts incorrectly and the sound won't work
		if (Player.AugmentationSystem.NumAugsActive() == 0 && !IsToggleAug())
			Player.AmbientSound = LoopSound;

		bIsActive = True;

		Player.ClientMessage(Sprintf(AugActivated, GetName()));

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
	if (!CanBeActivated())
		return;

	if (IsInState('Active'))
	{
        //Give back half of what we reserved
        //SARGE: TODO: Store this so we don't get weirdness with installing heart/whatever
        /*
        if (EnergyReserved > 0)
            player.Energy += GetReserveEnergyAmount() * 0.5;
        */


		bIsActive = False;

		Player.ClientMessage(Sprintf(AugDeactivated, GetName()));

        if (chargeTime > 0)
            currentChargeTime = chargeTime;

        Player.UpdateAugmentationDisplayStatus(Self);
		if (!Player.bHUDShowAllAugs && !IsCharging())
			Player.RemoveAugmentationDisplay(Self);
		Player.RadialMenuUpdateAug(Self);

		if (Player.AugmentationSystem.NumAugsActive() == 0)
			Player.AmbientSound = None;
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
		Player.ClientMessage(Sprintf(AugAlreadyHave, GetName()));
		return False;
	}

	if (bIsActive)
		Deactivate();

	CurrentLevel++;

    Setup();

	Player.ClientMessage(Sprintf(AugNowHave, GetName(), CurrentLevel + 1));
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
	winInfo.SetTitle(GetName());

	if (bUsingMedbot)
	{
		winInfo.SetText(Sprintf(OccupiesSlotLabel, AugLocsText[AugmentationLocation]));
		winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ GetDescription());
	}
	else
	{
		winInfo.SetText(GetDescription());
	}

    // Energy Reserve
    if (EnergyReserved > 0 && AugmentationType == Aug_Toggle)
        winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ Sprintf(EnergyReserveLabel, Int(GetAdjustedEnergyReserve())));

	// Energy Rate
    if (EnergyRate > 0)
        winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ Sprintf(EnergyRateLabel, Int(GetAdjustedEnergyRate())));

	// Current Level
	strOut = Sprintf(CurrentLevelLabel, CurrentLevel + 1);

	// Can Upgrade / Is Active labels
	if (CanBeUpgraded())
		strOut = strOut @ CanUpgradeLabel;
	else if (CurrentLevel == MaxLevel )
		strOut = strOut @ MaximumLabel;

	winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ strOut);

	// Always Active? //SARGE: Replaced with aug description string, see below
    /*
	if (!CanBeActivated())
		winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ AlwaysActiveLabel);
    */

    winInfo.AppendText(winInfo.CR() $ winInfo.CR());
    switch (AugmentationType)
    {
        case Aug_Passive: winInfo.AppendText(TypeDescriptorPassive); break;
        case Aug_Active: winInfo.AppendText(TypeDescriptorActive); break;
        case Aug_Toggle: winInfo.AppendText(TypeDescriptorToggle); break;
        case Aug_Automatic: winInfo.AppendText(TypeDescriptorAutomatic); break;
    }

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
    return EnergyRate;
}

// ----------------------------------------------------------------------
// CanDrainEnergy()
//
// Allows the individual augs to override when their energy is used
// ----------------------------------------------------------------------

simulated function bool CanDrainEnergy()
{
    return CanBeActivated() && !IsToggleAug();
}

// ----------------------------------------------------------------------
// GetAdjustedEnergyRate()
//
// Gets the actual rate of energy use for an augmentation, factoring in bonuses and penalties.
// SARGE: This was multiplicative for recirc and heart, in that order.
// So a 20 energy aug with level 3 recirc (-35%) and level 1 heart (+40%) would
// cost 18.2 energy (20 * 0.65 * 1.4) which seemed unintented.
// Replaced it with an additive bonus/penalty.
// Custom version allows working with any energy ratio
// ----------------------------------------------------------------------

function float GetAdjustedEnergyRate()
{    
    return GetCustomEnergyRate(GetEnergyRate());
}

function float GetCustomEnergyRate(float rate)
{    
    local Augmentation heart, recirc;
    local float total, bonus, penalty, mult;

    heart = Player.AugmentationSystem.FindAugmentation(class'AugHeartLung');
    recirc = Player.AugmentationSystem.FindAugmentation(class'AugPower');

    //Heart Penalty
    if (heart.bHasIt)
        penalty = heart.LevelValues[heart.CurrentLevel];

    //recirc bonus
    if (recirc.bHasIt)
        bonus = 1.0 - recirc.LevelValues[recirc.CurrentLevel];

    if (penalty > bonus)
        mult = penalty - bonus;
    else if (bonus > 0 || penalty > 0)
        mult = bonus - penalty;
    else
        mult = 1.0;

    //player.clientMessage("mult: " $ mult $ ", penalty: " $ penalty $ ", bonus: " $ bonus);

    return rate * mult;
}

// ----------------------------------------------------------------------
// GetAdjustedEnergyReserve()
//
// Gets the actual energy reserve amount, factoring in bonuses and penalties.
// ----------------------------------------------------------------------

function float GetAdjustedEnergyReserve()
{    
    local Augmentation heart, recirc;
    local float bonus, penalty, mult;

    heart = Player.AugmentationSystem.FindAugmentation(class'AugHeartLung');
    recirc = Player.AugmentationSystem.FindAugmentation(class'AugPower');

    //Heart Penalty
    if (heart.bHasIt)
        penalty = heart.LevelValues[heart.CurrentLevel];

    //recirc bonus
    if (recirc.bHasIt)
        bonus = 1.0 - recirc.LevelValues[recirc.CurrentLevel];

    if (penalty > bonus)
        mult = penalty - bonus;
    else if (bonus > 0 || penalty > 0)
        mult = bonus - penalty;
    else
        mult = 1.0;

    return EnergyReserved * mult;
}

// ----------------------------------------------------------------------
// CanBeActivated()
//
// Returns true for augs that are considered "activatable" in the UI etc
// ----------------------------------------------------------------------

function bool CanBeActivated()
{
    return bHasIt && (AugmentationType == Aug_Active || IsToggleAug());
}

// ----------------------------------------------------------------------
// IsToggleAug()
//
// Automatic and Toggle Augs behave very similarly, this functionality groups their behaviour
// ----------------------------------------------------------------------

function bool IsToggleAug()
{
    return AugmentationType == Aug_Toggle || AugmentationType == Aug_Automatic;
}

// ----------------------------------------------------------------------
// GetName()
//
// Gets the Augmentation name, followed by the aug type, such as "(Automatic)"
// ----------------------------------------------------------------------

function string GetName()
{
    local string suffix;

    switch (AugmentationType)
    {
        case Aug_Passive:
            suffix = PassiveLabel;
            break;
        case Aug_Active:
            suffix = ActiveLabel;
            break;
        case Aug_Automatic:
            suffix = AutomaticLabel;
            break;
        case Aug_Toggle:
            suffix = ToggleLabel;
            break;
    }

    return AugmentationName @ "(" $ suffix $ ")";
}

// ----------------------------------------------------------------------
// GetDescription()
//
// Gets the Augmentation description, allowing augmentations to modify their own descriptions.
// ----------------------------------------------------------------------

function string GetDescription()
{
    return Description;
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
     EnergyReserveLabel="Energy Reserved: %d Units"
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
     ActiveLabel="Active"
     AutomaticLabel="Automatic"
     ToggleLabel="Toggle"
     PassiveLabel="Passive"
     TypeDescriptorPassive="Passive Augmentations are always active and use no bioelectrical energy."
     TypeDescriptorActive="Active Augmentations use bioelectrical energy at a standard rate while activated."
     TypeDescriptorToggle="Toggled Augmentations reserve an amount of bioelectrical energy while active, but use no energy to function. The reserve amount is lost upon deactivation."
     TypeDescriptorAutomatic="Automatic Augmentations can be activated with no bioelectrical energy cost. While active, bioelectrical energy is drained based on specific circumstances."
     ActivateSound=Sound'DeusExSounds.Augmentation.AugActivate'
     DeActivateSound=Sound'DeusExSounds.Augmentation.AugDeactivate'
     LoopSound=Sound'DeusExSounds.Augmentation.AugLoop'
     bHidden=True
     bTravel=True
     NetUpdateFrequency=5.000000
     bAddedToWheel=true;
     chargeTime=1.000000
     AugmentationType=Aug_Active
}
