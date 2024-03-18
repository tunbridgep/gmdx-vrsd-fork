//=============================================================================
// DamageTrigger.   //CyberP: applies velocity to touching actors
//=============================================================================
class VelocityTrigger expands Trigger;

var() vector AppliedVelocity;
var Actor forced;
var () float accelerationRate;
var bool bIsOn;

function Timer()
{
	if (!bIsOn)
	{
		SetTimer(0.1, False);
		return;
	}

	if (forced != None)
	{
	    if (appliedVelocity.Z != 0)
	        forced.SetPhysics(PHYS_Falling);
		forced.Velocity += appliedVelocity;
    }
}

function Touch(Actor Other)
{
	if (!bIsOn)
		return;

	// should we even pay attention to this actor?
	if (!IsRelevant(Other) && !Other.IsA('DeusExDecoration'))
		return;

	forced = Other;
	//CyberP: need to use the Touching[] array to handle more than one object at a time.

    SetTimer(accelerationRate, True);

	Super.Touch(Other);
}

function UnTouch(Actor Other)
{
    SetTimer(0.1, false);

	if (!bIsOn)
		return;
}

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
	if (!bIsOn)
		bIsOn = True;

	Super.Trigger(Other, Instigator);
}

// if we are untriggered, turn us off
function UnTrigger(Actor Other, Pawn Instigator)
{
	if (bIsOn)
		bIsOn = False;

	SetTimer(0.1, false);

	Super.UnTrigger(Other, Instigator);
}

defaultproperties
{
     accelerationRate=0.100000
     bIsOn=True
}
