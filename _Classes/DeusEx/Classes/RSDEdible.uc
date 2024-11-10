//=============================================================================
// RSDEdible
// SARGE: Base Class to handle Edible objects (candy bars, sodas, etc)
// SARGE: Now also handles medkits and other consumables
//=============================================================================
class RSDEdible extends DeusExPickup abstract;

var int fullness;                                                   //How much a given food item should fill up the player
var int healAmount;                                                 //SARGE: Put healing amoung here to make the code more generic
var int bioenergyAmount;                                            //SARGE: Put recharge here to make code more generic

//Add fullness amount to the description field
var localized String HungerLabel;
var localized String HealsLabel;
var localized String HealLabel;
var localized String RechargeLabel;
var localized String RechargesLabel;

//SARGE: Move hunger/etc checks into separate function, so they can be used from the left frob button as well
function bool RestrictedUse(DeusExPlayer player)
{
    return player != none && player.fullUp >= 100 && (player.bHardCoreMode || player.bRestrictedMetabolism);
}

function bool DoLeftFrob(DeusExPlayer frobber)
{
    if (!RestrictedUse(frobber)) //SARGE: We have to check this here rather than simply going to Activate because frobbing breaks otherwise
        GotoState('Activated');
    else
        frobber.ClientMessage(frobber.fatty);
    return false;
}

//Give us healing/recharge when we eat it
function HealMe(DeusExPlayer player)
{
    if (healAmount > 0)
        player.HealPlayer(healAmount, False);
    if (bioenergyAmount > 0)
        player.ChargePlayer(bioenergyAmount,True);
}

//What happens when we eat this.
function Eat(DeusExPlayer player)
{
}

//SARGE: Edibles can always be added as secondaries
function bool CanAssignSecondary(DeusExPlayer player)
{
    return true;
}

//Adds a line if we already have some text, otherwise adds nothing
function string AddLine(string str, string newStr)
{
    if (str != "")
        return str $ "|n" $ newStr;
    else
        return newStr;
}

//Add Fullnes to description
function string GetDescription2()
{
    local string str;

    if (fullness > 0)
        str = sprintf(HungerLabel,fullness);

    //Add heals amount
    if (healAmount == 1)
        str = AddLine(str,sprintf(HealLabel,healAmount));
    else if (healAmount > 1)
        str = AddLine(str,sprintf(HealsLabel,healAmount));
    
    //Add bioenergy amount
    if (bioenergyAmount == 1)
        str = AddLine(str,sprintf(RechargeLabel,bioenergyAmount));
    else if (bioenergyAmount > 1)
        str = AddLine(str,sprintf(RechargesLabel,bioenergyAmount));

    if (str != "")
        str = str $ "|n";

    return str $ super.GetDescription2();;
}

//Add to the players FullUp bar
function FillUp(DeusExPlayer player)
{
    player.fullUp+=fullness;
    if (player.fullUp > 200)                                                    //RSD: Capped at 200
        player.fullUp = 200;
}

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local DeusExPlayer player;

		Super.BeginState();

		player = DeusExPlayer(GetPlayerPawn());

        if (RestrictedUse(player))
		{
            GotoState('Deactivated');                                               //RSD: Otherwise we try to activate again on map transition
            player.ClientMessage(player.fatty);
            return;
		}

		if (player != None)
		{
            FillUp(player);
            HealMe(player);
            Eat(player);
        }

		UseOnce();
	}
Begin:
}

defaultproperties
{
     fullness=0
     HungerLabel="Fullness Amount: %d%%"
     HealsLabel="Heals %d Points"
     HealLabel="Heals %d Point"
     RechargeLabel="Recharges %d Energy Unit"
     RechargesLabel="Recharges %d Energy Units"
}
