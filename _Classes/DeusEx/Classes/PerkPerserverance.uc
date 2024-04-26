//=============================================================================
// PerkPerserverance.
//=============================================================================
class PerkPerserverance extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="PERSERVERANCE"
    PerkDescription="|nAn agent's vision is not impaired whilst drowning and movement speed is not hindered by damage to the legs unless in a critical state.|n|nRequires: Athletics: TRAINED"
    PerkSkill=Class'DeusEx.SkillSwimming'
    PerkCost=100
    perkLevelRequirement=0
    PerkValue=1
}