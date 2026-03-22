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

var localized String TooSick;

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

function int GetHealAmount(DeusExPlayer player)
{
    local float amount;
    local Wound wound;
    
    //SARGE: Radiation poisoning now removes healing entirely
    if (player.WoundManager != None)
    {
        wound = player.WoundManager.GetWoundByType(class'WoundRadiation');
        if (wound != None && wound.HasWound())
            return 0;
    }

    if (glutton != None && glutton.bPerkObtained)
        amount = super.GetHealAmount(player) * 1.5;
    else
        amount = super.GetHealAmount(player);
    
    //Glutton gives amount rounded up
    return int(amount+0.9);
}

function int GetBioenergyAmount(DeusExPlayer player)
{
    local float amount;

    if (glutton != None && glutton.bPerkObtained)
        amount = super.GetBioenergyAmount(player) * 1.5;
    else
        amount = super.GetBioenergyAmount(player);

    //Glutton gives amount rounded up
    return int(amount+0.9);
}

//Check hunger before letting us use them
function bool RestrictedUse(DeusExPlayer player, optional out string RestrictedMsg)
{
    local int maxFullness;
    local Wound wound, wound2;
    
    //SARGE: Radiation sickness and poisoning now stop eating entirely
    if (player.WoundManager != None)
    {
        wound = player.WoundManager.GetWoundByType(class'WoundRadiation');
        wound2 = player.WoundManager.GetWoundByType(class'WoundPoison');
        if ((wound != None && wound.HasWound()) || (wound2 != None && wound2.HasWound()))
        {
            RestrictedMsg = TooSick;
            return true;
        }
    }
    
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

    RefreshGlutton();
    str = super.GetDescription2(player);

    if (fullness > 0 && (player.bHardcoreMode || player.bRestrictedMetabolism) && (!isA('Vice') || !player.bAddictionSystem))
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

//Shenanigans Fatness
function FattenUp(DeusExPlayer player)
{
    if (player.bShenanigans && player.fullUp >= 90 && FRand() < 0.1) //When nearly full, have a 10% chance of getting fatter
        player.Fatness = MIN(player.Fatness + 1,255);
}

//What happens when we eat this.
function OnActivate(DeusExPlayer player)
{
    RefreshGlutton();
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
     TooSick="You feel too nauseous to eat"
     bGluttonous=true
     msgConsumed="%d consumed"
}
