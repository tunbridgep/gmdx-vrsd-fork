//=============================================================================
// PerkStoppingPower.
//=============================================================================
class PerkStoppingPower extends Perk;

defaultproperties
{
    PerkName="STOPPING POWER"
    PerkDescription="An agent can stop an enemy in their tracks with a shotgun blast, gaining bonus damage (+%d%%) when every pellet hits a single target."
    PerkSkill=Class'DeusEx.SkillWeaponRifle'
    PerkCost=150
    PerkLevelRequirement=2
    PerkValueDisplay=Delta_Percentage
    PerkValue=1.25
}
