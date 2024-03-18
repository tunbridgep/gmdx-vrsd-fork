//=============================================================================
// GravityTrigger.                                                              //RSD: New class to enable me to change gravity settings in the Area 51 fan room
//=============================================================================
class GravityTrigger expands Trigger;

var() vector ZoneGravity;
var() vector ZoneVelocity;
var() bool bAlterVelocity;

function Trigger(Actor Other, Pawn Instigator)
{
	if (SetGravity())
	{
		Super.Trigger(Other, Instigator);
		if (bTriggerOnceOnly)
			Destroy();
	}
}

function bool SetGravity()
{
	local ZoneInfo ZI;

	// find the ZoneInfo to set gravity
	if (Event != '')
		foreach AllActors (class'ZoneInfo', ZI, Event)
		{
			ZI.ZoneGravity = ZoneGravity;
			if (bAlterVelocity)                                                 //RSD: Can also set velocity
				ZI.ZoneVelocity = ZoneVelocity;
		}

	return True;
}

defaultproperties
{
     bCollideActors=False
}
