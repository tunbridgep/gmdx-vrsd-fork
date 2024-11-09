//=============================================================================
// RSDEdible
// SARGE: Base Class to handle Edible objects (candy bars, sodas, etc)
//=============================================================================
class RSDEdible extends DeusExPickup abstract;

var int fullness;                                                   //How much a given food item should fill up the player

//Add fullness amount to the description field
var localized String HungerLabel;

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

//What happens when we eat this.
function Eat(DeusExPlayer player)
{
}

//Add Fullnes to description
function string GetDescription()
{
    if (fullness > 0)
        return Description $ "|n" $ sprintf(HungerLabel,fullness);
    else
        return Description;
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
}
