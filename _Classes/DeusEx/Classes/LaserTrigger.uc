//=============================================================================
// LaserTrigger.
//=============================================================================
class LaserTrigger extends Trigger;

var LaserEmitter emitter;
var() bool bIsOn;
var() bool bNoAlarm;			// if True, does NOT sound alarm
var actor LastHitActor;
var bool bConfused;				// used when hit by EMP
var float confusionTimer;		// how long until trigger resumes normal operation
var float confusionDuration;	// how long does EMP hit last?
var int HitPoints;
var int minDamageThreshold;
var float lastAlarmTime;		// last time the alarm was sounded
var int alarmTimeout;			// how long before the alarm silences itself
var actor triggerActor;			// actor which last triggered the alarm
var vector actorLocation;		// last known location of actor that triggered alarm

singular function Touch(Actor Other)
{
	// does nothing when touched
}

function BeginAlarm()
{
    local DeusExPlayer player;

    player = DeusExPlayer(GetPlayerPawn());
	    //if (player != None && player.bHardcoreAI3)
	       AmbientSound = Sound'alarms';
	    //else
	    //   AmbientSound = Sound'Klaxon2';
	SoundVolume = 80; //CyberP: less volume
	SoundRadius = 112; //CyberP: larger radius
	lastAlarmTime = Level.TimeSeconds;
	AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 24*(SoundRadius+1));

	// make sure we can't go into stasis while we're alarming
	bStasis = False;
}

function EndAlarm()
{
	AmbientSound = None;
	lastAlarmTime = 0;
	AIEndEvent('Alarm', EAITYPE_Audio);

	// reset our stasis info
	bStasis = Default.bStasis;
}

function Tick(float deltaTime)
{
	local Actor A;
	local AdaptiveArmor armor;
	local bool bTrigger;
	local DeusExPlayer player;
	local float mult1, mult2;                                                   //RSD: Added

	if (emitter != None)
	{
		// shut off the alarm if the timeout has expired
		if (lastAlarmTime != 0)
		{
			if (Level.TimeSeconds - lastAlarmTime >= alarmTimeout) //CyberP: extended block to fix laser explout on higher diffs
			{
			    if (emitter.HitActor == none)
				   EndAlarm();
				else
                {
                   player = DeusExPlayer(GetPlayerPawn());
                   if (player != None && player.CombatDifficulty < 3)
                       EndAlarm();
                }
			}
		}

		// if we've been EMP'ed, act confused
		if (bConfused && bIsOn)
		{
			confusionTimer += deltaTime;
            EndAlarm(); //CyberP: EMP also cancels alarm
			// randomly turn on/off the beam
			if (FRand() > 0.95)
				emitter.TurnOn();
			else
				emitter.TurnOff();

			if (confusionTimer > confusionDuration)
			{
				bConfused = False;
				confusionTimer = 0;
				emitter.TurnOn();
			}

			return;
		}

		emitter.SetLocation(Location);
		emitter.SetRotation(Rotation);

		if (!bNoAlarm)
		{
			if ((emitter.HitActor != None) && (LastHitActor != emitter.HitActor))
			{
				// TT_PlayerProximity actually works with decorations, too
				if (IsRelevant(emitter.HitActor) ||
					((TriggerType == TT_PlayerProximity) && emitter.HitActor.IsA('Decoration')))
				{
                    bTrigger = True;
                    if (emitter.HitActor.IsA('Cloud'))
                    {
                        Player = DeusExPlayer(GetPlayerPawn());
                        if (player != None && !Player.bHardCoreMode)
					        bTrigger = False;
					}
					else if (emitter.HitActor.IsA('DeusExPlayer'))
					{
				       player = DeusExPlayer(emitter.HitActor);                 //RSD: For repeated calls
                       if (player.AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') > 0) //RSD: changed to player
					      {
					       bTrigger = false;
					       mult1 = 1.0;
					       mult2 = player.AugmentationSystem.GetAugLevelValue(class'AugPower');
					       if (mult2 > 0)
					         mult1 *= mult2;
					       mult2 = player.AugmentationSystem.GetAugLevelValue(class'AugHeartLung');
					       if (mult2 > 0)
					         mult1 *= mult2;
					       player.Energy -= mult1*player.AugmentationSystem.FindAugmentation(class'AugRadarTrans').GetEnergyRate()/15 * deltaTime; //RSD: quadrupled cost for hitting laser triggers
					       if (player.Energy < 0)
					         player.Energy = 0;
					       return;
				          }
						// check for adaptive armor - makes the player invisible
						if (DeusExPlayer(emitter.HitActor).PerkManager.GetPerkWithClass(class'DeusEx.PerkChameleon').bPerkObtained == true)
						{
						foreach AllActors(class'AdaptiveArmor', armor)
							if ((armor.Owner == emitter.HitActor) && armor.bActive)
							{
								bTrigger = False;
								break;
							}
						}
					}
                    else if (emitter.HitActor.IsA('HumanMilitary'))
                    {
                       bTrigger = False;  //CyberP: the baddies don't set off their own alarms.

                    }
					if (bTrigger)
					{
						// now, the trigger sounds its own alarm
						if (AmbientSound == None)
						{
							triggerActor = emitter.HitActor;
							actorLocation = emitter.HitActor.Location - vect(0,0,1)*(emitter.HitActor.CollisionHeight-1);
							BeginAlarm();
						}

						// play "beam broken" sound
						PlaySound(sound'Beep2',,,, 1280, 3.0);
					}
				}
			}
		}

		LastHitActor = emitter.HitActor;
	}
}

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
	if (bConfused)
		return;

	if (emitter != None)
	{
		if (!bIsOn)
		{
			emitter.TurnOn();
			bIsOn = True;
			LastHitActor = None;
			MultiSkins[1] = Texture'LaserSpot1';
            if (class'HDTPLoader'.static.HDTPInstalled())
                Skin = class'HDTPLoader'.static.GetTexture("HDTPDecos.HDTPlaserEmitterTex1");
		}
	}

	Super.Trigger(Other, Instigator);
}

