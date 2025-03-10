//=============================================================================
// PerkSensorBurnout.
//=============================================================================
class PerkSensorBurnout extends Perk;

defaultproperties
{
    PerkName="SENSOR BURNOUT"
    PerkDescription="After being manipulated by scrambler grenades, affected robots will reboot over %d seconds."
    PerkSkill=Class'DeusEx.SkillDemolition'
    PerkCost=425
    PerkLevelRequirement=2
    PerkValueDisplay=Standard
    PerkValue=30
}
