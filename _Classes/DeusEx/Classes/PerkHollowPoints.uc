//=============================================================================
// PerkHollowPoints.
//=============================================================================
class PerkHollowPoints extends Perk;

defaultproperties
{
    PerkName="HOLLOW POINTS"
    PerkDescription="An agent uses hollow-pointed rounds in his pistol, increasing damage against transgenics and animals while using 10mm ammo (+%d%%)."
    PerkSkill=Class'DeusEx.SkillWeaponPistol'
    PerkCost=300
    PerkLevelRequirement=3
    PerkValue=1.5
    PerkValueDisplay=Delta_Percentage
}
