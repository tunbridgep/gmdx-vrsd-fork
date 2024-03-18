//=============================================================================
// Basketball.
//=============================================================================
class Basketball extends DeusExDecoration;

event HitWall(vector HitNormal, actor HitWall)
{
	local float speed;

	Velocity = 0.8*((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	if (HitWall.IsA('ScriptedPawn'))
	{
	   Velocity = VRand() * 200;
	   return;
	}
	speed = VSize(Velocity);
	bFixedRotationDir = True;
	RotationRate = RotRand(False);
	if ((speed > 0) && (speed < 75) && (HitNormal.Z > 0.7))
	{
		SetPhysics(PHYS_None, HitWall);
		Velocity = vect(0,0,0);
		if (Physics == PHYS_None)
			bFixedRotationDir = False;
	}
	else if (speed > 75)
	{
	    if (Frand() < 0.5)
		PlaySound(sound'Basketball', SLOT_None);
		else
		PlaySound(sound'Basketball2', SLOT_None);
		AISendEvent('LoudNoise', EAITYPE_Audio);
	}
}

defaultproperties
{
     HitPoints=60
     minDamageThreshold=40
     FragType=Class'DeusEx.PaperFragment'
     ItemName="Basketball"
     Mesh=LodMesh'HDTPDecos.HDTPBasketBall'
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bBounce=True
     Mass=8.000000
     Buoyancy=10.000000
}
