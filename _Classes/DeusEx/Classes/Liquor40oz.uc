//=============================================================================
// Liquor40oz.
//=============================================================================
class Liquor40oz extends Vice; //DeusExPickup;

enum ESkinColor
{
	SC_Super45,
	SC_Bottle2,
	SC_Bottle3,
	SC_Bottle4
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Super45:		Multiskins[1]=texture'HDTPitems.skins.HDTPLiquor40oztex1'; Multiskins[3]=texture'HDTPitems.skins.HDTPLiquor40oztex1'; break;
		case SC_Bottle2:		Multiskins[1]=texture'HDTPitems.skins.HDTPLiquor40oztex3'; Multiskins[3]=texture'HDTPitems.skins.HDTPLiquor40oztex3'; break;
		case SC_Bottle3:		Multiskins[1]=texture'HDTPitems.skins.HDTPLiquor40oztex4'; Multiskins[3]=texture'HDTPitems.skins.HDTPLiquor40oztex4'; break;
		case SC_Bottle4:		Multiskins[1]=texture'HDTPitems.skins.HDTPLiquor40oztex5'; Multiskins[3]=texture'HDTPitems.skins.HDTPLiquor40oztex5'; break;
	}
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
			player.drugEffectTimer += 7.0;
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
     ItemName="Forty"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPLiquor40oz'
     PickupViewMesh=LodMesh'HDTPItems.HDTPLiquor40oz'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPLiquor40oz'
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconBeerBottle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconBeerBottle'
     largeIconWidth=14
     largeIconHeight=47
     Description="'COLD SWEAT forty ounce malt liquor. Never let 'em see your COLD SWEAT.'"
     beltDescription="FORTY"
     Texture=Texture'HDTPItems.Skins.HDTPLiquor40oztex2'
     Mesh=LodMesh'HDTPItems.HDTPLiquor40oz'
     CollisionRadius=4.000000
     CollisionHeight=9.140000
     bCollideWorld=True
     bBlockPlayers=True
     Mass=10.000000
     Buoyancy=8.000000
}
