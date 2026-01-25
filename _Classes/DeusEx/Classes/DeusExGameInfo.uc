//=============================================================================
// DeusExGameInfo.
//=============================================================================
class DeusExGameInfo expands GameInfo
	config;

//SARGE: Allow loading gameinfo modules.
//Inspired by similar system in DXRando.
//TODO: Move a lot of gameplay systems to here, so they can work
//without needing to store 10 billion things on the player object.

var DXGameInfoModule modules;

//Fetches a module if it exists, or creates a new one
function DXGameInfoModule GetModule(class<DXGameInfoModule> moduleToLoad)
{
    local DXGameInfoModule mod, newMod;
    mod = default.modules;

    if (default.modules == None)
    {
        default.modules = new(Self) moduleToLoad;
        default.modules.Init(self);
        return default.modules;
    }

    while (mod != None)
    {
        if (mod.class == moduleToLoad)
            return mod;
        mod = mod.GetNext();
    }
    
    //Not found, create a new one and add it to the end
    newMod = new(Self) moduleToLoad;
    newMod.Init(self);

    mod.SetNext(newMod);
    return newMod;
}

function LoginAllModules(PlayerPawn newPlayer)
{
    local DXGameInfoModule mod;
    mod = default.modules;
    while (mod != None)
    {
        mod.PlayerLogin(newPlayer);
        mod = mod.GetNext();
    }

}

//SARGE: Tick all of our modules
event Tick(float deltaTime)
{
    local DXGameInfoModule mod;
        
    //Log("Ticking Info: " $ self);
    
    super.Tick(deltaTime);
    mod = default.modules;
    while (mod != None)
    {
        //Log("Ticking Module: " $ mod.Class);
        mod.Tick(deltaTime);
        mod = mod.GetNext();
    }
}

//Setup modules
function PreBeginPlay()
{
    GetModule(class'MusicPlayer');
}

// ----------------------------------------------------------------------
// Login()
// ----------------------------------------------------------------------

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local DeusExPlayer player;
	local NavigationPoint StartSpot;
	local byte InTeam;
	local DumpLocation dump;

   //DEUS_EX AMSD In non multiplayer games, force JCDenton.
   if (!ApproveClass(SpawnClass))
   {
      SpawnClass=class'JCDentonMale';
   }

	player = DeusExPlayer(Super.Login(Portal, Options, Error, SpawnClass));

	// If we're traveling across a map on the same mission,
	// nuke the player's crap and

	if ((player != None) && (!HasOption(Options, "Loadgame")))
	{
		player.ResetPlayerToDefaults();

		dump = player.CreateDumpLocationObject();

		if ((dump != None) && (dump.HasLocationBeenSaved()))
		{
			dump.LoadLocation();

			player.Pause();
			player.SetLocation(dump.currentDumpLocation.Location);
			player.SetRotation(dump.currentDumpLocation.ViewRotation);
			player.ViewRotation = dump.currentDumpLocation.ViewRotation;
			player.ClientSetRotation(dump.currentDumpLocation.ViewRotation);

			CriticalDelete(dump);
		}
		else
		{
			InTeam    = GetIntOption( Options, "Team", 0 ); // Multiplayer now, defaults to Team_Unatco=0
         if (Level.NetMode == NM_Standalone)
            StartSpot = FindPlayerStart( None, InTeam, Portal );
         else
            StartSpot = FindPlayerStart( Player, InTeam, Portal );

			player.SetLocation(StartSpot.Location);
			player.SetRotation(StartSpot.Rotation);
			player.ViewRotation = StartSpot.Rotation;
			player.ClientSetRotation(player.Rotation);
		}
	}
	return player;
}

//
// SARGE: Copied from Engine/GameInfo.uc so that we can change the music.
// SARGE: No longer starts players music
// Called after a successful login. This is the first place
// it is safe to call replicated functions on the PlayerPawn.
//
event PostLogin( playerpawn NewPlayer )
{
	local Pawn P;
	
    LoginAllModules(NewPlayer);

	if ( Level.NetMode != NM_Standalone )
	{
		// replicate skins
		for ( P=Level.PawnList; P!=None; P=P.NextPawn )
			if ( P.bIsPlayer && (P != NewPlayer) )
			{
				if ( P.bIsMultiSkinned )
					NewPlayer.ClientReplicateSkins(P.MultiSkins[0], P.MultiSkins[1], P.MultiSkins[2], P.MultiSkins[3]);
				else
					NewPlayer.ClientReplicateSkins(P.Skin);	
					
				if ( (P.PlayerReplicationInfo != None) && P.PlayerReplicationInfo.bWaitingPlayer && P.IsA('PlayerPawn') )
				{
					if ( NewPlayer.bIsMultiSkinned )
						PlayerPawn(P).ClientReplicateSkins(NewPlayer.MultiSkins[0], NewPlayer.MultiSkins[1], NewPlayer.MultiSkins[2], NewPlayer.MultiSkins[3]);
					else
						PlayerPawn(P).ClientReplicateSkins(NewPlayer.Skin);	
				}						
			}
	}
}

event DetailChange()
{
   local DeusExPlayer player;

   Super.DetailChange();

   if(Level.NetMode==NM_Standalone)
   {
      player = DeusExPlayer(GetPlayerPawn());

      if (player != None)
         if (player.IsCrouching())
            player.bDuck = 1;
   }
}

// ----------------------------------------------------------------------
// ApproveClass()
// Is this class allowed for this gametype?  Override if you want to be
// other than JCDentonMale.  If it returns false, will force JCDenton spawn.
// ----------------------------------------------------------------------

function bool ApproveClass( class<playerpawn> SpawnClass)
{
	return false;
}

// ----------------------------------------------------------------------
// DiscardInventory()
// ----------------------------------------------------------------------

function DiscardInventory( Pawn Other )
{
	// do nothing
}

// ----------------------------------------------------------------------
// ScoreKill()
// ----------------------------------------------------------------------

function ScoreKill(pawn Killer, pawn Other)
{
	// do nothing
}

// ----------------------------------------------------------------------
// ClientPlayerPossessed()
// ----------------------------------------------------------------------
function ClientPlayerPossessed(PlayerPawn CheckPlayer)
{
	CheckPlayerWindow(CheckPlayer);
	CheckPlayerConsole(CheckPlayer);
}

// ----------------------------------------------------------------------
// CheckPlayerWindow()
// ----------------------------------------------------------------------
function CheckPlayerWindow(PlayerPawn CheckPlayer)
{
	// do nothing.
}

// ----------------------------------------------------------------------
// CheckPlayerConsole()
// ----------------------------------------------------------------------
function CheckPlayerConsole(PlayerPawn CheckPlayer)
{
	// do nothing.
}

// ----------------------------------------------------------------------
// FailRootWindowCheck()
// ----------------------------------------------------------------------
function FailRootWindowCheck(PlayerPawn FailPlayer)
{
	// do nothing
}

// ----------------------------------------------------------------------
// FailConsoleCheck()
// ----------------------------------------------------------------------
function FailConsoleCheck(PlayerPawn FailPlayer)
{
	// do nothing
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
