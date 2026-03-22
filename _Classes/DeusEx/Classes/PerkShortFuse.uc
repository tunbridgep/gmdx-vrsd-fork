//=============================================================================
// PerkShortFuse.
//=============================================================================
class PerkShortFuse extends Perk;

defaultproperties
{
    PerkName="SHORT FUSE"
    //Horrible dirty hardcode
    PerkDescription="Grenade detonation time is 1 second shorter. Fuse time can be toggled with the Reload key while a grenade is held."
    PerkSkill=Class'DeusEx.SkillDemolition'
    PerkCost=200
    PerkLevelRequirement=2
    PerkValue=1
}
