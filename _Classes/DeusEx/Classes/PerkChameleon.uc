//=============================================================================
// PerkChameleon.
//=============================================================================
class PerkChameleon extends Perk;

   //PerkDescription="|nAn agent modifies thermoptic camo output that enables the user to pass through laser alarms undetected and reduces drain while standing still (-30%). |n|nRequires: Environmental Training: MASTER"

defaultproperties
{
    PerkName="CHAMELEON"
    PerkDescription="An agent modifies thermoptic camo output that enables the user to pass through laser alarms undetected."
    PerkSkill=Class'DeusEx.SkillEnviro'
    PerkCost=250
    PerkLevelRequirement=3
    PerkValue=0.1
}
