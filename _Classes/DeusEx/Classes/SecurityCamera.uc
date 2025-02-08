//=============================================================================
// SecurityCamera.
//=============================================================================
class SecurityCamera extends HackableDevices;

var() bool bSwing;
var() int swingAngle;
var() float swingPeriod;
var() int cameraFOV;
var() int cameraRange;
var float memoryTime;
var() bool bActive;
var() bool bNoAlarm;			// if True, does NOT sound alarm
var Rotator origRot;
var Rotator ReplicatedRotation; // for net propagation
var bool bTrackPlayer;
var bool bPlayerSeen;
var bool bEventTriggered;
var bool bFoundCurPlayer;  		// in multiplayer, if we found a player this tick.
var float lastSeenTimer;
var float playerCheckTimer;
var float swingTimer;
var bool bConfused;				// used when hit by EMP
var float confusionTimer;		// how long until camera resumes normal operation
var float confusionDuration;	// how long does EMP hit last?
var float triggerDelay;			// how long after seeing the player does it trigger?
var float triggerTimer;			// timer used for above
var vector playerLocation;		// last seen position of player

// DEUS_EX AMSD Used for multiplayer target acquisition.
var Actor curTarget;          // current view target
var Actor prevTarget;         // target we had last tick.
var Pawn safeTarget;          // in multiplayer, this actor is strictly off-limits
										 // Usually for the player who activated the turret.

var localized string msgActivated;
var localized string msgDeactivated;

var int team;						// Keep track of team the camera is  on

// Some more variables for carcass detection -- eshkrm
var bool bCarcassSeen;
var bool bTrackCarcass;
var float carcassTriggerTimer;
var float carcassCheckTimer;
var bool bTrigSound; //CyberP
var() bool bAlarmEvent;  //CyberP: optionally send event if triggered.
var bool bDiffProperties; //CyberP:
var bool bSkillApplied; //CyberP:

//Sarge: Hacking disable time
var float disableTime;                    //Sarge: timer before we are enabled again after hacking.
var float disableTimeBase;                //Sarge: Our hacking skill is multiplied by this to give total disable time
var float disableTimeMult;                //Sarge: Our hacking skill is multiplied by this to give total disable time
var bool bRebooting;                      //This will be set when the camera is hacked, to control rebooting

// ------------------------------------------------------------------------------------
// Network replication
// ------------------------------------------------------------------------------------

replication
{
	 //server to client var
	 reliable if (Role == ROLE_Authority)
		  bActive, ReplicatedRotation, team, safeTarget;
}

function BeginPlay()
{
	Super.BeginPlay();

	origRot = Rotation;
	DesiredRotation = origRot;

	playerLocation = Location;

	if (bSwing == False)
	{
	bSwing = True;  //CyberP: hack so non-swinging cameras reset to default rot after tagging player/corpse.
	swingAngle = 2;
    }
	SoundRadius=96;
	default.SoundRadius=96;
	if (Level.NetMode != NM_Standalone)
	{
		bInvincible=True;
		HackStrength = 0.6;
	}
}

function HackAction(Actor Hacker, bool bHacked)
{
	 local ComputerSecurity CompOwner;
	 local ComputerSecurity TempComp;
	 local AutoTurret turret;
	local name Turrettag;
	 local int ViewIndex;

	if (bConfused)
		return;

	Super.HackAction(Hacker, bHacked);

	if (bHacked)
	{
		if (Level.NetMode == NM_Standalone)
		{
			if (bActive || HackStrength == 0)
				UnTrigger(Hacker, Pawn(Hacker));
			else
				Trigger(Hacker, Pawn(Hacker));
		}
		else
		{
			//DEUS_EX AMSD Reset the hackstrength afterwards
			if (hackStrength == 0.0)
				hackStrength = 0.6;
			if (bActive)
				UnTrigger(Hacker, Pawn(Hacker));
			//Find the associated computer.
			foreach AllActors(class'ComputerSecurity',TempComp)
			{
				for (ViewIndex = 0; ViewIndex < ArrayCount(TempComp.Views); ViewIndex++)
				{
					if (TempComp.Views[ViewIndex].cameraTag == self.Tag)
					{
						CompOwner = TempComp;

						//find associated turret
						Turrettag = TempComp.Views[ViewIndex].Turrettag;
						if (Turrettag != '')
						{
							foreach AllActors(class'AutoTurret', turret, TurretTag)
							{
								break;
							}
						}
					}
				}
			}

			if (CompOwner != None)
			{
				//Turn off the associated turret as well
				if ( (Hacker.IsA('DeusExPlayer')) && (Turret != None))
				{
					Turret.bDisabled = True;
					Turret.gun.HackStrength = 0.6;
				}
			}
		}
	}
}

