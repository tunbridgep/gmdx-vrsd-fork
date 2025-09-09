//=============================================================================
// BeamTrigger.
//=============================================================================
class BeamTrigger extends Trigger;

var LaserEmitter emitter;
var() bool bIsOn;
var actor LastHitActor;
var bool bConfused;				// used when hit by EMP
var float confusionTimer;		// how long until trigger resumes normal operation
var float confusionDuration;	// how long does EMP hit last?
var int HitPoints;
var int minDamageThreshold;
var bool bAlreadyTriggered;
var() bool bUseRedBeam;
var string HDTPMesh;
var string HDTPSkin;
var string HDTPTexture;
var config int iHDTPModelToggle;

singular function Touch(Actor Other)
{
	// does nothing when touched
}

function Tick(float deltaTime)
{
	local Actor A;
	local AdaptiveArmor armor;
	local bool bTrigger;
	local DeusExPlayer Player;

	if (emitter != None)
	{
		// if we've been EMP'ed, act confused
		if (bConfused && bIsOn)
		{
			confusionTimer += deltaTime;

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
				bTrigger = True;
                if (emitter.HitActor.IsA('Cloud'))
                {
                        Player = DeusExPlayer(GetPlayerPawn());
                        if (player != None && !Player.bHardCoreMode && !Player.bImprovedLasers)
					        bTrigger = False;
				}
				if (emitter.HitActor.IsA('DeusExPlayer'))
				{
				    if (DeusExPlayer(emitter.HitActor).AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') > 0)
					     {
					       bTrigger = false;
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
				else if (emitter.HitActor.IsA('HumanMilitary')) //CyberP: that'll do
                    bTrigger = false;
				if (bTrigger)
				{
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
			    emitter.bBlueBeam = False;
			else
			{
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
	    if (bUseRedBeam == false)
		emitter.SetBlueBeam();
		emitter.TurnOn();
		bIsOn = True;
	}
	else
		bIsOn = False;
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
     MultiSkins(1)=FireTexture'Effects.Laser.LaserSpot2'
     CollisionRadius=2.500000
     CollisionHeight=2.500000
}
