//-----------------------------------------------------------
//GMDXFireSmokeFade, tracer hit small puff o smoke :dasraiser
//-----------------------------------------------------------
class GMDXFireSmokeFade extends FireSmoke;

var float lSpan;
var float dtSpan;

simulated function PostBeginPlay()
{
   super.PostBeginPlay();

   dtSpan=1/LifeSpan;
   lSpan=1;
}

simulated function Tick( float dt )
{
	//Super.Tick(dt); dont want to scale;

	if ( !bRelinquished )
		return;

	lSpan-=(dt*dtSpan);
	ScaleGlow =lSpan;
	DrawScale+=0.05;
}

defaultproperties
{
     bRelinquished=True
     LifeSpan=0.260000
     DrawScale=0.010000
}
