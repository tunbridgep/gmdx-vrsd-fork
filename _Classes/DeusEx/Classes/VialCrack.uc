//=============================================================================
// VialCrack.
//=============================================================================
class VialCrack extends Vice; //DeusExPickup;

function Eat(DeusExPlayer player)
{
    player.drugEffectTimer += 60.0;
    player.bHardDrug = True;
    if (!player.bAddictionSystem)
        player.HealPlayer(-10, False);
}

defaultproperties
{
     AddictionType=2
     AddictionIncrement=60.000000
     DrugIncrement=60.000000
     MaxDrugTimer=60.000000
     bBreakable=True
     maxCopies=20
     ItemName="Zyme Vial"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.VialCrack'
     PickupViewMesh=LodMesh'DeusExItems.VialCrack'
     ThirdPersonMesh=LodMesh'DeusExItems.VialCrack'
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconVial_Crack'
     largeIcon=Texture'DeusExUI.Icons.LargeIconVial_Crack'
     largeIconWidth=24
     largeIconHeight=43
     Description="A vial of zyme, brewed up in some basement lab."
     beltDescription="ZYME"
     Mesh=LodMesh'DeusExItems.VialCrack'
     CollisionRadius=1.410000
     CollisionHeight=1.710000
     bCollideWorld=True
     bBlockPlayers=True
     Mass=2.000000
     Buoyancy=3.000000
}
