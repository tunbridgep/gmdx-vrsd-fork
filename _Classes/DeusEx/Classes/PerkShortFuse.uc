//=============================================================================
// PerkShortFuse.
//=============================================================================
class PerkShortFuse extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="SHORT FUSE"
    PerkDescription="|nGrenade detonation time is 1 second shorter. |n|nRequires: Demolitions: ADVANCED"
    PerkSkill=Class'DeusEx.SkillDemolition'
    PerkCost=200
    perkLevelRequirement=1
    PerkValue=1
}