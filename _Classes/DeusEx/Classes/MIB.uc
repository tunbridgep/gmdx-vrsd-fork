//=============================================================================
// MIB.
//=============================================================================
class MIB extends HumanMilitary;

var ParticleGenerator whizzBang; //GMDX: special MIB have effect
var float burnAmount; //cyberP: MIBs can set on fire, but only after a continual spray.
//GMDX inline hack

/*function PostBeginPlay()
{
	if (GroundSpeed>default.GroundSpeed)
	{
	default.Health=850;                                                         //RSD: Making these all 850 to avoid a stupid edge case where two Master sniper shots leaves the MIB at 0.4% health
	default.HealthHead=850;
	default.HealthTorso=850;
	default.HealthLegLeft=850;
	default.HealthLegRight=850;
	default.HealthArmLeft=850;
	default.HealthArmRight=850;
	bTank=True;
	Health=900;
	HealthHead=900;
	HealthTorso=900;
	HealthLegLeft=900;
	HealthLegRight=900;
	HealthArmLeft=900;
	HealthArmRight=900;
	runAnimMult=1.200000;
	MinRange=96.000000;
	SurprisePeriod=0.200000;
	GroundSpeed=450.000000;
	} else
	{
	default.Health=300;
	default.HealthHead=300;
	default.HealthTorso=300;
	default.HealthLegLeft=300;
	default.HealthLegRight=300;
	default.HealthArmLeft=300;
	default.HealthArmRight=300;
	Health=300;
	HealthHead=300;
	HealthTorso=300;
	HealthLegLeft=300;
	HealthLegRight=300;
	HealthArmLeft=300;
	HealthArmRight=300;
	}

	if (Fatness == 130)
	{
	HitSound1 = None;
	bShowPain=False;
	runAnimMult=1.200000;
	SurprisePeriod=0.200000;
	GroundSpeed=350.000000;
	}
	Die = None;
	Super.PostBeginPlay();
}*/

function PopHead()
{
MultiSkins[0] = Texture'GMDXSFX.Skins.DoctorTexBeheaded';
MultiSkins[5] = Texture'DeusExItems.Skins.PinkMaskTex';
MultiSkins[6] = Texture'DeusExItems.Skins.PinkMaskTex';
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
    if (damageType == 'EMP' && GroundSpeed > default.GroundSpeed) //CyberP: EMP fucks up hyper MIBs
	{
	if (whizzBang != None)
	   whizzbang.Destroy();
	GroundSpeed = 300.000000;
	runAnimMult = 1.100000;
	bShowPain = True;
	super.TakeDamageBase(10, instigatedBy, hitlocation, momentum, 'Stunned', true);
	}

	if (damageType == 'Flamed') //CyberP: Mibs can be set on fire after continual flamed damage.
	{
	burnAmount+=Damage;
	if (burnAmount > 25 && BurnPeriod == 0)                                     //RSD: Was burnAmount > 50, took way too long
	{
	BurnPeriod = 120.000000;
	super.TakeDamageBase(20, instigatedBy, hitlocation, momentum, 'Flamed', true);
	super.SetTimer(1.0,True);
	return;
	}
	}

	if (damageType == 'Poison' && GroundSpeed>default.GroundSpeed && Fatness != 130)
       HitSound1 = Sound'GMDXSFX.Human.MiBPain';  //CyberP: no sound for poisoned augged MiBs
    else if (damageType != 'Poison' && Damage > 0 && GroundSpeed>default.GroundSpeed && Fatness != 130)
       HitSound1 = Sound'DeusExSounds.Generic.ArmorRicochet';


	//CyberP: MiB Shield
    if (Fatness == 130)
    {
        if (Health > 450 && !bShowPain)
        {
        Spawn(class'SphereEffectShield');
        Damage *= 0.5;
        HitSound1 = none;
        }
        else
        HitSound1 = Sound'DeusExSounds.Generic.ArmorRicochet';
    }
    super.TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, true);
}
// ----------------------------------------------------------------------
// SpawnCarcass()
//
// Blow up instead of spawning a carcass
// ----------------------------------------------------------------------

