//=============================================================================
// PerkTacticalDistraction.
//=============================================================================
class PerkTacticalDistraction extends Perk;

defaultproperties
{
    PerkName="TACTICAL DISTRACTION"
    PerkDescription="An agent is skilled in the art of distraction, confusing enemies for longer with sound (+50%) and diverting enraged animals on the attack by using carcasses as bait."
    PerkSkill=Class'DeusEx.SkillStealth'
    PerkCost=250
    PerkLevelRequirement=3
    PerkValueDisplay=Delta_Percentage
    PerkValue=1.5
}
