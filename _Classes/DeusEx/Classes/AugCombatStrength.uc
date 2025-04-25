//=============================================================================
// AugCombat.
//=============================================================================
class AugCombatStrength extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

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

defaultproperties
{
     mpAugValue=2.000000
     mpEnergyDrain=20.000000
     //EnergyRate=20.000000
     EnergyRate=0.000000
     AugmentationType=Aug_Toggle
     EnergyReserved=25
     Icon=Texture'DeusExUI.UserInterface.AugIconCombat'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconCombat_Small'
     AugmentationName="Combat Strength (Active)"
     Description="Sorting rotors accelerate actin and myosin concentration in the sarcoplasmic reticulum, increasing an agent's muscle strength and thereby multiplying the damage they inflict in melee combat.|n|nTECH ONE: The power of Low-Tech attacks is increased slightly.|n|nTECH TWO: The power of Low-Tech attacks is increased moderately.|n|nTECH THREE: The power of Low-Tech attacks is increased significantly.|n|nTECH FOUR: Low-Tech attacks are almost instantly lethal."
     MPInfo="When active, you do double damage with melee weapons.  Energy Drain: Low"
     LevelValues(0)=1.250000
     LevelValues(1)=1.500000
     LevelValues(2)=1.750000
     LevelValues(3)=2.000000
     AugmentationLocation=LOC_Arm
     MPConflictSlot=1
}
