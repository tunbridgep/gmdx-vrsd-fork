//=============================================================================
// OutfitSpawner3
// Spawns an outfit, or does nothing depending on if the outfits mod is installed.
//=============================================================================
class OutfitSpawner3 extends OutfitSpawner;

defaultproperties
{
     FragType=Class'DeusEx.PaperFragment'
     ItemName="Augmentique Collectable"
     bBlockSight=True
     bInvincible=True
     Skin=Texture'FemJC.deco.AugmentiqueAccBoxTex1'
     Mesh=LodMesh'DeusExDeco.BoxSmall'
     DrawScale=1.000000
     CollisionRadius=13.000000
     CollisionHeight=5.180000
     Mass=20.000000
     Buoyancy=30.000000
}
