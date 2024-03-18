//=============================================================================
// Sodacan.
//=============================================================================
class Sodacan extends DeusExPickup;

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local DeusExPlayer player;
        local string staminup;
		Super.BeginState();

		player = DeusExPlayer(GetPlayerPawn());

		if (player != none && player.fullUp >= 100 && (player.bHardCoreMode || player.bRestrictedMetabolism)) //RSD: Added option stuff
		{
		GotoState('Deactivated');                                               //RSD: Otherwise we try to activate again on map transition
        player.ClientMessage(player.fatty);
		return;
		}

		if (player != None)
		{
			player.HealPlayer(2, False);
		}

		PlaySound(sound'MaleBurp');
		UseOnce();
	}
Begin:
}

function postpostbeginplay()
{
	//check for non-standard textures, adjust accordingly. HAAACKY.
	if(skin == texture'SodacanTex2' || multiskins[0] == texture'SodacanTex2')
		Multiskins[1] = texture'HDTPSodacantex2';
	else if(skin == texture'SodacanTex3' || multiskins[0] == texture'SodacanTex3')
		Multiskins[1] = texture'HDTPSodacantex3';
	else if(skin == texture'SodacanTex4' || multiskins[0] == texture'SodacanTex4')
		Multiskins[1] = texture'HDTPSodacantex4';

	super.PostPostBeginPlay();
}

defaultproperties
{
     bBreakable=True
     FragType=Class'DeusEx.PlasticFragment'
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Soda"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPsodacan'
     PickupViewMesh=LodMesh'HDTPItems.HDTPsodacan'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPsodacan'
     LandSound=Sound'DeusExSounds.Generic.MetalHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconSodaCan'
     largeIcon=Texture'DeusExUI.Icons.LargeIconSodaCan'
     largeIconWidth=24
     largeIconHeight=45
     Description="The can is blank except for the phrase 'PRODUCT PLACEMENT HERE.' It is unclear whether this is a name or an invitation."
     beltDescription="SODA"
     Mesh=LodMesh'HDTPItems.HDTPsodacan'
     CollisionRadius=3.000000
     CollisionHeight=4.500000
     Mass=5.000000
     Buoyancy=3.000000
}
