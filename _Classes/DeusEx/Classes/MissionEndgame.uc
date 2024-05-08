//=============================================================================
// MissionEndgame.
//=============================================================================
class MissionEndgame extends MissionScript;

var byte savedSoundVolume;
var float endgameDelays[3];
var float endgameTimer;
var localized string endgameQuote[6];
var HUDMissionStartTextDisplay quoteDisplay;
var bool bQuotePrinted;

var name TarEndgameConvo; //LDDP, 11/3/21: Store this so we can execute once flags are here and ready.
var float DelayTimer;

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

	Super.FirstFrame();

	endgameTimer = 0.0;

	if (Player != None)
	{
		// Make sure all the flags are deleted
		TarEndgameConvo = 'Barf';
		DelayTimer = 0.05;
		
		//LDDP, 11/3/21: Barf.
		//Player.StartConversationByName(UseConvo, Player, False, True);.

		//DeusExRootWindow(Player.rootWindow).ResetFlags();

		// Start the conversation   //CyberP: here we also unlock hardcore mode + options
		if (localURL == "ENDGAME1")
		{
			//Player.StartConversationByName('Endgame1', Player, False, True);
			Player.ConsoleCommand("set" @ "DeusExPlayer bHardcoreUnlocked" @ "True");
            Player.ConsoleCommand("set" @ "JCDentonMale bHardcoreUnlocked" @ "True");
		}
		else if (localURL == "ENDGAME2")
		{
			//Player.StartConversationByName('Endgame2', Player, False, True);
			Player.ConsoleCommand("set" @ "DeusExPlayer bHardcoreUnlocked" @ "True");
            Player.ConsoleCommand("set" @ "JCDentonMale bHardcoreUnlocked" @ "True");
		}
		else if (localURL == "ENDGAME3")
		{
			//Player.StartConversationByName('Endgame3', Player, False, True);
			Player.ConsoleCommand("set" @ "DeusExPlayer bHardcoreUnlocked" @ "True");
            Player.ConsoleCommand("set" @ "JCDentonMale bHardcoreUnlocked" @ "True");
		}

		// turn down the sound so we can hear the speech
		savedSoundVolume = SoundVolume;
		SoundVolume = 32;
		Player.SetInstantSoundVolume(SoundVolume);
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
	SoundVolume = savedSoundVolume;
	Player.SetInstantSoundVolume(SoundVolume);
    Player.bHardcoreUnlocked = True;      //CyberP: unlock the options menu
	Super.PreTravel();
}

//Function added by LDDP
function Tick(float DT)
{
	local bool bFemale;
	local name UseConvo;
	
	Super.Tick(DT);
	
	//LDDP, 11/3/21: Barf, part 2.
	if (TarEndgameConvo == 'Barf')
	{
		if (DelayTimer > 0)
		{
			DelayTimer -= DT;
		}
		else
		{
			//LDDP, 10/26/21: Parse this on the fly, and reset flags AFTER playing the right conversation, NOT before.
			//if ((Player.FlagBase != None) && (Player.FlagBase.GetBool('LDDPJCIsFemale')))
			if ((Human(Player) != None) && (Human(Player).bMadeFemale))
			{
				bFemale = true;
			}
			
			// Start the conversation
			switch(LocalURL)
			{
				case "ENDGAME1":
					UseConvo = 'Endgame1';
					if (bFemale) UseConvo = 'FemJCEndgame1';
				break;
				case "ENDGAME2":
					UseConvo = 'Endgame2';
					if (bFemale) UseConvo = 'FemJCEndgame2';
				break;
				case "ENDGAME3":
					UseConvo = 'Endgame3';
					if (bFemale) UseConvo = 'FemJCEndgame3';
				break;
			}
			TarEndgameConvo = UseConvo;
			
			Player.StartConversationByName(TarEndgameConvo, Player, False, True);
			
			//LDDP, 11/3/21: Make sure all the flags are deleted, now that flags manager is here.
			DeusExRootWindow(Player.rootWindow).ResetFlags();
		}
	}
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
	Super.Timer();

	if (flags.GetBool('EndgameExplosions'))
		ExplosionEffects();

	// After the conversation finishes playing, print a quote, delay a
	// bit, then scroll the credits and then return to the DXOnly map
	if (flags.GetBool('Endgame1_Played'))
	{
		if (!bQuotePrinted)
			PrintEndgameQuote(0);

		endgameTimer += checkTime;

		if (endgameTimer > endgameDelays[0])
			FinishCinematic();
	}
	else if (flags.GetBool('Endgame2_Played'))
	{
		if (!bQuotePrinted)
			PrintEndgameQuote(1);

		endgameTimer += checkTime;

		if (endgameTimer > endgameDelays[1])
			FinishCinematic();
	}
	else if (flags.GetBool('Endgame3_Played'))
	{
		if (!bQuotePrinted)
			PrintEndgameQuote(2);

		endgameTimer += checkTime;

		if (endgameTimer > endgameDelays[2])
			FinishCinematic();
	}
}

