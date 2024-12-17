//=============================================================================
// Human.
//=============================================================================
class Human extends DeusExPlayer
	abstract;

var float mpGroundSpeed;
var float mpWaterSpeed;
var float humanAnimRate;
var bool isMantling;
var float mantleTimer;
var float negaTime;          //CyberP: mantling camera effect timer
var float CollisionDiff;
var float mantleBeginZ;
var float negaMult;
var DeusExDecoration decorum;
var DeusExMover mova;
var bool bSpecialCase, bSpecialCase2;
var bool bOnKeyHold;
var() bool bDontRandomize;      //Sarge: Prevents an NPC from being randomized by the Enemy Randomization Feature

//var Actor LockPawn;
//var vector LockPawnHeight;

//LDDP, 10/26/21: Female storage, because flags wipe on new game.
var(LDDP) travel bool bMadeFemale, bFemaleUsesMaleInteractions; //Are we female? Do we want traditionally male interactions? Save this per char, I guess.
var(LDDP) globalconfig bool bRetroMorpheus, bGaveNewGameTips; //Keep old morpheus lines? Also, did we give a tip yet?

replication
{
	reliable if (( Role == ROLE_Authority ) && bNetOwner )
		humanAnimRate;
}

event WalkTexture( Texture Texture, vector StepLocation, vector StepNormal )
{
   //Log( "(Texture="$Texture$")", 'WalkTexture' );

   if (Texture != None && Texture.Outer!=None && Texture.Outer.Name=='Ladder' )
   {
      if (!Region.Zone.bWaterZone && !FootRegion.Zone.bWaterZone)
      {
          bOnLadder = True;
          bIsWalking = True;
      }
      else
          bOnLadder = False;
   }
   else
      bOnLadder = False;
}

function bool CheckWaterJump(out vector WallNormal)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, checkpoint, start, checkNorm, Extent;

	if (CarriedDecoration != None)
		return false;
	checkpoint = vector(Rotation);
	checkpoint.Z = 0.0;
	checkNorm = Normal(checkpoint);
	checkPoint = Location + CollisionRadius * checkNorm;
	Extent = CollisionRadius * vect(1,1,0);
	Extent.Z = CollisionHeight;
	HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, true, Extent);
	if ( (HitActor != None) && (Pawn(HitActor) == None) && WallMaterial != 'Ladder')
	{
		WallNormal = -1 * HitNormal;
		start = Location;
		start.Z += 1.1 * MaxStepHeight;
		//checkPoint = start + 2 * CollisionRadius * checkNorm;
		HitActor = Trace(HitLocation, HitNormal, Location, start, true);
		if (HitActor == None)
			return true;
	}

	return false;
}

function Bool IsFiring()
{
	if ((Weapon != None) && ( Weapon.IsInState('NormalFire') || Weapon.IsInState('ClientFiring') ) )
		return True;
	else
		return False;
}

function Bool HasTwoHandedWeapon()
{
    //LDDP, 11/3/2021: Checking bool here because it's faster, and anim functions are called a LOT.
	if (bMadeFemale)
	{
		return false;
	} 

	if ((Weapon != None) && (Weapon.Mass >= 30))
		return True;
	else
		return False;
}

//
// animation functions
//
function PlayTurning()
{
//	ClientMessage("PlayTurning()");
	if (IsCrouching() || IsLeaning())
		TweenAnim('CrouchWalk', 0.1);
	else
	{
		if (HasTwoHandedWeapon())
			TweenAnim('Walk2H', 0.1);
		else
			TweenAnim('Walk', 0.1);
	}
}

function TweenToWalking(float tweentime)
{
//	ClientMessage("TweenToWalking()");
	if (IsCrouching())
		TweenAnim('CrouchWalk', tweentime);
	else
	{
		if (HasTwoHandedWeapon())
			TweenAnim('Walk2H', tweentime);
		else
			TweenAnim('Walk', tweentime);
	}
}

function PlayWalking()
{
	local float newhumanAnimRate;

	newhumanAnimRate = humanAnimRate;

	// UnPhysic.cpp walk speed changed by proportion 0.7/0.3 (2.33), but that looks too goofy (fast as hell), so we'll try something a little slower
	if ( Level.NetMode != NM_Standalone )
		newhumanAnimRate = humanAnimRate * 1.75;

	//	ClientMessage("PlayWalking()");
	if (IsCrouching())
		LoopAnim('CrouchWalk', newhumanAnimRate+0.2);
	else
	{
		if (HasTwoHandedWeapon())
			LoopAnim('Walk2H', newhumanAnimRate+0.2);
		else
			LoopAnim('Walk', newhumanAnimRate+0.2);
	}
}

