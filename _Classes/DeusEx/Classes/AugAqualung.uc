//=============================================================================
// AugAqualung.
//=============================================================================
class AugAqualung extends Augmentation;

var float mult, pct;

var float mpAugValue;
var float mpEnergyDrain;

/*state Active                                                                  //RSD: Aqualung no longer boosts max stamina/breath, just drain/regen rate
{
Begin:
	mult = Player.SkillSystem.GetSkillLevelValue(class'SkillSwimming');
	pct = Player.swimTimer / Player.swimDuration;
	Player.UnderWaterTime = LevelValues[CurrentLevel];
	Player.swimDuration = Player.UnderWaterTime;// * mult;                      //RSD: Removed effect of Athletcis on stamina
	Player.swimTimer = Player.swimDuration * pct;

	if (( Level.NetMode != NM_Standalone ) && Player.IsA('Human') )
	{
		mult = Player.SkillSystem.GetSkillLevelValue(class'SkillSwimming');
		Player.WaterSpeed = Human(Player).Default.mpWaterSpeed * 2.0 * mult;
	}
}

function Deactivate()
{
	Super.Deactivate();

	mult = Player.SkillSystem.GetSkillLevelValue(class'SkillSwimming');
	pct = Player.swimTimer / Player.swimDuration;
	Player.UnderWaterTime = Player.Default.UnderWaterTime;
	Player.swimDuration = Player.UnderWaterTime;// * mult;                      //RSD: Removed effect of Athletics on stamina
	Player.swimTimer = Player.swimDuration * pct;

	if (( Level.NetMode != NM_Standalone ) && Player.IsA('Human') )
	{
		mult = Player.SkillSystem.GetSkillLevelValue(class'SkillSwimming');
		Player.WaterSpeed = Human(Player).Default.mpWaterSpeed * mult;
	}
}*/

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
     mpAugValue=240.000000
     mpEnergyDrain=10.000000
     EnergyRate=0.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconAquaLung'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconAquaLung_Small'
     AugmentationType=Aug_Toggle
     EnergyReserved=10
     AugmentationName="Aqualung"
     Description="Soda lime exostructures imbedded in the alveoli of the lungs convert CO2 to O2, extending the time an agent can remain underwater.|n|nTECH ONE: Lung capacity is extended slightly.|n|nTECH TWO: Lung capacity is extended moderately.|n|nTECH THREE: Lung capacity is extended significantly.|n|nTECH FOUR: An agent can stay underwater indefinitely."
     MPInfo="When active, you can stay underwater 12 times as long and swim twice as fast.  Energy Drain: Low"
     LevelValues(0)=1.150000
     LevelValues(1)=1.300000
     LevelValues(2)=1.450000
     LevelValues(3)=1.600000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=9
}
