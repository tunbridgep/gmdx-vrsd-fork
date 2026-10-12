//=============================================================================
// WaterPool.
//=============================================================================
class WaterPoolTiny extends ScaledDecal;

simulated function Tick(float deltaTime)
{
	time += deltaTime;
	if (time <= spreadTime)
	{
		DrawScale = GetMaxDrawScaleModified() * time / spreadTime;
		ReattachDecal(vect(0.1,0.1,0));
	}
	else if (time > (spreadTime * 3.0))
		Destroy();
}

defaultproperties
{
     spreadTime=1.000000
     maxDrawScale=0.1800000
     Texture=Texture'DeusExItems.Skins.FlatFXTex47'
     ScaleGlow=1.000000
     time=0.000000
}