function TweenToRunning(float tweentime)
{
//	ClientMessage("TweenToRunning()");
	if (bIsWalking)
	{
		TweenToWalking(0.1);
		return;
	}

	if (IsFiring() && !IsInState('Reload'))
	{
		if (aStrafe != 0)
		{
			if (HasTwoHandedWeapon())
				PlayAnim('Strafe2H',humanAnimRate, tweentime);
			else
				PlayAnim('Strafe',humanAnimRate, tweentime);
		}
		else
		{
			if (HasTwoHandedWeapon())
				PlayAnim('RunShoot2H',humanAnimRate, tweentime);
			else
				PlayAnim('RunShoot',humanAnimRate, tweentime);
		}
	}
	else if (bOnFire)
		PlayAnim('Panic',humanAnimRate, tweentime);
	else
	{
		if (HasTwoHandedWeapon())
			PlayAnim('RunShoot2H',humanAnimRate, tweentime);
		else
			PlayAnim('Run',humanAnimRate, tweentime);
	}
}

function PlayRunning()
{
//	ClientMessage("PlayRunning()");
	if (IsFiring())
	{
		if (aStrafe != 0)
		{
			if (HasTwoHandedWeapon())
				LoopAnim('Strafe2H', humanAnimRate);
			else
				LoopAnim('Strafe', humanAnimRate);
		}
		else
		{
			if (HasTwoHandedWeapon())
				LoopAnim('RunShoot2H', humanAnimRate);
			else
				LoopAnim('RunShoot', humanAnimRate);
		}
	}
	else if (bOnFire)
		LoopAnim('Panic', humanAnimRate);
	else
	{
		if (HasTwoHandedWeapon())
			LoopAnim('RunShoot2H', humanAnimRate);
		else
			LoopAnim('Run', humanAnimRate);
	}
}

function TweenToWaiting(float tweentime)
{
//	ClientMessage("TweenToWaiting()");
	if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
	{
		if (IsFiring())
			LoopAnim('TreadShoot');
		else
			LoopAnim('Tread');
	}
	else if (IsLeaning() || IsCrouching())
		TweenAnim('CrouchWalk', tweentime);
	else if (((AnimSequence == 'Pickup') && bAnimFinished) || ((AnimSequence != 'Pickup') && !IsFiring()))
	{
		if (HasTwoHandedWeapon())
			TweenAnim('BreatheLight2H', tweentime);
		else
			TweenAnim('BreatheLight', tweentime);
	}
}

function PlayWaiting()
{
//	ClientMessage("PlayWaiting()");
	if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
	{
		if (IsFiring())
			LoopAnim('TreadShoot');
		else
			LoopAnim('Tread');
		isMantling = False;
	    mantleTimer = -1;
	}
	else if (IsLeaning() || IsCrouching())
		TweenAnim('CrouchWalk', 0.1);
	else if (!IsFiring())
	{
		if (HasTwoHandedWeapon())
			LoopAnim('BreatheLight2H');
		else
			LoopAnim('BreatheLight');
	}

}

function PlaySwimming()
{
//	ClientMessage("PlaySwimming()");
	LoopAnim('Tread');
}

function TweenToSwimming(float tweentime)
{
//	ClientMessage("TweenToSwimming()");
	TweenAnim('Tread', tweentime);
}

function PlayInAir()
{
//	ClientMessage("PlayInAir()");
	if (!IsCrouching() && (AnimSequence != 'Jump'))
		PlayAnim('Jump',3.0,0.1);
}

function PlayLanded(float impactVel)
{
//	ClientMessage("PlayLanded()");
	PlayFootStep();
    //SARGE: TODO: Make this not always silent, it should be impact dependent
	if (!IsCrouching())
		PlayAnim('Land',3.0,0.1);
	isMantling = False;
}

function PlayDuck()
{
//	ClientMessage("PlayDuck()");
	if ((AnimSequence != 'Crouch') && (AnimSequence != 'CrouchWalk'))
	{
		if (IsFiring())
			PlayAnim('CrouchShoot',,0.1);
		else
			PlayAnim('Crouch',,0.1);
	}
	else
		TweenAnim('CrouchWalk', 0.1);
}

function PlayRising()
{
//	ClientMessage("PlayRising()");
	PlayAnim('Stand',,0.1);
}

function PlayCrawling()
{
//	ClientMessage("PlayCrawling()");
	if (IsFiring())
		LoopAnim('CrouchShoot');
	else
		LoopAnim('CrouchWalk');
}

