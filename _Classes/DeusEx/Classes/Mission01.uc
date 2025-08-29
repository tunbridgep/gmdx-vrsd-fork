//=============================================================================
// Mission01.
//=============================================================================
class Mission01 expands MissionScript;

var bool bDoneConversationFix;

// ----------------------------------------------------------------------
// FirstFrame()
//
// Stuff to check at first frame
// ----------------------------------------------------------------------

//Reduce Paul's starting weapon choice dialog.
//ENGLISH ONLY!
//Based on the DX Rando code
function ReducePaulDialog()
{
    local Conversation C;
    local ConEvent E, before, after;
    local ConEventSpeech S;
        
    if (!player.bNoStartingWeaponChoices) //SARGE: Check for the no starting weapons modifier
        return;

    C = GetConversation('MeetPaul');
    E = C.eventList;

    while (E != None)
    {
        if (E.eventType == ET_Speech)
        {
            S = ConEventSpeech(E);
            if (InStr(S.conSpeech.speech,"NSF took one of our agents hostage") != -1)
            {
                before = E;
            }
            if (InStr(S.conSpeech.speech,"Great.  What's the first move?") != -1)
            {
                after = E;
            }
            if (before != None && after != None)
            {
                break;
            }
        }
        E = E.nextEvent;
    }

    //Just in case something went wrong
    if (before != None && after != None)
    {
        before.nextEvent = after;
    }
}

function FirstFrame()
{
	local CrateBreakableMedCombat LaserCrate;
	local PaulDenton Paul;
	local UNATCOTroop troop;
	local TerroristCommander cmdr;
	local newspaper N;
	local vector v;
	local Female2 Shannon;
    local ScriptedPawn SP;

	Super.FirstFrame();

	if (localURL == "01_NYC_UNATCOISLAND")
	{
        //SARGE: If hardcore mode, swap out the laser sight
        //for the recoil mod.
        if (player.bHardcoreMode)
        {
            foreach AllActors(class'CrateBreakableMedCombat', LaserCrate, 'LaserCrate')
                if (LaserCrate.Contents == class'WeaponModLaser') //Make sure we haven't been randomised
                    LaserCrate.Contents = class'WeaponModRecoil';
        }

		// delete Paul and company after final briefing
		if (flags.GetBool('M02Briefing_Played'))
		{
			foreach AllActors(class'PaulDenton', Paul)
				Paul.Destroy();
			foreach AllActors(class'UNATCOTroop', troop, 'custodytroop')
				troop.Destroy();
			foreach AllActors(class'TerroristCommander', cmdr, 'TerroristCommander')
				cmdr.Destroy();
		}

	}
	//DDL added to fix a newspaper that gets destroyed by JC's door
	if(localURL == "01_NYC_UNATCOHQ")
	{
		foreach allactors(Class'Newspaper', N)
		{
			if(N.name == 'Newspaper1')
			{
				V = N.location;
				V.X -= 1;      //CyberP: was 50. I moved the paper.
				N.setlocation(V);
				break;
			}
		}
	}
	//GotoState('QuickSaver');
	CanQuickSave=true;

//      player.SaveGame(-3, "Auto Save"); //Lork: Autosave after loading a new map... this saves lives!
}



// ----------------------------------------------------------------------
// PreTravel()
//
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------

