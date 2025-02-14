//=============================================================================
// PerkSecurityLoophole.
//=============================================================================
class PerkSecurityLoophole extends Perk;

defaultproperties
{
    PerkName="SECURITY LOOPHOLE"
    PerkDescription="An agent easily identifies the blindspots of modern security systems, evading camera detection for a longer period of time (%d%%) and tucking the legs away from laser tripwires."
    PerkSkill=Class'DeusEx.SkillStealth'
    PerkIcon=Texture'RSDCrap.UserInterface.PerkSecurityLoophole'
    PerkCost=200
    PerkLevelRequirement=2
    PerkValueDisplay=Delta_Percentage
    PerkValue=1.5
}
