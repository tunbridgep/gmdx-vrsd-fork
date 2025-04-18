//=============================================================================
// DeusExFragment.
//=============================================================================
class DeusExFragment expands Fragment;

var bool bSmoking;
var Vector lastHitLoc;
var float smokeTime;
var ParticleGenerator smokeGen;

//SARGE: HDTP Model toggles
var globalconfig int iHDTPModelToggle;
var string HDTPSkin;
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
        if (!region.zone.bWaterZone) //SARGE: Prevent endless sounds when in water
        {
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
    UpdateHDTPsettings();

	speed *= 1.1;

    if (class'DeusExPlayer'.default.iPersistentDebris >= 2) //SARGE: Stick around forever, if we've enabled the setting.
        LifeSpan = 0;
    else if (!IsA('GMDXImpactSpark') && !IsA('GMDXImpactSpark2'))
        // randomize the lifespan a bit so things don't all disappear at once
        LifeSpan += FRand()*1.5; //CyberP: was 1.0
}

static function bool IsHDTP()
{
    return class'DeusExPlayer'.static.IsHDTPInstalled() && default.iHDTPModelToggle > 0;
}

exec function UpdateHDTPsettings()
{
	if(HDTPMesh != "")
		Mesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),IsHDTP());
}

exec function UpdateHDTPSkin()
{
    if (HDTPSkin != "")
        Skin=class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),IsHDTP());
}

//SARGE: Unused???
function SkinVariation()
{
}

simulated function AddSmoke()
{
    if (smokeTime == -1 && class'DeusExPlayer'.default.iPersistentDebris >= 2)
        return;

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
        if (class'DeusExPlayer'.default.iPersistentDebris >= 2)
            smokeTime = 30 + (FRand() * 10); //Sarge: only smoke for 30 seconds, now that we can have permanent gore.
        else
            smokeTime = -1;
	}
}

simulated function Tick(float deltaTime)
{
   if ((bSmoking) && (smokeGen == None))
		AddSmoke();

	// fade out the object smoothly 2 seconds before it dies completely
	if (LifeSpan <= 2 && LifeSpan != 0 && !IsA('GMDXImpactSpark') && !IsA('GMDXImpactSpark2'))
	{
		if (Style != STY_Translucent)
			Style = STY_Translucent;

		ScaleGlow = LifeSpan / 2.0;
	}

    //Sarge: only smoke for 30 seconds, now that we can have permanent gore.
    if (smokeTime > 0)
    {
        smokeTime -= deltaTime;
        
        //slow down the smoke as we get to the end
        smokeGen.frequency = 6.0 / (30 - smokeTime);

        if (smokeTime <= 0)
        {
            smokeTime = -1;
            if (smokeGen != none)
                smokeGen.Destroy();
        }
    }
}

auto state flying
{
    simulated function BeginState()
    {
        UpdateHDTPsettings();
        super.BeginState();
        UpdateHDTPSkin();
    }
}

defaultproperties
{
     ScaleGlow=0.500000
}
