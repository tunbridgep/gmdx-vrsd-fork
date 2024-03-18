//=============================================================================
// WaltonSimons.
//=============================================================================
class WaltonSimons extends HumanMilitary;

//
// Damage type table for Walton Simons:
//
// Shot			- 100%
// Sabot		- 100%
// Exploded		- 100%
// TearGas		- 10%
// PoisonGas	- 10%
// Poison		- 10%
// PoisonEffect	- 10%
// HalonGas		- 10%
// Radiation	- 10%
// Shocked		- 10%
// Stunned		- 0%
// KnockedOut   - 0%
// Flamed		- 0%
// Burned		- 0%
// NanoVirus	- 0%
// EMP			- 0%
//

var bool bBeginCounter;
var float lpa;
var ParticleGenerator whizzBang;
var bool bEMPd;

function float ShieldDamage(name damageType)
{
    if (Health > 350 && !bEMPd)
        Spawn(class'SphereEffectShield2');

	// handle special damage types
	if ((damageType == 'Flamed') || (damageType == 'Burned') || (damageType == 'Stunned') ||
	    (damageType == 'KnockedOut'))
		return 0.0;
	else if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'HalonGas') ||
			(damageType == 'Radiation') || (damageType == 'Shocked') || (damageType == 'Poison') ||
	        (damageType == 'PoisonEffect'))
		return 0.1;
	else if (damageType == 'Exploded')
        return 0.6;
	else
		return Super.ShieldDamage(damageType);
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
    super.TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, true);

    if (damageType == 'EMP' && Damage > 30) //CyberP: EMP fucks up augs
	{
	if (whizzBang != None)
	whizzbang.Destroy();
	bEMPd = True;
	GroundSpeed = default.GroundSpeed;
	runAnimMult = 1.100000;
	CrouchRate=default.CrouchRate;
	bShowPain = True;
	CloakThreshold = 0;
    EnableCloak(false);
	}
}

function ParticleGenState(bool bShow)
{
   if (WhizzBang!=none)
   {
      if(bShow)
      {
         WhizzBang.bSpewing = true; //was true
		   WhizzBang.proxy.bHidden = false;
		   WhizzBang.bStasis = False;
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
	function EndState()
	{
	  if (HasEnemyTimedOut())
	  {
	  CloakThreshold = 0;
      EnableCloak(false);
      ParticleGenState(False);
      lpa = 0;
      runAnimMult=default.runAnimMult;
      }
      super.EndState();
	}

	function Tick(float deltaSeconds)
	{
	  super.Tick(deltaSeconds);

      if (bEMPd)
          return;
	  if (FRand() < 0.001 && bBeginCounter == False)
	  {
	       if (!bCloakOn)
	       {
	          CloakThreshold = Health*2;
	          EnableCloak(True);
	       }
	       else if (CloakThreshold != 0)
	       {
	          CloakThreshold = 0;
              EnableCloak(false);
           }
	  }
	  if (FRand() < 0.001 && !bCloakOn)
	  {
	     GroundSpeed = 1000.000000;
	     bBeginCounter = True;
	     ParticleGenState(true);
	     runAnimMult=1.350000;
	     CrouchRate=0.1;
	  }
	  else if (bBeginCounter)
	  {
	     lpa +=1;
	     if (lpa > 500)
	     {
	         GroundSpeed = default.GroundSpeed;
	         bBeginCounter = False;
	         CrouchRate=default.CrouchRate;
	         ParticleGenState(False);
	         runAnimMult=default.runAnimMult;
	         lpa = 0;
	     }
	  }
	}
}

function DifficultyMod(float CombatDifficulty, bool bHardCoreMode, bool bExtraHardcore, bool bFirstLevelLoad) //RSD: New function to streamline NPC stat difficulty modulation
{
         Super.DifficultyMod(CombatDifficulty, bHardCoreMode, bExtraHardcore, bFirstLevelLoad);

         if (!bHardCoreMode)
         {
          GroundSpeed=360.000000;
          if (bFirstLevelLoad || !bNotFirstDiffMod)                       //RSD: Only alter health if it's the first time loading the map
          {
          default.Health=500;
         default.HealthHead=500;
         default.HealthTorso=500;
         default.HealthLegLeft=500;
         default.HealthLegRight=500;
         default.HealthArmLeft=500;
         default.HealthArmRight=500;
         Health=500;
         HealthHead=500;
          HealthTorso=500;
         HealthLegLeft=500;
         HealthLegRight=500;
         HealthArmLeft=500;
         HealthArmRight=500;
         }
         }
         bNotFirstDiffMod = true;
}

defaultproperties
{
     CarcassType=Class'DeusEx.WaltonSimonsCarcass'
     WalkingSpeed=0.333333
     bImportant=True
     bInvincible=True
     CrouchRate=0.000000
     CloseCombatMult=0.500000
     BaseAssHeight=-23.000000
     BurnPeriod=0.000000
     bHasCloak=True
     CloakThreshold=100
     walkAnimMult=1.400000
     runAnimMult=1.200000
     HDTPMeshName="HDTPCharacters.HDTPWaltonSimons"
     HDTPMeshTex(0)="HDTPCharacters.skins.HDTPSimonsTex0"
     HDTPMeshTex(1)="HDTPCharacters.skins.HDTPSimonsTex1"
     HDTPMeshTex(2)="HDTPCharacters.skins.HDTPSimonsTex2"
     HDTPMeshTex(3)="HDTPCharacters.skins.HDTPSimonsTex3"
     HDTPMeshTex(4)="HDTPCharacters.skins.HDTPSimonsTex4"
     HDTPMeshTex(5)="Deusexitems.skins.pinkmasktex"
     HDTPMeshTex(6)="Deusexitems.skins.pinkmasktex"
     HDTPMeshTex(7)="Deusexitems.skins.pinkmasktex"
     bTank=True
     GroundSpeed=330.000000
     Health=1200
     HealthHead=1600
     HealthTorso=1200
     HealthLegLeft=1200
     HealthLegRight=1200
     HealthArmLeft=1200
     HealthArmRight=1200
     Mesh=LodMesh'DeusExCharacters.GM_Trench'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.WaltonSimonsTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.WaltonSimonsTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.PantsTex5'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.WaltonSimonsTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.WaltonSimonsTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.WaltonSimonsTex2'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="WaltonSimons"
     FamiliarName="Walton Simons"
     UnfamiliarName="Walton Simons"
}
