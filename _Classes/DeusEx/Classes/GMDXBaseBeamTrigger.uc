//=============================================================================
// GMDXBaseBeamTrigger
// SARGE: Handles common cases between BeamTrigger and LaserTrigger entities
//=============================================================================
class GMDXBaseBeamTrigger extends Trigger;

var LaserEmitter emitter;
var() bool bIsOn;
var() bool bNoAlarm;			// if True, does NOT sound alarm
var actor LastHitActor;
var bool bConfused;				// used when hit by EMP
var float confusionTimer;		// how long until trigger resumes normal operation
var float confusionDuration;	// how long does EMP hit last?
var int HitPoints;
var int minDamageThreshold;
var bool bAlreadyTriggered;
var float lastAlarmTime;		// last time the alarm was sounded
var int alarmTimeout;			// how long before the alarm silences itself
var actor triggerActor;			// actor which last triggered the alarm
var vector actorLocation;		// last known location of actor that triggered alarm
var() bool bUseRedBeam;
var string HDTPMesh;
var string HDTPSkin;
var string HDTPTexture;
var globalconfig int iHDTPModelToggle;

//SARGE: Filters. Moved from Containers, now affects all DeusExDecorations
var(Spawning) bool bLowDifficultyOnly; //Remove on realistic and hardcore
var(Spawning) bool bHardcoreRemoveIt; //Remove on hardcore only //SARGE: This was called bHardcoreRemoveIt before, and I'm too lazy to change it in every map/t3d file, so it gets that same name here.
var(Spawning) bool bHardcoreOnly; //Keep on hardcore only
var(Spawning) int minimumNewGamePlusCycle;
var(Spawning) int maximumNewGamePlusCycle;

//SARGE: Moved from the giant SetupDifficultyMod function in DeusExPlayer
//This is called automatically on mission start.
//NOT called for objects created during gameplay.
function SetupDifficultyMod(DeusExPlayer P)
{
    //New Game Plus handling
    if (minimumNewGamePlusCycle > P.iNewGamePlusCycle)
        Destroy();
    else if (maximumNewGamePlusCycle > -1 && maximumNewGamePlusCycle < P.iNewGamePlusCycle)
        Destroy();

    //Hardcore Filters
    if (bHardcoreOnly && !P.bHardCoreMode && !P.bHardcoreFilterOption)
        Destroy();
    else if (bHardcoreRemoveIt && (P.bHardCoreMode || P.bHardcoreFilterOption))
        Destroy();

    //Difficulty Filters
    if ((bLowDifficultyOnly && (P.CombatDifficulty >= 3.0 || P.bHardCoreMode)))
        Destroy();
}

singular function Touch(Actor Other)
{
	// does nothing when touched
}

static function bool IsHDTP()
{
    return class'DeusExPlayer'.static.IsHDTPInstalled() && default.iHDTPModelToggle > 0;
}

//Ygll: Setup the HDTP settings for this classe
function UpdateHDTPSettings()
{
	if(HDTPMesh != "")
        Mesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),IsHDTP());

    if(HDTPSkin != "")
        Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),IsHDTP());

    if(HDTPTexture != "")
        Texture = class'HDTPLoader'.static.GetTexture2(HDTPTexture,string(default.Texture),IsHDTP());	
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	UpdateHDTPSettings();
}

