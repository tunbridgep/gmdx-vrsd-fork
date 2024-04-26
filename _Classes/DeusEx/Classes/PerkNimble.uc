//=============================================================================
// PerkNimble.
//=============================================================================
class PerkNimble extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="NIMBLE"
    PerkDescription="|nAn agent is silent whilst mantling and climbing ladders. |n|nRequires: Stealth: TRAINED"
    PerkSkill=Class'DeusEx.SkillStealth'
    PerkCost=150
    perkLevelRequirement=0
    PerkValue=1
}