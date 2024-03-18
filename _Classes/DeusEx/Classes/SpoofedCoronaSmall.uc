//=============================================================================
// SpoofedCorona
//=============================================================================
class SpoofedCoronaSmall extends Effects;

var bool bNoScale;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (bNoScale)
	{
	Skin=Texture'Effects.Corona.Corona_B';
	DrawScale=1.300000;
	 LightSaturation=32;
	}

}

simulated function Tick(float deltaTime)
{
  if (!bNoScale)
   {
	DrawScale -= 0.15;//2 * (Default.LifeSpan - LifeSpan) / Default.LifeSpan;
	ScaleGlow = LifeSpan / Default.LifeSpan;
	}
}

defaultproperties
{
     LifeSpan=0.350000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'Effects.Corona.Corona_E'
     Mesh=LodMesh'DeusExItems.FlatFX'
     DrawScale=2.500000
     ScaleGlow=2.000000
     AmbientGlow=255
     bUnlit=True
     LightType=LT_Strobe
     LightBrightness=128
     LightHue=160
     LightSaturation=128
     LightRadius=6
     Mass=0.000000
}
