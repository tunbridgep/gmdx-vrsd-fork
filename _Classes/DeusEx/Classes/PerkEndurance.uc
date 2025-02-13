//=============================================================================
// PerkEndurance.
//=============================================================================
class PerkEndurance extends Perk;

defaultproperties
{
    PerkName="ENDURANCE"
    PerkDescription="An agent's stamina regenerates at a faster rate (+%d%%), even while crouched."
    PerkSkill=Class'DeusEx.SkillSwimming'
    PerkCost=300
    PerkLevelRequirement=3
    PerkValueDisplay=Percentage
    PerkValue=1
}
