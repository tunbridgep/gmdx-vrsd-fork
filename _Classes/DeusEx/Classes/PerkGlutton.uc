//=============================================================================
// PerkGlutton.
//=============================================================================
class PerkGlutton extends Perk;

function OnPerkPurchase()
{
    class'SodaCan'.default.MaxCopies *= 2;
    class'Liquor40oz'.default.MaxCopies *= 2;
    class'LiquorBottle'.default.MaxCopies *= 2;
    class'WineBottle'.default.MaxCopies *= 2;
    class'CandyBar'.default.MaxCopies *= 2;
    class'SoyFood'.default.MaxCopies *= 2;
}

/*
function OnMapLoadAndPurchase()
{
    local RSDEdible edible;

    foreach PerkOwner.AllActors(class'RSDEdible',edible)
        edible.MaxCopies = edible.default.MaxCopies;
}
*/

defaultproperties
{
    PerkName="Glutton"
    PerkDescription="An agent is able to carry twice as many food and drink items, and hunger threshold is increased (%d%%)"
    PerkCost=500
    PerkValue=1.25
}
