//=============================================================================
// Gray.
//=============================================================================
class Gray extends Animal;

#exec OBJ LOAD FILE=Ambient

var float damageRadius;
var float damageInterval;
var float damageAmount;
var float damageTime;
var bool bPsychicAttack;
var bool bPsychicConfirm;
var float psychoTime;

// check every damageInterval seconds and damage any player near the gray
function Tick(float deltaTime)
{
	local DeusExPlayer player;

	damageTime += deltaTime;

	if (damageTime >= damageInterval)
	{
		damageTime = 0;
		foreach VisibleActors(class'DeusExPlayer', player, damageRadius)
			if (player != None)
				player.TakeDamage(damageAmount, Self, player.Location, vect(0,0,0), 'Radiation');
	}

	Super.Tick(deltaTime);
}

function ComputeFallDirection(float totalTime, int numFrames,
                              out vector moveDir, out float stopTime)
{
	// Determine direction, and how long to slide
	if (AnimSequence == 'DeathFront')
	{
		moveDir = Vector(DesiredRotation) * Default.CollisionRadius*2.0;
		stopTime = totalTime*0.7;
	}
	else if (AnimSequence == 'DeathBack')
	{
		moveDir = -Vector(DesiredRotation) * Default.CollisionRadius*1.8;
		stopTime = totalTime*0.65;
	}
}

function bool FilterDamageType(Pawn instigatedBy, Vector hitLocation,
                               Vector offset, Name damageType)
{
	// Grays aren't affected by radiation or fire or gas
	if ((damageType == 'Radiation')) //CyberP: removed burned and flamed
		return false;
	else if ((damageType == 'TearGas') || (damageType == 'HalonGas') || (damageType == 'PoisonGas'))
		return false;
	else
		return Super.FilterDamageType(instigatedBy, hitLocation, offset, damageType);
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if (damageType == 'Stunned')
		GotoNextState();
	else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

function TweenToAttack(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
		TweenAnimPivot('Attack', tweentime);
}

function PlayAttack()
{
if (FRand() < 0.4)     //CyberP: to get Grays to occassionally have a more spread-out attack.
BaseAccuracy=0.750000;
else
BaseAccuracy=0.000000;
	if ((Weapon != None) && Weapon.IsA('WeaponGraySpit'))
		PlayAnimPivot('Shoot',1.2);
	else
		PlayAnimPivot('Attack',1.3);
}

function PlayPanicRunning()
{
	PlayRunning();
}

function PlayTurning()
{
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,, GetSwimPivot());
	else
		LoopAnimPivot('Walk', 0.1);
}

function TweenToWalking(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
		TweenAnimPivot('Walk', tweentime);
}

function PlayWalking()
{
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,, GetSwimPivot());
	else
		LoopAnimPivot('Walk', , 0.15);
}

function TweenToRunning(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
		LoopAnimPivot('Run',, tweentime);
}

function PlayRunning()
{
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,, GetSwimPivot());
	else
		LoopAnimPivot('Run',1.3);  //CyberP: faster anim rate
}
function TweenToWaiting(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
		TweenAnimPivot('BreatheLight', tweentime);
}
function PlayWaiting()
{
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,, GetSwimPivot());
	else
		LoopAnimPivot('BreatheLight', , 0.3);
}

function PlayTakingHit(EHitLocation hitPos)
{
	local vector pivot;
	local name   animName;

    if (RotationRate.Yaw != 90000)
    RotationRate.Yaw = 90000;

	animName = '';
	if (!Region.Zone.bWaterZone)
	{
		switch (hitPos)
		{
			case HITLOC_HeadFront:
			case HITLOC_TorsoFront:
			case HITLOC_LeftArmFront:
			case HITLOC_RightArmFront:
			case HITLOC_LeftLegFront:
			case HITLOC_RightLegFront:
				animName = 'HitFront';
				break;

			case HITLOC_HeadBack:
			case HITLOC_TorsoBack:
			case HITLOC_LeftArmBack:
			case HITLOC_RightArmBack:
			case HITLOC_LeftLegBack:
			case HITLOC_RightLegBack:
				animName = 'HitBack';
				break;
		}
		pivot = vect(0,0,0);
	}

	if (animName != '')
		PlayAnimPivot(animName, 1.3, 0.1, pivot);
}

// sound functions
function PlayIdleSound()
{
	if (FRand() < 0.5)
		PlaySound(sound'GrayIdle', SLOT_None);
	else
		PlaySound(sound'GrayIdle2', SLOT_None);
}

function PlayScanningSound()
{
	if (FRand() < 0.3)
	{
		if (FRand() < 0.5)
			PlaySound(sound'GrayIdle', SLOT_None);
		else
			PlaySound(sound'GrayIdle2', SLOT_None);
	}
}

function PlayTargetAcquiredSound()
{
	PlaySound(sound'GrayAlert', SLOT_None);
}

function PlayCriticalDamageSound()
{
	PlaySound(sound'GrayFlee', SLOT_None);
}

function EHitLocation HandleDamage(int Damage, Vector hitLocation, Vector offset, name damageType, optional Pawn instigatedBy)
{
	local EHitLocation hitPos;
    local float        headOffsetZ, headOffsetY;                                //RSD: Adding head damage
	hitPos = HITLOC_None;

    headOffsetZ = CollisionHeight * 0.625;
	headOffsetY = CollisionRadius * 0.5;

    if (offset.z > headOffsetZ)		// head
    {
    	if (offset.X < 0.0)
			hitPos = HITLOC_HeadBack;
		else
			hitPos = HITLOC_HeadFront;
		if (!bInvincible)
			Health -= 2*Damage;
    }
    else
    {
    	if (offset.X < 0.0)
			hitPos = HITLOC_TorsoBack;
		else
			hitPos = HITLOC_TorsoFront;
    	if (!bInvincible)
			Health -= Damage;
    }

	return hitPos;

}

