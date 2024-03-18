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
      LightType = LT_Steady;
      PlaySound(sound'Switch4ClickOn');
   }
   else
   {
      bOn = False;
      LightType = LT_None;
      PlaySound(sound'Switch4ClickOff');
   }
   ResetScaleGlow();
}

function PostPostBeginPlay()
{
   lighttype = LT_Steady;
   //BroadcastMessage(bUnlit @ ScaleGlow);                                      //RSD
   bUnlit = True;
   bOn = True;
   ScaleGlow=1.5;
   ResetScaleGlow();//might as well do this every time, because seriously, what the fuck is your problem, light?
   Super.PostPostBeginPlay();
}


function ResetScaleGlow()
{
   local float mod;

   //if (!bInvincible)
   //   mod = 1.5;//float(HitPoints) / float(Default.HitPoints) * 0.9 + 0.1;
   //else
   //   mod = 1.5;

   if(bOn)
   {
      ScaleGlow = 1.5;// * mod;
      bUnlit = true;
   }
   else
   {
      ScaleGlow = 0.5;
      bUnlit = false;
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
