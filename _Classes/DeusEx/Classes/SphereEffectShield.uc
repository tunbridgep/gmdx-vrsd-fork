//=============================================================================
// SphereEffect.
//=============================================================================
class SphereEffectShield extends Effects;

//simulated function Tick(float deltaTime)
//{
//	ScaleGlow = 2.0 * (LifeSpan / Default.LifeSpan);
//}

defaultproperties
{
     LifeSpan=0.040000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'HDTPDecos.Skins.HDTPAlarmLightTex6'
     Mesh=LodMesh'DeusExItems.SphereEffect'
     DrawScale=6.500000
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
