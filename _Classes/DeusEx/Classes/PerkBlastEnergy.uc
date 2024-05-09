//=============================================================================
// PerkBlastEnergy.
//=============================================================================
class PerkBlastEnergy extends Perk;

// Trash: TODO change the PerkValue here to the proper Plasma Rifle value.

defaultproperties
{
    PerkName="BLAST ENERGY"
    PerkDescription="|nAn agent tunes the plasma rifle to reduce damage falloff within the same blast radius.|n|nRequires: Heavy Weapons: ADVANCED"
    PerkSkill=Class'DeusEx.SkillWeaponHeavy'
    PerkIcon=Texture'RSDCrap.UserInterface.PerkBlastEnergy'
    PerkCost=250
    PerkLevelRequirement=2
    PerkValue=1
}