//=============================================================================
// Lightbulb.
//=============================================================================
class Lightbulb extends DeusExDecoration;

var bool bOn;
var() int toggledRadius;

function PostBeginPlay()
{
  super.PostBeginPlay();

  if (LightRadius == 0)
  {
     bOn = False;
     ScaleGlow = 0.5;
     bUnlit = False;
  }
}

Function Destroyed()
{
	local Light A;

	if(Event != '')
	{
		foreach AllActors(class 'Light', A, Event)
		{
                    A.DrawScale = 0;
        }
    }
}

Function Bump(actor Other)
{
  if (Other.IsA('Robot'))
     TakeDamage(10,None,vect(0,0,0),vect(0,0,0),'shot');
  else
     super.Bump(other);
}

function Trigger(Actor Other, Pawn Instigator)
{
	Super.Trigger(Other, Instigator);

    if (bOn)
    {
    bUnlit=False;
    ScaleGlow=0.5;
    LightRadius=0;
    bOn = False;
    }
    else
    {
    bUnlit=True;
    ScaleGlow=2;
    LightRadius=toggledRadius;
    bOn = True;
    }
}

defaultproperties
{
     bOn=True
     toggledRadius=6
     HitPoints=3
     FragType=Class'DeusEx.GlassFragment'
     bHighlight=False
     ItemName="Light Bulb"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'HDTPDecos.HDTPLightBulb'
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
}
