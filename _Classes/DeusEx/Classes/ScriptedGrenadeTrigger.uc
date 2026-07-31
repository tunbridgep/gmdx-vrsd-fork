//=============================================================================
// EnterWorldTrigger.
//=============================================================================
class ScriptedGrenadeTrigger extends Trigger;

var ProjectileGenerator ProjGen;
var() bool bNoMoverCheck;
var() float CheckHumanRadius;
var() float CheckMoverRadius;
var() float CheckGasRadius;
var() float ThrowChance;
var() float CooldownTime;

var DeusExPlayer player;            //SARGE: Now we run it on a timer, rather than being per touch
var GasGrenade GG;                  //The actual grenade we're using as a source.
var float cooldown;                 //The cooldown if we threw one recently.

//We only need to do this once.
function GrenadeCheck()
{
	local GasGrenade temp;
	foreach RadiusActors(class'GasGrenade', temp, CheckGasRadius)
	{
		if (temp.bScriptedGrenade)
        {
            GG = temp;
            return;
        }
    }
}

//SARGE: Now we spawn a new one, rather than throwing the old one.
//SARGE: Also allow spawning more than one type of grenade.
function TriggerGrenade(bool bGasOnly)
{
    local ThrownProjectile TP;
    local Class<ThrownProjectile> Type;
    local float roll;

    roll = FRand();

    //Get grenade type
    if (bGasOnly)
        Type = class'GasGrenade';
    else if(roll > 0.75)
        Type = class'EMPGrenade';
    else if(roll > 0.50)
        Type = class'LAM';
    else if(roll > 0.25)
        Type = class'NanoVirusGrenade';
    else
        Type = class'GasGrenade';

    TP = ThrownProjectile(class'SpawnUtils'.static.SpawnSafe(Type,GG,'SpawnedGrenade',GG.Location,GG.Rotation));
    TP.Velocity = 1200.0 * Vector(GG.Rotation);
    cooldown = Level.TimeSeconds + CooldownTime;
    ThrowChance = default.ThrowChance;
    player.DebugMessage("ScriptedGrenadeTrigger - End");
}

//Check to see if we can throw a nade, and if so, throw it
function TriggerCheck()
{
	local HumanMilitary HM;
    local DeusExMover DM;
    local float dist, dist2;
    local bool bGasOnly;              //If we only find terrorists, then only allow gas grenades.
        
    player.DebugMessage("ScriptedGrenadeTrigger Check");
		
    //First check Cooldown
    if (cooldown >= Level.TimeSeconds)
        return;


    //player.DebugMessage("ScriptedGrenadeTrigger Check: Cooldown Passed");

    //Then, check if any movers are in the way
    if (!bNoMoverCheck)
    {
        //SARGE: Bail if any nearby mover is closed.
        //But only if it's actually closer than the grenade.
        ForEach RadiusActors(class'DeusExMover', DM, CheckMoverRadius)
        {
            dist = abs(VSize(DM.Location - Location)); //Distance from mover to trigger
            dist2 = abs(VSize(GG.Location - Location)); //Distance from mover to grenade
            player.DebugMessage("Mover Distance: " $ DM @ dist @ "(grenade dist " $ dist2 $ ")");
            if (DM.KeyNum == 0 && dist < dist2)
            {
                player.DebugMessage("ScriptedGrenadeTrigger - Mover is closed: " $ DM);
                return;
            }
        }
    }

    //Then check for actors
    foreach RadiusActors(class'HumanMilitary', HM, CheckHumanRadius)
    {
        player.DebugMessage("State:" @ HM.GetStateName());
        if ((HM.IsInState('Attacking') || HM.IsInState('Seeking')) && !HM.IsA('MJ12Commando')) //SARGE: Added Seeking
        {
            //Then check chance, and increase if it fails.
            if (FRand() >= ThrowChance)
            {
                ThrowChance += 0.025;
                player.DebugMessage("ScriptedGrenadeTrigger roll failed. Chance increased to " $ ThrowChance);
                return;
            }

            bGasOnly = HM.IsA('Terrorist');
            HM.PlayAnimPivot('Attack',,0.2);
            player.DebugMessage("ScriptedGrenadeTrigger - Triggering");
            TriggerGrenade(bGasOnly);
            return;
        }
    }
}

function BeginPlay()
{
    GrenadeCheck();
    super.BeginPlay();
}

function Touch(Actor Other)    //Scripted hackage!!!
{
	local HumanMilitary HM;
    local DeusExMover DM;
    local float dist, dist2;
		    
	if (IsRelevant(Other))
	{
        //This part was copied from Trigger.uc
        if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		} 

        GrenadeCheck();
        if (GG == None)
            return;

        player = DeusExPlayer(Other);
        player.DebugMessage("ScriptedGrenadeTrigger Start");
		
        if(player != None)
            TriggerCheck();

        //This part was also copied from Trigger.uc
        if( bTriggerOnceOnly )
            // Ignore future touches.
            SetCollision(False);
        else if ( RepeatTriggerTime > 0 )
            SetTimer(RepeatTriggerTime, false);
    }
}

defaultproperties
{
     CheckHumanRadius=1256.000000
     CheckMoverRadius=512.000000
     CheckGasRadius=1024.000000
     ReTriggerDelay=1
     RepeatTriggerTime=1
     ThrowChance=0.15
     CooldownTime=10
}
