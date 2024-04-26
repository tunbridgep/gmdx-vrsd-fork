//=============================================================================
// PerkSharpEyed.
//=============================================================================
class PerkSharpEyed extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="SHARP-EYED"
    PerkDescription="|nAn agent can clearly see the traversed flight path of airborne darts and throwing knives. |n|nRequires: Low-Tech: TRAINED"
    PerkSkill=Class'DeusEx.SkillWeaponLowTech'
    PerkCost=125
    perkLevelRequirement=0
    PerkValue=1
}