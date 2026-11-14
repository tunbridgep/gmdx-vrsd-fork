//=============================================================================
// PerkRemoteDetonation.
//=============================================================================
class PerkRemoteDetonation extends Perk;

defaultproperties
{
    PerkName="Remote Detonation"
    PerkDescription="An agent is able to remotely detonate all of their placed wall mines by using the Change Ammo key while holstered. Manually Disabled grenades can still be proximity triggered."
    PerkCost=50
    PerkSkill=Class'DeusEx.SkillDemolition'
    PerkLevelRequirement=1
}
