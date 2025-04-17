//=============================================================================
// WineBottle.
//=============================================================================
class WineBottle extends Vice; //DeusExPickup;

function Eat(DeusExPlayer player)
{
    super.Eat(player);
    player.drugEffectTimer += 5.0;
    player.PlaySound(sound'drinkwine',SLOT_None);
}

defaultproperties
{
     healAmount=2
     AddictionIncrement=5.000000
     bBreakable=true
     ItemName="Wine"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconWineBottle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWineBottle'
     largeIconWidth=36
     largeIconHeight=48
     Description="A nice bottle of wine."
     beltDescription="WINE"
     HDTPTexture="HDTPItems.Skins.HDTPWineBottletex2"
     HDTPMesh="HDTPItems.HDTPWineBottle"
     Mesh=LodMesh'DeusExItems.WineBottle'
     CollisionRadius=5.060000
     CollisionHeight=16.180000
     bCollideWorld=true
     bBlockPlayers=true
     Mass=10.000000
     Buoyancy=8.000000
     fullness=4
}
