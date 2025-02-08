//=============================================================================
// PerkDoorsman.
//=============================================================================
class PerkDoorsman extends Perk;

function OnPerkPurchase()
{
    local DeusExMover mov;

    foreach PerkOwner.AllActors(class'DeusExMover',mov)
    {
        mov.minDamageThreshold -= PerkValue;
        if (mov.minDamageThreshold <= 0)
        mov.minDamageThreshold = 1;
        mov.bPerkApplied = True;
    }
}

defaultproperties
{
    PerkName="DOORSMAN"
    PerkDescription="With advanced lockpicking skill comes knowledge of doors and their structural vulnerabilities. The damage threshold of all breakable doors is reduced by %d."
    PerkSkill=Class'DeusEx.SkillLockpicking'
    PerkCost=225
    PerkLevelRequirement=2
    PerkValueDisplay=Standard
    PerkValue=5
}
