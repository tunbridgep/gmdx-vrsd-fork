//=============================================================================
// DeusExFragment.
//=============================================================================
class DeusExFragment expands Fragment;

var bool bSmoking;
var Vector lastHitLoc;
var float smokeTime;
var ParticleGenerator smokeGen;

//SARGE: HDTP Model toggles
var config int iHDTPModelToggle;
var bool bHDTPInstalled;                                             //SARGE: Store whether HDTP is installed, otherwise we get insane lag
var string HDTPSkin;
var string HDTPTexture;
var string HDTPMesh;

//
// copied from Engine.Fragment
//
simulated function HitWall (vector HitNormal, actor HitWall)
{
	local Sound sound;
	local float volume, radius;
	local DeusExPlayer playa;
    local vector offs;

	playa = DeusExPlayer(GetPlayerPawn());

	if (IsA('FleshFragment') && bFirstHit)   //CyberP: for gore up the walls
	{
	offs=Location;
	offs.Z+=3;
	if (Velocity.Z > 0) //cyberP: you need to make frag rotation match velocity
    spawn(class'FleshFragmentWall',,,offs,Rotation);
	}

	// if we are stuck, stop moving
	if ((lastHitLoc == Location))
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
	RotationRate.Yaw = RotationRate.Yaw*0.75;
	RotationRate.Roll = RotationRate.Roll*0.75;
	RotationRate.Pitch = RotationRate.Pitch*0.75;
	if ( ( (speed < 60) && (HitNormal.Z > 0.7) ) || (speed == 0) )
	{
		SetPhysics(PHYS_none, HitWall);
		if (Physics == PHYS_None)
		{
			bBounce = false;
			GoToState('Dying');
		}
	}

    if (speed > 20)
    {
	volume = 0.5+FRand()*0.5;
	radius = 512+(FRand()*100); //CyberP: was 758
	if (FRand()<0.5)
		sound = ImpactSound;
	else
		sound = MiscSound;
	if (IsA('FleshFragmentWall'))
 	   PlaySound(sound, SLOT_None, 0.2,, radius, 0.85+FRand()*0.3);
 	else
       PlaySound(sound, SLOT_None, volume,, radius, 0.85+FRand()*0.3);
	if (sound != None)
		AISendEvent('LoudNoise', EAITYPE_Audio, volume, radius); // lower AI sound radius for gameplay balancing
    }
	lastHitLoc = Location;
}

state Dying
{
	simulated function HitWall (vector HitNormal, actor HitWall)
	{
		// if we are stuck, stop moving
		if ((lastHitLoc == Location))
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
		RotationRate.Yaw = RotationRate.Yaw*0.75;
		RotationRate.Roll = RotationRate.Roll*0.75;
		RotationRate.Pitch = RotationRate.Pitch*0.75;
		if ( (Velocity.Z < 50) && (HitNormal.Z > 0.7) )
		{
			SetPhysics(PHYS_none, HitWall);
			if (Physics == PHYS_None)
				bBounce = false;
		}
        if (ImpactSound==Sound'DeusExSounds.Generic.FleshHit1')
        {
        if (FRand()<0.2)
			PlaySound(ImpactSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		else if (FRand()<0.4)
			PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
        }
        else
        {
		if (FRand()<0.5)
			PlaySound(ImpactSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		else
			PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
        }
		lastHitLoc = Location;
	}

	function BeginState()
	{
		Super.BeginState();

		if (smokeGen != None)
			smokeGen.DelayedDestroy();
	}
}

function Destroyed()
{
	if (smokeGen != None)
		smokeGen.DelayedDestroy();

	Super.Destroyed();
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	bHDTPInstalled = class'HDTPLoader'.static.HDTPInstalled(); 
    UpdateHDTPsettings();

	// randomize the lifespan a bit so things don't all disappear at once
	speed *= 1.1;
	if (!IsA('GMDXImpactSpark') && !IsA('GMDXImpactSpark2'))
	LifeSpan += FRand()*1.5; //CyberP: was 1.0
}

function bool IsHDTP()
{
    return bHDTPInstalled && iHDTPModelToggle > 0;
}

exec function UpdateHDTPsettings()
{
    if (HDTPMesh != "")
        Mesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),IsHDTP());
    if (HDTPSkin != "")
        Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),IsHDTP());
    if (HDTPTexture != "")
        Texture = class'HDTPLoader'.static.GetTexture2(HDTPTexture,string(default.Texture),IsHDTP());
}

function SkinVariation()
{
}

simulated function AddSmoke()
{
	smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
		smokeGen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		smokeGen.particleDrawScale = 0.075 + (DrawScale*0.01);
		smokeGen.riseRate = 40.0 + (DrawScale*9);    //CyberP: drawscale influences rise rate
		smokeGen.checkTime = 0.08;
		smokeGen.frequency = 6.0;
		smokeGen.ejectSpeed = 0.0;
		smokeGen.particleLifeSpan = 1 + (DrawScale/11); //CyberP
		smokeGen.bRandomEject = True;
		smokeGen.bFade = True;
		smokeGen.SetBase(Self);
	}
}

simulated function Tick(float deltaTime)
{
   if ((bSmoking) && (smokeGen == None))
		AddSmoke();

	// fade out the object smoothly 2 seconds before it dies completely
	if (LifeSpan <= 2 && !IsA('GMDXImpactSpark') && !IsA('GMDXImpactSpark2'))
	{
		if (Style != STY_Translucent)
			Style = STY_Translucent;

		ScaleGlow = LifeSpan / 2.0;
	}
}

defaultproperties
{
     ScaleGlow=0.500000
}