function PlayFiring()
{
	local DeusExWeapon W;
    local float comb;
//	ClientMessage("PlayFiring()");

	W = DeusExWeapon(Weapon);
    comb = AugmentationSystem.GetAugLevelValue(class'AugCombat');

    if (comb <= 1.3)
    comb = 1.3;

    if (AddictionManager.addictions[DRUG_CRACK].drugTimer > 0)                                                 //RSD: Zyme gives its own +50% boost
        comb += 0.5;

	if ((W != None) && (!IsInState('Dying')))
	{
		if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
			LoopAnim('TreadShoot',,0.1);
		else if (W.bHandToHand)
		{
			if (bAnimFinished || (AnimSequence != 'Attack'))
				PlayAnim('Attack',comb*1.25,0.1);
		}
		else if (IsCrouching() || IsLeaning())
			LoopAnim('CrouchShoot',,0.1);
		else
		{
			if (HasTwoHandedWeapon())
				LoopAnim('Shoot2H',,0.1);
			else
				LoopAnim('Shoot',,0.1);
		}
	}
}

function PlayWeaponSwitch(Weapon newWeapon)
{
//	ClientMessage("PlayWeaponSwitch()");
	if (!IsCrouching() && !IsLeaning() && !IsInState('Dying')) //CyberP: bugfix: added !state dying
		PlayAnim('Reload');
}

function PlayDying(name damageType, vector hitLoc)
{
	local Vector X, Y, Z;
	local float dotp;

//	ClientMessage("PlayDying()");
	GetAxes(Rotation, X, Y, Z);
	dotp = (Location - HitLoc) dot X;

	if (Region.Zone.bWaterZone)
	{
		PlayAnim('WaterDeath',,0.1);
	}
	else
	{
		// die from the correct side
		if (dotp < 0.0)		// shot from the front, fall back
		{
		    if (bRemoveVanillaDeath && FRand() < 0.5) //CyberP: the better first person death is more common.
		        PlayAnim('DeathFront',1.2,0.1);
		    else
			    PlayAnim('DeathBack',1.1,0.1);
		}
        else				// shot from the back, fall front
		{
            PlayAnim('DeathFront',1.2,0.1);
        }
	}

	PlayDyingSound();
}

//
// sound functions
//

function float RandomPitch()
{
	return (1.1 - 0.2*FRand());
}

//LDDP, 10/26/21: These next 3 functions are all modified for unique sound playing based on female stuff
function Gasp()
{
	local Sound TSound;

    if (swimTimer < swimDuration * 0.3)
    {
        if ((FlagBase != None) && (FlagBase.GetBool('LDDPJCIsFemale')))
        {
            TSound = Sound(DynamicLoadObject("FemJC.FJCGasp", class'Sound', false));
            if (TSound != None) PlaySound(TSound, SLOT_Pain,,,, RandomPitch());
        }
        else
        {
            PlaySound(sound'MaleGasp', SLOT_Pain,,,, RandomPitch());
        }
    }
}

function PlayDyingSound()
{
	local Sound TSound;
	
	if ((FlagBase != None) && (FlagBase.GetBool('LDDPJCIsFemale')))
	{
		if (Region.Zone.bWaterZone)
		{
			TSound = Sound(DynamicLoadObject("FemJC.FJCWaterDeath", class'Sound', false));
			if (TSound != None) PlaySound(TSound, SLOT_Pain,,,, RandomPitch());
		}
		else
		{
			TSound = Sound(DynamicLoadObject("FemJC.FJCDeath", class'Sound', false));
			if (TSound != None) PlaySound(TSound, SLOT_Pain,,,, RandomPitch());
		}
	}
	else
	{
		if (Region.Zone.bWaterZone)
		{
			PlaySound(sound'MaleWaterDeath', SLOT_Pain,,,, RandomPitch());
		}
		else
		{
			PlaySound(sound'MaleDeath', SLOT_Pain,,,, RandomPitch());
		}
	}
}