function EnableCamera()
{
    bActive = True;
    LightType = LT_Steady;
    LightHue = 80;
    MultiSkins[2] = Texture'GreenLightTex';
    AmbientSound = None;
    bRebooting = false;
}

function DisableCamera()
{
    TriggerEvent(False);
    TriggerCarcassEvent(False); // eshkrm
    bActive = False;
    LightType = LT_None;
    AmbientSound = None;
    DesiredRotation = origRot;
    bRebooting = false;
    //hackStrength = 0.0;
}

function Trigger(Actor Other, Pawn Instigator)
{
	if (bConfused)
		return;

	Super.Trigger(Other, Instigator);

	if (!bActive)
	{
		if (Instigator != None)
			Instigator.ClientMessage(msgActivated);
	}
    EnableCamera();
}

function UnTrigger(Actor Other, Pawn Instigator)
{
	//if (bConfused) //Sarge: Attempted fix for cameras reactivating once EMP wears off if they were disabled during EMP
	//	return;

	Super.UnTrigger(Other, Instigator);

	if (bActive)
	{
		if (Instigator != None)
			Instigator.ClientMessage(msgDeactivated);
	}
    DisableCamera();
}

function TriggerEvent(bool bTrigger)
{
    local DeusExPlayer player;
    local actor A;

	bEventTriggered = bTrigger;
	bTrackPlayer = bTrigger;
	triggerTimer = 0;
    LightRadius = 1;
	// now, the camera sounds its own alarm
	if (bTrigger)
	{
	    player = DeusExPlayer(GetPlayerPawn());
	    //if (player != None && player.bHardcoreAI3)
	       AmbientSound = Sound'alarms';
	    //else
		  // AmbientSound = Sound'Klaxon2';

		if (bAlarmEvent && event != '' && player != None)
			foreach AllActors(class'Actor', A, Event)
				A.Trigger(Self, player);

		SoundVolume = 80;  //lowered volume, increased radius
		SoundRadius = 112;
                SoundPitch = 64; //CyberP: set back to default pitch
		LightHue = 0;
		MultiSkins[2] = Texture'RedLightTex';
		AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 24*(SoundRadius+2));

		// make sure we can't go into stasis while we're alarming
		bStasis = False;
	}
	else
	{
		AmbientSound = None;
		SoundRadius = 48;
		SoundVolume = 32;
		LightHue = 80;
		MultiSkins[2] = Texture'GreenLightTex';
		AIEndEvent('Alarm', EAITYPE_Audio);

		// reset our stasis info
		bStasis = Default.bStasis;
	}
}

function TriggerCarcassEvent(bool bTrigger)
{
	bEventTriggered = bTrigger; // change to carcass specific?
	bTrackCarcass = bTrigger;
	carcassTriggerTimer = 0;

	// now, the camera sounds its own alarm
	if (bTrigger)
	{
		AmbientSound = Sound'Klaxon2';
		SoundVolume = 80;
		SoundRadius = 112;
        SoundPitch = 32; //CyberP: Different pitch for carcasses
		LightHue = 144; //CyberP: Blue for carcasses
		MultiSkins[2] = Texture'HDTPAlarmLightTex7'; //Cyberp: Blue for carc
		AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 24*(SoundRadius+2));

		// make sure we can't go into stasis while we're alarming
		bStasis = False;
	}
	else
	{
		AmbientSound = None;
		SoundRadius = 48;
		SoundVolume = 32;
		LightHue = 80;
		MultiSkins[2] = Texture'GreenLightTex';
		AIEndEvent('Alarm', EAITYPE_Audio);

		// reset our stasis info
		bStasis = Default.bStasis;
	}
}

