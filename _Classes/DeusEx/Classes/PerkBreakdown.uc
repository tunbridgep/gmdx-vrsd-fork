//=============================================================================
// PerkBreakdown.
//=============================================================================
class PerkBreakdown extends Perk;

function OnMapLoadAndPurchase()
{
    local DeusExMover mov;

    foreach PerkOwner.AllActors(class'DeusExMover',mov)
    {
        if (mov.bPickable && !mov.bBreakable)
        {
            mov.bBreakable = true;
            mov.doorStrength = 0.8;
            mov.minDamageThreshold = PerkValue;
        }
    }
}

defaultproperties
{
    PerkName="BREAKDOWN"
    PerkDescription="Through a better understanding of demolitions technologies, an agent learns to exploit the structural weaknesses of various mechanisms -- such as bolts, locks and latches. Should they have a security weakpoint, previously unbreakable doors and containers can be broken using high explosives. (Damage Threshold %s)"
    PerkSkill=Class'DeusEx.SkillDemolition'
    PerkCost=350
    PerkLevelRequirement=3
    PerkValueDisplay=Standard
    PerkValue=160
}
