//=============================================================================
// RSDEdible
// SARGE: Base Class to handle Edible objects (candy bars, sodas, etc)
//=============================================================================
class RSDEdible extends ConsumableItem abstract;

var int fullness;                                                   //How much a given food item should fill up the player

var localized string msgConsumed;                                   //SARGE: Message to print when consuming food.

//Add fullness amount to the description field
var localized String HungerLabel;

var private PerkGlutton glutton;

var const bool bGluttonous;                                         //SARGE: Is this edible affected by gluttony

function RefreshGlutton()
{
    local DeusExPlayer player;

    if (glutton != None)
        return;

    player = DeusExPlayer(GetPlayerPawn());

    if (player != None)
        glutton = PerkGlutton(player.PerkManager.GetPerkWithClass(class'DeusEx.PerkGlutton'));
}

//SARGE: Edibles can always be added as secondaries
function bool CanAssignSecondary(DeusExPlayer player)
{
    return true;
}

//Gluttony perk lets us hold twice as much
function int RetMaxCopies()
{
    RefreshGlutton();
    if (glutton != none && glutton.bPerkObtained && bGluttonous)
        return default.maxCopies * 2;
    else
        return default.maxCopies;
}

//Check hunger before letting us use them
function bool RestrictedUse(DeusExPlayer player)
{
    local int maxFullness;
    
    RefreshGlutton();

    maxFullness = 100;

    if (glutton != None && glutton.bPerkObtained)
        maxFullness *= glutton.PerkValue;

    return player != none && player.fullUp >= maxFullness && (player.bHardCoreMode || player.bRestrictedMetabolism);
}

//Add Fullnes to description
function string GetDescription2(DeusExPlayer player)
{
    local string str;

    str = super.GetDescription2(player);

    if (fullness > 0 && (player.bHardcoreMode || player.bRestrictedMetabolism))
        str = AddLine(str,sprintf(HungerLabel,fullness));

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

//What happens when we eat this.
function OnActivate(DeusExPlayer player)
{
    player.ClientMessage(sprintf(msgConsumed,ItemName));
    Super.OnActivate(player);
    Eat(player);
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
