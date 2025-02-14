//=============================================================================
// AugAmmoCap.
//=============================================================================
class AugAmmoCap extends Augmentation;

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
     EnergyRate=0.000000
     Icon=Texture'GMDXSFX.UI.AugIconAmmoCap'
	 AugmentationType=Aug_Passive
     smallIcon=Texture'GMDXSFX.UI.AugIconAmmoCap_Small'
     AugmentationName="Ammo Capacity (Passive)"
     Description="A nanofiber composite weave in the upper appendicular skeleton gives an agent expanded weight-carrying capabilities.|n|nTECH ONE: Capacity increases slightly for all ammunition types (20%)|n|nTECH TWO: Capacity increases moderately for all ammunition types (30%).|n|nTECH THREE: Capacity increases significantly for all ammunition types (40%).|n|nTECH FOUR: An agent can carry enough ammunition to supply a small army (50%)."
     MPInfo="When active, you do double damage with melee weapons.  Energy Drain: Low"
     LevelValues(0)=0.250000
     LevelValues(1)=0.500000
     LevelValues(2)=0.750000
     LevelValues(3)=1.000000
     AugmentationLocation=LOC_Arm
     MPConflictSlot=1
}
