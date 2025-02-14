//=============================================================================
// AugCombat.
//=============================================================================
class AugEnergyTransfer extends Augmentation;

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
     Icon=Texture'GameMedia.UserInterface.AugIconEMP'
     smallIcon=Texture'GameMedia.UserInterface.AugIconEMPSmall'
     AugmentationType=Aug_Passive
     AugmentationName="Energy Transference (Passive)"
     Description="Nanoconducters in the arms absorb energy upon sustained contact with a perished organic lifeform.|nAs a measure to prevent abuse of power, the augmentation's manufacturer designed it to only function if the IFF identifies the victim to be a hostile threat.|n|nTECH ONE: Stamina and bioelectrical energy are transfered from the victim to the host when the victim is killed or knocked out through physical contact (10% Stamina, 3% Bioenergy). Knocking an unaware target out will result in additional energy transference (+50%).|n|nTECH TWO: Energy transference is increased moderately (20%, 6%).|n|nTECH THREE: Energy transference is increased significantly (30%, 9%).|n|nTECH FOUR: Energy transference is optimal (40%, 12%)."
     MPInfo="When active, you do double damage with melee weapons.  Energy Drain: Low"
     LevelValues(0)=1.000000
     LevelValues(1)=2.000000
     LevelValues(2)=3.000000
     LevelValues(3)=4.000000
     AugmentationLocation=LOC_Arm
     MPConflictSlot=1
}
