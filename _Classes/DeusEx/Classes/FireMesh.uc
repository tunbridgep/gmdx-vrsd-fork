//=============================================================================
// Fire. This whole effect stolen shamelessly from Smoke39, who is ace. -DDL
//=============================================================================
class FireMesh extends Effects;

var float scaleadjust;
var ParticleGenerator smokeGen;
var ParticleGenerator fireGen;
var Actor origBase;
var vector BaseOffset; //Where we are relative to Base, so that we can stay synced in mp.
var Actor PrevBase;
// Smoke39
var bool bSmoke;
var bool bDying;
var float smoketimer;

#exec OBJ LOAD FILE=Ambient
#exec OBJ LOAD FILE=Effects

// Smoke39 - torn apart

simulated function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	// if our owner or base is destroyed, destroy us
	if (Owner == None)
		Destroy();

	if(bSmoke)
	{
		Smoketimer += deltatime;
		LightBrightness = default.LightBrightness * ((3.1 - smoketimer)/3.1);
	}
}
/*
simulated function BaseChange()
{
	Super.BaseChange();

	if (Base == None)
		SetBase(origBase);
}

simulated function Destroyed()
{
	if (smokeGen != None)
		smokeGen.DelayedDestroy();

	if (fireGen != None)
		fireGen.DelayedDestroy();

	Super.Destroyed();
}
*/
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	mesh = Owner.Mesh;
	DrawScale = Owner.DrawScale*scaleadjust;
	PrePivot += vect(0,0,20);

	bTrailerSameRotation = true;
	bAnimByOwner = true;

	SetBase(Owner);

	SetTimer( 0.05, true );
}

// stop fire, keep smoke, die after a while
function smoke()
{
	DrawType = DT_None;
	AmbientSound = None;
	if(!bDying)
		LightType = LT_None;
	bSmoke = true;
	LifeSpan = 3;
}

// spawn fancy burny stuff!
simulated function Timer()
{
	local vector v;
	local SmokeTrail p;  // "p" is for "puff!" :O
	local FlameEffect S;
	local int i;

	if ( !bSmoke )
	{
		Spawn(class'FlameEffect', Owner);
		Spawn(class'FlameEffect', Owner);

		if ( Level.bDropDetail )
			return;

		Spawn(class'FlameEffect', Owner);
		Spawn(class'FlameEffect', Owner);
	}
	else if(bDying)
	{
		for(i=0; i<2; i++)
		{
			S = Spawn(class'FlameEffect', Owner);
			if(S != none)
			{
				S.dropAmt = 1 - (3.1 - smoketimer)/3.1;
			}

			if ( Level.bDropDetail )
				return;
		}
	}



	v = FRand()*Owner.CollisionRadius * vector( FRand()*rot(0,65536,0) );
	v.Z += (FRand()-FRand()) * Owner.CollisionHeight;
	v += Owner.Location;

	p = Spawn( class'SmokeTrail',,, v );
	if ( p != None )
	{
		p.Velocity.Z = 45 + FRand()*35;
		p.OrigVel = p.Velocity;
		p.DrawScale = 0.5 + FRand()/2;
		p.OrigScale = p.DrawScale;
		p.LifeSpan = 1.0 + FRand();
		p.OrigLifeSpan = p.LifeSpan;
	}
}

defaultproperties
{
     scaleadjust=1.000000
     bTravel=True
     Physics=PHYS_Trailer
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=FireTexture'Effects.Fire.OneFlame_J'
     bUnlit=True
     bParticles=True
     bOwnerNoSee=True
     SoundVolume=192
     AmbientSound=Sound'Ambient.Ambient.FireSmall1'
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=255
     LightHue=16
     LightSaturation=64
     LightRadius=4
}