function PreTravel()
{
	Super.PreTravel();
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
	local Terrorist T;
	local TerroristCarcass carc;
	local ScriptedPawn P;
	local SpawnPoint SP;
	local DeusExMover M;
	local PaulDenton Paul;
	local AutoTurret turret;
	local LaserTrigger laser;
	local SecurityCamera cam;
	local int count;
	local Inventory item, nextItem;

	Super.Timer();

	if (localURL == "01_NYC_UNATCOISLAND")
	{
        //Fix conversations
        //This has to be done every time we restart the game.
        if (!bDoneConversationFix)
        {
            ReducePaulDialog();

            // "the NSF have set up patchwork security systems here"
            GetConversation('DL_FrontEntrance').AddFlagRef('GMDXNoTutorials', false);
            // "The NSF has a security bot on patrol..."
            //GetConversation('DL_FrontEntranceBot').AddFlagRef('GMDXNoTutorials', false);
            // "you might be able to avoid some of the security by entering this way"
            GetConversation('DL_BackEntrance').AddFlagRef('GMDXNoTutorials', false);
            // "NSF everywhere, JC.  Your orders are to shoot on sight."
            //GetConversation('DL_LeaveDockNoGun').AddFlagRef('GMDXNoTutorials', false);
            // "If you want to make a covert approach, remember the academy's stealth course..."
            GetConversation('DL_GameplayIntro').AddFlagRef('GMDXNoTutorials', false);
            bDoneConversationFix = true;
        }


        //SARGE: Dodgy hack to fix Paul being repeatable
        if (player.bNoStartingWeaponChoices && flags.GetBool('MeetPaul_Played') && !flags.GetBool('PaulGaveWeapon'))
            flags.SetBool('PaulGaveWeapon', True,, 2);


		// count the number of dead terrorists
		if (!flags.GetBool('M01PlayerAggressive'))
		{
			count = 0;
		
            //SARGE: Our reputation as a killer spreads quickly...
            if (flags.GetBool('KaplanLikesPlayer'))
                count -= 1;

			// count the living
			foreach AllActors(class'Terrorist', T)
				count++;

			// add the unconscious ones to the not dead count
			// there are 28 terrorists total on the island
			foreach AllActors(class'TerroristCarcass', carc)
			{
				if (carc.bNotDead)//((carc.KillerBindName == "JCDenton") && (carc.itemName == "Unconscious"))
					count++;
				else if (carc.KillerBindName != "JCDenton")
					count++;
			}

			// if the player killed more than 5, set the flag
			if (count < 23)
				flags.SetBool('M01PlayerAggressive', True,, 6);		// don't expire until mission 6
		}

		// check for the leader being killed
		if (!flags.GetBool('MS_DL_Played'))
		{
			if (flags.GetBool('TerroristCommander_Dead'))
			{
				if (!flags.GetBool('DL_LeaderNotKilled_Played'))
					Player.StartDataLinkTransmission("DL_LeaderKilled");
				else
					Player.StartDataLinkTransmission("DL_LeaderKilledInSpite");

				flags.SetBool('MS_DL_Played', True,, 2);
			}
		}

		// check for player not killing leader
		if (!flags.GetBool('PlayerAttackedStatueTerrorist') &&
			flags.GetBool('MeetTerrorist_Played') &&
			!flags.GetBool('MS_DL2_Played'))
		{
			Player.StartDataLinkTransmission("DL_LeaderNotKilled");
			flags.SetBool('MS_DL2_Played', True,, 2);
		}

		// remove guys and move Paul
		if (!flags.GetBool('MS_MissionComplete'))
		{
			if (flags.GetBool('StatueMissionComplete'))
			{
				// open the HQ blast doors and unlock some other doors
				foreach AllActors(class'DeusExMover', M)
				{
					if (M.Tag == 'UN_maindoor')
					{
						M.bLocked = False;
						M.lockStrength = 0.0;
						M.Trigger(None, None);
					}
					else if ((M.Tag == 'StatueRuinDoors') || (M.Tag == 'temp_celldoor'))
					{
						M.bLocked = False;
						M.lockStrength = 0.0;
					}
				}

				// unhide the troop, delete the terrorists, Gunther, and teleport Paul
				foreach AllActors(class'ScriptedPawn', P)
				{
					if (P.IsA('UNATCOTroop') && (P.BindName == "custodytroop"))
						P.EnterWorld();
					else if (P.IsA('UNATCOTroop') && (P.BindName == "postmissiontroops"))
						P.EnterWorld();
					else if (P.IsA('UNATCOTroop') && (P.BindName == "PrivateLloyd"))
                        P.EnterWorld();
					else if (P.IsA('ThugMale2') || P.IsA('SecurityBot3') || P.IsA('Doberman')) //CyberP: Get rid of the doberman
						P.Destroy();
					else if (P.IsA('Terrorist') && (P.BindName != "TerroristCommander"))
					{
						// actually kill the terrorists instead of destroying them
						P.HealthTorso = 0;
						P.Health = 0;
						P.TakeDamage(1, P, P.Location, vect(0,0,0), 'Shot');

						// delete their inventories as well
						if (P.Inventory != None)
						{
							do
							{
								item = P.Inventory;
								nextItem = item.Inventory;
								P.DeleteInventory(item);
								item.Destroy();
								item = nextItem;
							}
							until (item == None);
						}
					}
					else if (P.BindName == "GuntherHermann")
						P.Destroy();
					else if (P.BindName == "PaulDenton")
					{
						SP = GetSpawnPoint('PaulTeleport');
						if (SP != None)
						{
							P.SetLocation(SP.Location);
							P.SetRotation(SP.Rotation);
							P.SetOrders('Standing',, True);
							P.SetHomeBase(SP.Location, SP.Rotation);
						}
					}
				}

				// delete all tagged turrets
				foreach AllActors(class'AutoTurret', turret)
					if ((turret.Tag == 'NSFTurret01') || (turret.Tag == 'NSFTurret02'))
						turret.Destroy();

				// delete all tagged lasertriggers  //CyberP: just delete all laser triggers.
				foreach AllActors(class'LaserTrigger', laser)//, 'statue_lasertrap')
					laser.Destroy();

				// turn off all tagged cameras
				foreach AllActors(class'SecurityCamera', cam)
					if ((cam.Tag == 'NSFCam01') || (cam.Tag == 'NSFCam02') || (cam.Tag == 'NSFCam03'))
						cam.bNoAlarm = True;

				flags.SetBool('MS_MissionComplete', True,, 2);
			}
		}
	}
	else if (localURL == "01_NYC_UNATCOHQ")
	{
		// unhide Paul
		if (!flags.GetBool('MS_ReadyForBriefing'))
		{
			if (flags.GetBool('M01ReadyForBriefing'))
			{
				foreach AllActors(class'PaulDenton', Paul)
					Paul.EnterWorld();

				flags.SetBool('MS_ReadyForBriefing', True,, 2);
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
