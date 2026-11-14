//=============================================================================
// Lamp.
//=============================================================================
class Lamp extends Furniture
   abstract;

var() bool bOn;

function Frob(Actor Frobber, Inventory frobWith)
{
   Super.Frob(Frobber, frobWith);
   if (!bOn)
   {
      bOn = True;
      PlaySound(sound'Switch4ClickOn');
   }
   else
   {
      bOn = False;
      PlaySound(sound'Switch4ClickOff');
   }
   ResetScaleGlow();

}

function PostPostBeginPlay()
{
   Super.PostPostBeginPlay();
   //BroadcastMessage(bUnlit @ ScaleGlow);                                      //RSD
   ResetScaleGlow();//might as well do this every time, because seriously, what the fuck is your problem, light?
}


//SARGE: Refactored to not be so fucking stupid...
function ResetScaleGlow()
{
    super.ResetScaleGlow();
    if(bOn)
    {
        LightType = LT_Steady;
        ScaleGlow = 1.5;
        bUnlit = true;
    }
    else
    {
        bUnlit = false;
        LightType = LT_None;
        ScaleGlow=0.5;
    }
}

defaultproperties
{
     bOn=True
     FragType=Class'DeusEx.GlassFragment'
     bPushable=False
     ScaleGlow=1.500000
     bUnlit=True
     LightBrightness=255
     LightSaturation=255
     LightRadius=10
}
