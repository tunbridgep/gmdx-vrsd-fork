//=============================================================================
// Mission04.
//=============================================================================
class Mission04 expands MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
//
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local ScriptedPawn pawn;
	local PaulDenton paul;
	local FlagTrigger ftrig;
	local int count;

	if(flags.GetBool('PaulDenton_Dead') && !flags.GetBool('TalkedToPaulAfterMessage')) //== Paul CANNOT die before the raid, period
		flags.SetBool('PaulDenton_Dead',False,, 16);  //CyberP: now checks until talked to paul after message

	if(flags.GetBool('PlayerBailedOutWindow') && !flags.GetBool('PaulDenton_Dead')) //CyberP: only check if paul isn't already dead.
	{
		if(flags.GetBool('M04_Hotel_Cleared'))
			flags.SetBool('PlayerBailedOutWindow', False,, 0);
		else
			flags.SetBool('PaulDenton_Dead', True,, 16);
	}

	Super.FirstFrame();

	if (localURL == "04_NYC_STREET")
	{
		// unhide a bunch of stuff on this flag
		if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn)
				if (pawn.IsA('UNATCOTroop') || pawn.IsA('SecurityBot2'))
					pawn.EnterWorld();
		}
	}
	/*else if (localURL == "04_NYC_FREECLINIC")
	{
		// unhide a bunch of stuff on this flag
		if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn)
				if (pawn.IsA('UNATCOTroop'))
					pawn.EnterWorld();
		}
	}*/
	else if (localURL == "04_NYC_HOTEL")
	{
		// unhide the correct JoJo
		if (flags.GetBool('SandraRenton_Dead') ||
			flags.GetBool('GilbertRenton_Dead'))
		{
			if (!flags.GetBool('JoJoFine_Dead') && !flags.GetBool('MS_JoJoUnhidden'))
			{
				foreach AllActors(class'ScriptedPawn', pawn, 'JoJoInLobby')
					pawn.EnterWorld();

				flags.SetBool('MS_JoJoUnhidden', True,, 5);
			}
		}

		if(!flags.GetBool('M04RaidTeleportDone') && !flags.GetBool('PaulDenton_Dead'))
		{
			// Lesson the first: Paul should never leave until AFTER the raid
			count = 0;
			foreach AllActors(Class'PaulDenton', paul)
			{
				paul.EnterWorld();
				count++;
			}

			//== Lesson the second: Paul shouldn't be able to die
			if(count == 0)
			{
				log("EPIC FAIL!  Paul is dead, you lose.  Sadness consumes your soul and the air is fraught with the wailings and lamentations of your women.");
				paul = Spawn(class'PaulDenton', None,, vect(-359.133942, -2919.048584, 112.233070));
				paul.Orders = 'Sitting';
				paul.bHateCarcass = False;
				paul.bHateDistress = False;
				paul.bHateShot = False;
				paul.Event = 'FlagTriggerP';
				paul.Alliance = 'PaulDenton';
				paul.bInvincible = False;
			}
		}
		//== Let's get rid of the damn auto-kill flag so we can intelligently track whether or not Paul is dead.
		if(!flags.GetBool('M04_Paul_Check_Fixed'))
		{
			foreach AllActors(Class'FlagTrigger', ftrig)
			{
				if(ftrig.flagName == 'PaulDenton_Dead' && ftrig.flagValue)
				{
					ftrig.bSetFlag = False;
					flags.SetBool('M04_Paul_Check_Fixed', True,, 6);
				}
			}
		}
	}

CanQuickSave=true;
}

// ----------------------------------------------------------------------
// PreTravel()
//
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------