// if we are untriggered, turn us off
function UnTrigger(Actor Other, Pawn Instigator)
{
	if (bConfused)
		return;

	if (emitter != None)
	{
		if (bIsOn)
		{
			emitter.TurnOff();
			bIsOn = False;
			LastHitActor = None;
			MultiSkins[1] = Texture'BlackMaskTex';
            if (class'HDTPLoader'.static.HDTPInstalled())
                Skin = class'HDTPLoader'.static.GetTexture("HDTPDecos.HDTPlaserEmitterTex0");
			EndAlarm();
		}
	}

	Super.UnTrigger(Other, Instigator);
}

function BeginPlay()
{
	Super.BeginPlay();

	LastHitActor = None;
	emitter = Spawn(class'LaserEmitter');

	if (emitter != None)
	{
		emitter.TurnOn();
		bIsOn = True;
        if (bNoAlarm)
        emitter.AmbientSound = None;
		// turn off the sound if we should
		if (SoundVolume == 0)
			emitter.AmbientSound = None;
	}
	else
		bIsOn = False;
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
	local MetalFragment frag;

	if (DamageType == 'EMP')
	{
	    if (bNoAlarm)
	    Destroy();

     	confusionTimer = 0;
		if (!bConfused)
		{
			bConfused = True;
			PlaySound(sound'EMPZap', SLOT_None,,, 1280);
		}
	}
	else if ((DamageType == 'Exploded') || (DamageType == 'Shot'))
	{
		if (Damage >= minDamageThreshold)
			HitPoints -= Damage;

        if (bNoAlarm)
        Destroy();

		if (HitPoints <= 0)
		{
			frag = Spawn(class'MetalFragment', Owner);
			if (frag != None)
			{
				frag.Instigator = EventInstigator;
				frag.CalcVelocity(Momentum,0);
				frag.DrawScale = 0.5*FRand();
				frag.Skin = GetMeshTexture();
			}

			Destroy();
		}
	}
}

function Destroyed()
{
	if (emitter != None)
	{
		emitter.Destroy();
		emitter = None;
	}

	Super.Destroyed();
}

defaultproperties
{
     bIsOn=True
     confusionDuration=10.000000
     HitPoints=50
     minDamageThreshold=50
     alarmTimeout=30
     TriggerType=TT_AnyProximity
     bHidden=False
     bDirectional=True
     DrawType=DT_Mesh
     HDTPSkin"HDTPDecos.Skins.HDTPlaseremittertex0"
     HDTPMesh="HDTPDecos.HDTPlaseremitter"
     Mesh=LodMesh'DeusExDeco.LaserEmitter'
     CollisionRadius=2.500000
     CollisionHeight=2.500000
}
