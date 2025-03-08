//=============================================================================
// BulletHole.
//=============================================================================
class BulletHole extends DeusExDecal;

// overridden to NOT rotate decal
//HDTP DDL- OVERRULED!
function DoHDTP()
{
    super.DoHDTP();
	drawscale *= 1.0 + frand()*0.2;

    if (class'DeusExPlayer'.default.bJohnWooSparks)
        drawScale *= 1.5;

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
