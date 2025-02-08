//=============================================================================
// PerkGlutton.
//=============================================================================
class PerkGlutton extends Perk;

function OnPerkPurchase()
{
    local RSDEdible edible;

    foreach PerkOwner.AllActors(class'RSDEdible',edible)
    {
        edible.MaxCopies = edible.default.MaxCopies * 2;
    }
}

defaultproperties
{
    PerkName="Glutton"
    PerkDescription="An agent is able to carry twice as many food and drink items, and hunger threshold is increased (%d%%)"
    PerkCost=500
    PerkValue=1.25
}
