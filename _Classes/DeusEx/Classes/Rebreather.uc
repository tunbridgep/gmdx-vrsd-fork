//=============================================================================
// Rebreather.
//=============================================================================
class Rebreather extends ChargedPickup;

function ChargedPickupUpdate(DeusExPlayer Player)
{
	Super.ChargedPickupUpdate(Player);

	Player.swimTimer += 0.15;
	if (Player.swimTimer >= Player.swimDuration)                                //RSD: WTF this was never capped
		Player.swimTimer = Player.swimDuration;
}

defaultproperties
{
     skillNeeded=Class'DeusEx.SkillEnviro'
     LoopSound=Sound'DeusExSounds.Pickup.RebreatherLoop'
     ChargedIcon=Texture'DeusExUI.Icons.ChargedIconRebreather'
     chargeMult=0.100000
     ExpireMessage="Rebreather power supply used up"
     ItemName="Rebreather"
     PlayerViewOffset=(X=30.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Rebreather'
     PickupViewMesh=LodMesh'DeusExItems.Rebreather'
     ThirdPersonMesh=LodMesh'DeusExItems.Rebreather'
     Charge=400
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconRebreather'
     largeIcon=Texture'DeusExUI.Icons.LargeIconRebreather'
     largeIconWidth=44
     largeIconHeight=34
     Description="A disposable chemical scrubber that can extract oxygen from water during brief submerged operations."
     beltDescription="REBREATHR"
     Mesh=LodMesh'DeusExItems.Rebreather'
     CollisionRadius=6.900000
     CollisionHeight=3.610000
     Mass=10.000000
     Buoyancy=8.000000
}
