//=============================================================================
// BulletHole.
//=============================================================================
class BulletHole extends DeusExDecal;

// overridden to NOT rotate decal
//HDTP DDL- OVERRULED!
simulated event BeginPlay()
{
	drawscale *= 1.0 + frand()*0.2;

	//if(!AttachDecal(32, vect(0.1,0.1,0)))
	//	Destroy();
	super.beginplay();
}

defaultproperties
{
     Texture=Texture'HDTPItems.Skins.HDTPFlatFXtex9'
     DrawScale=0.019000
}