function Carcass SpawnCarcass()
{
	if (bStunned)
		return Super.SpawnCarcass();

    ExpelInventory();
	Explode();

	return None;
}

function Explode()
{
	local SphereEffect sphere;
	local ScorchMark s;
	local ExplosionLight light;
	local int i;
	local float explosionDamage;
	local float explosionRadius;
    local vector loc;
    local FleshFragment chunk;

	explosionDamage = 110;
	explosionRadius = 288;

	// alert NPCs that I'm exploding
	AISendEvent('LoudNoise', EAITYPE_Audio, , explosionRadius*16);
	PlaySound(Sound'LargeExplosion1', SLOT_None,,, explosionRadius*16);

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, Location);
	if (light != None)
		light.size = 4;

	Spawn(class'ExplosionSmall',,, Location + 2*VRand()*CollisionRadius);
	Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);
	Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);


	sphere = Spawn(class'SphereEffect',,, Location);
	if (sphere != None)
		sphere.size = explosionRadius / 32.0;

	// spawn a mark
	s = spawn(class'ScorchMark', Base,, Location-vect(0,0,1)*CollisionHeight, Rotation+rot(16384,0,0));
	if (s != None)
	{
		s.DrawScaleMult = FClamp(explosionDamage/30, 0.1, 5.0);
		s.UpdateHDTPSettings();
	}

    for (i=0; i<22; i++) //CyberP: was /1.2
			{
				loc.X = (1-2*FRand()) * CollisionRadius;
				loc.Y = (1-2*FRand()) * CollisionRadius;
				loc.Z = (1-2*FRand()) * CollisionHeight;
				loc += Location;
				spawn(class'BloodDropFlying');
				spawn(class'BloodDropFlying');
				chunk = spawn(class'FleshFragment', None,, loc);
                if (chunk != None)
				{
				    chunk.Velocity = VRand() *400;
                    chunk.Velocity.Z = FRand() * 300 + 300;
					chunk.bFixedRotationDir = False;
					chunk.RotationRate = RotRand();
				}
             }
	HurtRadius(explosionDamage, explosionRadius, 'Exploded', explosionDamage*100, Location);
}

function Bool HasTwoHandedWeapon()
{
	return False;
}

function ParticleGenState(bool bShow)
{
   if (WhizzBang!=none)
   {
      if(bShow)
      {
         WhizzBang.bSpewing = true; //was true
		   WhizzBang.proxy.bHidden = false;
		   WhizzBang.bStasis = false;
		   WhizzBang.particleDrawScale = 0.400000;
		   WhizzBang.LifeSpan = WhizzBang.spewTime;
		   if (WhizzBang.bAmbientSound && (WhizzBang.AmbientSound != None))
			   WhizzBang.SoundVolume = 255;
      } else
      {
         WhizzBang.bSpewing = False;
         WhizzBang.proxy.bHidden = True;
         if (WhizzBang.bAmbientSound && (WhizzBang.AmbientSound != None))
            WhizzBang.SoundVolume = 0;
      }
   }
}

event GainedChild(Actor Other)
{
   if(Other.IsA('ParticleGenerator'))
   {
      whizzBang=ParticleGenerator(Other);
      ParticleGenState(false);
   }
   super.GainedChild(Other);
}

event LostChild(Actor Other)
{
   if(Other.IsA('ParticleGenerator'))
   {
      ParticleGenState(false);
      whizzBang=none;
   }
   super.LostChild(Other);
}

State Attacking
{
   function BeginState()
	{
      ParticleGenState(true);
      super.BeginState();
	}
   function EndState()
	{
      ParticleGenState(false);
      super.EndState();
	}
}

