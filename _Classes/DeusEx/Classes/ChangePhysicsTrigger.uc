//=============================================================================
// ChangeDecoPhysicsTrigger.                                                    //RSD: New class to enable me to change physics settings on actors
//=============================================================================
class ChangePhysicsTrigger expands Trigger;

/*var(Movement) const enum EPhysics
{
	PHYS_None,
	PHYS_Walking,
	PHYS_Falling,
	PHYS_Swimming,
	PHYS_Flying,
	PHYS_Rotating,
	PHYS_Projectile,
	PHYS_Rolling,
	PHYS_Interpolating,
	PHYS_MovingBrush,
	PHYS_Spider,
	PHYS_Trailer
} TriggerPhysics;*/

function Trigger(Actor Other, Pawn Instigator)
{
	if (SetActorPhysics())
	{
		Super.Trigger(Other, Instigator);
		if (bTriggerOnceOnly)
			Destroy();
	}
}

function bool SetActorPhysics()
{
	local Actor A;

	// find the ZoneInfo to set gravity
	if (Event != '')
		foreach AllActors (class'Actor', A, Event)
			A.SetPhysics(Physics);

	return True;
}

defaultproperties
{
     bCollideActors=False
}
