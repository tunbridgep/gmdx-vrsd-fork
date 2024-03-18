//---------------------------------------------------------------------------
//GMDXSparkFade, tracer hit small spark effect with light :dasraiser & CyberP
//---------------------------------------------------------------------------
class GMDXSparkFade extends Spark;

var float lightlSpan;
var float lightdtSpan;


simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	lightdtSpan=LightBrightness/lightlSpan;
	lightlSpan=LightBrightness;

}

simulated function Tick( float dt )
{
	if (LightBrightness>0.0)
	{
	  lightlSpan-=(dt*lightdtSpan);
	  if (lightlSpan<0) lightLSpan=0;
	  LightBrightness=lightlSpan;
	} else
	{
	  LightBrightness=0.0;
	  LightRadius=0.0;
	  LightType=LT_None;
	}
}

defaultproperties
{
     lightlSpan=0.200000
     LifeSpan=0.220000
     DrawScale=0.190000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=128
     LightHue=40
     LightSaturation=128
     LightRadius=1
}
