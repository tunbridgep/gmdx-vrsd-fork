//=============================================================================
// Greasel.
//=============================================================================
class Greasel extends Animal;

function PostBeginPlay()
{
super.PostBeginPlay();

if (RotationRate.Yaw != 80000)
    RotationRate.Yaw = 80000; //CyberP: turn faster
}

function Bump(actor Other)     //CyberP: to do with shouldgreaselmelee()
{
 super.Bump(Other);

 if (Physics == PHYS_Falling)
 {
     if (enemy != None && Other == enemy && bBiteClamp == False)
     {
              Other.TakeDamage(15,self,Vect(0,0,0),Vect(0,0,0),'Poison');
              bBiteClamp = True;
              PlaySound(sound'greaselbite2',SLOT_None);
              SwitchToBestWeapon();
     }
 }
 else
     RotationRate.Yaw = default.RotationRate.Yaw;
}

function Landed(vector HitNormal) //CyberP: to do with shouldgreaselmelee()
{
		RotationRate.Yaw = default.RotationRate.Yaw;
        SwitchToBestWeapon();
		super.Landed(HitNormal);
}

function bool FilterDamageType(Pawn instigatedBy, Vector hitLocation,
										 Vector offset, Name damageType)
{
	if ((damageType == 'TearGas') || (damageType == 'HalonGas') || (damageType == 'PoisonGas') || (damageType == 'Radiation'))
		return false;
	else
		return Super.FilterDamageType(instigatedBy, hitLocation, offset, damageType);
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if ((damageType == 'TearGas') || (damageType == 'HalonGas'))
		GotoNextState();
	else if (damageType == 'Stunned')
		GotoNextState();
	else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

function vector GetSwimPivot()
{
	// THIS IS A HIDEOUS, UGLY, MASSIVELY EVIL HACK!!!!
	return (vect(0,0,1)*CollisionHeight);
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
  local float hardcoreMod;

  hardcoreMod = 0.0;

  if (enemy != None && enemy.IsA('DeusExPlayer'))
      if (DeusExPlayer(enemy).bHardCoreMode)
         hardcoremod = 0.3;

  if (weapon.IsA('WeaponGreaselBite'))
    PlayAnimPivot('Attack',2.0+hardcoreMod);
  else
	PlayAnimPivot('Attack',1.1+hardcoreMod);
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
	if (Physics != PHYS_Falling)
	    RotationRate.Yaw = default.RotationRate.Yaw;

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
		LoopAnimPivot('Tread',2.5,,, GetSwimPivot()); //CyberP: 1.5
	else
		LoopAnimPivot('Run', 1.5);
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
		LoopAnimPivot('Tread',1.5,,, GetSwimPivot());
	else
		LoopAnimPivot('BreatheLight', , 0.3);
}

function PlayTakingHit(EHitLocation hitPos)
{
	local vector pivot;
	local name   animName;

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
		PlayAnimPivot(animName, , 0.1, pivot);
	RotationRate.Yaw = default.RotationRate.Yaw;

}

function vector GetChompPosition()
{
	return (Location+Vector(Rotation)*(CollisionRadius+10)+vect(0,0,-10));
}

function PlayEating()
{
	PlayAnimPivot('Eat', 2.0, 0.2);
}

function SpewBlood(vector Position)
{
	local float         size;
	local FleshFragment chunk;

	size = (CollisionRadius + CollisionHeight) / 2;  // yes, we *are* using the Greasel's size...  :)
	if ((FRand() < 0.5) && (size > 10.0))
	{
		chunk = spawn(class'FleshFragment', None,, Position);
		if (chunk != None)
		{
			chunk.DrawScale = size / 25;
			chunk.SetCollisionSize(chunk.CollisionRadius / chunk.DrawScale, chunk.CollisionHeight / chunk.DrawScale);
			chunk.bFixedRotationDir = True;
			chunk.RotationRate = RotRand(False);
			chunk.Velocity = VRand()*100;
			chunk.Velocity.Z = chunk.Velocity.Z + 250;
		}
	}
	else
		Super.SpewBlood(Position);
}

// sound functions
function PlayEatingSound()
{
	PlaySound(sound'GreaselEat', SLOT_None,,, 384);
}

function PlayIdleSound()
{
	if (FRand() < 0.5)
		PlaySound(sound'GreaselIdle', SLOT_None);
	else
		PlaySound(sound'GreaselIdle2', SLOT_None);
}

function PlayScanningSound()
{
	if (FRand() < 0.3)
	{
		if (FRand() < 0.5)
			PlaySound(sound'GreaselIdle', SLOT_None);
		else
			PlaySound(sound'GreaselIdle2', SLOT_None);
	}
}

function PlayTargetAcquiredSound()
{
	PlaySound(sound'GreaselAlert', SLOT_None);
}

function PlayCriticalDamageSound()
{
	PlaySound(sound'GreaselFlee', SLOT_None);
}

function Shenanigans(bool bEnabled)
{
    if (FRand() < 0.1 && bEnabled)
    {
        FamiliarName="Beasel the Greasel";
        UnfamiliarName="Beasel the Greasel";
    }
}

defaultproperties
{
     bPlayDying=True
     FoodClass=Class'DeusEx.DeusExCarcass'
     FoodDamage=4
     FoodHealth=2
     bMessyEater=True
     maxRange=2048.000000
     CarcassType=Class'DeusEx.GreaselCarcass'
     WalkingSpeed=0.080000
     bCanBleed=True
     ShadowScale=1.000000
     InitialAlliances(0)=(AllianceName=Karkian,AllianceLevel=1.000000,bPermanent=True)
     EnemyTimeout=10.000000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponGreaselSpit')
     InitialInventory(1)=(Inventory=Class'DeusEx.AmmoGreaselSpit',Count=9999)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponGreaselBite')
     WalkSound=Sound'DeusExSounds.Animal.GreaselFootstep'
     bSpawnBubbles=False
     HDTPMesh="HDTPCharacters.HDTPGreasel"
     bCanSwim=True
     bCanGlide=False
     GroundSpeed=350.000000
     WaterSpeed=160.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     BaseEyeHeight=12.500000
     Health=100
     UnderWaterTime=99999.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Animal.GreaselPainSmall'
     HitSound2=Sound'DeusExSounds.Animal.GreaselPainLarge'
     Die=Sound'DeusExSounds.Animal.GreaselDeath'
     VisibilityThreshold=0.002000
     Alliance=Greasel
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.Greasel'
     CollisionHeight=17.879999
     Mass=40.000000
     Buoyancy=40.000000
     RotationRate=(Yaw=80000)
     BindName="Greasel"
     FamiliarName="Greasel"
     UnfamiliarName="Greasel"
}