function PreTravel()
{
	local int count;
	local MIB mblack;
	local UNATCOTroop troop;
	local PaulDenton paul;

	// If the hotel is clear of hostiles when the player leaves through the window,
	//  remove the "Player Bailed" flag so Paul doesn't wind up dead anyway
	if (localURL == "04_NYC_HOTEL" && flags.GetBool('M04RaidTeleportDone'))
	{
		count = 1;

		foreach AllActors(Class'PaulDenton', paul)
		{
			//== If Paul has left the building, or if he acts like he's safe, he's safe
			if((paul.bHidden || flags.GetBool('M04RaidDone')) && !flags.GetBool('PaulDenton_Dead') )  //cyberp
				count = 0;
		}

		if(count > 0)
		{
			count = 0;
			foreach AllActors(Class'UNATCOTroop', troop)
			{
				if(troop.bHidden == False)
					count++;
			}

			foreach AllActors(Class'MIB', mblack)
			{
				if(mblack.bHidden == False)
					count += 2;
			}
		}

		if(count <= 0)
		{
			flags.SetBool('M04_Hotel_Cleared', True,, 6);
			flags.SetBool('PlayerBailedOutWindow', False,, 0);
			if (!flags.GetBool('PaulDenton_Dead') )
            flags.SetBool('PaulDenton_Dead', False,, 16);
		}
		else
			flags.SetBool('M04_Hotel_Cleared', False,, 6);
	}

	else if(localURL == "04_NYC_BATTERYPARK")
	{
        ClearBelt();
	}

	Super.PreTravel();
}

