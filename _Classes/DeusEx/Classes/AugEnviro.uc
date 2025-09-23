//=============================================================================
// AugEnviro.
//=============================================================================
class AugEnviro extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;
var float lastEnergyTick;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
      AugmentationLocation = LOC_Subdermal;
	}
}

//We will handle energy drain automatically
simulated function bool CanDrainEnergy()
{
    return false;
}

defaultproperties
{
     mpAugValue=0.100000
     mpEnergyDrain=20.000000
     //EnergyRate=0.000000
     EnergyRate=30.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconEnviro'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconEnviro_Small'
     AugmentationName="Environmental Resistance"
     AugmentationShortName="Environ Resistance"
     Description="Induced keratin production strengthens all epithelial tissues and reduces the agent's vulnerability to a number of environmental hazards such as radiation, tear gas, toxic poisoning, electricity & fire.|n|nTECH ONE: Toxic resistance is increased slightly.|n|nTECH TWO: Toxic resistance is increased moderately.|n|nTECH THREE: Toxic resistance is increased significantly.|n|nTECH FOUR: An agent is nearly invulnerable to damage from toxins."
     MPInfo="When active, you only take 10% damage from poison and gas, and poison and gas will not affect your vision.  Energy Drain: Low"
     LevelValues(0)=0.700000
     LevelValues(1)=0.550000
     LevelValues(2)=0.400000
     LevelValues(3)=0.200000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=3
     AugmentationType=Aug_Automatic
     ActivateSound=Sound'PickupActivate'
     DeActivateSound=Sound'PickupDeactivate'
}
