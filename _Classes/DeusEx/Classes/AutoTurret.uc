//=============================================================================
// AutoTurret.
//=============================================================================
class AutoTurret extends HackableDevices;

var AutoTurretGun gun;

var() localized String titleString;		// So we can name specific turrets in multiplayer
var() bool bTrackPawnsOnly;
var() bool bTrackPlayersOnly;
var() bool bActive;
var() int maxRange;
var() float fireRate;
var() float gunAccuracy;
var() int gunDamage;
var() int ammoAmount;
var Actor curTarget;
var Actor prevTarget;         // target we had last tick.
var Pawn safeTarget;          // in multiplayer, this actor is strictly off-limits
							   // Usually for the player who activated the turret.
var float fireTimer;
var bool bConfused;				// used when hit by EMP
var float confusionTimer;		// how long until turret resumes normal operation
var float confusionDuration;	// how long does an EMP hit last?
var Actor LastTarget;			// what was our last target?
var float pitchLimit;			// what's the maximum pitch?
var Rotator origRot;			// original rotation
var bool bPreAlarmActiveState;	// was I previously awake or not?
var bool bDisabled;				// have I been hacked or shut down by computers?
var float TargetRefreshTime;      // used for multiplayer to reduce rate of checking for targets.

var int team;						// Keep track of team the turrets on

var int mpTurretDamage;			// Settings for multiplayer
var int mpTurretRange;

var bool bComputerReset;			// Keep track of if computer has been reset so we avoid all actors checks

var bool bSwitching;
var float SwitchTime, beepTime;
var Pawn savedTarget;

//Sarge: Hacking disable time
var float disableTime;                    //Sarge: timer before we are enabled again after hacking.
var float disableTimeBase;                //Sarge: Our hacking skill is multiplied by this to give total disable time
var float disableTimeMult;                //Sarge: Our hacking skill is multiplied by this to give total disable time
var bool bRebooting;                      //This will be set when the turret is hacked, to control rebooting

//SARGE: Store the default state of the turret
var travel bool bSetupDefaults;
var travel bool bDefaultDisabled;
var travel bool bDefaultActive;
var travel bool bDefaultTrackPlayersOnly;
var travel bool bDefaultTrackPawnsOnly;

var bool bWasDisabledOnce;  //Ygll: var to set at true one, to not have the 'hum' sound anymore in case of bypassed turret

// networking replication
replication
{
	//server to client
	reliable if (Role == ROLE_Authority)
	  safeTarget, bDisabled, bActive, team, titleString;
}

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
	if (!bActive)
	{
		bActive = true;
		if(!bWasDisabledOnce)
			AmbientSound = Default.AmbientSound;
		else
			AmbientSound = None;
	}

    bDisabled = false;
	bHackable = true;
	bDisabledByComputer = false;
	Super.Trigger(Other, Instigator);
}

// if we are untriggered, turn us off
function UnTrigger(Actor Other, Pawn Instigator)
{
	if (bActive)
	{
		bActive = false;
		AmbientSound = None;
	}
	
	if(!bWasDisabledOnce)
		bWasDisabledOnce = true;
    
    bDisabled = true;	
	bHackable = false;
	bDisabledByComputer = true;
	Super.UnTrigger(Other, Instigator);
}

function Destroyed()
{
	if (gun != None)
	{
		gun.Destroy();
		gun = None;
	}

	Super.Destroyed();
}

function UpdateSwitch()
{
	if ( Level.Timeseconds > SwitchTime )
	{
		bSwitching = false;
		//safeTarget = savedTarget;
		SwitchTime = 0;
		beepTime = 0;
	}
	else
	{
		if ( Level.Timeseconds > beepTime )
		{
			PlaySound(Sound'TurretSwitch', SLOT_Interact, 1.0,, maxRange );
			beepTime = Level.Timeseconds + 0.75;
		}
	}
}

function SetSafeTarget( Pawn newSafeTarget )
{
	local DeusExPlayer aplayer;

	bSwitching = true;
	SwitchTime = Level.Timeseconds + 2.5;
	beepTime = 0.0;
	safeTarget = newSafeTarget;
	//savedTarget = newSafeTarget;
}