function DifficultyMod(float CombatDifficulty, bool bHardCoreMode, bool bExtraHardcore, bool bFirstLevelLoad) //RSD: New function to streamline NPC stat difficulty modulation
{
    Super.DifficultyMod(CombatDifficulty, bHardCoreMode, bExtraHardcore, bFirstLevelLoad);

    if (GroundSpeed>default.GroundSpeed)
    {
	bTank=True;
	runAnimMult=1.200000;
	MinRange=96.000000;
	SurprisePeriod=0.200000;
         if(bHardCoreMode)
         {
	GroundSpeed=450.000000;
         if (bFirstLevelLoad || !bNotFirstDiffMod)                       //RSD: Only alter health if it's the first time loading the map
         {
	default.Health=800;                                                         //RSD: Making these all 850 to avoid a stupid edge case where two Master sniper shots leaves the MIB at 0.4% health
	default.HealthHead=800;                                                     //RSD: Now 800 since sniper rifle was also nerfed
	default.HealthTorso=800;
	default.HealthLegLeft=800;
	default.HealthLegRight=800;
	default.HealthArmLeft=800;
	default.HealthArmRight=800;
	Health=800;
	HealthHead=800;
	HealthTorso=800;
	HealthLegLeft=800;
	HealthLegRight=800;
	HealthArmLeft=800;
	HealthArmRight=800;
         }
         }
         else
        {
         GroundSpeed=360.000000;
         if (bFirstLevelLoad || !bNotFirstDiffMod)                       //RSD: Only alter health if it's the first time loading the map
         {
          default.Health=350;
         default.HealthHead=350;
         default.HealthTorso=350;
         default.HealthLegLeft=350;
         default.HealthLegRight=350;
         default.HealthArmLeft=350;
         default.HealthArmRight=350;
         Health=350;
         HealthHead=350;
          HealthTorso=350;
         HealthLegLeft=350;
         HealthLegRight=350;
         HealthArmLeft=350;
         HealthArmRight=350;
         }
        }
    }
    else
    {
	default.Health=300;
	default.HealthHead=300;
	default.HealthTorso=300;
	default.HealthLegLeft=300;
	default.HealthLegRight=300;
	default.HealthArmLeft=300;
	default.HealthArmRight=300;
	Health=300;
	HealthHead=300;
	HealthTorso=300;
	HealthLegLeft=300;
	HealthLegRight=300;
	HealthArmLeft=300;
	HealthArmRight=300;
    }

    if (Fatness == 130)
	{
	HitSound1 = None;
	bShowPain=False;
	runAnimMult=1.200000;
	SurprisePeriod=0.200000;
	GroundSpeed=350.000000;
	}
    super.DifficultyMod(CombatDifficulty,bHardCoreMode,bExtraHardcore,bFirstLevelLoad);
}

defaultproperties
{
     MinHealth=0.000000
     CarcassType=Class'DeusEx.MIBCarcass'
     WalkingSpeed=0.213333
     CrouchRate=0.200000
     CloseCombatMult=0.500000
     BurnPeriod=0.000000
     bCanPop=True
     smartStrafeRate=0.400000
     GroundSpeed=180.000000
     Health=900
     HitSound1=Sound'GMDXSFX.Human.MiBPain'
     HitSound2=Sound'GMDXSFX.Human.MiBPain'
     Die=None
     bDontChangeDeathPainSounds=True
     HealthHead=900
     HealthTorso=900
     HealthLegLeft=900
     HealthLegRight=900
     HealthArmLeft=900
     HealthArmRight=900
     Mesh=LodMesh'DeusExCharacters.GM_Suit'
     DrawScale=1.100000
     MultiSkins(0)=Texture'DeusExCharacters.Skins.MIBTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.PantsTex5'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MIBTex0'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.MIBTex1'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.MIBTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.FramesTex2'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.LensesTex3'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionHeight=52.250000
     BindName="MIB"
     FamiliarName="Man In Black"
     UnfamiliarName="Man In Black"
}
