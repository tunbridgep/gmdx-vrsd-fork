//=============================================================================
// UnTrigger.
//=============================================================================
class SpecialCaseTrigger extends Trigger;

// special case trigger used on liberty island that funnels players to unatco
//DO NOT USE!!!
var() bool specialCaseHack;

function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;
    local DeusExPlayer playa;
	// UnTrigger event
	playa = DeusExPlayer(GetPlayerPawn());

	if(Event != '')
		foreach AllActors(class 'Actor', A, Event)
		{
			if (A.IsA('DeusExMover'))
			{
			     if (playa != none && playa.CombatDifficulty >= 1.0)
                    A.Trigger(Other, Instigator);
                 else if (specialCaseHack)
                    A.Trigger(Other, Instigator);
			}
			else if (A.IsA('ScriptedPawn'))
			{
			    if (playa != none && playa.CombatDifficulty < 1.0)
                    A.Destroy();
            }
            else if (A.IsA('CageLight'))
			{
			     if (playa != none && playa.CombatDifficulty >= 1.0)
                    A.LightRadius=16;
                 else if (specialCaseHack)
                    A.LightRadius=16;
			}
		}
		Destroy();
}

function Touch(Actor Other)
{
	local Actor A;
    local DeusExPlayer playa;
	// UnTrigger event
	playa = DeusExPlayer(GetPlayerPawn());

	if (IsRelevant(Other))
		if(Event != '')
		foreach AllActors(class 'Actor', A, Event)
		{
			if (A.IsA('DeusExMover'))
			{
			     if (playa != none && playa.CombatDifficulty >= 1.0)
                    A.Trigger(Other, Instigator);
                 else if (specialCaseHack)
                    A.Trigger(Other, Instigator);
			}
			else if (A.IsA('ScriptedPawn'))
			{
			    if (playa != none && playa.CombatDifficulty < 1.0)
                    A.Destroy();
            }
            else if (A.IsA('CageLight'))
			{
			     if (playa != none && playa.CombatDifficulty >= 1.0)
                    A.LightRadius=16;
                 else if (specialCaseHack)
                    A.LightRadius=16;
			}
		}
		Destroy();
}

defaultproperties
{
}
