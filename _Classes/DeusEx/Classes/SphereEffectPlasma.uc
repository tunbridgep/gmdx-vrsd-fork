//=============================================================================
// SphereEffect.
//=============================================================================
class SphereEffectPlasma extends GMDXEffect;

var float size;

simulated function Tick(float deltaTime)
{
	DrawScale = 3.0 * size * (Default.LifeSpan - LifeSpan) / Default.LifeSpan;
	ScaleGlow = 2.0 * (LifeSpan / Default.LifeSpan);
}

defaultproperties
{
     size=5.000000
     LifeSpan=0.500000
     DrawType=DT_Mesh
     Style=STY_Translucent
     HDTPSkin"HDTPDecos.Skins.HDTPAlarmLightTex4"
     Skin=Texture'DeusExDeco.Skins.AlarmLightTex4'
     Mesh=LodMesh'DeusExItems.SphereEffect'
     bUnlit=True
     LightType=LT_Strobe
     LightBrightness=224
     LightHue=96
     LightSaturation=32
     LightRadius=24
}
