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
		flamething.LifeSpan=1;
		flamething.Destroy();
		flamething.bHidden=true;
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
	local vector loc, loc2;
	local rotator rota;

	if(gen != none)
	{
		loc = location;
		rota = rotation;
		rota.Yaw += 16384;
		gen.SetLocation(loc);
		gen.SetRotation(rota);
	}

	if(flaregen != none)
	{
		loc = location;
		rota = rotation;
		rota.Yaw += 16384;
		//rota = rotation;
		//rota.Roll = 0;
		//rota.Yaw += 16384;
		flaregen.SetLocation(loc);
		//flaregen.SetRotation(rota);
		flaregen.SetRotation(rota);

//		if(FF != none)
//		{
//			FF.SetLocation(locac);
//			FF.SetRotation(rotator(loc - location));
//		}
	}
	if(flamething != none)
	{
	     flamething.SetLocation(Loc);
        flamething.SetRotation(rota);
		//rota = rotation;
		//rota.pitch += 4096*(frand()-0.5);
		//flamething.setrotation(rota);
		if(lifespan > 2)
			flamething.DrawScale = 0.1 + 0.2*lifespan/flaretime;
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
	local Vector X, Y, Z, dropVect, loc, loc2, offset;
	local Pawn P;
	local rotator rota;

	if (gen == None && IsHDTP())
	{
        AmbientSound=Sound'DeusExSounds.Generic.Flare';
        flaretime=LifeSpan;

		loc2.Y += collisionradius*1.05;
		loc = loc2 >> rotation;
		loc += location;
		gen = Spawn(class'ParticleGenerator', Self,, Loc, rot(16384,0,0));
		if (gen != None )
		{
			gen.attachTag = Name;
			gen.SetBase(Self);
			gen.LifeSpan = LifeSpan;
			gen.bRandomEject = True;
			gen.bParticlesUnlit = false;
			gen.ejectSpeed = 30;
			gen.riseRate = 10;
			gen.checkTime = 0.075;
			gen.particleLifeSpan = 5;
			gen.particleDrawScale = 0.1;
			gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		}
		loc2.Y = collisionradius*0.8;    //I hate coordinate shifting
		loc = loc2 >> rotation;
		loc += location;
		rota = rotation;
		rota.Roll = 0;
		rota.Yaw = 0;//32768;//16384;
		flaregen = Spawn(class'ParticleGenerator',Self,, Loc, rota);
		if (flaregen != None)
		{
			flaregen.LifeSpan = LifeSpan;
			flaregen.attachTag = Name;
			flaregen.SetBase(Self);
			flaregen.bRandomEject=true;
			flaregen.RandomEjectAmt=0.1;
			flaregen.bParticlesUnlit=true;
			flaregen.frequency=0.5 + 0.5*frand();
			flaregen.numPerSpawn=2;
			flaregen.bGravity=false;
			flaregen.ejectSpeed = 100;
			flaregen.riseRate = -1;
			flaregen.checkTime = 0.02;
			flaregen.particleLifeSpan = 0.6*(1 + frand());
			flaregen.particleDrawScale = 0.01 + 0.05*frand();
            //SARGE: TODO: Make this actually work
			flaregen.particleTexture = class'HDTPLoader'.static.GetFireTexture("HDTPAnim.effects.HDTPFlarespark");
		}
		flamething = Spawn(class'Effects', Self,, Loc, rota);
		if(flamething != none)
		{
			flamething.setbase(self);
			flaregen.attachTag = Name;
			flamething.DrawType=DT_mesh;
			flamething.mesh=class'HDTPLoader'.static.GetMesh("HDTPItems.HDTPflareflame");
			flamething.multiskins[1]=class'HDTPLoader'.static.GetFireTexture("HDTPAnim.effects.HDTPflrflame");
			flamething.Style=STY_Translucent;
			flamething.bUnlit=true;
			flamething.DrawScale=0.15;
			flamething.Scaleglow=5;
			flamething.lifespan=LifeSpan;
			flamething.bHidden=false;
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
