//=============================================================================
// PerkPiercing.
//=============================================================================
class PerkPiercing extends Perk;

defaultproperties
{
    PerkName="PIERCING"
    PerkDescription="|nAn agent is more likely to cause organic targets to flinch in pain when struck by low-tech weaponry, and an agent deals 20% more damage to bots with low-tech weaponry. |n|nRequires: Low-Tech: ADVANCED"
    PerkSkill=Class'DeusEx.SkillWeaponLowTech'
    PerkCost=250
    perkLevelRequirement=1
    PerkValue=1.2
}