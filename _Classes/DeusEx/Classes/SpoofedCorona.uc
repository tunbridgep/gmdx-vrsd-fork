//=============================================================================
// SpoofedCorona
//=============================================================================
class SpoofedCorona extends Effects;

simulated function Tick(float deltaTime)
{
	DrawScale -= 0.45;//2 * (Default.LifeSpan - LifeSpan) / Default.LifeSpan;
	ScaleGlow = LifeSpan / Default.LifeSpan;
}

defaultproperties
{
     LifeSpan=0.350000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'Effects.Corona.Corona_E'
     Mesh=LodMesh'DeusExItems.FlatFX'
     DrawScale=7.000000
     ScaleGlow=2.000000
     AmbientGlow=255
     bUnlit=True
     LightType=LT_Strobe
     LightBrightness=96
     LightHue=160
     LightSaturation=128
     LightRadius=6
     Mass=0.000000
}
