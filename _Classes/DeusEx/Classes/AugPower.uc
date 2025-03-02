//=============================================================================
// AugPower.
//=============================================================================
class AugPower extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

var localized string CombinedDesc;

state Active
{
Begin:
}

function Deactivate()
{
	Super.Deactivate();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
	}
}

//SARGE: If we have Heart and Power, display the total energy penalty/savings
function string GetDescription()
{
    local int energyMod;

    if (!player.AugmentationSystem.GetAug(class'AugHeartLung').bHasIt || !bHasIt)
        return Description;

    energyMod = int(GetAdjustedEnergy(100));
    return Description $ "|n|n" $ sprintf(CombinedDesc,energyMod);
}

defaultproperties
{
     mpAugValue=0.650000
     EnergyRate=0.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconPowerRecirc'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconPowerRecirc_Small'
     AugmentationType=Aug_Passive
     AugmentationName="Power Recirculator"
     Description="Power consumption for all augmentations is reduced by polyanilene circuits, plugged directly into cell membranes, that allow nanite particles to interconnect electronically without leaving their host cells.|n|nTECH ONE: Power drain of augmentations is reduced slightly.|n|nTECH TWO: Power drain of augmentations is reduced moderately.|n|nTECH THREE: Power drain of augmentations is reduced.|n|nTECH FOUR: Power drain of augmentations is reduced significantly."
     MPInfo="Reduces the cost of other augs.  Automatically used when needed.  Energy Drain: None"
     CombinedDesc="When combined with Synthetic Heart, the energy bonus and penalty are added together. Current energy rate: %d%%"
     LevelValues(0)=0.950000
     LevelValues(1)=0.800000
     LevelValues(2)=0.650000
     LevelValues(3)=0.500000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=5
}
