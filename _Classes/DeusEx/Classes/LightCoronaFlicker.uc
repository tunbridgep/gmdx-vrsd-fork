//=============================================================================
// Lightbulb.
//=============================================================================
class LightCoronaFlicker extends DeusExDecoration;

var Light CoronaLight;
var() float lightScale;

var float timeSincePrevious;
var float minimumTime;

function PostBeginPlay()
{
  local Light A;
  super.PostBeginPlay();

  if (Event != '')
  {
		foreach AllActors(class 'Light', A, Event)
		{
                if (A.bCorona)
                    CoronaLight = A;
        }
  }
}

//SARGE: Changed to make this less insufferable
//Now, it has to have been "on" for at least 2 seconds, with the chance of changing starting small and going up
function Tick(float deltaTime)
{
    if (CoronaLight != None)
    {
        timeSincePrevious += deltaTime;

        if (timeSincePrevious <= minimumTime)
            return;

        if (FRand() < 0.4)
        {
            CoronaLight.DrawScale = 0.0;
            LightBrightness = 0;
            AmbientSound = None;
        }
        else
        {
            CoronaLight.DrawScale = lightScale;
            LightBrightness = 68;
            AmbientSound = sound'HumLight3';
        }
        timeSincePrevious = 0;
    }
}

Function Destroyed()
{
	local Light A;

	if(CoronaLight != None)
	{
		CoronaLight.DrawScale = 0.0;
    }
}

Function Bump(actor Other)
{
  if (Other.IsA('Robot'))
     TakeDamage(10,None,vect(0,0,0),vect(0,0,0),'shot');
  else
     super.Bump(other);
}

static function bool IsHDTP()
{
    return class'DeusExPlayer'.static.IsHDTPInstalled() && class'DeusEx.LightBulb'.default.iHDTPModelToggle > 0;
}

defaultproperties
{
     lightScale=0.700000
     HitPoints=3
     FragType=Class'DeusEx.GlassFragment'
     bHighlight=False
     ItemName="Light Bulb"
     HDTPMesh="HDTPDecos.HDTPLightBulb"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.Lightbulb'
     ScaleGlow=2.000000
     bUnlit=True
     CollisionRadius=1.600000
     CollisionHeight=2.900000
     LightType=LT_Steady
     LightBrightness=255
     LightHue=32
     LightSaturation=224
     LightRadius=6
     Mass=3.000000
     Buoyancy=2.000000
     minimumTime=0.0000
}
