//=============================================================================
// ShellCasing2.
//=============================================================================
class ShellCasing2 extends DeusExFragment;

var particlegenerator gen;
var float smoketimer;
var float smokeprob;


function postbeginplay()
{
	if(frand() > smokeprob)
	{
		smoketimer = 0.1+frand()*0.2;
	}

	super.postbeginplay();
}

function tick(float DT)
{
	local Vector loc, loc2;

	if(smoketimer > 0)
	{
		smoketimer -= DT;
		if(smoketimer <= 0)
		{
			spawnBulletSmoke();
		}
	}
	if(Gen != none)
	{
		Gen.setRotation(rotation);
		loc2.X += collisionradius*0.5;
		loc = loc2 >> rotation;
		loc += location;
		Gen.setlocation(loc);
	}
	super.tick(DT);
}


function spawnBulletSmoke()
{
	local Vector loc, loc2;

	if (gen == None)
	{
		loc2.X += collisionradius*0.5;
		loc = loc2 >> rotation;
		loc += location;
		gen = Spawn(class'ParticleGenerator', Self,, Loc, rotation);
		if (gen != None)
		{
			gen.attachTag = Name;
			gen.SetBase(Self);
			gen.LifeSpan = frand()+1;
			gen.bRandomEject = true;
			gen.RandomEjectAmt = 0.05;
			gen.bParticlesUnlit = false;
			gen.ejectSpeed = 2;
			gen.riseRate = 5;
			gen.checkTime = 0.002;
			gen.particleLifeSpan = frand()+1;
			gen.particleDrawScale = 0.01+0.01*frand();
			gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		}
	}
}


//
// copied from Engine.Fragment
//
simulated function HitWall (vector HitNormal, actor HitWall)
{
	local Sound sound;
	local float volume, radius;

	// if we are stuck, stop moving
	if (lastHitLoc == Location)
		Velocity = vect(0,0,0);
	else
		Velocity = Elasticity*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	speed = VSize(Velocity);
	if (bFirstHit && speed<400)
	{
		bFirstHit=False;
		bRotatetoDesired=True;
		bFixedRotationDir=False;
		DesiredRotation.Pitch=0;
		DesiredRotation.Yaw=FRand()*65536;
		DesiredRotation.roll=0;
	}
	RotationRate.Yaw = RotationRate.Yaw*0.95;
	RotationRate.Roll = RotationRate.Roll*0.95;
	RotationRate.Pitch = RotationRate.Pitch*0.95;
	if ( ( (speed < 60) && (HitNormal.Z > 0.7) ) || (speed == 0) )
	{
		SetPhysics(PHYS_none, HitWall);
		if (Physics == PHYS_None)
		{
			bBounce = false;
			GoToState('Dying');
		}
	}

	volume = 0.5+FRand()*0.5;
	radius = 768;
	if (FRand()<0.5)
		sound = ImpactSound;
	else
		sound = MiscSound;
	PlaySound(sound, SLOT_None, volume,, radius, 0.85+FRand()*0.3);
	if (sound != None)
		AISendEvent('LoudNoise', EAITYPE_Audio, volume, radius * 0.5);		// lower AI sound radius for gameplay balancing

	lastHitLoc = Location;
}

state Dying
{
	simulated function HitWall (vector HitNormal, actor HitWall)
	{
		// if we are stuck, stop moving
		if (lastHitLoc == Location)
			Velocity = vect(0,0,0);
		else
			Velocity = Elasticity*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		speed = VSize(Velocity);
		if (bFirstHit && speed<400)
		{
			bFirstHit=False;
			bRotatetoDesired=True;
			bFixedRotationDir=False;
			DesiredRotation.Pitch=0;
			DesiredRotation.Yaw=FRand()*65536;
			DesiredRotation.roll=0;
		}
		RotationRate.Yaw = RotationRate.Yaw*0.95;
		RotationRate.Roll = RotationRate.Roll*0.95;
		RotationRate.Pitch = RotationRate.Pitch*0.95;
		if ( (Velocity.Z < 50) && (HitNormal.Z > 0.7) )
		{
			SetPhysics(PHYS_none, HitWall);
			if (Physics == PHYS_None)
				bBounce = false;
		}

		if (FRand()<0.5)
			PlaySound(ImpactSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		else
			PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);

		lastHitLoc = Location;
	}

	function tick(float DT)
	{
		local Vector loc, loc2;

		if(smoketimer > 0)
		{
			smoketimer -= DT;
			if(smoketimer <= 0)
			{
				spawnBulletSmoke();
			}
		}
		if(Gen != none)
		{
			Gen.setRotation(rotation);
			loc2.X += collisionradius;
			loc = loc2 >> rotation;
			loc += location;
			Gen.setlocation(loc);
		}
		super.tick(DT);
	}
}

defaultproperties
{
     smokeprob=0.400000
     Fragments(0)=LodMesh'HDTPItems.HDTPShotguncasing'
     numFragmentTypes=1
     elasticity=0.400000
     ImpactSound=Sound'DeusExSounds.Generic.ShellHit'
     MiscSound=Sound'DeusExSounds.Generic.ShellHit'
     Mesh=LodMesh'HDTPItems.HDTPShotguncasing'
     DrawScale=1.400000
     CollisionRadius=2.870000
     CollisionHeight=0.920000
}
