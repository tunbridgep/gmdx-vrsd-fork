//=============================================================================
// BreakableGlass.
//=============================================================================
class BreakableGlass expands DeusExMover;

var() bool ParisUndergroundHack;

//SARGE: Added "Left Click Frob" and "Right Click Frob" support
//Simply pull out a melee weapon
function bool DoLeftFrob(DeusExPlayer frobber)
{
    frobber.SelectMeleePriority(minDamageThreshold);
    return false;
}

function BlowItUp(Pawn instigatedBy)
{
    local ScriptedPawn P;
    local DeusExPlayer Player;
    local Actor A;

    if (ParisUndergroundHack)
    {
        Player = DeusExPlayer(GetPlayerPawn());

        if (Player != None && !class'DeusExPlayer'.default.bCloakEnabled && !Player.bIsCloaked)
        {
            ForEach Player.RadiusActors(class'ScriptedPawn',P,2048)
            {
                if (P.LineOfSightTo(Player))
                {
                    if (Event != '')
	                	foreach AllActors(class'Actor', A, Event)
		             	if (A != None)
		              		A.Trigger(Self, instigatedBy);
                }
            }
         }
    }
    super.BlowItUp(instigatedBy);
}

defaultproperties
{
     bPickable=False
     bBreakable=True
     doorStrength=0.100000
     bHighlight=False
     bFrobbable=False
     minDamageThreshold=3
     NumFragments=30
     FragmentScale=0.750000
     FragmentClass=Class'DeusEx.GlassFragment'
     bFragmentTranslucent=True
     ExplodeSound1=Sound'DeusExSounds.Generic.GlassBreakSmall'
     ExplodeSound2=Sound'DeusExSounds.Generic.GlassBreakLarge'
     bBlockSight=False
     bOwned=True
}
