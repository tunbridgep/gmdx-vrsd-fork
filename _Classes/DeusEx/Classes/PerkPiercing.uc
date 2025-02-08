//=============================================================================
// PerkPiercing.
//=============================================================================
class PerkPiercing extends Perk;

defaultproperties
{
    PerkName="PIERCING"
    PerkDescription="An agent is more likely to cause organic targets to flinch in pain when struck by low-tech weaponry, and an agent deals %d%% more damage to bots with low-tech weaponry."
    PerkSkill=Class'DeusEx.SkillWeaponLowTech'
    PerkCost=250
    PerkLevelRequirement=2
    PerkValueDisplay=Delta_Percentage
    PerkValue=1.2
}
