//=============================================================================
// PerkTacticalDistraction.
//=============================================================================
class PerkTacticalDistraction extends Perk;

defaultproperties
{
    PerkName="TACTICAL DISTRACTION"
    PerkDescription="|nAn agent is skilled in the art of distraction, confusing enemies for longer with sound (+50%) and diverting enraged animals on the attack by using carcasses as bait.|n|nRequires: Stealth: MASTER"
    PerkSkill=Class'DeusEx.SkillStealth'
    PerkCost=250
    perkLevelRequirement=2
    PerkValue=1.5
}