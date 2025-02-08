//=============================================================================
// PerkAdrenalineRush.
//=============================================================================
class PerkAdrenalineRush extends Perk;

defaultproperties
{
    PerkName="ADRENALINE RUSH"
    PerkDescription="An agent receives a burst of stamina after successful elimination of a target using a hand-to-hand weapon (%d%%)."
    PerkSkill=Class'DeusEx.SkillSwimming'
    PerkCost=250
    PerkLevelRequirement=2
    PerkValueDisplay=Delta_Percentage
    PerkValue=0.5
}
