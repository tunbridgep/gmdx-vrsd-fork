//=============================================================================
// RSDEdible
// SARGE: Base Class to handle Edible objects (candy bars, sodas, etc)
//=============================================================================
class RSDEdible extends ConsumableItem abstract;

var int fullness;                                                   //How much a given food item should fill up the player

var localized string msgConsumed;                                   //SARGE: Message to print when consuming food.

//Add fullness amount to the description field
var localized String HungerLabel;
var localized String playerHungerLabel;

var const bool bGluttonous;                                         //SARGE: Is this edible affected by gluttony

//SARGE: Edibles can always be added as secondaries
function bool CanAssignSecondary(DeusExPlayer player)
{
    return true;
}

//SARGE: Whether or not to show the hunger level in the inventory screen.
function bool DisplayHungerLevel(DeusExPlayer player)
{
    return player.bHardCoreMode || player.bRestrictedMetabolism;
}

function int GetHealAmount(DeusExPlayer player)
{
    local float amount;
    local Wound wound;
    
    if (player.PerkManager != None && player.PerkManager.GetPerkWithClass(class'PerkGlutton').bPerkObtained)
        amount = super.GetHealAmount(player) * 1.5;
    else
        amount = super.GetHealAmount(player);
    
    //Glutton gives amount rounded up
    return int(amount+0.9);
}

function int GetBioenergyAmount(DeusExPlayer player)
{
    local float amount;

    if (player.PerkManager != None && player.PerkManager.GetPerkWithClass(class'PerkGlutton').bPerkObtained)
        amount = super.GetBioenergyAmount(player) * 1.5;
    else
        amount = super.GetBioenergyAmount(player);

    //Glutton gives amount rounded up
    return int(amount+0.9);
}

//Check hunger before letting us use them
function bool RestrictedUse(DeusExPlayer player, optional out string RestrictedMsg)
{
    return !player.HungerCheck(RestrictedMsg);
}

//Add Fullnes to description
function string GetDescription2(DeusExPlayer player)
{
    local string str;

    str = super.GetDescription2(player);

    if (fullness > 0 && DisplayHungerLevel(player))
    {
        str = AddLine(str,sprintf(HungerLabel,fullness));
        str = AddLine(str,player.GetHungerString());
    }

    return str;
}

//Add to the players FullUp bar
function FillUp(DeusExPlayer player)
{
    player.fullUp+=fullness;
    if (player.fullUp > 200)                                                    //RSD: Capped at 200
        player.fullUp = 200;
}

//What happens when we eat this consumable
function Eat(DeusExPlayer player)
{
}

//Shenanigans Fatness
function FattenUp(DeusExPlayer player)
{
    if (player.bShenanigans && player.fullUp >= 90 && FRand() < 0.1) //When nearly full, have a 10% chance of getting fatter
        player.Fatness = MIN(player.Fatness + 1,255);
}

//What happens when we eat this.
function OnActivate(DeusExPlayer player)
{
    player.ClientMessage(sprintf(msgConsumed,ItemName));
    Super.OnActivate(player);
    Eat(player);
    FattenUp(player);
    FillUp(player);
}

defaultproperties
{
     fullness=0
     HungerLabel="Fullness Amount: %d%%"
     CannotUse="You cannot consume any more at this time"
     bGluttonous=true
     msgConsumed="%d consumed"
}
