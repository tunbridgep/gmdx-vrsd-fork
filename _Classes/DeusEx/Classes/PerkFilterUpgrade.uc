//=============================================================================
// PerkFilterUpgrade.
//=============================================================================
class PerkFilterUpgrade extends Perk;

function bool IsVisible()
{
    return PerkOwner != None && (PerkOwner.iStaminaSystem > 0 || PerkOwner.bHardcoreMode);
}

defaultproperties
{
    PerkName="FILTER UPGRADE"
    PerkDescription="An agent uses an upgraded hazmat suit that filters out harmful chemicals, removing stamina damage from poison and tear gas entirely."
    PerkSkill=Class'DeusEx.SkillEnviro'
    PerkCost=75
    PerkLevelRequirement=1
    PerkValue=0.0
}
