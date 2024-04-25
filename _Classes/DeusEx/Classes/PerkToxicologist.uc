//=============================================================================
// PerkToxicologist.
//=============================================================================
class PerkToxicologist extends Perk;

defaultproperties
{
    PerkName="TOXICOLOGIST"
    PerkDescription="|nAn agent can instantaneously remove poisonous toxins from the bloodstream by applying a medkit to the torso. |n|nRequires: Medicine: ADVANCED"
    PerkSkill=Class'DeusEx.SkillMedicine'
    PerkCost=75
    perkLevelRequirement=1
    PerkValue=1
}