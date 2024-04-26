//=============================================================================
// PerkFieldRepair.
//=============================================================================
class PerkFieldRepair extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="FIELD REPAIR"
    PerkDescription="|nAn agent can perform more effective equipment repairs with biocells (1.5x).|n|nRequires: Environmental Training: TRAINED"
    PerkSkill=Class'DeusEx.SkillEnviro'
    PerkCost=200
    perkLevelRequirement=0
    PerkValue=1.5
}