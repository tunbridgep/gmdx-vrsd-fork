//=============================================================================
// Credits.
//=============================================================================
class Credits extends DeusExPickup;

var() int numCredits;
var localized String msgCreditsAdded;

//Show credits amount in frob string
function string GetFrobString(DeusExPlayer player)
{
    if (numCredits > 1 && player.bShowItemPickupCounts)
		return ItemName @ "(" $ numCredits $ ")"; //SARGE: Append the current charge and num copies
}

//SARGE: Modify credit amounts on higher difficulties
function SetupDifficultyMod(DeusExPlayer P)
{
    if (numCredits > 5)
    {
        if (P.iNewGamePlusCycle > 0)
            numCredits *= 0.4; //40% credits only on newgameplus
        else if (P.bHardcoreMode)
            numCredits *= 0.75; //75% credits only on hardcore mode

        numCredits = FMAX(5.0,numCredits);
    }

    super.SetupDifficultyMod(P);
}


// ----------------------------------------------------------------------
// Frob()
//
// Add these credits to the player's credits count
// ----------------------------------------------------------------------
auto state Pickup
{
	function Frob(Actor Frobber, Inventory frobWith)
	{
		local DeusExPlayer player;

		Super.Frob(Frobber, frobWith);

		player = DeusExPlayer(Frobber);

		if (player != None)
		{
            player.AddCredits(numCredits,true,true);
			player.FrobTarget = None;
			Destroy();
		}
	}
}

defaultproperties
{
     numCredits=100
     ItemName="Credit Chit"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Credits'
     PickupViewMesh=LodMesh'DeusExItems.Credits'
     ThirdPersonMesh=LodMesh'DeusExItems.Credits'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconCredits'
     beltDescription="CREDITS"
     HDTPSkin="HDTPItems.Skins.HDTPCreditstex1"
     Mesh=LodMesh'DeusExItems.Credits'
     CollisionRadius=7.000000
     CollisionHeight=0.550000
     Mass=2.000000
     Buoyancy=3.000000
}
