//=============================================================================
// SARGE: Pawn Utils
// Functions to assist with managing Pawns
//=============================================================================
class PawnUtils extends Object abstract;

//SARGE: Wake up all the AI in a radius.
//Otherwise, they go into stasis when they haven't been seen in a while.
//This allows things like sound propagation to actually work properly.
//This is the hackiest hack that ever hacked.
//NOT FOR THE FEINT OF HEART!
static function WakeUpAI(Actor S, float radius)
{
    local ScriptedPawn SP;
    local Pawn P;
	local DeusExLevelInfo info;
    local DeusExPlayer PL;
        
    if (S == None)
        return;
	
    PL = DeusExPlayer(S);
    if (PL == None)
        PL = DeusExPlayer(S.GetPlayerPawn());

    if (PL == None || !PL.bEnhancedSoundPropagation)
        return;

    info = PL.GetLevelInfo();

    for (P = S.Level.PawnList; P != None; P = P.NextPawn)
    {
        SP = ScriptedPawn(P);

        if (SP == None)
            continue;

        if (SP.InStasis() && SP.bInWorld && VSize(SP.Location - S.Location) <= radius * info.SoundPropagationMult)
            SP.lastRendertime = S.Level.TimeSeconds;
    }
}