function DifficultyMod(float CombatDifficulty, bool bHardCoreMode, bool bExtraHardcore, bool bFirstLevelLoad) //RSD: New function to streamline NPC stat difficulty modulation
{
        if (!bHardCoreMode)
        {
        if (bFirstLevelLoad || !bNotFirstDiffMod)                       //RSD: Only alter health if it's the first time loading the map
        {
        default.Health=200;                                                   //RSD: Was 250
	    default.HealthHead=200;
	    default.HealthTorso=200;                                              //RSD: Was 250
	    default.HealthLegLeft=200;                                            //RSD: Was 250
    	default.HealthLegRight=200;                                           //RSD: Was 250
     	default.HealthArmLeft=200;                                            //RSD: Was 250
	   default.HealthArmRight=200;                                            //RSD: Was 250
	    Health=200;                                                           //RSD: Was 250
         HealthHead=200;
         HealthTorso=200;                                                     //RSD: Was 250
          HealthLegLeft=200;                                                  //RSD: Was 250
          HealthLegRight=200;                                                 //RSD: Was 250
          HealthArmLeft=200;                                                  //RSD: Was 250
          HealthArmRight=200;                                                 //RSD: Was 250
          }
          }
          bNotFirstDiffMod = true;
}

State Attacking
{
   function Tick(float deltaSeconds)
	{
	local float dista;
    local bool bSafe, bSafe2;
    local DeusExDecoration acti;

		Super.Tick(deltaSeconds);

		if (enemy != None && bPsychicConfirm)
		{
		   if (!enemy.IsInState('Dying') && enemy.Physics == PHYS_Falling)
		   {
		   psychoTime += deltaSeconds;
		   enemy.Velocity.X = 0;
		   enemy.Velocity.Y = 0;
           enemy.Velocity.Z = 40;
           if (psychoTime > 12)
           {
              bPsychicConfirm = False;
		      bPsychicAttack = False;
		      enemy.SetPhysics(PHYS_Falling);
		      bShowPain = True;
              psychoTime = 0;
           }
           }
		}
		/*ForEach RadiusActors(class'DeusExDecoration',acti,320)
		{
		   if (acti.Owner == None)
		   {
		      if (acti.bPushable && acti.Velocity.X == 0 && acti.Velocity.Y == 0)
		      {
		         acti.psychoLiftTime+=deltaSeconds;
		         acti.SetPhysics(PHYS_Falling);
		         if (acti.psychoLiftTime <= 4)
		         {
		         acti.Velocity.Z = 30;
		         }
		         else if (acti.psychoLiftTime > 4)
		         {
		             acti.bFixedRotationDir = True;
                     acti.RotationRate.Pitch = 32000;
		             acti.RotationRate.Roll = 32000;
		             acti.Velocity = vector(ViewRotation) * 1500;
		             acti.Velocity.Z += 300;
		             acti.psychoLiftTime = 0;
		             acti.bPsychoBump = True;
		         }
		      }
		   }
		}*/
	}
}

State Dying
{
  function beginstate()
  {
   super.BeginState();

   if (AmbientSound == sound'GMDXSFX.Ambient.grayradiation')
         AmbientSound = None;
  }
}

defaultproperties
{
     DamageRadius=256.000000
     damageInterval=1.000000
     DamageAmount=10.000000
     bPlayDying=True
     maxRange=1024.000000
     MinHealth=20.000000
     CarcassType=Class'DeusEx.GrayCarcass'
     WalkingSpeed=0.280000
     bCanBleed=True
     CloseCombatMult=0.400000
     ShadowScale=0.750000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponGraySwipe')
     InitialInventory(1)=(Inventory=Class'DeusEx.WeaponGraySpit')
     InitialInventory(2)=(Inventory=Class'DeusEx.AmmoGraySpit',Count=9999)
     WalkSound=Sound'DeusExSounds.Animal.GrayFootstep'
     BurnPeriod=0.000000
     runAnimMult=1.300000
     GroundSpeed=550.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     BaseEyeHeight=25.000000
     Health=400
     ReducedDamageType=Radiation
     ReducedDamagePct=1.000000
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Animal.GrayIdle'
     HitSound2=Sound'DeusExSounds.Animal.GrayPainLarge'
     Die=Sound'DeusExSounds.Animal.GrayDeath'
     HealthHead=400
     HealthTorso=400
     HealthLegLeft=400
     HealthLegRight=400
     HealthArmLeft=400
     HealthArmRight=400
     Alliance=Gray
     DrawType=DT_Mesh
     Mesh=LodMesh'HDTPCharacters.HDTPGray'
     ScaleGlow=0.500000
     AmbientGlow=12
     SoundRadius=48
     SoundVolume=255
     AmbientSound=Sound'Ambient.Ambient.GeigerLoop'
     CollisionRadius=20.000000
     CollisionHeight=36.000000
     LightType=LT_Steady
     LightBrightness=32
     LightHue=96
     LightSaturation=128
     LightRadius=5
     Mass=120.000000
     Buoyancy=97.000000
     BindName="Gray"
     FamiliarName="Gray"
     UnfamiliarName="Gray"
}
