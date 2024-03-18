//=============================================================================
// AugEnviro.
//=============================================================================
class AugEnviro extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;
var Localized string AugmentationName2;

state Active
{
Begin:
Player.PlaySound(Sound'PickupActivate', SLOT_Interact, 0.85, ,768,1.0); //CyberP: added new sound
}

function Deactivate()
{
	Super.Deactivate();
        Player.PlaySound(Sound'PickupDeactivate', SLOT_Interact, 0.85, ,768,1.0); //CyberP: and deactivate sound too
}

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

defaultproperties
{
     mpAugValue=0.100000
     mpEnergyDrain=20.000000
     AugmentationName2="Environmental Resistance (Automatic)"
     EnergyRate=20.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconEnviro'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconEnviro_Small'
     AugmentationName="Environmental Resistance"
     Description="Induced keratin production strengthens all epithelial tissues and reduces the agent's vulnerability to a number of environmental hazards such as radiation, tear gas, toxic poisoning, electricity & fire.|n|nTECH ONE: Toxic resistance is increased slightly.|n|nTECH TWO: Toxic resistance is increased moderately.|n|nTECH THREE: Toxic resistance is increased significantly.|n|nTECH FOUR: An agent is nearly invulnerable to damage from toxins."
     MPInfo="When active, you only take 10% damage from poison and gas, and poison and gas will not affect your vision.  Energy Drain: Low"
     LevelValues(0)=0.700000
     LevelValues(1)=0.550000
     LevelValues(2)=0.400000
     LevelValues(3)=0.200000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=3
}
