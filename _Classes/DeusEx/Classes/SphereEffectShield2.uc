//=============================================================================
// SphereEffect.
//=============================================================================
class SphereEffectShield2 extends Effects;

//simulated function Tick(float deltaTime)
//{
//	ScaleGlow = 2.0 * (LifeSpan / Default.LifeSpan);
//}

defaultproperties
{
     LifeSpan=0.060000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'HDTPDecos.Skins.HDTPAlarmLightTex6'
     Mesh=LodMesh'DeusExItems.SphereEffect'
     DrawScale=7.500000
     ScaleGlow=2.000000
     bUnlit=True
     SoundRadius=160
     SoundVolume=255
     SoundPitch=96
     LightType=LT_Steady
     LightBrightness=224
     LightHue=160
     LightSaturation=32
     LightRadius=20
     RotationRate=(Yaw=98304)
}
