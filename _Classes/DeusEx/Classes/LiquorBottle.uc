//=============================================================================
// LiquorBottle.
//=============================================================================
class LiquorBottle extends Vice; //DeusExPickup;

function Eat(DeusExPlayer player)
{
    if (!player.bAddictionSystem)                                        //RSD: Was 2, now 5 health to go alongside the addiction system bonus //SARGE: Actually just back to 2, with addiction system only giving the buff
        player.HealPlayer(2, False);
    player.drugEffectTimer += 4.0;
    player.PlaySound(sound'drinkwine',SLOT_None);
}

defaultproperties
{
     AddictionIncrement=5.000000
     bUseHunger=True
     bBreakable=True
     ItemName="Liquor"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPLiquorBottle'
     PickupViewMesh=LodMesh'HDTPItems.HDTPLiquorBottle'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPLiquorBottle'
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconLiquorBottle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconLiquorBottle'
     largeIconWidth=20
     largeIconHeight=48
     Description="The label is torn off, but it looks like some of the good stuff."
     beltDescription="LIQUOR"
     Texture=Texture'HDTPItems.Skins.HDTPLiquorBottletex2'
     Mesh=LodMesh'HDTPItems.HDTPLiquorBottle'
     CollisionRadius=5.620000
     CollisionHeight=12.500000
     bCollideWorld=True
     bBlockPlayers=True
     Mass=10.000000
     Buoyancy=8.000000
}
