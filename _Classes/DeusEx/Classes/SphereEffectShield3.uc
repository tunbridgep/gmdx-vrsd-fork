//=============================================================================
// SphereEffect.
//=============================================================================
class SphereEffectShield3 extends Effects;

var float size;

simulated function Tick(float deltaTime)
{
	DrawScale = 2.0 * size * (Default.LifeSpan - LifeSpan) / Default.LifeSpan;
	ScaleGlow = 1.0 * (LifeSpan / Default.LifeSpan);
}

defaultproperties
{
     size=5.000000
     LifeSpan=0.110000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'HDTPDecos.Skins.HDTPAlarmLightTex6'
     Mesh=LodMesh'DeusExItems.SphereEffect'
     DrawScale=0.900000
     bUnlit=True
     SoundRadius=160
     SoundVolume=255
     SoundPitch=96
     LightType=LT_Steady
     LightBrightness=224
     LightHue=160
     LightSaturation=32
     LightRadius=20
}