function Actor AcquireMultiplayerTarget()
{
	local Pawn apawn;
	local DeusExPlayer aplayer;
	local Vector dist;
	local Actor noActor;

	if ( bSwitching )
	{
		noActor = None;
		return noActor;
	}

	//DEUS_EX AMSD See if our old target is still valid.
	if ((prevtarget != None) && (prevtarget != safetarget) && (Pawn(prevtarget) != None))
	{
	  if (Pawn(prevtarget).AICanSee(self, 1.0, false, false, false, true) > 0)
	  {
		 if ((DeusExPlayer(prevtarget) == None) && !DeusExPlayer(prevtarget).bHidden )
		 {
				dist = DeusExPlayer(prevtarget).Location - gun.Location;
				if (VSize(dist) < maxRange )
				{
					curtarget = prevtarget;
					return curtarget;
				}
		 }
		 else
		 {
			if ((DeusExPlayer(prevtarget).AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') == -1.0) && !DeusExPlayer(prevtarget).bHidden )
			{
					dist = DeusExPlayer(prevtarget).Location - gun.Location;
					if (VSize(dist) < maxRange )
					{
						curtarget = prevtarget;
						return curtarget;
					}
			}
		 }
	  }
	}
	// MB Optimized to use pawn list, previous way used foreach VisibleActors
	apawn = gun.Level.PawnList;
	while ( apawn != None )
	{
	  if (apawn.bDetectable && !apawn.bIgnore && apawn.IsA('DeusExPlayer'))
	  {
			aplayer = DeusExPlayer(apawn);

			dist = aplayer.Location - gun.Location;

			if ( VSize(dist) < maxRange )
			{
				// Only players we can see
				if ( aplayer.FastTrace( aplayer.Location, gun.Location ))
				{
					//only shoot at players who aren't the safetarget.
					//we alreayd know prevtarget not valid.
					if ((aplayer != safeTarget) && (aplayer != prevTarget))
					{
						if (! ( (TeamDMGame(aplayer.DXGame) != None) &&	(safeTarget != None) &&	(TeamDMGame(aplayer.DXGame).ArePlayersAllied( DeusExPlayer(safeTarget),aplayer)) ) )
						{
							// If the player's RadarTrans aug is off, the turret can see him
							if ((aplayer.AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') == -1.0) && !aplayer.bHidden )
							{
								curTarget = apawn;
								PlaySound(Sound'TurretLocked', SLOT_Interact, 1.0,, maxRange );
								break;
							}
						}
					}
				}
			}
	  }
		apawn = apawn.nextPawn;
	}
	return curtarget;
}

//SARGE: Telling this turret that it should start rebooting right now
function StartReboot(DeusExPlayer player)
{
    if (player.bHardCoreMode || player.bHackLockouts)
    {
        bRebooting = true;
        disableTime = player.saveTime + disableTimeBase + (disableTimeMult * MAX(0,player.SkillSystem.GetSkillLevel(class'SkillComputer') - 1));
    }
}

function Tick(float deltaTime)
{
	local Pawn pawn;
	local ScriptedPawn sp;
	local DeusExDecoration deco;
	local float near,near2;
	local Rotator destRot;
	local bool bSwitched;
	local Vector X,Y,Z;
    local float remainingTime;

	Super.Tick(deltaTime);

	bSwitched = false;

	if ( bSwitching )
	{
		UpdateSwitch();
		return;
	}
    
    remainingTime = disableTime - DeusExPlayer(GetPlayerPawn()).saveTime;
        
    if (gun.hackStrength == 0.0)
        bRebooting = false;
    
    if (bRebooting && !bConfused)
    {
        if (remainingTime <= 0)
        {
            bRebooting = false;
            bDisabled = bDefaultDisabled;
            bActive = bDefaultActive;

            //Reset Tracking
            bTrackPlayersOnly = bDefaultTrackPlayersOnly;
            bTrackPawnsOnly = bDefaultTrackPawnsOnly;
        }
    }

	GetAxes(gun.Rotation, X, Y, Z);

	// Make sure everything is valid and account for when players leave or switch teams
	if ( !bDisabled && (Level.NetMode != NM_Standalone) )
	{
		if ( safeTarget == None )
		{
			bDisabled = true;
			bComputerReset = false;
		}
		else
		{
			if ( DeusExPlayer(safeTarget) != None )
			{
				if ((TeamDMGame(DeusExPlayer(safeTarget).DXGame) != None) && (DeusExPlayer(safeTarget).PlayerReplicationInfo.team != team))
					bSwitched = true;
				else if ((DeathMatchGame(DeusExPlayer(safeTarget).DXGame) != None ) && (DeusExPlayer(safeTarget).PlayerReplicationInfo.PlayerID != team))
					bSwitched = true;

				if ( bSwitched )
				{
					bDisabled = true;
					safeTarget = None;
					bComputerReset = false;
				}
			}
		}
	}
	if ( bDisabled && (Level.NetMode != NM_Standalone) )
	{
		team = -1;
		safeTarget = None;
		if ( !bComputerReset )
		{
			gun.ResetComputerAlignment();
			bComputerReset = true;
		}
	}

	if (bConfused)
	{
		confusionTimer += deltaTime;
        
        //SARGE: Confusing pauses hacking reboot time
        if (bRebooting)
            disableTime += deltaTime;

		// pick a random facing
		if (confusionTimer % 0.25 > 0.2)
		{
			gun.DesiredRotation.Pitch = origRot.Pitch + (pitchLimit / 2 - Rand(pitchLimit));
			gun.DesiredRotation.Yaw = Rand(65535);
		}
		if (confusionTimer > confusionDuration)
		{
			bConfused = false;
			confusionTimer = 0;
			confusionDuration = Default.confusionDuration;
		}
	}

	if (bActive && !bDisabled)
	{
		curTarget = None;

		if ( !bConfused )
		{
			// if we've been EMP'ed, act confused
			if ((Level.NetMode != NM_Standalone) && (Role == ROLE_Authority))
			{
				// DEUS_EX AMSD If in multiplayer, get the multiplayer target.

				if (TargetRefreshTime < 0)
					TargetRefreshTime = 0;

				TargetRefreshTime = TargetRefreshTime + deltaTime;

				if (TargetRefreshTime >= 0.3)
				{
					TargetRefreshTime = 0;
					curTarget = AcquireMultiplayerTarget();
					if (( curTarget != prevTarget ) && ( curTarget == None ))
							PlaySound(Sound'TurretUnlocked', SLOT_Interact, 1.0,, maxRange );
					prevtarget = curtarget;
				}
				else
				{
					curTarget = prevtarget;
				}
			}
			else
			{
				//
				// Logic table for turrets
				//
				// bTrackPlayersOnly		bTrackPawnsOnly		Should Attack
				// 			T						X				Allies
				//			F						T				Enemies
				//			F						F				Everything
				//

				// Attack allies and neutrals
				if (bTrackPlayersOnly || (!bTrackPlayersOnly && !bTrackPawnsOnly))
				{
					foreach gun.VisibleActors(class'Pawn', pawn, maxRange, gun.Location+X*32)
					{
						if (pawn.bDetectable && !pawn.bIgnore)
						{
							if (pawn.IsA('DeusExPlayer'))
							{
								// If the player's RadarTrans aug is off, the turret can see him
								if (DeusExPlayer(pawn).AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') == -1.0)
								{
									curTarget = pawn;
									break;
								}
							}
							else if (pawn.IsA('ScriptedPawn') && (ScriptedPawn(pawn).GetPawnAllianceType(GetPlayerPawn()) != ALLIANCE_Hostile))
							{
							    if (bPreAlarmActiveState) //CyberP: fix the turrets causing stupidity
							    {
								    curTarget = pawn;
								    break;
								}
							}
						}
					}
				}

				if (!bTrackPlayersOnly)
				{
					// Attack everything
					/*if (!bTrackPawnsOnly)                                     //RSD: You know what actually though, why the hell do they even target decos
					{
						foreach gun.VisibleActors(class'DeusExDecoration', deco, maxRange, gun.Location)
						{
							if (!deco.IsA('ElectronicDevices') && !deco.IsA('AutoTurret') &&
								!deco.bInvincible && deco.bDetectable && !deco.bIgnore && !deco.IsA('Containers')) //RSD: hack to stop them shooting no longer invincible containers
							{
								curTarget = deco;
								break;
							}
						}
					}*/

					// Attack enemies
					foreach gun.VisibleActors(class'ScriptedPawn', sp, maxRange, gun.Location)
					{
						if (sp.bDetectable && !sp.bIgnore && (sp.GetPawnAllianceType(GetPlayerPawn()) == ALLIANCE_Hostile))
						{
							curTarget = sp;
							break;
						}
					}
				}
			}

			// if we have a target, rotate to face it
			if (curTarget != None)
			{

				destRot = Rotator((curTarget.Location+0.25*curTarget.CollisionHeight*vect(0,0,1)) - gun.Location); //RSD: Moved target up 25%
				gun.DesiredRotation = destRot;
				near = pitchLimit / 2;
				gun.DesiredRotation.Pitch = FClamp(gun.DesiredRotation.Pitch, origRot.Pitch - near, origRot.Pitch + near);
			}
			else
				gun.DesiredRotation = origRot;
		}
	}
	else
	{
		if ( !bConfused )
			gun.DesiredRotation = origRot;
	}


//GMDX:dasraiser : omg really 20-350 degrees not less than 4096 :clockwise move fixed
	near = (Abs(gun.Rotation.Yaw - gun.DesiredRotation.Yaw)) % 65536;
	near = FMin(65536-near,near);

	near2 = (Abs(gun.Rotation.Pitch - gun.DesiredRotation.Pitch)) % 65536;
	near2 = FMin(65536-near2,near2);

	near+=near2;

	near2=(Abs(gun.Rotation.Pitch - destRot.Pitch)) % 65536;
	near2=FMin(65536-near2,near2);

	if (bActive && !bDisabled)
	{
		// play an alert sound and light up
		//if ((curTarget != None) && (curTarget != LastTarget))
		//	PlaySound(Sound'TurretSwitch', SLOT_Interact, 1.0,, 2048); //CyberP: added new sound

		// if we're aiming close enough to our target
		if (curTarget != None)
		{
			gun.MultiSkins[1] = Texture'RedLightTex';

			if ((near < 4096) && (near2< 8192))
			{
				if (fireTimer > fireRate)
				{
                    if (!checkForObstruction())                                 //RSD: First see if there are objects in the way
                    {
                        Fire();
					    fireTimer = 0;
					}
				}
			}
		}
		else
		{
			if (gun.IsAnimating())
				gun.PlayAnim('Still', 10.0, 0.001);

			if (bConfused)
				gun.MultiSkins[1] = Texture'YellowLightTex';
			else
				gun.MultiSkins[1] = Texture'GreenLightTex';
		}

		fireTimer += deltaTime;
		LastTarget = curTarget;
	}
	else
	{
		if (gun.IsAnimating())
			gun.PlayAnim('Still', 10.0, 0.001);
		gun.MultiSkins[1] = None;
	}

	// make noise if we're still moving
	if (near > 64)
	{
		gun.AmbientSound = Sound'AutoTurretMove';
		if (bConfused)
			gun.SoundPitch = 128;
		else
			gun.SoundPitch = 64;
	}
	else
		gun.AmbientSound = None;
}

auto state Active
{
	function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
		local float mindmg;
		local int i;
		local GMDXImpactSpark s;
		local GMDXImpactSpark2 t;

        if (DamageType == 'Sabot' || DamageType == 'Shot')
        PlaySound(sound'ArmorRicochet',SLOT_Interact,,true,1280);

        if (DamageType == 'Sabot' || Damage >= minDamageThreshold)
        {
        for (i=0;i<10;i++)
        {
        s = spawn(class'GMDXImpactSpark');
        t = spawn(class'GMDXImpactSpark2');
        if (s != none && t != none)
        {
        s.LifeSpan+=0.07;
        t.LifeSpan+=0.07;
        }
        }
        }

		if (DamageType == 'EMP')
		{
			// duration is based on daamge
			// 10 seconds min to 30 seconds max
			mindmg = Max(Damage - 15.0, 0.0);
			confusionDuration += mindmg / 5.0;
		 confusionDuration = FClamp(confusionDuration,10.0,30.0);
			confusionTimer = 0;
			if (!bConfused)
			{
				bConfused = true;
				PlaySound(sound'EMPZap', SLOT_None,,, 1280);
			}
			return;
		}
		if (( Level.NetMode != NM_Standalone ) && (EventInstigator.IsA('DeusExPlayer')))
			DeusExPlayer(EventInstigator).ServerConditionalNotifyMsg( DeusExPlayer(EventInstigator).MPMSG_TurretInv );

		Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	}
}

function Fire()
{
	local Vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
	local Rotator rot;
	local Actor hit;
	local ShellCasing shell;
	local Spark spark;
	local Pawn attacker;
local int i;
local GMDXImpactSpark s;
local GMDXImpactSpark2 t;
local SmokeTrail puff;
local GMDXSparkFade fade;

	if (!gun.IsAnimating())
		gun.LoopAnim('Fire');

	// CNN - give turrets infinite ammo                                         //RSD: OR NAH
	if (ammoAmount > 0)
	{
		ammoAmount--;
		GetAxes(gun.Rotation, X, Y, Z);
		StartTrace = gun.Location+X*32;
		EndTrace = StartTrace + gunAccuracy * (FRand()-0.5)*Y*1000 + gunAccuracy * (FRand()-0.5)*Z*1000 ;
		EndTrace += 10000 * X;
		hit = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

		// spawn some effects
	  if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
	  {
		 shell = None;
	  }
	  else
	  {
		 shell = Spawn(class'ShellCasingSilent',,, gun.Location);
	  }
		if (shell != None)
			shell.Velocity = Vector(gun.Rotation - rot(0,16384,0)) * 100 + VRand() * 30;

		MakeNoise(1.0);
		PlaySound(sound'PistolFire', SLOT_Interface,2.0,,2048);
		AISendEvent('LoudNoise', EAITYPE_Audio);

		// muzzle flash
		gun.LightType = LT_Steady;
		if (IsHDTP())
			gun.MultiSkins[3] = GetHDTPMuzzleTex();
		else
			gun.MultiSkins[2] = GetHDTPMuzzleTex();
		SetTimer(0.1, false);

		// randomly draw a tracer
		if (FRand() < 0.5)
		{
			if (VSize(HitLocation - StartTrace) > 250)
			{
				rot = Rotator(EndTrace - StartTrace);
				Spawn(class'Tracer',,, StartTrace + 96 * Vector(rot), rot);
			}
		}

		if (hit != None)
		{
		 if (hit.IsA('DeusExPlayer') || hit.IsA('ScriptedPawn'))
		 {
			spark = None;
			puff = None;
			fade = None;
		 }
		 else
		 {
			// spawn a little spark and make a ricochet sound if we hit something
			spark = spawn(class'Spark',,,HitLocation+HitNormal, Rotator(HitNormal));
			spawn(class'GMDXFireSmokeFade',,,HitLocation+HitNormal, Rotator(HitNormal));
            spawn(class'GMDXSparkFade',,,HitLocation+HitNormal, Rotator(HitNormal));
            puff = spawn(class'SmokeTrail',,,HitLocation+HitNormal);
			if ( puff != None )
			{
				puff.DrawScale = 0.22; //1
				puff.OrigScale = puff.DrawScale;
				puff.LifeSpan = 0.9;
				puff.OrigLifeSpan = puff.LifeSpan;
			    puff.RemoteRole = ROLE_None;
			}
		fade = spawn(class'GMDXSparkFade',,,HitLocation+HitNormal);
		 if (fade != None)
		 {
		 fade.DrawScale = 0.12;
		 }
       for (i=0;i<11;i++)
        {
        s = spawn(class'GMDXImpactSpark',,,HitLocation+HitNormal);
        t = spawn(class'GMDXImpactSpark2',,,HitLocation+HitNormal);
          if (s != none && t != none)
        {
        s.LifeSpan=FRand()*0.042;
        t.LifeSpan=FRand()*0.042;
        s.DrawScale = FRand() * 0.04;
        t.DrawScale = FRand() * 0.04;
        }
        }
		 }

			if (spark != None)
			{
				spark.DrawScale = 0.05;
				PlayHitSound(spark, hit);
			}

			attacker = None;
			if ((curTarget == hit) && !curTarget.IsA('PlayerPawn'))
				attacker = GetPlayerPawn();
		 if (Level.NetMode != NM_Standalone)
			attacker = safetarget;
			if ( hit.IsA('DeusExPlayer') && ( Level.NetMode != NM_Standalone ))
				DeusExPlayer(hit).myTurretKiller = Self;
			hit.TakeDamage(gunDamage, attacker, HitLocation, 1000.0*X, 'AutoShot');

			if (hit.IsA('Pawn') && !hit.IsA('Robot'))
				SpawnBlood(HitLocation, HitNormal);
			else if ((hit == Level) || hit.IsA('Mover'))
				SpawnEffects(HitLocation, HitNormal, hit);
		}
	}                                                                           //RSD: Limited ammo is back, baby
	else
	{
		PlaySound(sound'DryFire', SLOT_None);
	}
}

simulated function texture GetHDTPMuzzleTex()
{
	local int i;
	local texture tex;

    if (!IsHDTP())                                                  //RSD: If using the vanilla model, use vanilla muzzle flash
    {
        if (FRand() < 0.5)
            tex = Texture'FlatFXTex34';
        else
            tex = Texture'FlatFXTex37';
    }
    else
    {
        i = rand(8);
        switch(i)
        {
            case 0: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge1"); break;
            case 1: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge2"); break;
            case 2: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge3"); break;
            case 3: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge4"); break;
            case 4: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge5"); break;
            case 5: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge6"); break;
            case 6: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge7"); break;
            case 7: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge8"); break;
        }
    }
	return tex;
}


function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
	local rotator rot;

	rot = Rotator(Location - HitLocation);
	rot.Pitch = 0;
	rot.Roll = 0;

	if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
	  return;

	spawn(class'BloodSpurt',,,HitLocation+HitNormal, rot);
	spawn(class'BloodDrop',,,HitLocation+HitNormal);
	spawn(class'BloodDrop',,,HitLocation+HitNormal);
	spawn(class'BloodDrop',,,HitLocation+HitNormal);
	spawn(class'BloodDrop',,,HitLocation+HitNormal);
	if (FRand() < 0.5)
		spawn(class'BloodDrop',,,HitLocation+HitNormal);
}

simulated function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other)
{
	local SmokeTrail puff;
	local int i;
	local Rotator rot;

	if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
	  return;

    if (Other == None)                                                          //RSD: Failsafe
      return;

	if (FRand() < 0.5)
	{
		puff = spawn(class'SmokeTrail',,,HitLocation+HitNormal, Rotator(HitNormal));
		if (puff != None)
		{
			puff.DrawScale *= 0.3;
			puff.OrigScale = puff.DrawScale;
			puff.LifeSpan = 0.25;
			puff.OrigLifeSpan = puff.LifeSpan;
		}
	}

	if (!Other.IsA('BreakableGlass'))
		for (i=0; i<2; i++)
			if (FRand() < 0.8)
				spawn(class'Rockchip',,,HitLocation+HitNormal);


	// should we crack glass?
	if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
        spawn(class'BulletHoleGlass', Other,, HitLocation, Rotator(HitNormal));
	else
		spawn(class'BulletHole', Other,, HitLocation, Rotator(HitNormal));
}

function name GetWallMaterial(vector HitLocation, vector HitNormal)
{
	local vector EndTrace, StartTrace;
	local actor newtarget;
	local int texFlags;
	local name texName, texGroup;

	StartTrace = HitLocation + HitNormal*16;		// make sure we start far enough out
	EndTrace = HitLocation - HitNormal;

	foreach TraceTexture(class'Actor', newtarget, texName, texGroup, texFlags, StartTrace, HitNormal, EndTrace)
		if ((newtarget == Level) || newtarget.IsA('Mover'))
			break;

	return texGroup;
}

function PlayHitSound(actor destActor, Actor hitActor)
{
	local float rnd;
	local sound snd;

	rnd = FRand();

	if (rnd < 0.25)
		snd = sound'Ricochet1';
	else if (rnd < 0.5)
		snd = sound'Ricochet2';
	else if (rnd < 0.75)
		snd = sound'Ricochet3';
	else
		snd = sound'Ricochet4';

	// play a different ricochet sound if the object isn't damaged by normal bullets
	if (hitActor != None)
	{
		if (hitActor.IsA('DeusExDecoration') && DeusExDecoration(hitActor).bInvincible)
			snd = sound'ArmorRicochet';
		else if (hitActor.IsA('Robot'))
			snd = sound'ArmorRicochet';
	}

	if (destActor != None)
		destActor.PlaySound(snd, SLOT_None,,, 1024, 1.1 - 0.2*FRand());
}

// turn off the muzzle flash
simulated function Timer()
{
	gun.LightType = LT_None;
	gun.MultiSkins[3] = None;
	gun.MultiSkins[2] = None;
}

function AlarmHeard(Name event, EAIEventState state, XAIParams params)
{
local DeusExPlayer player;

	if (state == EAISTATE_Begin)
	{
		if (!bActive)
		{
			bPreAlarmActiveState = bActive;
			bActive = true;
			//PlaySound(Sound'TurretSwitch', SLOT_None, 1.0,, 2048); //CyberP: added new sound
		}
	}
	else if (state == EAISTATE_End)
	{
	    /*player = DeusExPlayer(GetPlayerPawn());
	    if (player.bPermTurrets) //CyberP: alarms permanent once triggered if option is enabled.
	    {
	        bActive = true;
	    }
		else if (bActive)
			bActive = bPreAlarmActiveState;
		*/
        if (bActive)
			bActive = bPreAlarmActiveState;
	}
}

function PreBeginPlay()
{
	local Vector v1, v2;
	local class<AutoTurretGun> gunClass;
	local Rotator rot;

	Super.PreBeginPlay();

	if (IsA('AutoTurretSmall'))
		gunClass = class'AutoTurretGunSmall';
	else
		gunClass = class'AutoTurretGun';

	rot = Rotation;
	rot.Pitch = 0;
	rot.Roll = 0;
	origRot = rot;
	gun = Spawn(gunClass, Self,, Location, rot);
	if (gun != None)
	{
		v1.X = 0;
		v1.Y = 0;
		v1.Z = CollisionHeight + gun.Default.CollisionHeight;
		v2 = v1 >> Rotation;
		v2 += Location;
		gun.SetLocation(v2);
		gun.SetBase(Self);
	}

	// set up the alarm listeners
	AISetEventCallback('Alarm', 'AlarmHeard');

	if ( Level.NetMode != NM_Standalone )
	{
		maxRange = mpTurretRange;
		gunDamage = mpTurretDamage;
		bInvincible = true;
	  bDisabled = !bActive;
	}
}

function PostBeginPlay()
{
	safeTarget = None;
	prevTarget = None;
	TargetRefreshTime = 0;

    // Remember the default state so we can reset to it
    if (!bSetupDefaults)
    {
        bDefaultDisabled = bDisabled;
        bDefaultActive = bActive;
        bDefaultTrackPlayersOnly = bTrackPlayersOnly;
        bDefaultTrackPawnsOnly = bTrackPawnsOnly;
        bSetupDefaults = true;
        //log("bDisabled: " $ bDisabled $ ", bTrackPlayersOnly: " $ bTrackPlayersOnly);
    }

	Super.PostBeginPlay();
}

function bool checkForObstruction()                                             //RSD: function to determine whether there's a sturdy object in the way or if the target is too low/high to hit
{
	local Vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
	local Rotator destRot;
	local Actor hit;
    local float collisionMult;

    GetAxes(gun.Rotation, X, Y, Z);
	StartTrace = gun.Location+X*32;
	EndTrace = StartTrace + 10000*X;
	hit = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

    if (gun.DesiredRotation.Pitch > 0)                                          //RSD: If aiming up, current rotation (+25% of collision height)  to check is good
    	collisionMult = 0.;
   	else                                                                        //RSD: If aiming down, move the rotation to check down
   	    collisionMult = 0.75;

    destRot = Rotator((curTarget.Location+collisionMult*curTarget.CollisionHeight*vect(0,0,1)) - gun.Location);

	if (abs(destRot.Pitch) > abs(gun.DesiredRotation.Pitch))                    //RSD: Are we too low/high to hit?
    	return true;
    else if (hit != none && hit.IsA('DeusExDecoration') && (DeusExDecoration(hit).minDamageThreshold > gunDamage || DeusExDecoration(hit).bInvincible)) //RSD: Can the object not be destroyed?
    	return true;
   	else
   		return false;
}

defaultproperties
{
     titleString="AutoTurret"
     bHitMarkers=true
     bEMPHitMarkers=true
     bTrackPlayersOnly=true
     bActive=true
     maxRange=4000
     fireRate=0.240000
     gunAccuracy=0.500000
     gunDamage=4
     AmmoAmount=100
     confusionDuration=10.000000
     pitchLimit=11000.000000
     Team=-1
     mpTurretDamage=20
     mpTurretRange=1024
     HitPoints=60
     minDamageThreshold=60
     bHighlight=false
     ItemName="Turret Base"
     bPushable=false
     Physics=PHYS_None
     HDTPMesh="HDTPDecos.HDTPAutoTurretBase"
     Mesh=LodMesh'DeusExDeco.AutoTurretBase'
     SoundRadius=64
     SoundVolume=224
     AmbientSound=Sound'DeusExSounds.Generic.AutoTurretHum'
     CollisionRadius=14.000000
     CollisionHeight=20.200001
     Mass=50.000000
     Buoyancy=10.000000
     bVisionImportant=true
     disableTimeBase=120.0
     disableTimeMult=60.0
     bWasDisabledOnce=false
}
