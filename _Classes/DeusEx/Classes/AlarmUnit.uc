//=============================================================================
// AlarmUnit.
//=============================================================================
class AlarmUnit extends HackableDevices;

#exec OBJ LOAD FILE=Ambient

var() int alarmTimeout;
var localized string msgActivated;
var localized string msgDeactivated;
var bool bActive;
var float curTime;
var Pawn alarmInstigator;
var Vector alarmLocation;
var() name Alliance;
var Pawn associatedPawn;
var bool bDisabled;
var bool bConfused;				// used when hit by EMP
var float confusionTimer;		// how long until unit resumes normal operation
var float confusionDuration;	// how long does EMP hit last?var deusexplayer P; //might as well keep a global track
var bool bMaster; //so the HDTP deco has a tendency to do that 'go all black' mesh lighting fuckup
//thing that the unreal engine does on some renderers, which you can fix with a flush of the texture cache
//but...obviously you don't want to do this for every alarm unit, every time (I've tried, it causes
//fairly noticable stuttering on slower comps): hence slavery! -DDL

function UpdateAIEvents()
{
	local SecurityCamera SC;

    if (bActive)
	{
		// Make noise and light
		SoundRadius = 128;
		AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 24*(SoundRadius+1)); //CyberP:
	}
	else
	{
		// Stop making noise and light
		AIEndEvent('Alarm', EAITYPE_Audio);

		foreach AllActors(class'SecurityCamera',SC)                             //RSD: also shut off any active camera alarms
		{
			SC.TriggerAlarmOverride();
		}
	}
}

function UpdateGroup(Actor Other, Pawn Instigator, bool bActivated)
{
	local AlarmUnit unit;

	// Only do this if we have a group tag set
	if (Tag != '')
	{
		// Trigger (or untrigger) every alarm with the same tag
		foreach AllActors(Class'AlarmUnit', unit, Tag)
		{
			if (bActivated)
				unit.Trigger(Other, Instigator);
			else
				unit.UnTrigger(Other, Instigator);
		}
	}
}

