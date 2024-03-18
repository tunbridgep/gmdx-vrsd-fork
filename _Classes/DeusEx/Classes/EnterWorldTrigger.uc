//=============================================================================
// EnterWorldTrigger.
//=============================================================================
class EnterWorldTrigger extends Trigger;

//CyberP: Sends a unhide event when touched or triggered. Only works on pawns and vehicles, at least for now.
// Set bCollideActors to False to make it triggered

function Trigger(Actor Other, Pawn Instigator)
{
	local ScriptedPawn A;
    local Vehicles B;

	if(Event != '')
	{
		foreach AllActors(class 'ScriptedPawn', A, Event)
                    A.PutInWorld(true);
        foreach AllActors(class 'Vehicles', B, Event)
                    B.PutInWorld(true);
    }
}

function Touch(Actor Other)
{
	local ScriptedPawn A;
    local Vehicles B;

	if (IsRelevant(Other))
	{
		if(Event != '')
		{
			foreach AllActors(class 'ScriptedPawn', A, Event)
                    A.PutInWorld(true);
            foreach AllActors(class 'Vehicles', B, Event)
                    B.PutInWorld(true);
        }
    }
}

defaultproperties
{
}
