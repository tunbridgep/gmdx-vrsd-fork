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
	{
		flaregen.DelayedDestroy();
		flamething.LifeSpan=1;
		flamething.Destroy();
		flamething.bHidden=true;
	}
}

function tick(float DT)
{
	if(self==none)
		ExtinguishFlare();
    else if(self!=none && gen != none)
		UpdateGens();

	super.Tick(dt);
}

function UpdateGens()
{
	local Vector loc;
	local rotator rota;

	if(gen != none)
	{
		loc = location;
		loc.X += 2.0;		
		rota = rotation;
		rota.Yaw += 32768;
		gen.SetLocation(loc);
		gen.SetRotation(rota);
	}

	if(flaregen != none)
	{
		loc = location;
		rota = rotation;
		if(rota.Roll > 0)
		{
			rota.Roll += 4096;
		}
		else if (rota.Roll < 0)
		{
			rota.Roll -= 4096;
		}
		else
		{
			rota.Roll = 0;
		}
		rota.Yaw += 32768;
		flaregen.SetLocation(loc);
		flaregen.SetRotation(rota);
	}
	
	if(flamething != none)
	{
		loc = location;
		rota = rotation;
		if(rota.Roll > 0)
		{
			rota.Roll += 4096;
		}
		else if (rota.Roll < 0)
		{
			rota.Roll -= 4096;
		}
		else
		{
			rota.Roll = 0;
		}		
		rota.Yaw += 16384;
		flamething.SetLocation(loc);
        flamething.SetRotation(rota);
		
		if(lifespan > 2)
			flamething.DrawScale = 0.06 + (0.2*lifespan)/flaretime;
		else
			flamething.Destroy();
	}
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner!=None && Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkHumanCombustion').bPerkObtained == true) //RSD: Was 11, now 22 (Human Combustion perk moved from Advanced -> Master)
		DamageType='Flamed';

	SetTimer(0.05, False);
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
		loc = loc2 >> rotation;
		loc += location;
		gen = Spawn(class'ParticleGenerator', Self,, loc, rot(32768,0,0));
		if (gen != None )
		{
			gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
			gen.attachTag = Name;
			gen.SetBase(Self);
			gen.LifeSpan = LifeSpan;
			gen.bRandomEject = true;
			gen.bParticlesUnlit = false;
			gen.ejectSpeed = 15;
			gen.riseRate = 5;
			gen.checkTime = 0.05;
			gen.particleLifeSpan = 2.8;
			gen.particleDrawScale = 0.11;			
		}
		
		loc2.Y = collisionradius*0.8;    //I hate coordinate shifting
		loc = loc2 >> rotation;
		loc += location;
		rota = rotation;
		rota.Roll = 0;
		rota.Yaw = 32768;//32768;//16384;
		flaregen = Spawn(class'ParticleGenerator',Self,, loc, rota);
		if (flaregen != None)
		{
			//SARGE: TODO: Make this actually work
			flaregen.particleTexture = class'HDTPLoader'.static.GetFireTexture("HDTPAnim.Effects.HDTPFlarespark");
				
			flaregen.LifeSpan = LifeSpan;
			flaregen.attachTag = Name;
			flaregen.SetBase(Self);
			flaregen.bRandomEject = true;
			flaregen.RandomEjectAmt = 0.1;
			flaregen.bParticlesUnlit = true;
			flaregen.frequency = 0.3 + 0.4*frand();
			flaregen.numPerSpawn = 2;
			flaregen.bGravity = true;
			flaregen.ejectSpeed = 100;
			flaregen.riseRate = 1;
			flaregen.checkTime = 0.02;
			flaregen.particleLifeSpan = 0.2*(1 + frand());
			flaregen.particleDrawScale = 0.01 + 0.04*frand();            
		}
		
		rota.Yaw = 0;
		flamething = Spawn(class'Effects', Self,, Loc, rota);
		if(flamething != none)
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

defaultproperties
{
     mpDamage=10.000000
     DamageType=Burned
     spawnAmmoClass=Class'DeusEx.AmmoDartFlare'
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
     LightRadius=10
}
