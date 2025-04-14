//=============================================================================
// MissionIntro.
//=============================================================================
class MissionIntro extends MissionScript;

// ----------------------------------------------------------------------
// InitStateMachine()
// ----------------------------------------------------------------------

function InitStateMachine()
{
	Super.InitStateMachine();

	// Destroy all flags!
	if (flags != None)
		flags.DeleteAllFlags();

	// Set the PlayerTraveling flag (always want it set for 
	// the intro and endgames)
	flags.SetBool('PlayerTraveling', True, True, 0);
}

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local BobPage bob;
    local DeusExCarcass C;

	Super.FirstFrame();

	if (player != None)
	{
		// Make sure all the flags are deleted.
		DeusExRootWindow(Player.rootWindow).ResetFlags();

		// Find our buddy Bob, because he has the conversation!
		foreach AllActors(class'BobPage', bob)
			break;

		if (bob != None)
		{
			// Start the conversation
			player.StartConversationByName('Intro', bob, False, True);
		}

		// turn down the sound so we can hear the speech
        SetMinimumVolume();

        //SARGE: Make the corpses not bleed anymore (except for the thug in the Paris scene)
        Foreach AllActors(class'DeusExCarcass', C)
        {
            If (!C.IsA('ThugMaleCarcass'))
                C.DestroyPool();
        }
	}
}

// ----------------------------------------------------------------------
// PreTravel()
// 
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------

function PreTravel()
{
	// restore the sound volume
    RestorePreviousVolume();

	Super.PreTravel();
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
	Super.Timer();

	// After the Intro conversation is over, tell the player to go on
	// to the next map (which will either be the main menu map or 
	// the first game mission if we're starting a new game.

	if (flags.GetBool('Intro_Played'))
	{
		flags.SetBool('Intro_Played', False,, 1);
		player.PostIntro();
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