function CheckPlayerVisibility(DeusExPlayer player)
{
	local float yaw, pitch, dist;
	local Actor hit;
	local Vector HitLocation, HitNormal;
	local Rotator rot;
    local AdaptiveArmor armor;

	if (player == None)
		return;

	dist = Abs(VSize(player.Location - Location));

	// if the player is in range
	if (player.bDetectable && !player.bIgnore && (dist <= cameraRange))
	{
		hit = Trace(HitLocation, HitNormal, player.Location, Location, True);
		if (hit == player)
		{
			// If the player's RadarTrans aug is on, the camera can't see him
			// DEUS_EX AMSD In multiplayer, we've already done this test with
			// AcquireMultiplayerTarget
			if (Level.Netmode == NM_Standalone)
			{
				if (player.AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') != -1.0)
					return;

                foreach AllActors(class'AdaptiveArmor', armor) //CyberP: thermoptic camo hides us from cameras
						if ((armor.Owner == player) && armor.bActive)
                        	    return;
			}

			// figure out if we can see the player
			rot = Rotator(player.Location - Location);
			rot.Roll = 0;
			yaw = (Abs(Rotation.Yaw - rot.Yaw)) % 65536;
			pitch = (Abs(Rotation.Pitch - rot.Pitch)) % 65536;

			// center the angles around zero
			if (yaw > 32767)
				yaw -= 65536;
			if (pitch > 32767)
				pitch -= 65536;

			// if we are in the camera's FOV
			if ((Abs(yaw) < cameraFOV) && (Abs(pitch) < cameraFOV))
			{
				// rotate to face the player
				if (bTrackPlayer)
					DesiredRotation = rot;

				lastSeenTimer = 0;
				bPlayerSeen = True;
				bTrackPlayer = True;
				bFoundCurPlayer = True;
                if (minDamageThreshold >= 70 && bTrigSound == False)
		       {
               bTrigSound = True;
               PlaySound(Sound'TurretSwitch',,0.9,, 2560, 0.9);
               }
				playerLocation = player.Location - vect(0,0,1)*(player.CollisionHeight-5);

				// trigger the event if we haven't yet for this sighting
				if (!bEventTriggered && (triggerTimer >= triggerDelay) && (Level.Netmode == NM_Standalone))
					TriggerEvent(True);

				return;
			}
		}
	}
}

// Emulates the CheckPlayerVisibility() method but for carcasses -- eshkrm
function CheckCarcassVisibility(DeusExCarcass carcass)
{
	local float yaw, pitch, dist;
	local Actor hit;
	local Vector HitLocation, HitNormal;
	local Rotator rot;

	if (carcass == None)
		return;


        if (carcass.bAnimalCarcass || carcass.bNotDead)                         //RSD: No unconscious bodies either
                return;  //CyberP: No animals

        dist = Abs(VSize(carcass.Location - Location));

	if (dist <= cameraRange && carcass.Alliance != 'None' && carcass.KillerAlliance == 'Player')
	{
		hit = Trace(HitLocation, HitNormal, carcass.Location, Location, True);
		if (hit == carcass)
		{
			// figure out if we can see the carcass
			rot = Rotator(carcass.Location - Location);
			rot.Roll = 0;
			yaw = (Abs(Rotation.Yaw - rot.Yaw)) % 65536;
			pitch = (Abs(Rotation.Pitch - rot.Pitch)) % 65536;

			// center the angles around zero
			if (yaw > 32767)
				yaw -= 65536;
			if (pitch > 32767)
				pitch -= 65536;

			// if we are in the camera's FOV
			if ((Abs(yaw) < cameraFOV) && (Abs(pitch) < cameraFOV))
			{
				// rotate to face the carcass
				if (bTrackCarcass)
					DesiredRotation = rot;

				lastSeenTimer = 0;
				bCarcassSeen = True;
                if (minDamageThreshold >= 70 && bTrigSound == False)
		       {
               bTrigSound = True;
               PlaySound(Sound'TurretSwitch',,0.9,, 2560, 0.9);
               }
				// trigger the event if we haven't yet for this sighting
				if (!bEventTriggered && (carcassTriggerTimer >= triggerDelay) && (Level.Netmode == NM_Standalone))
				{
					TriggerCarcassEvent(True);
				}

				return;
			}
		}
	}
}

//SARGE: Telling this camera that it should start rebooting right now
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
	local float ang;
	local Rotator rot;
	local DeusExPlayer curplayer;
	local DeusExCarcass carcass; // eshkrm
	//local int skillz; //CyberP                                                //RSD: Removed
    local float remainingTime;
    local int remainingTimeInt;

	Super.Tick(deltaTime);

	curTarget = None;

    remainingTime = disableTime - DeusExPlayer(GetPlayerPawn()).saveTime;

    if (bRebooting && !bConfused)
    {
        bActive = False;
        remainingTimeInt = int(remainingTime);
        MultiSkins[2] = Texture'BlackMaskTex';

        if (remainingTimeInt <= 6)
        {
            if (remainingTimeInt % 2 == 0)
            {
                MultiSkins[2] = Texture'YellowLightTex';
				//PlaySound(Sound'Beep6',,0.9,, 2560, 0.9);
            }
        }

        if (remainingTime <= 0)
        {
            if (hackStrength != 0.0 && !bActive)
                EnableCamera();
        }
    }

	// if this camera is not active, get out
	if (!bActive && !bConfused)
	{
		// DEUS_EX AMSD For multiplayer
		ReplicatedRotation = DesiredRotation;

        if (!bRebooting) //We will handle our own textures
    		MultiSkins[2] = Texture'BlackMaskTex';
		return;
	}

    // if we've been EMP'ed, act confused
	if (bConfused)
	{
		confusionTimer += deltaTime;
        
        //SARGE: Confusing pauses hacking reboot time
        if (bRebooting)
            disableTime += deltaTime;

		// pick a random facing at random
		if (confusionTimer % 0.25 > 0.2)
		{
			DesiredRotation.Pitch = origRot.Pitch + 0.5*swingAngle - Rand(swingAngle);
			DesiredRotation.Yaw = origRot.Yaw + 0.5*swingAngle - Rand(swingAngle);
		}

		if (confusionTimer > confusionDuration)
		{
			bConfused = False;
			confusionTimer = 0;
			confusionDuration = Default.confusionDuration;
			LightHue = 80;
            if (!bRebooting)
                MultiSkins[2] = Texture'GreenLightTex';
            else
                MultiSkins[2] = Texture'BlackMaskTex';
			SoundPitch = 64;
			DesiredRotation = origRot;
		}

		return;
	}
    if (!bPlayerSeen && !bCarcassSeen && minDamageThreshold >= 70)
    {
        if (bTrigSound)
           PlaySound(Sound'TurretSwitch',,0.9,, 2560, 0.5);
        bTrigSound=False;
        MultiSkins[2] = Texture'GreenLightTex';
        LightRadius = 0;
    }
	// Check visibility every 0.1 seconds
	if (!bNoAlarm)
	{
		playerCheckTimer += deltaTime;
		carcassCheckTimer += deltaTime; // eshkrm

		if (playerCheckTimer > 0.1 && !bCarcassSeen)
		{
			playerCheckTimer = 0;
			if (Level.NetMode == NM_Standalone)
				CheckPlayerVisibility(DeusExPlayer(GetPlayerPawn()));
			else
			{
				curPlayer = DeusExPlayer(AcquireMultiplayerTarget());
				if (curPlayer != None)
					CheckPlayerVisibility(curPlayer);
			}
			if (!bSkillApplied)
	        {
            curplayer=DeusExPlayer(GetPlayerPawn());
             if (curplayer != None)
             {
               //skillz = curplayer.SkillSystem.GetSkillLevel(class'SkillStealth'); //RSD: Removed
               if (curplayer.SkillSystem != none && curplayer.PerkManager.GetPerkWithClass(class'DeusEx.PerkSecurityLoophole').bPerkObtained == true)//skillz >= 2) //RSD: Uses Security Loophole perk now instead of Advanced Stealth
               {
			      //SARGE: TODO: Actually make this use the perk value!
                  triggerDelay = 4.125000;                                      //RSD: Was 4.200000, misreported as +45% increase but actually was +52.73%. Now 50%!
                  bSkillApplied = True;
               }
             }
            }
		}

		// Scan over carcasses in CameraRange -- eshkrm
		if(carcassCheckTimer > 0.1 && !bPlayerSeen)
		{
			carcassCheckTimer = 0;
            curplayer=DeusExPlayer(GetPlayerPawn());
			// Not a feature in multiplayer
			if (Level.NetMode == NM_Standalone && curplayer != None && (curplayer.bHardCoreMode || curplayer.bCameraSensors)) //cyberP: carcass scan only in hardcore
			{
				foreach RadiusActors(Class'DeusExCarcass', carcass, CameraRange)
				{
					CheckCarcassVisibility(carcass);
				}
			}
		}
	}

	// forget about the player/carcass after a set amount of time
	if (bPlayerSeen || bCarcassSeen)
	{
		// if the player/carcass has been seen, but the camera hasn't triggered yet,
		// provide some feedback to the player (light and sound)
		if (!bEventTriggered)
		{
			if (bPlayerSeen)
				triggerTimer += deltaTime;
			if (bCarcassSeen)
				carcassTriggerTimer += deltaTime;
				SoundPitch = 96;

			if (triggerTimer % 0.5 > 0.4 || carcassTriggerTimer % 0.5 > 0.4)
			{
				LightHue = 0;
				MultiSkins[2] = Texture'RedLightTex';
                if (minDamageThreshold < 70)
				   PlaySound(Sound'Beep6',,0.9,, 2560, 0.9);
				if ((bPlayerSeen) && (curplayer != None) && ((curplayer.bHardCoreMode==True) || (curplayer.bHardcoreAI1==true)))  //CyberP: AI notice cameras beeping and hunt in the direction they are facing (player pos). bit of a hack.
				{
					curplayer.AISendEvent('LoudNoise', EAITYPE_Audio,,1024);
				}
				else if ((bCarcassSeen) && (curplayer != None) && (curplayer.bHardCoreMode==True))
				{
					carcass.AISendEvent('LoudNoise', EAITYPE_Audio,,1024);
				}
			}
			else
			{
				LightHue = 80;
				if (minDamageThreshold < 70)
				MultiSkins[2] = Texture'GreenLightTex';
			}
		}

		if (lastSeenTimer < memoryTime)
		{
			lastSeenTimer += deltaTime;
			bStasis = False;
		}
		else
		{
		    bPlayerSeen = False;
			bCarcassSeen = False;
			bStasis = default.bStasis;
			lastSeenTimer = 0;
			// untrigger events
			TriggerEvent(False);
			TriggerCarcassEvent(False);
		}

		return;
	}


	swingTimer += deltaTime;
	MultiSkins[2] = Texture'GreenLightTex';

	// swing back and forth if all is well
	// the above returns before we ever get to this, which is why cam stops -- eshkrm
	if (bSwing && !bTrackPlayer && !bTrackCarcass)
	{
		ang = 2 * Pi * swingTimer / swingPeriod;
		rot = origRot;
		rot.Yaw += Sin(ang) * swingAngle;
		DesiredRotation = rot;
	}

	// DEUS_EX AMSD For multiplayer
	ReplicatedRotation = DesiredRotation;
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

        if (DamageType == 'Sabot' || Damage >= 50)
        {
        for (i=0;i<11;i++)
        {
        s = spawn(class'GMDXImpactSpark');
        t = spawn(class'GMDXImpactSpark2');
        if (s != none && t != none)
        {
        s.LifeSpan+=0.04;
        t.LifeSpan+=0.04;
        }
        }
        }

		if (DamageType == 'EMP')
		{
			// duration is based on daamge
			// 10 seconds min to 30 seconds max
			mindmg = Max(Damage - 15.0, 0.0);
			confusionDuration += mindmg / 5.0;
			confusionTimer = 0;
			if (!bConfused)
			{
				bConfused = True;
				LightHue = 40;
				MultiSkins[2] = Texture'YellowLightTex';
				SoundPitch = 128;
				PlaySound(sound'EMPZap', SLOT_None,,, 1280);
			}
			return;
		}
		if (( Level.NetMode != NM_Standalone ) && (EventInstigator.IsA('DeusExPlayer')))
			DeusExPlayer(EventInstigator).ServerConditionalNotifyMsg( DeusExPlayer(EventInstigator).MPMSG_CameraInv );

		Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	}
}

