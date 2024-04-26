//=============================================================================
// PerkHumanCombustion.
//=============================================================================
class PerkHumanCombustion extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="HUMAN COMBUSTION"
    PerkDescription="|nAn agent modifies flare darts with a napalm combustion tube which ignites upon deep penetration of materials.|n|nRequires: Pistols: MASTER"
    PerkSkill=Class'DeusEx.SkillWeaponPistol'
    PerkCost=250
    perkLevelRequirement=2
    PerkValue=1
}