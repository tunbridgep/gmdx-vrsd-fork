//=============================================================================
// PerkSteady.
//=============================================================================
class PerkSteady extends Perk;

defaultproperties
{
    PerkName="STEADY"
    PerkDescription="An agent's standing accuracy bonus with rifles is accelerated by %d%%."
    PerkSkill=Class'DeusEx.SkillWeaponRifle'
    PerkCost=200
    PerkLevelRequirement=1
    PerkValueDisplay=Percentage
    PerkValue=0.25
}
