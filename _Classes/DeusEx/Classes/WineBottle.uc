//=============================================================================
// WineBottle.
//=============================================================================
class WineBottle extends Vice; //DeusExPickup;

function Eat(DeusExPlayer player)
{
    if (!player.bAddictionSystem)                                        //RSD: Was 2, now 5 health to go alongside the addiction system bonus //SARGE: Actually just back to 2, with addiction system only giving the buff
        player.HealPlayer(2, False);
    player.drugEffectTimer += 5.0;
    player.PlaySound(sound'drinkwine',SLOT_None);
}

defaultproperties
{
     AddictionIncrement=5.000000
     bUseHunger=True
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