function HackAction(Actor Hacker, bool bHacked)
{
	Super.HackAction(Hacker, bHacked);

	if (bHacked)
	{
		if (bActive)
		{
			UnTrigger(Hacker, Pawn(Hacker));
			bDisabled = True;
			LightType = LT_None;
			MultiSkins[1] = Texture'HDTPAlarmUnittex1';
			MultiSkins[2] = Texture'PinkMaskTex';

		}
/*		else		// don't actually ever set off the alarm
		{
			Trigger(Hacker, Pawn(Hacker));
			bDisabled = False;
			LightType = LT_None;
			MultiSkins[1] = Texture'HDTPAlarmUnittex1';
			MultiSkins[2] = Texture'PinkMaskTex';
		}*/
		else
		    UpdateAIEvents();                                                   //RSD
	}
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (bDisabled)
		return;

	// if we've been EMP'ed, act confused
	if (bConfused)
	{
		confusionTimer += deltaTime;

		// randomly flash the light
		if (FRand() > 0.95)
		{
			MultiSkins[1] = Texture'HDTPAlarmUnittex2';
			MultiSkins[2] = Texture'HDTPAlarmUnittex2';

		}
		else
		{
			MultiSkins[1] = Texture'HDTPAlarmUnittex1';
			MultiSkins[2] = Texture'PinkMaskTex';

		}

		if (confusionTimer > confusionDuration)
		{
			bConfused = False;
			confusionTimer = 0;
			MultiSkins[1] = Texture'HDTPAlarmUnittex2';
			MultiSkins[2] = Texture'HDTPAlarmUnittex2';

		}

		return;
	}

	if (bActive)
	{
		curTime += deltaTime;
		if (curTime >= alarmTimeout)
		{
			UnTrigger(Self, None);
			return;
		}

		// flash the light and texture
		if ((Level.TimeSeconds % 0.5) > 0.25)
		{
			if(LightType != LT_Steady)  //I see no reason to do this _every_ tick that the above is valid
			{
				LightType = LT_Steady;
				MultiSkins[1] = Texture'HDTPAlarmUnittex2';
				if(Multiskins[2] != Texture'HDTPAlarmUnittex2')
				{
					MultiSkins[2] = Texture'HDTPAlarmUnittex2';
				}
				//if(bMaster)
				//	deusexplayer(getPlayerPawn()).ConsoleCommand("FLUSH");
			}
		}
		else
		{
			if(LightType != LT_None)
			{
				LightType = LT_None;
				MultiSkins[1] = Texture'HDTPAlarmUnittex1';
				if(Multiskins[2] != Texture'pinkmasktex')
				{
					MultiSkins[2] = Texture'pinkmasktex';
				}
				//if(bMaster)
				//		deusexplayer(getPlayerPawn()).ConsoleCommand("FLUSH");
			}

		}
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;
    local DeusExPlayer player;

	if (bConfused || bDisabled)
		return;

	Super.Trigger(Other, Instigator);

	if (!bActive)
	{
		if(associatedpawn != none) //we've been triggered by a dude, not by another alarm
			bMaster=true;
		else
			bMaster=false; //safetycheck
		if (Instigator != None)
			Instigator.ClientMessage(msgActivated);
		bActive = True;
		bUnlit=True; //CyberP: hack to stop alarms going black
        player = DeusExPlayer(GetPlayerPawn());
	    //if (player != None && player.bHardcoreAI3)
	       AmbientSound = Sound'alarms';
	    //else
	    //   AmbientSound = Sound'Klaxon2';
		SoundRadius = 112; //CyberP: larger radius
		SoundVolume = 96;  //CyberP: less volume
		curTime = 0;
		LightType = LT_Steady;
		MultiSkins[1] = Texture'HDTPAlarmUnittex2';
		MultiSkins[2] = Texture'HDTPAlarmUnittex2';
		//if(bMaster)
		//	deusexplayer(getPlayerPawn()).ConsoleCommand("FLUSH");
		alarmInstigator = Instigator;
/* taken out for now...
		if (Instigator != None)
			alarmLocation = Instigator.Location-vect(0,0,1)*(Instigator.CollisionHeight-1);
		else
*/
			alarmLocation = Location;
		UpdateAIEvents();
		UpdateGroup(Other, Instigator, true);

		// trigger the event
		if (Event != '')
			foreach AllActors(class'Actor', A, Event)
				A.Trigger(Self, Instigator);

		// make sure we can't go into stasis while we're alarming
		bStasis = False;
	}
}

function UnTrigger(Actor Other, Pawn Instigator)
{

	if (bConfused || bDisabled)
		return;

	Super.UnTrigger(Other, Instigator);

	if (bActive)
	{
		if (Instigator != None)
			Instigator.ClientMessage(msgDeactivated);
		bActive = False;
		bUnlit=False; //CyberP:
		AmbientSound = Default.AmbientSound;
		SoundRadius = 16;
		SoundVolume = 192;
		curTime = 0;
		LightType = LT_None;
		MultiSkins[1] = Texture'HDTPAlarmUnittex1';
		MultiSkins[2] = Texture'PinkMaskTex';
		//if(bMaster)
		//	deusexplayer(getPlayerPawn()).ConsoleCommand("FLUSH");

		UpdateAIEvents();
		UpdateGroup(Other, Instigator, false);

		bMaster = false;

		// reset our stasis info
		bStasis = Default.bStasis;
	}
}

auto state Active
{
	function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
        if (DamageType == 'Sabot' || DamageType == 'Shot')
        PlaySound(sound'ArmorRicochet',SLOT_Interact,,true,1280);

		if (DamageType == 'EMP')
		{
			confusionTimer = 0;
			if (!bConfused)
			{
				curTime = alarmTimeout;
				bConfused = True;
				PlaySound(sound'EMPZap', SLOT_None,,, 1280);
				UnTrigger(Self, None);
			}
			return;
		}

		Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	}
}

defaultproperties
{
     alarmTimeout=30
     msgActivated="Alarm activated"
     msgDeactivated="Alarm deactivated"
     confusionDuration=10.000000
     hackStrength=0.100000
     HitPoints=60
     minDamageThreshold=50
     bInvincible=False
     ItemName="Alarm Sounder Panel"
     Mesh=LodMesh'HDTPDecos.HDTPalarmunit'
     MultiSkins(2)=Texture'DeusExItems.Skins.PinkMaskTex'
     SoundRadius=14
     AmbientSound=Sound'DeusExSounds.Generic.AlarmUnitHum'
     CollisionRadius=9.720000
     CollisionHeight=9.720000
     LightBrightness=255
     LightRadius=1
     Mass=10.000000
     Buoyancy=5.000000
}
