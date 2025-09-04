//=============================================================================
// PerkWetwork.
//=============================================================================
class PerkWetwork extends Perk;

function bool IsVisible()
{
    return PerkOwner != None && (PerkOwner.bAddonDrawbacks || PerkOwner.bHardcoreMode);
}

defaultproperties
{
    PerkName="Wetwork Specialist"
    PerkDescription="An agent gains an advanced understanding of non-standard weapon configurations, negating any penalties from attaching scopes, silencers and lasers."
    PerkSkill=Class'DeusEx.SkillStealth'
    PerkCost=450
    PerkLevelRequirement=2
    PerkValue=1
}
