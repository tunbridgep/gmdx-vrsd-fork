//=============================================================================
// Lightbulb.
//=============================================================================
class Lightbulb extends DeusExDecoration;

var bool bOn;
var() int toggledRadius;

function ResetScaleGlow()
{
    super.ResetScaleGlow();
    if (bOn)
    {
        bUnlit=True;
        ScaleGlow=2;
        LightRadius=toggledRadius;
    }
    else
    {
        bUnlit=False;
        LightRadius=0;
        ScaleGlow=0.5;
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
    bOn = !bOn;
    ResetScaleGlow();
}

defaultproperties
{
     bOn=True
     toggledRadius=6
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
}
