//=============================================================================
// WineBottle.
//=============================================================================
class WineBottle extends Vice; //DeusExPickup;

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

		if (player != none && player.fullUp >= 100 && (player.bHardCoreMode || player.bRestrictedMetabolism) && !player.bAddictionSystem) //RSD: Added option stuff, no food limit on drugs with addiction system
		{
		GotoState('Deactivated');                                               //RSD: Otherwise we try to activate again on map transition
        player.ClientMessage(player.fatty);
		return;
		}

        UseOnce();                                                              //RSD: Moved

		if (player != None)
		{
			if (player.bAddictionSystem)                                        //RSD: Was 2, now 5 health to go alongside the addiction system bonus
            	player.HealPlayer(5, False);
            else
                player.HealPlayer(2, False);
			player.drugEffectTimer += 5.0;
			player.PlaySound(sound'drinkwine',SLOT_None);
		}

		//UseOnce();                                                            //RSD: Moved
	}
Begin:
}

defaultproperties
{
     AddictionIncrement=5.000000
     bBreakable=True
     ItemName="Wine"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPWineBottle'
     PickupViewMesh=LodMesh'HDTPItems.HDTPWineBottle'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPWineBottle'
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconWineBottle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWineBottle'
     largeIconWidth=36
     largeIconHeight=48
     Description="A nice bottle of wine."
     beltDescription="WINE"
     Texture=Texture'HDTPItems.Skins.HDTPWineBottletex2'
     Mesh=LodMesh'HDTPItems.HDTPWineBottle'
     CollisionRadius=5.060000
     CollisionHeight=16.180000
     bCollideWorld=True
     bBlockPlayers=True
     Mass=10.000000
     Buoyancy=8.000000
}