// ------------------------------------------------------------------------
// AcquireMultiplayerTarget()
// DEUS_EX AMSD Copied from Turret so that cameras will track enemy players
// in multiplayer.
// ------------------------------------------------------------------------
function Actor AcquireMultiplayerTarget()
{
	local Pawn apawn;
	local DeusExPlayer aplayer;
	local Vector dist;

	//DEUS_EX AMSD See if our old target is still valid.
	if ((prevtarget != None) && (prevtarget != safetarget) && (Pawn(prevtarget) != None))
	{
		if (Pawn(prevtarget).AICanSee(self, 1.0, false, false, false, true) > 0)
		{
			if (DeusExPlayer(prevtarget) == None)
			{
				curtarget = prevtarget;
				return curtarget;
			}
			else
			{
				if (DeusExPlayer(prevtarget).AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') == -1.0)
				{
					curtarget = prevtarget;
					return curtarget;
				}
			}
		}
	}
	// MB Optimized to use pawn list, previous way used foreach VisibleActors
	apawn = Level.PawnList;
	while ( apawn != None )
	{
		if (apawn.bDetectable && !apawn.bIgnore && apawn.IsA('DeusExPlayer'))
		{
			aplayer = DeusExPlayer(apawn);

			dist = aplayer.Location - Location;

			if ( VSize(dist) < CameraRange )
			{
				// Only players we can see
				if ( aplayer.FastTrace( aplayer.Location, Location ))
				{
					//only track players who aren't the safetarget.
					//we already know prevtarget not valid.
					if ((aplayer != safeTarget) && (aplayer != prevTarget))
					{
						if (! ( (TeamDMGame(aplayer.DXGame) != None) &&	(safeTarget != None) &&	(TeamDMGame(aplayer.DXGame).ArePlayersAllied( DeusExPlayer(safeTarget),aplayer)) ) )
						{
							// If the player's RadarTrans aug is off, the turret can see him
							if (aplayer.AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') == -1.0)
							{
								curTarget = apawn;
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

function TriggerAlarmOverride()                                                 //RSD: used by AlarmUnit.uc to shut off any active camera alarms
{
        if (bActive)
		{
			bPlayerSeen = False;
			bCarcassSeen = False;
			bStasis = default.bStasis;
			lastSeenTimer = 0;
			// untrigger events
			TriggerEvent(False);
			TriggerCarcassEvent(False);
		}
}

defaultproperties
{
     bEMPHitMarkers=True
     swingAngle=8192
     swingPeriod=8.000000
     cameraFOV=4096
     cameraRange=2048
     memoryTime=5.000000
     bActive=True
     confusionDuration=10.000000
     triggerDelay=2.750000
     msgActivated="Camera activated"
     msgDeactivated="Camera deactivated"
     Team=-1
     HitPoints=50
     minDamageThreshold=55
     bInvincible=False
     FragType=Class'DeusEx.MetalFragment'
     ItemName="Surveillance Camera"
     Physics=PHYS_Rotating
     Texture=Texture'DeusExDeco.Skins.SecurityCameraTex2'
     Mesh=LodMesh'DeusExDeco.SecurityCamera'
     SoundRadius=96
     SoundVolume=32
     CollisionRadius=10.720000
     CollisionHeight=11.000000
     LightType=LT_Steady
     LightBrightness=224
     LightHue=80
     LightRadius=1
     bRotateToDesired=True
     Mass=20.000000
     Buoyancy=5.000000
     RotationRate=(Pitch=65535,Yaw=65535)
     bVisionImportant=True
     disableTimeBase=120.0;
     disableTimeMult=60.0;
}
