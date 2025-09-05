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
		    //if (player.PerkNamesArray[33]==1)                                 //RSD: No more Neat Hack perk
			//numCredits *= 1.5;
			//PlaySound(Sound'objpickup',SLOT_None);
			player.Credits += numCredits;
			player.ClientMessage(Sprintf(msgCreditsAdded, numCredits));
			player.FrobTarget = None;
			Destroy();
		}
	}
}

defaultproperties
{
     numCredits=100
     msgCreditsAdded="%d credits added"
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
