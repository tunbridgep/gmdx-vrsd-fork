//=============================================================================
// EnterWorldTrigger.
//=============================================================================
class FlashViewTrigger extends Trigger;

//CyberP: player red/blue flash event. Lazy trigger. May expand
var() bool bBlueFlash;

function Trigger(Actor Other, Pawn Instigator)
{
	local DeusExPlayer player;

        player = DeusExPlayer(GetPlayerPawn());
		if(player != none)
		{
		    if (bBlueFlash)
			    player.ClientFlash(0.1, vect(0,0,100));
            else
            {
                player.ClientFlash(0.1, vect(64,0,0));
			    player.IncreaseClientFlashLength(3);
			}
			Destroy();
		}

}

function Touch(Actor Other)
{
	local DeusExPlayer player;

		if(Other.IsA('DeusExPlayer'))
		{
		    if (bBlueFlash)
			    DeusExPlayer(Other).ClientFlash(0.1, vect(0,0,100));
            else
            {
                DeusExPlayer(Other).ClientFlash(0.1, vect(64,0,0));
			    DeusExPlayer(Other).IncreaseClientFlashLength(3);
			}
			Destroy();
		}

}

defaultproperties
{
}
