//=============================================================================
// PerkControlledBurn.
//=============================================================================
class PerkControlledBurn extends Perk;

defaultproperties
{
    PerkName="CONTROLLED BURN"
    PerkDescription="|nAn agent is trained with the use of the flamethrower, ensuring that the igniting fuel is not blocked by targets.|n|nRequires: Heavy Weapons: TRAINED"
    PerkSkill=Class'DeusEx.SkillWeaponHeavy'
    PerkIcon=Texture'RSDCrap.UserInterface.PerkControlledBurn'
    PerkCost=150
    PerkLevelRequirement=1
    PerkValue=1
}