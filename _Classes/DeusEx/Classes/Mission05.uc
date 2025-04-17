//=============================================================================
// Mission05.
//=============================================================================
class Mission05 extends MissionScript;

var bool bRescuedMiguel;
// ----------------------------------------------------------------------
// FirstFrame()
//
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local PaulDentonCarcass carc;
	local PaulDenton Paul;
	local Terrorist T;
	local Inventory item, nextItem;
	local SpawnPoint SP;
	local AnnaNavarre Anna;
    local ammocrate crate;                                                      //RSD: Added an ammo crate to store all the player's ammo (new behavior in SP for that class)
    local Ammo Ammotype;
    local int ammoCount;

	Super.FirstFrame();

	if (localURL == "05_NYC_UNATCOMJ12LAB")
	{
		// make sure this goal is completed
		Player.GoalCompleted('EscapeToBatteryPark');
		// delete Paul's carcass if he's still alive
		if (!flags.GetBool('PaulDenton_Dead'))
		{
			foreach AllActors(class'PaulDentonCarcass', carc)
				carc.Destroy();
		}

		// if the player has already talked to Paul, delete him
		if (flags.GetBool('M05PaulDentonDone') ||
			flags.GetBool('PlayerBailedOutWindow'))
		{
			foreach AllActors(class'PaulDenton', Paul)
				Paul.Destroy();
		}

		// if Miguel is not following the player, delete him
		if (flags.GetBool('MeetMiguel_Played') &&
			!flags.GetBool('MiguelFollowing'))
		{
			foreach AllActors(class'Terrorist', T)
				if (T.BindName == "Miguel")
					T.Destroy();
		}

		// remove the player's inventory and put it in a room
		// also, heal the player up to 50% of his total health
		if (!flags.GetBool('MS_InventoryRemoved'))
		{
			Player.HealthHead = Max(50, Player.HealthHead);
			Player.HealthTorso =  Max(50, Player.HealthTorso);
			Player.HealthLegLeft =  Max(50, Player.HealthLegLeft);
			Player.HealthLegRight =  Max(50, Player.HealthLegRight);
			Player.HealthArmLeft =  Max(50, Player.HealthArmLeft);
			Player.HealthArmRight =  Max(50, Player.HealthArmRight);
			Player.GenerateTotalHealth();

			if (Player.Inventory != None)
			{
				item      = Player.Inventory;
				nextItem  = None;

				foreach AllActors(class'SpawnPoint', SP, 'player_inv')
				{
					// Find the next item we can process.
					while((item != None) && (item.IsA('NanoKeyRing') || (!item.bDisplayableInv)))
						item = item.Inventory;

					if (item != None)
					{
						nextItem = item.Inventory;
                        if (item.IsA('Weapon'))
                        {
                            AmmoType = Ammo(player.FindInventoryType(Weapon(item).AmmoName));
                            ammoCount = ammoType.AmmoAmount;
                        }
						
						//== Y|y: Turn off any charged pickups we were using and remove the associated HUD.  Per Lork on the OTP forums
						if (item.IsA('ChargedPickup'))
							ChargedPickup(item).ChargedPickupEnd(Player);

						Player.DeleteInventory(item);

                        if (item.IsA('WeaponGEPGun'))                           //RSD: To try to help with the GEP gun not showing up?
                        	item.DropFrom(SP.Location + item.CollisionHeight*vect(0,0,1));
                        else
							item.DropFrom(SP.Location);
							//item.DropFrom(player.Location); //SARGE: Enable this for testing, then disable it after!

						// restore any ammo amounts for a weapon to default
						//DDL- except the fucking lams and stuff!
						if (item.IsA('DeusExWeapon') && (Weapon(item).AmmoType != None))
						{
                            //Normal weapons are easy. Just set their ammo count to nothing.
							if(!DeusExWeapon(item).bDisposableWeapon)
								Weapon(item).PickupAmmoCount = 0;               //RSD: Weapons will be emptied of their ammunition
                            
                            //If it's a disposable weapon, it's harder. Add our current ammo to the weapon pickup, then remove our ammo.
                            else
                            {
                                player.ClientMessage("Mission05 crap: " $ AmmoType.itemName $ " - " $ ammoCount);
                                Weapon(item).PickupAmmoCount = ammoCount;
                                AmmoType.ammoAmount = 0;
                            }
						}
					}

					if (nextItem == None)
						break;
					else
						item = nextItem;
				}

                if (player.bHardcoreMode)                                       //RSD: Take away the player's ammo in Hardcore
                {
				//RSD: First we copy the player's inventory onto the ammo crate so that it has all the player's ammo
				foreach AllActors(class'ammocrate', crate, 'ammostoredhere')
				{
                	//crate.Inventory = player.Inventory;                       //RSD: This assigns the same pointer to both vars, BAD idea

                item = player.Inventory;

                while (item != none)
                {
                	if (item.IsA('ammo'))
                	{
                		crate.SpawnCopy(ammo(item));
               		}
               		//player.ClientMessage(ammo(crate.FindInventoryType(ammo(item).Class)).Class);
               		//player.ClientMessage(ammo(crate.FindInventoryType(ammo(item).Class)).AmmoAmount);
               		item = item.Inventory;
                }
                }

                //RSD: Now we clear the player's ammo counts (probably don't need to do this separately but meh)
                item      = Player.Inventory;

                while (item != none)
                {
                	if (item.IsA('ammo'))
                		ammo(item).AmmoAmount = 0;
               		item = item.Inventory;
                }
                }
                else                                                            //RSD: Get rid of the ammo crate if not Hardcore
                {
                	ForEach AllActors(class'ammocrate', crate, 'ammostoredhere')
       				{
              			crate.DrawScale = 0.00001;
              			crate.SetCollision(false,false,false);
              			crate.SetCollisionSize(0,0);
	       			}
       			}

				player.primaryWeapon = None;

                //SARGE: If we're using the "Killswitch Engaged" playthrough mod,
                //then set the killswitch to ~23 hours, as mentioned by Simons
                if (player.bRealKillswitch && !flags.GetBool('GMDXKillswitchSet'))
                {
                    player.killswitchTimer = (23*60)*60;
                    player.killswitchTimer += Player.Randomizer.GetRandomInt(3600);
                    player.DeactivateAllAugs(true);
                    //player.killSwitchTimer = 20; //For testing, set it to 20 seconds.
                    flags.SetBool('GMDXKillswitchSet', True,, 6);
                }
			}

			flags.SetBool('MS_InventoryRemoved', True,, 6);
		}
	}
	else if (localURL == "05_NYC_UNATCOHQ")
	{
		// if Miguel is following the player, unhide him
		if (flags.GetBool('MiguelFollowing'))
		{
			foreach AllActors(class'Terrorist', T)
				if (T.BindName == "Miguel")
					T.EnterWorld();
		}

		// make Anna not flee in this mission
		foreach AllActors(class'AnnaNavarre', Anna)
			Anna.MinHealth = 0;
	}
	else if (localURL == "05_NYC_UNATCOISLAND")
	{
		// if Miguel is following the player, unhide him
		if (flags.GetBool('MiguelFollowing'))
		{
			foreach AllActors(class'Terrorist', T)
				if (T.BindName == "Miguel")
					T.EnterWorld();
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
	Super.PreTravel();
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
	local AnnaNavarre Anna;
	local WaltonSimons Walton;
	local DeusExMover M;
	local Terrorist T;
	local BlackHelicopter B;

	Super.Timer();

	if (localURL == "05_NYC_UNATCOHQ")
	{
		// unlock a door
		if (flags.GetBool('CarterUnlock') &&
			!flags.GetBool('MS_DoorUnlocked'))
		{
			foreach AllActors(class'DeusExMover', M, 'supplydoor')
			{
				M.bLocked = False;
				M.lockStrength = 0.0;
			}

			flags.SetBool('MS_DoorUnlocked', True,, 6);
		}

		// kill Anna when a flag is set
		if (flags.GetBool('annadies') &&
			!flags.GetBool('MS_AnnaKilled'))
		{
			foreach AllActors(class'AnnaNavarre', Anna)
			{
				Anna.HealthTorso = 0;
				Anna.Health = 0;
				Anna.TakeDamage(1, Anna, Anna.Location, vect(0,0,0), 'Shot');
			}

			flags.SetBool('MS_AnnaKilled', True,, 6);
		}

		// make Anna attack the player after a convo is played
		if (flags.GetBool('M05AnnaAtExit_Played') &&
			!flags.GetBool('MS_AnnaAttacking'))
		{
			foreach AllActors(class'AnnaNavarre', Anna)
				Anna.SetOrders('Attacking', '', True);

			flags.SetBool('MS_AnnaAttacking', True,, 6);
		}

		// unhide Walton Simons
		if (flags.GetBool('simonsappears') &&
			!flags.GetBool('MS_SimonsUnhidden'))
		{
			foreach AllActors(class'WaltonSimons', Walton)
				Walton.EnterWorld();

			flags.SetBool('MS_SimonsUnhidden', True,, 6);
		}

		// hide Walton Simons
		if ((flags.GetBool('M05MeetManderley_Played') ||
			flags.GetBool('M05SimonsAlone_Played')) &&
			!flags.GetBool('MS_SimonsHidden'))
		{
			foreach AllActors(class'WaltonSimons', Walton)
				Walton.LeaveWorld();

			flags.SetBool('MS_SimonsHidden', True,, 6);
		}

		// mark a goal as completed
		if (flags.GetBool('KnowsAnnasKillphrase1') &&
			flags.GetBool('KnowsAnnasKillphrase2') &&
			!flags.GetBool('MS_KillphraseGoalCleared'))
		{
			Player.GoalCompleted('FindAnnasKillphrase');
			flags.SetBool('MS_KillphraseGoalCleared', True,, 6);
		}

		// clear a goal when anna is out of commision
		if (flags.GetBool('AnnaNavarre_Dead') &&
			!flags.GetBool('MS_EliminateAnna'))
		{
			Player.GoalCompleted('EliminateAnna');
			flags.SetBool('MS_EliminateAnna', True,, 6);
		}
	}
	else if (localURL == "05_NYC_UNATCOMJ12LAB")
	{
		// After the player talks to Paul, start a datalink
		if (!flags.GetBool('MS_DL_Played') &&
			flags.GetBool('PaulInMedLab_Played'))
		{
			Player.StartDataLinkTransmission("DL_Paul");
			flags.SetBool('MS_DL_Played', True,, 6);
		}
	}
	else if (localURL == "05_NYC_UNATCOISLAND") //CyberP: Reward player for rescuing miguel. Hackage.
	{
        if (!bRescuedMiguel)
        {
			foreach AllActors(class'Terrorist', T)
			{
			    if (T != None && T.BaseAccuracy<2.0)
			    {
				  foreach T.RadiusActors(class'BlackHelicopter',B,256)
				    if (B != None)
				    {
				        bRescuedMiguel=True;
				        T.BaseAccuracy=2.0;
				        Player.SkillPointsAdd(150);
				        Player.BroadcastMessage("Rescued Miguel");
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
}
