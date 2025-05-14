//=============================================================================
// DartFlare.
//=============================================================================
class DartFlare extends Dart;

var float mpDamage;
var ParticleGenerator gen, flaregen;
var effects flamething; //trying very hard not to introduce extra classes
var float flaretime;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
		Damage = mpDamage;
}

function ExtinguishFlare()
{
	LightType = LT_None;
	AmbientSound = None;
	if (gen != None)
		gen.DelayedDestroy();
	
	if (flaregen != None)
		flaregen.DelayedDestroy();
	
	if(flamething != None)
		flamething.Destroy();
}

simulated function Tick(float deltaTime)
{
	super.Tick(deltaTime);
	
	if(Self == None)
		ExtinguishFlare();
    else if(Self != None && gen != None)
		UpdateGens();	
}

function UpdateGens()
{
	local rotator rota;
	
	rota = Rotation;
	rota.Yaw += 32768.0;
	
	if(gen != None)
	{
		if(gen.Location != Location)
			gen.SetLocation(Location); //bah!

		gen.SetRotation(rota);
	}
	
	if(flaregen != None)
	{
		if(flaregen.Location != Location)
			flaregen.SetLocation(Location); //bah!

		flaregen.SetRotation(rota);
	}
	
	if(flamething != None)
	{
		if(flamething.Location != Location)
			flamething.SetLocation(Location); //bah!

		rota.Yaw -= 16384.0;
		flamething.SetRotation(rota);
		if(lifespan > 1)
			flamething.DrawScale = 0.06 + (0.2*lifespan)/flaretime;
		else
			flamething.Destroy();
	}
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner != None && Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkHumanCombustion').bPerkObtained) //RSD: Was 11, now 22 (Human Combustion perk moved from Advanced -> Master)
		DamageType='Flamed';

	SetTimer(0.05, false);
}

simulated function Destroyed()
{
	ExtinguishFlare();
}

function Timer()
{
	local Vector loc, loc2;
	local rotator rota;

	if (gen == None)
	{
        AmbientSound = Sound'DeusExSounds.Generic.Flare';
        flaretime = LifeSpan;

		loc2.Y += collisionradius*1.05;
		loc = loc2 >> Rotation;
		loc += Location;
		gen = Spawn(class'ParticleGenerator', Self,, loc, Rot(16384.0,0.0,0.0));
		if (gen != None )
		{
			gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
			gen.attachTag = Name;
			//gen.SetBase(Self);
			gen.LifeSpan = LifeSpan;
			gen.bRandomEject = true;
			gen.bParticlesUnlit = false;
			gen.ejectSpeed = 15;
			gen.riseRate = 15;
			gen.checkTime = 0.075;
			gen.particleLifeSpan = 3.5;
			gen.particleDrawScale = 0.20;			
		}
		
		if(IsHDTP())
		{			
			loc2.Y = collisionradius*0.8;    //I hate coordinate shifting
			loc = loc2 >> Rotation;
			loc += Location;
			rota = Rotation;
			rota.Roll = 0;
			rota.Yaw += 16384;
			
			flaregen = Spawn(class'ParticleGenerator',Self,, loc, rota);
			if (flaregen != None)
			{
				flaregen.particleTexture = class'HDTPLoader'.static.GetFireTexture("HDTPAnim.Effects.HDTPFlarespark");
				flaregen.LifeSpan = LifeSpan;
				flaregen.attachTag = Name;
				flaregen.SetBase(Self);
				flaregen.bRandomEject = true;
				flaregen.RandomEjectAmt = 0.1;
				flaregen.bParticlesUnlit = true;
				flaregen.frequency = 0.3 + 0.4*FRand();
				flaregen.numPerSpawn = 2;
				flaregen.bGravity = true;
				flaregen.ejectSpeed = 100;
				flaregen.riseRate = 1;
				flaregen.checkTime = 0.02;
				flaregen.particleLifeSpan = 0.2*(1 + FRand());
				flaregen.particleDrawScale = 0.01 + 0.04*FRand();            
			}

			rota.Yaw = 0;
			flamething = Spawn(class'Effects', Self,, Loc, rota);
			if(flamething != None)
			{
				flamething.mesh=class'HDTPLoader'.static.GetMesh("HDTPItems.HDTPflareflame");
				flamething.multiskins[1]=class'HDTPLoader'.static.GetFireTexture("HDTPAnim.Effects.HDTPflrflame");
				flamething.setbase(self);
				flaregen.attachTag = Name;
				flamething.lifespan = LifeSpan;
				flamething.bHidden = false;
				flamething.DrawType = DT_mesh;			
				flamething.Style = STY_Translucent;
				flamething.bUnlit = true;
				flamething.DrawScale = 0.1;
				flamething.Scaleglow = 5;			
			}
		}
	}
}

defaultproperties
{
     mpDamage=10.000000
     DamageType=Burned
     spawnAmmoClass=class'DeusEx.AmmoDartFlare'
     hdtpReference=class'DeusEx.WeaponMiniCrossbow'
     ItemName="Flare Dart"
     Damage=7.000000
     LifeSpan=160.000000
     bUnlit=True
     SoundRadius=20
     SoundVolume=128
     LightType=LT_Steady
     LightEffect=LE_TorchWaver
     LightBrightness=255
     LightHue=16
     LightSaturation=192
     LightRadius=12
}