//== For looks, let's remove the items from the player's belt
//==  before they get sent to MJ12 HQ, rather than after.
//==  (the items are still in inventory though)
function ClearBelt()
{
    local int count;
    for(count=0; count < 10; count++)
    {
        if(DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem() != None && !DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem().IsA('NanoKeyRing'))
        {
            DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem().bInObjectBelt = False;
            DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem().beltPos = -1;
        }
    }
    //player.assignedWeapon = None;
    //player.primaryWeapon = None;
    DeusExRootWindow(Player.rootWindow).hud.belt.ClearBelt();
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
	local ScriptedPawn pawn;
	local SatelliteDish dish;
	local SandraRenton Sandra;
	local GilbertRenton Gilbert;
	local GilbertRentonCarcass GilbertCarc;
	local SandraRentonCarcass SandraCarc;
	local UNATCOTroop troop;
	local Actor A;
	local PaulDenton Paul;
	local FordSchick Ford;
    local int count;

	Super.Timer();

	// do this for every map in this mission
	// if the player is "killed" after a certain flag, he is sent to mission 5
	if (!flags.GetBool('MS_PlayerCaptured') && localURL != "04_NYC_UNDERGROUND") //CyberP: die in the sewers, dead permanently
	{
		if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
		{
		    //cyberP: beware lazy timer hack. I'm sorry. Also player no longer is captured if gibbed.
			if (Player.IsInState('Dying') && Player.HeadRegion.Zone.ViewFog.X > 0.01 && Player.Health > -40)
			{
				flags.SetBool('MS_PlayerCaptured', True,, 5);

				//CyberP: Paul dies if the player is captured in the hotel while some troops are remaining.
                //CyberP: if there are less than five, he survives as we can assume he can defend himself against that amount.
				if (!flags.GetBool('PaulDenton_Dead') && localURL == "04_NYC_HOTEL")
                {
				    foreach AllActors(class'UNATCOTroop',troop)
                    {
				       count++;
				    }
                    if (count > 8 - int(Player.CombatDifficulty))
                       flags.SetBool('PaulDenton_Dead',True,,16);
                }

                ClearBelt();
				Player.GoalCompleted('EscapeToBatteryPark');
				Level.Game.SendPlayer(Player, "05_NYC_UNATCOMJ12Lab?Difficulty="$Player.combatDifficulty);
			}
		}
	}

	if (localURL == "04_NYC_HOTEL")
	{
		// check to see if the player has killed either Sandra or Gilbert
		if (!flags.GetBool('PlayerKilledRenton'))
		{
			count = 0;
			foreach AllActors(class'SandraRenton', Sandra)
				count++;

			foreach AllActors(class'GilbertRenton', Gilbert)
				count++;

			foreach AllActors(class'SandraRentonCarcass', SandraCarc)
				if (SandraCarc.KillerBindName == "JCDenton")
					count = 0;

			foreach AllActors(class'GilbertRentonCarcass', GilbertCarc)
				if (GilbertCarc.KillerBindName == "JCDenton")
					count = 0;

			if (count < 2)
			{
				flags.SetBool('PlayerKilledRenton', True,, 5);
				foreach AllActors(class'Actor', A, 'RentonsHatePlayer')
					A.Trigger(Self, Player);
			}
		}

        if (flags.GetBool('M04RaidDone') && flags.GetBool('M04RaidTeleportDone'))
        {
           foreach AllActors(class'PaulDenton', paul)
           {
           paul.HomeTag = '';
           paul.bDefendHome = False;
           }
        }

		if (!flags.GetBool('TalkedToPaulAfterMessage_Played') &&
			flags.GetBool('ApartmentEntered'))
		{
			if (flags.GetBool('NSFSignalSent'))
			{
			    if (!flags.GetBool('M04RaidTeleportDone'))
				{
                 foreach AllActors(class'ScriptedPawn', pawn)
				 {
					if (pawn.IsA('UNATCOTroop') || pawn.IsA('MIB'))
						pawn.EnterWorld();
					else if (pawn.IsA('SandraRenton') || pawn.IsA('GilbertRenton') || pawn.IsA('HarleyFilben'))
						pawn.LeaveWorld();
			     }
                }
				foreach AllActors(class'PaulDenton', Paul)
				{
                    //LDDP, 11/3/2021 Call the FemJC version of the convo if JC is female	
            		if (flags.GetBool('LDDPJCIsFemale'))
			    		Player.StartConversationByName('FemJCTalkedToPaulAfterMessage', Paul, False, False);
                    else
			    		Player.StartConversationByName('TalkedToPaulAfterMessage', Paul, False, False);
					break;
				}

				flags.SetBool('M04RaidTeleportDone', True,, 5);
			}
		}

		// Sometimes the game gets a little... goofy on tracking if you're in the apartment
		else if (!flags.GetBool('M04RaidTeleportDone') && !flags.GetBool('ApartmentEntered'))
		{
			if(flags.GetBool('NSFSignalSent'))
			{
				foreach AllActors(class'PaulDenton', Paul)
				{
					count = Abs(VSize(Player.Location - Paul.Location));
					if(count < 120 && Player.Location.X > -410.000000 && Player.Location.Y > -2990.000000)
						flags.SetBool('ApartmentEntered', True,, 5);
				}
			}
		}

		// make the MIBs mortal
		if (!flags.GetBool('MS_MIBMortal'))
		{
			if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
			{
				foreach AllActors(class'ScriptedPawn', pawn)
					if (pawn.IsA('MIB'))
						pawn.bInvincible = False;

                foreach AllActors(class'PaulDenton', paul) //CyberP: set paul vulnerable after speaking.
                   { if (paul.bInvincible)
                     {
                        paul.bInvincible = False;
                        paul.SetOrders('Standing',, True);
                        paul.bKeepWeaponDrawn = True;
                        paul.MinHealth = 0.0;
                     }
                     //if (paul == None)
                     //flags.SetBool('PaulDenton_Dead', True,,0);
                    }

				flags.SetBool('MS_MIBMortal', True,, 5);
			}
		}

		// unhide the correct JoJo
		if (!flags.GetBool('MS_JoJoUnhidden') &&
			(flags.GetBool('SandraWaitingForJoJoBarks_Played') ||
			flags.GetBool('GilbertWaitingForJoJoBarks_Played')))
		{
			if (!flags.GetBool('JoJoFine_Dead'))
			{
				foreach AllActors(class'ScriptedPawn', pawn, 'JoJoUpstairs')
					pawn.EnterWorld();

				flags.SetBool('MS_JoJoUnhidden', True,, 5);
			}
		}

		// unhide the correct JoJo
		if (!flags.GetBool('MS_JoJoUnhidden') &&
			(flags.GetBool('M03OverhearSquabble_Played') &&
			!flags.GetBool('JoJoOverheard_Played') &&
			flags.GetBool('JoJoEntrance')))
		{
			if (!flags.GetBool('JoJoFine_Dead'))
			{
				foreach AllActors(class'ScriptedPawn', pawn, 'JoJoUpstairs')
					pawn.EnterWorld();

				flags.SetBool('MS_JoJoUnhidden', True,, 5);
			}
		}

		// trigger some stuff based on convo flags
		if (flags.GetBool('JoJoOverheard_Played') && !flags.GetBool('MS_JoJo1Triggered'))
		{
			if (flags.GetBool('GaveRentonGun'))
			{
				foreach AllActors(class'Actor', A, 'GilbertAttacksJoJo')
					A.Trigger(Self, Player);
			}
			else
			{
				foreach AllActors(class'Actor', A, 'JoJoAttacksGilbert')
					A.Trigger(Self, Player);
			}

			flags.SetBool('MS_JoJo1Triggered', True,, 5);
		}

		// trigger some stuff based on convo flags
		if (flags.GetBool('JoJoAndSandraOverheard_Played') && !flags.GetBool('MS_JoJo2Triggered'))
		{
			foreach AllActors(class'Actor', A, 'SandraLeaves')
				A.Trigger(Self, Player);

			flags.SetBool('MS_JoJo2Triggered', True,, 5);
		}

		// trigger some stuff based on convo flags
		if (flags.GetBool('JoJoAndGilbertOverheard_Played') && !flags.GetBool('MS_JoJo3Triggered'))
		{
			foreach AllActors(class'Actor', A, 'JoJoAttacksGilbert')
				A.Trigger(Self, Player);

			flags.SetBool('MS_JoJo3Triggered', True,, 5);
		}
	}
	else if (localURL == "04_NYC_NSFHQ")
	{
		// rotate the dish when the computer sets the flag
		if (!flags.GetBool('MS_Dish1Rotated'))
		{
			if (flags.GetBool('Dish1InPosition'))
			{
				foreach AllActors(class'SatelliteDish', dish, 'Dish1')
					dish.DesiredRotation.Yaw = 49152;

				flags.SetBool('MS_Dish1Rotated', True,, 5);
			}
		}

		// rotate the dish when the computer sets the flag
		if (!flags.GetBool('MS_Dish2Rotated'))
		{
			if (flags.GetBool('Dish2InPosition'))
			{
				foreach AllActors(class'SatelliteDish', dish, 'Dish2')
					dish.DesiredRotation.Yaw = 0;

				flags.SetBool('MS_Dish2Rotated', True,, 5);
			}
		}

		// rotate the dish when the computer sets the flag
		if (!flags.GetBool('MS_Dish3Rotated'))
		{
			if (flags.GetBool('Dish3InPosition'))
			{
				foreach AllActors(class'SatelliteDish', dish, 'Dish3')
					dish.DesiredRotation.Yaw = 16384;

				flags.SetBool('MS_Dish3Rotated', True,, 5);
			}
		}

		// set a flag when all dishes are rotated
		if (!flags.GetBool('CanSendSignal'))
		{
			if (flags.GetBool('Dish1InPosition') &&
				flags.GetBool('Dish2InPosition') &&
				flags.GetBool('Dish3InPosition'))
				flags.SetBool('CanSendSignal', True,, 5);
		}

		// count non-living troops
		if (!flags.GetBool('MostWarehouseTroopsDead'))
		{
			count = 0;
			foreach AllActors(class'UNATCOTroop', troop)
				count++;

			// if two or less are still alive
			if (count <= 2)
				flags.SetBool('MostWarehouseTroopsDead', True);
		}
	}
	else if(localURL == "04_NYC_SMUG")
	{
		if(flags.getBool('FordSchickRescued'))
		{
			if(!flags.getBool('M04_FordShick_Appeared'))
			{
				foreach AllActors(class'FordSchick', Ford)
				{
					Ford.EnterWorld();
					flags.SetBool('M04_FordSchick_Appeared', True,, 5);
				}
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