//SARGE: More complex triggering
function bool IsRelevant( actor Other )
{
    local DeusExPlayer player;

    if (Other == None)
        return false;
    
    Log("Hit by: " $ Other);

    //SARGE: Don't emit alarms when hitting medical or repair bots
    //Fixes really annoying/stupid issue on Vandenberg where a med-bot keeps setting off the
    //alarms repeatedly
    if (Other.IsA('MedicalBot') || Other.IsA('RepairBot'))
        return false;
    
    //If we're set to player only, then also allow decorations
    if (TriggerType == TT_PlayerProximity && Other.IsA('Decoration'))
        return true;

    //SARGE: Code copied over from base GMDX. Meh.
    if (Other.IsA('HumanMilitary'))
        return false;
    
    //SARGE: Pepper Spray only works if it's enabled
    if (Other.IsA('Cloud'))
    {
        player = DeusExPlayer(GetPlayerPawn());

        if (player != None && (player.bHardCoreMode || player.bImprovedLasers))
            return false;
    }

    if (Other.IsA('DeusExPlayer'))
    {
        player = DeusExPlayer(Other);
				    
        //Radar Trans blocks it
        if (player.AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') > 0)
            return false;

        //Adaptive Armor allows going through it with the Chameleon perk.
        if (player.UsingChargedPickup(class'AdaptiveArmor') && player.PerkManager.GetPerkWithClass(class'DeusEx.PerkChameleon').bPerkObtained)
            return false;
    }

    return super.IsRelevant(Other);
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
	local MetalFragment frag;

	if (DamageType == 'EMP')
	{
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

function BeginPlay()
{
	Super.BeginPlay();

	LastHitActor = None;
	emitter = Spawn(class'LaserEmitter');
	
    if (emitter != None)
	{
	    if (!bUseRedBeam)
        {
            emitter.SetBlueBeam(true);
            MultiSkins[1] = Texture'LaserSpot2';
        }

		emitter.TurnOn();
		bIsOn = True;
        
        // turn off the sound if we should
        if (bNoAlarm || SoundVolume == 0)
            emitter.AmbientSound = None;
	}
	else
		bIsOn = False;
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
		
        if ((emitter.HitActor != None) && (LastHitActor != emitter.HitActor))
		{
            if (IsRelevant(emitter.HitActor))
            {
                // now, the trigger sounds its own alarm
                if (!bNoAlarm)
                {
                    if (AmbientSound == None)
                    {
                        triggerActor = emitter.HitActor;
                        actorLocation = emitter.HitActor.Location - vect(0,0,1)*(emitter.HitActor.CollisionHeight-1);
                        BeginAlarm();
                    }
                    else //SARGE: Reset timer if we cross it again
                    {
                        lastAlarmTime = Level.TimeSeconds;
                    }
                }
                
                // play "beam broken" sound
                PlaySound(sound'Beep2',,,, 1280, 3.0);

                if (!bAlreadyTriggered)
                {
                    // only be triggered once?
                    if (bTriggerOnceOnly)
                        bAlreadyTriggered = True;
                    
                    // Trigger event
                    if(Event != '')
                        foreach AllActors(class 'Actor', A, Event)
                            A.Trigger(Self, Pawn(emitter.HitActor));
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
			if (bUseRedBeam)
            {
			    emitter.SetBlueBeam(false);
                MultiSkins[1] = Texture'LaserSpot1';
                if (class'HDTPLoader'.static.HDTPInstalled())
                    Skin = class'HDTPLoader'.static.GetTexture("HDTPDecos.HDTPlaserEmitterTex1");
            }
			else
			{
			    emitter.SetBlueBeam(true);
                MultiSkins[1] = Texture'LaserSpot2';
                if (class'HDTPLoader'.static.HDTPInstalled())
                    Skin = class'HDTPLoader'.static.GetTexture("HDTPDecos.HDTPlaserEmitterTex2");
			}
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

function BeginAlarm()
{
    local DeusExPlayer player;
                


    //player = DeusExPlayer(GetPlayerPawn());
	    //if (player != None && player.bHardcoreAI3)
	       AmbientSound = Sound'alarms';
	    //else
	       //AmbientSound = Sound'Klaxon2';
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

defaultproperties
{
     bIsOn=true
     confusionDuration=10.000000
     HitPoints=50
     minDamageThreshold=50
     TriggerType=TT_AnyProximity
     bHidden=false
     bDirectional=true
     DrawType=DT_Mesh
     HDTPSkin"HDTPDecos.Skins.HDTPlaseremittertex0"
     HDTPMesh="HDTPDecos.HDTPlaseremitter"
     Mesh=LodMesh'DeusExDeco.LaserEmitter'
     CollisionRadius=2.500000
     CollisionHeight=2.500000
     iHDTPModelToggle=1
}
