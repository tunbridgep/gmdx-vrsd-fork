//=============================================================================
// PerkBiogenic.
//=============================================================================
class PerkBiogenic extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="BIOGENIC"
    PerkDescription="|nAn agent recieves additional bioelectrical charge from biocells (+5). |n|nRequires: Medicine: TRAINED"
    PerkSkill=Class'DeusEx.SkillMedicine'
    PerkCost=175
    perkLevelRequirement=0
    PerkValue=1
}