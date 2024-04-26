//=============================================================================
// PerkSonicTransducerSensor.
//=============================================================================
class PerkSonicTransducerSensor extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="SONIC-TRANSDUCER SENSOR"
    PerkDescription="|nNearby proximity mines emit audible feedback to your infolink, revealing their location. |n|nRequires: Demolitions: TRAINED"
    PerkSkill=Class'DeusEx.SkillDemolition'
    PerkCost=100
    perkLevelRequirement=0
    PerkValue=1
}