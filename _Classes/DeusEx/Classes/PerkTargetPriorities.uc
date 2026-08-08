//=============================================================================
// PerkTargetPriorities.
//=============================================================================
class PerkTargetPriorities extends Perk;

defaultproperties
{
    PerkName="TARGETING ROUTINES"
    //Horrible dirty hardcode
    PerkDescription="An agent is able to program the targeting routines of their proximity grenades, ensuring placed EMP and Scrambler grenades only explode in the presence of robots, and placed gas grenades only explode in the presence of organics."
    PerkSkill=Class'DeusEx.SkillDemolition'
    PerkCost=300
    PerkLevelRequirement=2
    PerkValue=1
}

