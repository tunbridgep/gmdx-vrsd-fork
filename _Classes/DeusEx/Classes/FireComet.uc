//=============================================================================
// FireComet.
//=============================================================================
class FireComet extends DeusExFragment;

var ParticleGenerator smokeGen;
var ParticleGenerator smokeGen2;
var ParticleGenerator smokeGen3;

function PostBeginPlay()
{
if (Region.Zone.bWaterZone)
	Destroy();

    super.PostBeginPlay();
}

auto simulated state Flying
{
	simulated function HitWall(vector HitNormal, actor Wall)
	{
		local BurnMark mark;

		mark = spawn(class'BurnMark',,, Location, Rotator(HitNormal));
		if (mark != None)
		{
			mark.DrawScale *= 0.4*DrawScale;
			mark.ReattachDecal();
		}
		if (smokeGen != None)
		smokeGen.DelayedDestroy();
        if (smokeGen2 != None)
		smokeGen2.DelayedDestroy();
		if (smokeGen3 != None)
		smokeGen3.DelayedDestroy();
		Destroy();
	}
	simulated function BeginState()
	{
		Velocity = VRand() * 400; //300
		Velocity.Z = FRand() * 300 + 300; //200+200
		DrawScale = 0.3 + FRand();
		SetRotation(Rotator(Velocity));

	smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
	  smokeGen.RemoteRole = ROLE_None;
		smokeGen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		smokeGen.particleDrawScale = 0.18;
		smokeGen.checkTime = 0.02; //CyberP: 0.02
		smokeGen.riseRate = 8.0;
		smokeGen.ejectSpeed = 0.0;
		smokeGen.particleLifeSpan = 0.6; //was 2.0
		smokeGen.bRandomEject = True;
		smokeGen.SetBase(Self);
	}
	smokeGen2 = Spawn(class'ParticleGenerator', Self);
	if (smokeGen2 != None)
	{
	  smokeGen2.RemoteRole = ROLE_None;
		smokeGen2.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		smokeGen2.particleDrawScale = 0.2; //0.3
		smokeGen2.checkTime = 0.01;
		smokeGen2.riseRate = 8.0;
		smokeGen2.ejectSpeed = 20.0; //0
		smokeGen2.particleLifeSpan = 0.61;
		smokeGen2.bRandomEject = True;
		smokeGen2.SetBase(Self);
	}
	smokeGen3 = Spawn(class'ParticleGenerator', Self); //CyberP Start
	if (smokeGen3 != None)
	{
	  smokeGen3.RemoteRole = ROLE_None;
		smokeGen3.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		smokeGen3.particleDrawScale = 0.21; //0.3
		smokeGen3.checkTime = 0.01; //CyberP: 0.02
		smokeGen3.riseRate = 8.0;
		smokeGen3.ejectSpeed = 40.0; //0
		smokeGen3.particleLifeSpan = 0.62;
		smokeGen3.bRandomEject = True;
		smokeGen3.SetBase(Self);
	}
	}
}

simulated function Tick(float deltaTime)
{
	local BurnMark mark;

	if (Velocity == vect(0,0,0))
	{
		mark = spawn(class'BurnMark',,, Location, rot(16384,0,0));
		if (mark != None)
		{
			mark.DrawScale *= 0.4*DrawScale;
			mark.ReattachDecal();
		}
		if (smokeGen != None)
		smokeGen.DelayedDestroy();
        if (smokeGen2 != None)
		smokeGen2.DelayedDestroy();
		if (smokeGen3 != None)
		smokeGen3.DelayedDestroy();
		Destroy();
	}
	else
		SetRotation(Rotator(Velocity));
}

defaultproperties
{
     Style=STY_Translucent
     Mesh=LodMesh'DeusExItems.FireComet'
     ScaleGlow=2.000000
     bUnlit=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=192
     LightHue=32
     LightSaturation=64
     LightRadius=8
     bBounce=False
}