function PlayTakeHitSound(int Damage, name damageType, int Mult)
{
	local float rnd;
	
	local sound TSound;

	if ( Level.TimeSeconds - LastPainSound < FRand() + 1.1 || Damage <= 0) //CyberP: was 0.9
		return;

	LastPainSound = Level.TimeSeconds;

	if ((FlagBase != None) && (FlagBase.GetBool('LDDPJCIsFemale')))
	{
		if (Region.Zone.bWaterZone)
		{
			if (damageType == 'Drowned')
			{
				if (FRand() < 0.8)
				{
					TSound = Sound(DynamicLoadObject("FemJC.FJCDrown", class'Sound', false));
					if (TSound != None) PlaySound(TSound, SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
				}
			}
			else
			{
				TSound = Sound(DynamicLoadObject("FemJC.FJCPainSmall", class'Sound', false));
				if (TSound != None) PlaySound(TSound, SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			}
		}
		else
		{
			// Body hit sound for multiplayer only
			if (((damageType == 'Shot') || (damageType == 'AutoShot'))  && (Level.NetMode != NM_Standalone))
			{
				PlaySound(sound'BodyHit', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			}
			
			if ((damageType == 'TearGas') || (damageType == 'HalonGas'))
			{
				TSound = Sound(DynamicLoadObject("FemJC.FJCEyePain", class'Sound', false));
				if (TSound != None) PlaySound(TSound, SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			}
			else if (damageType == 'PoisonGas')
			{
				TSound = Sound(DynamicLoadObject("FemJC.FJCCough", class'Sound', false));
				if (TSound != None) PlaySound(TSound, SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			}
			else
			{
				rnd = FRand();
				if (rnd < 0.33)
				{
					TSound = Sound(DynamicLoadObject("FemJC.FJCPainSmall", class'Sound', false));
					if (TSound != None) PlaySound(TSound, SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
				}
				else if (rnd < 0.66)
				{
					TSound = Sound(DynamicLoadObject("FemJC.FJCPainMedium", class'Sound', false));
					if (TSound != None) PlaySound(TSound, SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
				}
				else
				{
					TSound = Sound(DynamicLoadObject("FemJC.FJCPainLarge", class'Sound', false));
					if (TSound != None) PlaySound(TSound, SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
				}
			}
			AISendEvent('LoudNoise', EAITYPE_Audio, FMax(Mult * TransientSoundVolume, Mult * 2.0));
		}
	}
	else
	{
		if (Region.Zone.bWaterZone)
		{
			if (damageType == 'Drowned')
			{
				if (FRand() < 0.8)
					PlaySound(sound'MaleDrown', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			}
			else
				PlaySound(sound'MalePainSmall', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
		}
		else
		{
			// Body hit sound for multiplayer only
			if (((damageType=='Shot') || (damageType=='AutoShot'))  && ( Level.NetMode != NM_Standalone ))
			{
				PlaySound(sound'BodyHit', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			}
			
			if ((damageType == 'TearGas') || (damageType == 'HalonGas'))
				PlaySound(sound'MaleEyePain', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			else if (damageType == 'PoisonGas')
				PlaySound(sound'MaleCough', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			else
			{
				rnd = FRand();
				if (rnd < 0.33)
					PlaySound(sound'MalePainSmall', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
				else if (rnd < 0.66)
					PlaySound(sound'MalePainMedium', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
				else
					PlaySound(sound'MalePainLarge', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			}
			AISendEvent('LoudNoise', EAITYPE_Audio, FMax(Mult * TransientSoundVolume, Mult * 2.0));
		}
	}
}

function UpdateAnimRate( float augValue )
{
	if ( Level.NetMode != NM_Standalone )
	{
		if ( augValue == -1.0 )
			humanAnimRate = (Default.mpGroundSpeed/320.0);
		else
			humanAnimRate = (Default.mpGroundSpeed/320.0) * augValue * 0.90;	// Scale back about 15% so were not too fast //CyberP: 10%
	}
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		GroundSpeed = mpGroundSpeed;
		WaterSpeed = mpWaterSpeed;
		humanAnimRate = (GroundSpeed/320.0);
	}
}

function DoJump( optional float F )
{

if ((Physics == PHYS_Falling || (HealthLegLeft < 1 && HealthLegRight < 1))  && Base==none && !isMantling && bMantleOption && CarriedDecoration == None)
{      startMantling();    }

super.DoJump();
}

//CyberP: Shitty lock-on. *Grumble Moan*. Programmed for "neologicx1992" for their mod. Keep commented out. This shit should NOT be in Deus Ex/GMDX.
/*
function LockOnInit()
{
 local Actor HitActor;
 local vector HitLocation, HitNormal, EndTrace, StartTrace, Extent;

  StartTrace = Location;
  Extent = CollisionRadius * vect(0.5,0.5,0.5);
  EndTrace = Location + (vector(ViewRotation) * 2000);
  HitActor = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True,Extent);
  if (HitActor != None && HitActor.IsA('ScriptedPawn'))
  {
      LockPawn = HitActor;
      LockPawnHeight.X = 0;
      LockPawnHeight.Y = 0;
      LockPawnHeight.Z = LockPawn.CollisionHeight*0.5;
      BroadcastMessage("Lock-On Activated");
      ViewRotation =  Rotator(LockPawn.Location - Location);
  }
}

exec function ShowScores()
{
   if (LockPawn != None)
   {
       LockPawn = None;
       BroadcastMessage("Lock-On disabled");
   }
   else
       LockOnInit();
}
*/

function checkMantle()                                                          //RSD: Unified function for PlayerWalking and PlayerFlying
{
		local actor HitActor;
		local vector HitLocation, HitNormal, checkpoint, start, checkNorm, EndTrace, Extent;
        local float shakeTime, shakeRoll, shakeVert, mult;                      //RSD: added mult

        //Justice: Mantling system.  Code shamelessly stolen from CheckWaterJump() in ScriptedPawn
		if (isMantling && !bOnLadder && !bStunted) //CyberP: PHYS_Falling && != 0 //RSD: PlayerFlying had velocity.Z != 0 ??? also added !bStunted
		{
		    EndTrace = Location + CollisionHeight * 1.1 * vect(0,0,1);
		    HitActor = Trace(HitLocation, HitNormal, EndTrace,,True);
		    if (HitActor == None)
		    {
			if (CarriedDecoration == None && velocity.Z > -1000)
			{
				checkpoint = vector(Rotation);
				checkpoint.Z = 0.0;
				checkNorm = Normal(checkpoint);
				checkPoint = Location + CollisionRadius * checkNorm;
				//Extent = CollisionRadius * vect(1,1,0);
				if (bIcarusClimb)
				   Extent = CollisionRadius * vect(1.2,1.2,0); //0.3
				else
                   Extent = CollisionRadius * vect(0.3,0.3,0);
				Extent.Z = CollisionHeight*0.67;
				if (bIcarusClimb)
				   Extent.Z = CollisionHeight*0.8;
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, Extent);
				if ( (HitActor != None) && (HitActor.IsA('Mover') || HitActor == Level || HitActor.IsA('DeusExDecoration')))
				{
				    if (HitActor.IsA('DeusExDecoration') && (HitActor.CollisionHeight < 20 || DeusExDecoration(HitActor).bCanBeBase == False))
				        return;
				    else if (HitActor.IsA('DeusExDecoration'))
                    {    bSpecialCase = True; decorum = DeusExDecoration(HitActor);}
                    else if (HitActor.IsA('DeusExMover'))
                    {   bSpecialCase2 = True; mova = DeusExMover(HitActor);}
					WallNormal = -1 * HitNormal;
					/*mult = SkillSystem.GetSkillLevelValue(class'SkillSwimming');//RSD: Get skill value (0.9/1.2/1.7/2.25)
					if (mult > 2.25)
		  			    mult = 2.25;*/                                            //RSD: Capping multiplier at 2.25
                    mult = 0.6*(self.SkillSystem.GetSkillLevel(class'SkillSwimming')); //RSD: Actually it will just be 0.0/0.5/1.0/1.5 x CollisionHeight
					start = Location;
					//start.Z += 1.1 * MaxStepHeight + CollisionHeight;         //RSD: Old mantling formula
					start.Z += 0.6 * MaxStepHeight + mult*CollisionHeight;      //RSD: Mantling height affected by Athletics skill (SkillSwimming)
					checkPoint = start + 1.25 * CollisionRadius * checkNorm;
					HitActor = Trace(HitLocation, HitNormal, checkpoint, start, true, Extent);
					if (HitActor == None)
					{
                        if (bHardCoreMode)                                      //RSD: Stamina drain
                            swimTimer -= 1.0;
                        else
                            swimTimer -= 0.8;
                        if (swimTimer < 0)                                      //RSD: Can run out of breath
                        {
                            swimTimer = 0;
                            if (bStaminaSystem || bHardCoreMode)
                            {
                                bStunted = true;
                                SetTimer(3,false);
                                if (!bOnLadder && FRand() < 0.7)
                                    PlaySound(sound'MaleBreathe', SLOT_None,0.8);
                                if (bBoosterUpgrade && Energy > 0)
                                    AugmentationSystem.AutoAugs(false,false);
                            }
                        }
						goToState('Mantling');
					}
				}
			}
			}
		}
}

state PlayerFlying
{
    function ProcessMove ( float DeltaTime, vector newAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local actor HitActor;
		local vector HitLocation, HitNormal, checkpoint, start, checkNorm, EndTrace, Extent;
        local float shakeTime, shakeRoll, shakeVert, mult;                      //RSD: added mult

		super.ProcessMove(DeltaTime, newAccel, DodgeMove, DeltaRot);

		checkMantle();                                                          //RSD: New unified function
	}
	event PlayerTick(float deltaTime)
	{
	    /*if (LockPawn != None)
        {
           if (LockPawn.IsA('ScriptedPawn') && ScriptedPawn(LockPawn).LineOfSightTo(self))
               ViewRotation =  Rotator(LockPawn.Location - Location - LockPawnHeight);
           else
               LockPawn = None;
        }*/
		if(mantleTimer <= 1)
		{
			if(mantleTimer > -1)
			{
				isMantling = true;
				mantleTimer = -1;
			}
			else
			    isMantling = false;
		}
		else
			mantleTimer -= deltaTime;

		super.PlayerTick(deltaTime);
	}
}
state PlayerWalking
{
	function ProcessMove ( float DeltaTime, vector newAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local actor HitActor;
		local vector HitLocation, HitNormal, checkpoint, start, checkNorm, EndTrace, Extent;
        local float shakeTime, shakeRoll, shakeVert, mult;                      //RSD: added mult

		super.ProcessMove(DeltaTime, newAccel, DodgeMove, DeltaRot);

        if (bOnKeyHold && Physics == PHYS_Falling)
           DoJump();
		checkMantle();
	}

	event PlayerTick(float deltaTime)
	{
        /*if (LockPawn != None)
        {
            if (LockPawn.IsA('ScriptedPawn') && ScriptedPawn(LockPawn).LineOfSightTo(self))
                ViewRotation =  Rotator(LockPawn.Location - Location - LockPawnHeight);
            else
                LockPawn = None;
        }*/
		if(mantleTimer <= 1)
		{
			if(mantleTimer > -1)
			{
				isMantling = true;
				mantleTimer = -1;
			}
			else
			    isMantling = false;
		}
		else
			mantleTimer -= deltaTime;

		super.PlayerTick(deltaTime);
	}
}

State PlayerSwimming
{
  event PlayerTick(float deltaTime)
  {
    /*if (LockPawn != None)
    {
        if (LockPawn.IsA('ScriptedPawn') && ScriptedPawn(LockPawn).LineOfSightTo(self))
            ViewRotation =  Rotator(LockPawn.Location - Location - LockPawnHeight);
        else
            LockPawn = None;
    }*/
    mantleTimer -= deltaTime;
    super.PlayerTick(deltaTime);
  }
}

State Mantling
{
    /*function ProcessMove ( float DeltaTime, vector newAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
	   super.ProcessMove(DeltaTime, newAccel, DodgeMove, DeltaRot);
	}

	function DoJump( optional float F )
    {
      BroadcastMessage("DoJump");
    } */

    function BeginState()
    {
      local vector HitLocation, Hitnormal, StartTrace, EndTrace, Extent;
      local Actor HitActor;
      local vector ap;
      local float decremental;

      Velocity = vect(0,0,0);
      Acceleration = vect(0,0,0);
      PlayAnim('Pickup',1.2,0.1);
      negaMult = 1;
        bCrouchHack = true;

      if (bIcarusClimb)
		   Velocity = Vector(ViewRotation) * 260;
	  /*else if (HealthLegLeft < 1 && HealthLegRight < 1)
	  {
           SetPhysics(PHYS_Falling);
           Velocity.Z += 10;
           if (Base.IsA('DeusExDecoration'))
               SetBase(None);
      }*/
      if ((WallMaterial == 'Metal' || WallMaterial == 'Ladder'))
         PlaySound(sound'woodhvydrop_metal',SLOT_None,,,, 1.2);
      else
		 PlaySound(sound'pcconcfall1',SLOT_None,,,, 1.2);

      mantleBeginZ = Location.Z;
      //StartTrace = Location - CollisionHeight * 0.9 * vect(0,0,1);
      //EndTrace = StartTrace + (vector(Rotation) * (CollisionRadius+6));
      //Extent = CollisionRadius * vect(0.1,0.1,0);
      //Extent.Z = 3;
      //HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, True, Extent);
      StartTrace = Location + (vector(Rotation) * (CollisionRadius+4));
      StartTrace.Z += CollisionHeight*1.1;
      EndTrace = Location + (vector(Rotation) * (CollisionRadius+4));
      EndTrace.Z -= CollisionHeight;
      HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, True);
      if (HitActor == None)
      {
         //BroadcastMessage("No HitActor");
         mantleBeginZ+=(CollisionHeight+19.5);
         if (inHand != None)
         {
            if (inHand.IsA('DeusExWeapon'))
            {
                 DeusExWeapon(inHand).GotoState('DownWeapon');
            }
            else if (inHand.IsA('SkilledTool'))
                 SkilledTool(inHand).PutDown();
            else if (inHand.IsA('DeusExPickup'))
                 PutInHand(None);
          }
      }
      else
      {
      MantleBeginZ = HitLocation.Z+CollisionHeight+0.5;
      if (inHand != None && HitLocation.Z > Location.Z)
      {
            if (inHand.IsA('DeusExWeapon'))
            {
                 DeusExWeapon(inHand).GotoState('DownWeapon');
            }
            else if (inHand.IsA('SkilledTool'))
                 SkilledTool(inHand).PutDown();
            else if (inHand.IsA('DeusExPickup'))
                 PutInHand(None);
      }
      else if (inHand != None && inHand.IsA('DeusExWeapon'))
      {
         DeusExWeapon(inHand).bMantlingEffect = True;
         negaMult = 3;
      }
      }
    }

	function EndState()
	{
		//setPhysics(PHYS_Falling);
		//stopMantling();
		negaMult = 1;
		isMantling = False;
	    mantleTimer = -1;
		bIcarusClimb = False;
		bSpecialCase = False;
		bSpecialCase2 = False;
		bOnKeyHold = False;
		decorum = None;
		mova = None;

        SetTimer(0.6,false);

		if (inHand != None && inHand.IsA('DeusExWeapon'))
        {
         DeusExWeapon(inHand).bMantlingEffect = False;
        }
	}

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
    {
        super.TakeDamage(Damage, instigatedBy, hitLocation, momentum, damageType);
    }

	event PlayerTick(float deltaTime)
	{
	  local vector HitLocation, Hitnormal, StartTrace, EndTrace, Extent;
      local Actor HitActor;
      local bool bFin;
      local vector cp;

        //RefreshSystems(deltaTime);
      DrugEffects(deltaTime);
      RecoilEffectTick(deltaTime);
      Bleed(deltaTime);
  	  //HighlightCenterObject();
      UpdateDynamicMusic(deltaTime);
  	  UpdateWarrenEMPField(deltaTime);
  	  UpdatePoison(DeltaTime);
	  //MultiplayerTick(deltaTime);
      FrobTime += deltaTime;
      UpdateTimePlayed(deltaTime);

      velocity.X = 0;
      velocity.Y = 0;
      //StartTrace = Location + CollisionHeight * 1.025 * vect(0,0,1);
      //EndTrace = StartTrace + vect(0,0,3);
      //HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace);
      //if (HitActor == None)
      //{
        super.DrugEffects(deltaTime);

        if (location.Z < mantleBeginZ+19.5)
        {
         if (location.Z < mantleBeginZ-30)
            velocity.Z = 120;
         else
            velocity.Z = 90;
        }
        else
        {
           if (inHand == none)
           {
             RecoilTime=default.RecoilTime*4;
		     RecoilShake.Z-=lerp(min(Abs(Velocity.X),4.0*310)/(4.0*310),4,6.0); //CyberP: 7
		     RecoilShake.Y-=lerp(min(Abs(Velocity.Z),4.0*310)/(4.0*310),4,6.0);
		     RecoilShaker(vect(10,2,5));
		   }
           StartTrace = Location - CollisionHeight * 1.15 * vect(0,0,1);
           EndTrace = StartTrace + (vector(Rotation) * (CollisionRadius+10));
           HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, True);
           if (HitActor != None)
              velocity.Z = 80;
           else
           {
              /*StartTrace = Location - CollisionHeight * 1.2 * vect(3,0,1);
              EndTrace = StartTrace + (vector(Rotation) * (CollisionRadius+8));
              HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, True);
              if (HitActor != None)
              {
                velocity.Z = 70;
                BroadCastMessage("Spawned");
                spawn(class'LaserSpot',,,HitLocation );
              }
              else*/
                 bFin = True;
           }
        }
      //}
      //else
        // bFin = True;

      StartTrace = Location;
      StartTrace.Z += CollisionHeight + 1;
      EndTrace = Location;
      EndTrace.Z += CollisionHeight + 4;
      HitActor = Trace(HitLocation, HitNormal, EndTrace, , True);
      if (HitActor != None)
         bFin = True;

      if (bSpecialCase)
      {
        if (decorum == None)
         bFin = True;
      }
      else if (bSpecialCase2)
      {
        if (mova == None)
          bFin = True;
      }
      if (bFin)
      {
       bIcarusClimb = False;
       velocity = wallNormal * waterSpeed / 2;
	   velocity = Vector(Rotation) * 90;
	   Acceleration = wallNormal * AccelRate / 5;
	   //SetPhysics(PHYS_Falling);
       GoToState('PlayerWalking');
       //SetPhysics(PHYS_Falling);
      }

	    if (negaTime > 0.225)
		{
		   if (negaTime > 0.3)
		   {
		       if (bIcarusClimb)
		          ViewRotation.Pitch -= deltaTime * 10000;
		       else
                  ViewRotation.Pitch -= deltaTime * 7000;
               if ((ViewRotation.Pitch > 12000) && (ViewRotation.Pitch < 32768))
				  ViewRotation.Pitch -= deltaTime * 3000;
		       ViewRotation.Yaw += deltaTime * 320;
		       ViewRotation.Roll -= deltaTime * 756;
		   }
           else if (negaTime <= 0.25)
           {
		       ViewRotation.Yaw -= deltaTime * 1024;
		       ViewRotation.Pitch -= deltaTime * 3500;
		   }
		}
		else if (negaTime <= 0.225)
		{
		if (bIcarusClimb)
            ViewRotation.Pitch += deltaTime * 5000;
        else
		    ViewRotation.Pitch += deltaTime * 3200;
		if (negaTime <= 0)
		{
          ViewRotation.Roll -= deltaTime * 256;
          ViewRotation.Yaw -= deltaTime * 756;
          ViewRotation.Pitch -= deltaTime * 1200;
        }
        else
        {
          ViewRotation.Roll += deltaTime * 1024;
          ViewRotation.Yaw += deltaTime * 1024;
        }
		if (negaTime < -1)
		{
		  bIcarusClimb = False;
          velocity = wallNormal * waterSpeed / 2;
	      velocity = Vector(Rotation) * 80;
	      Acceleration = wallNormal * AccelRate / 5;
          GoToState('PlayerWalking');
          //SetPhysics(PHYS_Falling);
        }
		}
		negaTime -= deltaTime * negaMult;
		if ((ViewRotation.Pitch > 16384) && (ViewRotation.Pitch < 32768))
				ViewRotation.Pitch = 16384;
	}

Begin:

	if(isMantling)
	{
	    negaTime = 0.5;
		isMantling = False;
		mantleTimer = -1;
		setPhysics(Phys_Falling);
		if (FRand() < 0.6)
		{
            if (PerkManager.GetPerkWithClass(class'DeusEx.PerkNimble').bPerkObtained == false)
            {
                AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 544);
                if (FlagBase.GetBool('LDDPJCIsFemale'))
                    PlaySound(Sound(DynamicLoadObject("FJCLand", class'Sound', false)), SLOT_None, 1.5, true, 1024);
                else
                    PlaySound(sound'MaleLand', SLOT_None, 1.5, true, 1024);
            }
        }
        swimTimer -= 0.5;
	}
}

exec function startMantling(optional float F)
{
    if (F > 0)
       bOnKeyHold = True;
    if ((velocity.Z > -1 && (camInterpol <= 0 || camInterpol > 0.35)) || isMantling || !bMantleOption || CarriedDecoration != None)
    {
    }
    else
	{
	isMantling = True;
	mantleTimer = 0.5; //0.001
	}
}

exec function stopMantling(optional float F)
{
    if (IsInState('Mantling') && location.Z > mantleBeginZ+18.5)
    {
	isMantling = False;
	bOnKeyHold = False;
	mantleTimer = -1;
	if (f > 0 && IsInState('Mantling'))
	   GoToState('PlayerWalking');
	}
	else if (!IsInState('Mantling'))
	{
	bOnKeyHold = False;
	mantleTimer = -1;
	isMantling = False;
	}
}

//LDDP, 10/26/21: Fix for using "Walk" command resetting collision height in a way that is wrong.
function ClientReStart()
{
	Super.ClientRestart();
	
	if ((FlagBase != None) && (FlagBase.GetBool('LDDPJCIsFemale')))
	{
		BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight) - 2.0;
	}
	else
	{
		BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight);
	}
}


//LDDP, 10/26/21: We tweak this because in theory feign death breaks dynamic collision size. That's bad, M'kay.
state FeigningDeath
{
ignores SeePlayer, HearNoise, Bump;

	function Rise()
	{
		if ( !bRising )
		{
			Enable('AnimEnd');
			
			//LDDP, 10/26/21: Yeah, this is on its way out. Thanks.
			//BaseEyeHeight = Default.BaseEyeHeight;
			
			//LDDP, 10/26/21: Update female sounds a bit here.
			if ((FlagBase != None) && (FlagBase.GetBool('LDDPJCIsFemale')))
			{
				BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight) - 2.0;
			}
			else
			{
				BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight);
			}
			bRising = true;
			PlayRising();
		}
	}
}
defaultproperties
{
     mpGroundSpeed=230.000000
     mpWaterSpeed=110.000000
     humanAnimRate=1.000000
     mantleTimer=-1.000000
     bIsHuman=True
     WaterSpeed=300.000000
     AirSpeed=4000.000000
     AccelRate=900.000000
     JumpZ=320.000000
     BaseEyeHeight=40.000000
     UnderWaterTime=18.000000
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     Mass=150.000000
     Buoyancy=150.500000
     RotationRate=(Pitch=4096,Yaw=90000,Roll=3072)
}
