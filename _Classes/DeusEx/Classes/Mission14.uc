//=============================================================================
// Mission14.
//=============================================================================
class Mission14 expands MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
//
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
    local ComputerSecurity SC;
	Super.FirstFrame();

	if (localURL == "14_OCEANLAB_LAB")
	{
		Player.GoalCompleted('StealSub');
	}

	else if (localURL == "14_VANDENBERG_SUB")
    {
        //Remove the Hallway security computer login.
        //Tech/Sharkman can now ONLY be used to access the sub bay.
        //Hackers can still bypass the security.
        if (player.bHardCoreMode && !flags.GetBool('GMDX_RemoveComputer'))
        {
            foreach AllActors(class'ComputerSecurity', SC, 'HallwayComputer')
                SC.UserList[0]=SC.default.UserList[0];
                
            flags.SetBool('GMDX_RemoveComputer',True,, 15);
        }
        
        //prevent the "Antennapedia" password on hardcore,
        //since it trivialises the security setup.
        if (player.bHardCoreMode)
            flags.SetBool('OceanLabSkipPassword',True,, 1);
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

function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (localURL == "14_OCEANLAB_SILO") //CyberP: add shake effect to rocket event
    {
       if (Player != None)
       {
          if (Player.bInterpolating == True && Player.bCollideWorld == False)
          {
              if (Player.Location.Z > 1590.000000)
              {
                 if (Player.DesiredFOV == Player.default.DesiredFOV && FRand() < 0.9)
                     Player.DesiredFOV = Player.default.DesiredFOV+0.5;
                 else
                     Player.DesiredFOV = Player.default.DesiredFOV;
              }
          }
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
	local int count;
	local HowardStrong Howard;
	local BlackHelicopter chopper;
	local MiniSub sub;
	local ScubaDiver diver;
	local GarySavage Gary;
	local WaltonSimons Walton;
	local Actor part, A;
	local BobPage Bob;
    local ParticleGenerator PG;
    Local DeusExMover DM;
    local Light L;
	local Karkian K;
	local Greasel G;

	Super.Timer();

	if (localURL == "14_VANDENBERG_SUB")
	{
		// when the mission is complete, unhide the chopper and Gary Savage,
		// and destroy the minisub and the welding parts
        // SARGE: Also add some divers
		if (!flags.GetBool('MS_DestroySub'))
		{
			if (flags.GetBool('DL_downloaded_Played'))
			{
				foreach AllActors(class'MiniSub', sub, 'MiniSub2')
					sub.Destroy();

				foreach AllActors(class'Actor', part, 'welding_stuff')
					part.Destroy();

				foreach AllActors(class'BlackHelicopter', chopper, 'BlackHelicopter')
					chopper.EnterWorld();

				foreach AllActors(class'GarySavage', Gary)
					Gary.EnterWorld();

				flags.SetBool('MS_DestroySub', True,, 15);
				
                foreach AllActors(class'ScubaDiver', diver, 'ReturnAmbush')
					diver.EnterWorld();
			}
		}
	}
	else if (localURL == "14_OCEANLAB_LAB")
	{
        //SARGE: Do Lighting Accessibility
        if (Player.bLightingAccessibility)
        {
            ForEach AllActors(class'Light', L)
            {
                DoLightingAccessibility(L, 'Light73');
            }
        }

		// when the mission is complete, unhide the minisub and the diver team
		if (!flags.GetBool('MS_UnhideSub'))
		{
			if (flags.GetBool('DL_downloaded_Played'))
			{
                //SARGE: We need to remove the remaining greasels/karkians
                //otherwise Walton Simons does a T-pose
				foreach AllActors(class'Karkian', K)
                    K.LeaveWorld();
				foreach AllActors(class'Greasel', G)
                    G.LeaveWorld();

				foreach AllActors(class'WaltonSimons', Walton)
					Walton.EnterWorld();

                foreach AllActors(class'ParticleGenerator', PG)
                {
                     if (PG.Tag == 'ParticleGeneratorXYZ')
                         PG.AttachTag = 'WaltonSimons';
				         if (PG.attachTag != '')
				         {
		                 foreach AllActors(class'WaltonSimons', Walton)
                         {
			              	    PG.SetOwner(Walton);
			                	PG.SetBase(Walton);
		                  }
                          }
                }

				foreach AllActors(class'MiniSub', sub, 'MiniSub2')
					sub.EnterWorld();

				foreach AllActors(class'ScubaDiver', diver, 'scubateam')
					diver.EnterWorld();
				

                //SARGE: Now that we may or may not get the oceanguard/kraken password,
                //based on our difficulty, we need to force the sub door open.
                if (!flags.GetBool('door_open'))
                {
                    foreach AllActors(class'DeusExMover', DM, 'subDoor')
                        DM.Trigger(DM,player);
                    flags.SetBool('door_open', True,, 15);
                }

				foreach AllActors(class'DeusExMover', DM, 'simonsDoor')
                {
                    DM.StayOpenTime = 30.0;
                 // DM.KeyNum = 1;
                //  DM.bHighlight = False;
                 // DM.bFrobbable = False;
                }

				flags.SetBool('MS_UnhideSub', True,, 15);
			}
		}
	}
	else if (localURL == "14_OCEANLAB_SILO")
	{
		// when HowardStrong is dead, unhide the helicopter
		if (!flags.GetBool('MS_UnhideHelicopter'))
		{
			count = 0;
			foreach AllActors(class'HowardStrong', Howard)
				count++;

			if (count == 0)
			{
				foreach AllActors(class'BlackHelicopter', chopper, 'BlackHelicopter')
					chopper.EnterWorld();

				Player.StartDataLinkTransmission("DL_Dead");
				flags.SetBool('MS_UnhideHelicopter', True,, 15);
			}
		}
	}
	else if (localURL == "14_OCEANLAB_UC")
	{
		// when a flag is set, unhide Bob Page
		if (!flags.GetBool('MS_UnhideBobPage') &&
			flags.GetBool('schematic_downloaded'))
		{
			foreach AllActors(class'BobPage', Bob)
				Bob.EnterWorld();

			flags.SetBool('MS_UnhideBobPage', True,, 15);
		}

		// when a flag is set, hide Bob Page
		if (!flags.GetBool('MS_HideBobPage') &&
			flags.GetBool('PageTaunt_Played'))
		{
			foreach AllActors(class'BobPage', Bob)
				Bob.LeaveWorld();

			flags.SetBool('MS_HideBobPage', True,, 15);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