// ----------------------------------------------------------------------
// FinishCinematic()
// ----------------------------------------------------------------------

function FinishCinematic()
{
	local CameraPoint cPoint;

	if (quoteDisplay != None)
	{
		quoteDisplay.Destroy();
		quoteDisplay = None;
	}

	// Loop through all the CameraPoints and set the "nextPoint"
	// to None will will effectively cause them to halt.
	// This prevents the screen from fading while the credits are rolling.

	foreach player.AllActors(class'CameraPoint', cPoint)
		cPoint.nextPoint = None;

	flags.SetBool('EndgameExplosions', False);
	SetTimer(0, False);
	Player.ShowCredits(True);
}

// ----------------------------------------------------------------------
// PrintEndgameQuote()
// ----------------------------------------------------------------------

function PrintEndgameQuote(int num)
{
	local int i;
	local DeusExRootWindow root;

	bQuotePrinted = True;
	flags.SetBool('EndgameExplosions', False);

	root = DeusExRootWindow(Player.rootWindow);
	if (root != None)
	{
		quoteDisplay = HUDMissionStartTextDisplay(root.NewChild(Class'HUDMissionStartTextDisplay', True));
		if (quoteDisplay != None)
		{
			quoteDisplay.displayTime = endgameDelays[num];
			quoteDisplay.SetWindowAlignments(HALIGN_Center, VALIGN_Center);

			for (i=0; i<2; i++)
				quoteDisplay.AddMessage(endgameQuote[2*num+i]);

			quoteDisplay.StartMessage();
		}
	}
}

// ----------------------------------------------------------------------
// ExplosionEffects()
// ----------------------------------------------------------------------

function ExplosionEffects()
{
	local float size;
	local int i;
	local Vector loc, endloc, HitLocation, HitNormal;
	local Actor HitActor;
	local MetalFragment frag;

	if (FRand() < 0.8)
	{
		// pick a random explosion size and modify everything accordingly
		size = FRand();

		// play a sound
		if (size < 0.5)
			Player.PlaySound(Sound'LargeExplosion1', SLOT_None, 2.0,, 16384);
		else
			Player.PlaySound(Sound'LargeExplosion2', SLOT_None, 2.0,, 16384);

		// have random metal fragments fall from the ceiling
		if (FRand() < 0.8)
		{
			for (i=0; i<Int(size*10.0); i++)
			{
				loc = Player.Location + 512.0 * VRand();
				loc.Z = Player.Location.Z;
				endloc = loc;
				endloc.Z += 1024.0;
				HitActor = Trace(HitLocation, HitNormal, endloc, loc, False);
				if (HitActor == None)
					HitLocation = endloc;

				// spawn some explosion effects
				if (size < 0.5)
					Spawn(class'ExplosionMedium',,, HitLocation+8*HitNormal);
				else
					Spawn(class'ExplosionLarge',,, HitLocation+8*HitNormal);

				if (FRand() < 0.5)
				{
					frag = Spawn(class'MetalFragment',,, HitLocation);
					if (frag != None)
					{
						frag.CalcVelocity(vect(20000,0,0),256);
						frag.DrawScale = 0.5 + 2.0 * FRand();
						if (FRand() < 0.75)
							frag.bSmoking = True;
					}
				}
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     endgameDelays(0)=13.000000
     endgameDelays(1)=13.500000
     endgameDelays(2)=10.500000
     endgameQuote(0)="YESTERDAY WE OBEYED KINGS AND BENT OUR NECKS BEFORE EMPERORS.  BUT TODAY WE KNEEL ONLY TO TRUTH..."
     endgameQuote(1)="    -- KAHLIL GIBRAN"
     endgameQuote(2)="IF THERE WERE NO GOD, IT WOULD BE NECESSARY TO INVENT HIM."
     endgameQuote(3)="    -- VOLTAIRE"
     endgameQuote(4)="BETTER TO REIGN IN HELL, THAN SERVE IN HEAVEN."
     endgameQuote(5)="    -- PARADISE LOST, JOHN MILTON"
}
