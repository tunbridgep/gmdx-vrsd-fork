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

//SARGE: This was a HUGE switch written into both the players and NPCs PlayFootStep functions...
//Now it's here and generalised
static function Sound GetFootstepSound(Pawn P, Name FloorMaterial, Name FloorTexture, out float volumeMultiplier, out int bRainStep)
{
	local float rnd;
    local Sound stepSound;

    if (P == None)
        return None;

    bRainStep = 1;
	
    rnd = FRand();

	if (P.IsA('DeusExPlayer') && (P.IsInState('PlayerSwimming') || (P.Physics == PHYS_Swimming)))
	{
        bRainStep = 0;
		volumeMultiplier = 0.5;
		if (rnd < 0.5)
			stepSound = Sound'Swimming';
		else
			stepSound = Sound'Treading';
	}
	else if (P.FootRegion.Zone.bWaterZone)
	{
        bRainStep = 0;
		volumeMultiplier = 1.0;
		if (rnd < 0.33)
			stepSound = Sound'WaterStep1';
		else if (rnd < 0.66)
			stepSound = Sound'WaterStep2';
		else
			stepSound = Sound'WaterStep3';
	}
    if (FloorTexture == 'Marker' || FloorTexture == 'Marker_sky' || FloorTexture == 'FlufBlueCloud_A' || FloorTexture == 'metalgrate_a') //SARGE: Moved this out of the Metal check, to handle new special case for invisible walkways
    {
        bRainStep = 0; //SARGE: No splash effects on gratings
		volumeMultiplier = 0.9;
        if (rnd < 0.2)
            stepSound = Sound'GMDXSFX.Player.metal_grate_01';
        else if (rnd < 0.4)
            stepSound = Sound'GMDXSFX.Player.metal_grate_02';
        else if (rnd < 0.6)
            stepSound = Sound'GMDXSFX.Player.metal_grate_03';
        else if (rnd < 0.8)
            stepSound = Sound'GMDXSFX.Player.metal_grate_04';
        else
            stepSound = Sound'GMDXSFX.Player.metal_grate_05';
    }
	else
	{
		switch(FloorMaterial)
		{
			case 'Textile':
			case 'Paper':
				volumeMultiplier = 0.6;
				if (rnd < 0.25)
					stepSound = Sound'CarpetStep1';
				else if (rnd < 0.5)
					stepSound = Sound'CarpetStep2';
				else if (rnd < 0.75)
					stepSound = Sound'CarpetStep3';
				else
					stepSound = Sound'CarpetStep4';
				break;

                case 'Earth':
                volumeMultiplier = 0.8;
				if (rnd < 0.25)
					stepSound = Sound'DIRT1';
				else if (rnd < 0.5)
					stepSound = Sound'DIRT2';
				else if (rnd < 0.75)
					stepSound = Sound'DIRT3';
				else
					stepSound = Sound'DIRT4';
				break;

			case 'Foliage':
				volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'GrassStep1';
				else if (rnd < 0.5)
					stepSound = Sound'GrassStep2';
				else if (rnd < 0.75)
					stepSound = Sound'GrassStep3';
				else
					stepSound = Sound'GrassStep4';
				break;

			case 'Metal':
				volumeMultiplier = 0.9;
                if (FloorTexture == 'A51_Floor_01')
                {
                    if (rnd < 0.25)
                        stepSound = Sound'GRATE1';
                    else if (rnd < 0.5)
                        stepSound = Sound'GRATE2';
                    else if (rnd < 0.75)
                        stepSound = Sound'GRATE3';
                    else
                        stepSound = Sound'GRATE4';
                }
                else
                {
                    if (rnd < 0.25)
                        stepSound = Sound'MetalStep1';
                    else if (rnd < 0.5)
                        stepSound = Sound'MetalStep2';
                    else if (rnd < 0.75)
                        stepSound = Sound'MetalStep3';
                    else
                        stepSound = Sound'MetalStep4';
                }
				break;

			case 'Ladder':
				volumeMultiplier = 1.0;
                if (rnd < 0.25)
					stepSound = Sound'GRATE1';
				else if (rnd < 0.5)
					stepSound = Sound'GRATE2';
				else if (rnd < 0.75)
					stepSound = Sound'GRATE3';
				else
					stepSound = Sound'GRATE4';
                 break;

            case 'Glass':
                volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'GLASS1';
				else if (rnd < 0.5)
					stepSound = Sound'GLASS2';
				else if (rnd < 0.75)
					stepSound = Sound'GLASS3';
				else
					stepSound = Sound'GLASS4';
				break;

			case 'Ceramic':
			case 'Tiles':
				volumeMultiplier = 0.75;
				if (rnd < 0.25)
					stepSound = Sound'TileStep1';
				else if (rnd < 0.5)
					stepSound = Sound'TileStep2';
				else if (rnd < 0.75)
					stepSound = Sound'TileStep3';
				else
					stepSound = Sound'TileStep4';
				break;

			case 'Wood':
				volumeMultiplier = 0.825;
				if (FloorTexture == 'OldeOakPlank_A')
				{
				    if (rnd < 0.2)
			     		stepSound = Sound'GMDXSFX.Player.Wood_01';
				    else if (rnd < 0.4)
			     		stepSound = Sound'GMDXSFX.Player.Wood_02';
				    else if (rnd < 0.6)
			     		stepSound = Sound'GMDXSFX.Player.Wood_03';
			     	else if (rnd < 0.8)
			     		stepSound = Sound'GMDXSFX.Player.Wood_04';
			    	else
				    	stepSound = Sound'GMDXSFX.Player.Wood_05';
				}
				else
				{
			    	if (rnd < 0.25)
			     		stepSound = Sound'WoodStep1';
			       	else if (rnd < 0.5)
			        	stepSound = Sound'WoodStep2';
			       	else if (rnd < 0.75)
				       	stepSound = Sound'WoodStep3';
				    else
				       	stepSound = Sound'WoodStep4';
				}
                break;

            case 'Stucco':
                volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'CARDB1';
				else if (rnd < 0.5)
					stepSound = Sound'CARDB2';
				else if (rnd < 0.75)
					stepSound = Sound'CARDB3';
				else
					stepSound = Sound'CARDB4';
				break;

			case 'Brick':
			case 'Concrete':
                volumeMultiplier = 0.9;
				if (rnd < 0.25)
					stepSound = Sound'STEP1';
				else if (rnd < 0.5)
					stepSound = Sound'STEP2';
				else if (rnd < 0.75)
					stepSound = Sound'STEP3';
				else
					stepSound = Sound'STEP4';
				break;

			case 'Stone':
				volumeMultiplier = 0.8;
				if (rnd < 0.25)
					stepSound = Sound'GMDXSFX.Player.concrete_ct_01';
				else if (rnd < 0.5)
					stepSound = Sound'GMDXSFX.Player.concrete_ct_02';
				else if (rnd < 0.75)
					stepSound = Sound'GMDXSFX.Player.concrete_ct_03';
				else
					stepSound = Sound'GMDXSFX.Player.concrete_ct_04';
				break;
			default:
                    volumeMultiplier = 0.8;
					if (rnd < 0.25)
			    		stepSound = Sound'StoneStep1';
				    else if (rnd < 0.5)
			     		stepSound = Sound'StoneStep2';
			    	else if (rnd < 0.75)
			     		stepSound = Sound'StoneStep3';
			    	else
			     		stepSound = Sound'StoneStep4';
					break;
		}
    }
    return stepSound;
}

// ----------------------------------------------------------------------
// GetFloorMaterial()
//
// gets the name of the texture group that we are standing on
// ----------------------------------------------------------------------

static function GetFloorMaterial(Pawn P, out name texGroup, out name texName)
{
	local vector EndTrace, HitLocation, HitNormal;
	local actor target;
	local int texFlags;

	// trace down to our feet
	EndTrace = P.Location - P.CollisionHeight * 2 * vect(0,0,1);

	foreach P.TraceTexture(class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace)
	{
		if ((target == P.Level) || target.IsA('Mover'))
			break;
	}

    if (target != None && target.IsA('DeusExMover')) //CyberP: special case for movers.
    {
        if (target.IsA('BreakableGlass'))
            texGroup = 'Glass';
        else if (DeusExMover(target).FragmentClass == Class'DeusEx.WoodFragment')
            texGroup = 'Wood';
        else if (DeusExMover(target).FragmentClass == Class'DeusEx.MetalFragment')
            texGroup = 'Metal';
        else
            texGroup = 'Stucco';
    }
}
