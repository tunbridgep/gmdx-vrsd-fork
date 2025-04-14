//=============================================================================
// LiquorBottle.
//=============================================================================
class LiquorBottle extends Vice; //DeusExPickup;

var bool bUseHunger;

function Eat(DeusExPlayer player)
{
    super.Eat(player);
    player.drugEffectTimer += 4.0;
    player.PlaySound(sound'drinkwine',SLOT_None);
}

defaultproperties
{
     healAmount=2
     AddictionIncrement=5.000000
     bUseHunger=true
     bBreakable=true
     ItemName="Liquor"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconLiquorBottle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconLiquorBottle'
     largeIconWidth=20
     largeIconHeight=48
     Description="The label is torn off, but it looks like some of the good stuff."
     beltDescription="LIQUOR"
     Mesh=LodMesh'DeusExItems.LiquorBottle'
     HDTPMesh="HDTPItems.HDTPLiquorBottle"
     HDTPTexture="HDTPItems.Skins.HDTPLiquorBottletex2"
     CollisionRadius=5.620000
     CollisionHeight=12.500000
     bCollideWorld=true
     bBlockPlayers=true
     Mass=10.000000
     Buoyancy=8.000000
     fullness=4
}
