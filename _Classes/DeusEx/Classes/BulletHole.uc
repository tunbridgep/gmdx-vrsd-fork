//=============================================================================
// BulletHole.
//=============================================================================
class BulletHole extends DeusExDecal;

var float randomScale;

function BeginPlay()
{
	randomScale = FRand()*0.2;
	Super.BeginPlay();
}

// overridden to NOT rotate decal
//HDTP DDL- OVERRULED!
function DoHDTP()
{
    super.DoHDTP();
	DrawScale *= 1.0 + randomScale;

    if (class'DeusExPlayer'.default.bJohnWooSparks)
        DrawScale *= 1.55;

	//if(!AttachDecal(32, vect(0.1,0.1,0)))
	//	Destroy();
}

defaultproperties
{
     HDTPTexture="HDTPItems.Skins.HDTPFlatFXtex9"
	 Texture=Texture'DeusExItems.Skins.FlatFXtex9'
     DrawScale=0.100000
     HDTPDrawScale=0.019000
}
