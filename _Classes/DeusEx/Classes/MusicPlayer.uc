//SARGE: Moved all music playing functions to the Music Player,
//So that it can handle everything in it's own way.
class MusicPlayer extends DXGameInfoModule;

//SARGE: Music Stuff
/*
var globalconfig int iAllowCombatMusic;                                        //SARGE: Enable/Disable combat music, or make it require 2 enemies
var Music previousTrack;                                             //SARGE: The last thing that was ClientSetMusic'd
var EMusicMode previousMusicMode;                                    //SARGE: The last thing that was ClientSetMusic'd
var byte previousLevelSection;                                       //SARGE: The last levelsection
var transient bool bMusicSystemReset;                                //SARGE: Whether or not the music system is setup
*/

//Copied from DeusExPlayer
enum EMusicMode
{
	MUS_Ambient,
	MUS_Combat,
	MUS_Conversation,
	MUS_Outro,
	MUS_Dying
};

//Copied from DeusExPlayer
var transient travel Music currentSong;
var transient travel int currentLevelSection;
var transient travel EMusicMode musicMode;
var transient travel byte savedSection;
var transient travel float musicCheckTimer;
var transient travel float musicChangeTimer;
var transient travel float fMusicHackTimer;                                           //SARGE: A hack for fixing music fading when loading music.

var globalconfig int iAllowCombatMusic;                                        //SARGE: Enable/Disable combat music, or make it require 2 enemies

var globalconfig int iEnhancedMusicSystem;                                        //SARGE: Should the music system be a bit smarter about playing tracks?

function SetNewSong(Music song, optional byte section)
{
    local PlayerPawn player;
    local bool bFade;
    local int i;

    player = GetGameInfo().GetPlayerPawn();
        
    //Reset the music volume for when we change songs while in combat or whatever
    if (DeusExPlayer(player) != None)
        DeusExPlayer(player).SoundVolumeHackFix();

    if (currentSong != song || iEnhancedMusicSystem == 0 || currentLevelSection != section)
    {
        //Fade out when we're changing to an empty track
        if (string(currentSong) != "Title_Music.Title_Music")
            bFade = (section == 255 || song == None);

        currentSong = song;
        musicMode = MUS_Ambient;
        savedSection = section;
        musicChangeTimer = 0.0;
        fMusicHackTimer = 10;
        
        Log("SetNewSong Changing Song: " $ currentSong @ section);

        //If changing to none, or if new section is 255, slow transition.
        if (bFade)
            player.ClientSetMusic(currentSong,section,255,MTRAN_SlowFade);
        else
            player.ClientSetMusic(currentSong,section,255,MTRAN_Instant);
    }
    //Just in case, reset our part
    else if (fMusicHackTimer > 0)
        player.ClientSetMusic(song,savedSection,255,MTRAN_Instant);


}

//Replace all MusicEvent's with GMDXMusicTriggers
function private ReplaceMusicEvents()
{
    local MusicEvent E;
    local GMDXMusicTrigger T;
    local PlayerPawn player;

    player = GetGameInfo().GetPlayerPawn();
	foreach player.AllActors(class'MusicEvent', E)
    {
        if (E.IsA('GMDXMusicTrigger'))
            continue;

        DeusExPlayer(player).DebugMessage("Replacing music event " $ E);
        T = GMDXMusicTrigger(class'SpawnUtils'.static.SpawnSafe(class'GMDXMusicTrigger',player));	// Create ammo type required
        T.SetLocation(E.Location);
        T.Transition = E.Transition;
        T.Song = E.Song;
        T.SongSection = E.SongSection;
        T.CDTrack = E.CDTrack;
        T.bSilence = E.bSilence;
        T.bOnceOnly = E.bOnceOnly;
        T.bAffectAllPlayers = E.bAffectAllPlayers;
        T.Tag = E.Tag;
        T.Event = E.Event;
        E.Destroy();
    }
}

function private SetHackTimer()
{
    fMusicHackTimer = 10;
}

function SetDefaultLevelMusic(DeusExLevelInfo info)
{
    local PlayerPawn player;
    player = GetGameInfo().GetPlayerPawn();

    //Always start our default song when adding a new player
    SetNewSong(player.Level.Song,info.SongAmbientSection);
    DeusExPlayer(player).DebugMessage("SongSection: " $ info.SongAmbientSection);
    
    //If we're in a different section of the same song, then reset it
    if (musicMode != MUS_Ambient)
    {
        //musicMode = MUS_Ambient;
        //musicChangeTimer = 5.0;
        //SetNewSection(savedSection, true);
    }
    musicCheckTimer = 5.0;
    musicChangeTimer = 5.0;
    
    currentLevelSection = info.SongAmbientSection;
}

function SetNewSection(byte section, optional bool bInstant)
{
    local PlayerPawn player;
    player = GetGameInfo().GetPlayerPawn();
        
    Log("SetNewSong Changing Section: " $ currentSong @ section);

    if (bInstant)
        player.ClientSetMusic(currentSong,section,255,MTRAN_Instant);
    else
        player.ClientSetMusic(currentSong,section,255,MTRAN_Fade);

    //If we're doing a transition already, we need to apply the sound hack fix
    //if (fMusicHackTimer > 0 && DeusExPlayer(player) != None)
    //    DeusExPlayer(player).SoundVolumeHackFix();
    
    SetHackTimer();

    Log("SetNewSong Changed Section: " $ section @ player.SongSection);
}

function PlayerLogin(PlayerPawn P)
{
	local DeusExLevelInfo info;
    Log("PlayerLogin" @ p.Level.Song @ p.Level.SongSection);
    
    //Fix up song ambient section if it's not set.
    info = GetLevelInfo();
    
    if (info.SongAmbientSection == -1)
        info.SongAmbientSection = p.Level.SongSection;
    
    DeusExPlayer(p).DebugMessage("New Song:" @ p.Level.Song @ "Section: " $ p.level.SongSection @ "info.SongAmbientSection: " $ info.SongAmbientSection);

    SetDefaultLevelMusic(info);
    ReplaceMusicEvents();
}

function DeusExLevelInfo GetLevelInfo()
{
	local DeusExLevelInfo info;
    local PlayerPawn player;

    player = GetGameInfo().GetPlayerPawn();

	foreach player.AllActors(class'DeusExLevelInfo', info)
		break;

	return info;
}

function bool CanSetAsSavedSection(int section)
{
    return fMusicHackTimer == 0 && section != 255 && section != 1 && section != 3 && section != 4 && (section != 5 || string(currentSong) == "NYCStreets_Music.NYCStreets_Music");
}

//Update music state every frame
function Tick(float deltaTime)
{
	//local bool bCombat; //SARGE: Replaced with aggro below
    local int aggro;
    local DeusExPlayer player;
	local DeusExLevelInfo info;
    local bool bAllowConverse, bAllowCombat, bAllowOther;

    fMusicHackTimer = FMAX(fMusicHackTimer - deltaTime,0);
		
    info = GetLevelInfo();

    player = DeusExPlayer(GetGameInfo().GetPlayerPawn());

    bAllowConverse = info.SongAmbientSection != 255 && info.MusicType != MT_SingleTrack && info.MusicType != MT_CombatOnly;
    bAllowCombat = info.SongAmbientSection != 255 && info.MusicType != MT_SingleTrack && info.MusicType != MT_ConversationOnly && iAllowCombatMusic > 0;
    bAllowOther = info.SongAmbientSection != 255 && info.MusicType == MT_Normal;

    //If we have the Extended music option, and we're in a bar or club, stop all of the music entirely
    if ((info.MusicType == MT_ConversationOnly || info.MusicType == MT_CombatOnly) && iEnhancedMusicSystem == 2)
    {
        bAllowConverse = false;
        bAllowCombat = false;
        bAllowOther = false;
    }

	musicCheckTimer += deltaTime;
	musicChangeTimer += deltaTime;

    //Log("Ticking MusicPlayer: " $ deltaTime @ info @ fMusicHackTimer @ player.GetStateName());
    //Log("  " @ bAllowConverse @ bAllowCombat @ bAllowOther @ musicMode);

    //SARGE: Failsafe                    
    //if (fMusicHackTimer == 0 && musicMode == MUS_Ambient)
    //    savedSection = info.SongAmbientSection;

	if (player.IsInState('Interpolating'))
	{
		// don't mess with the music on any of the intro maps
		if ((info != None) && (info.MissionNumber < 0))
		{
			musicMode = MUS_Outro;
			return;
		}

		if (musicMode != MUS_Outro && bAllowOther)
		{
            //Always reset the track when transitioning through outtros
            savedSection = info.SongAmbientSection;
			player.ClientSetMusic(currentSong, 5, 255, MTRAN_FastFade);
			musicMode = MUS_Outro;
            SetHackTimer();
		}
	}
	else if (player.IsInState('Conversation') && bAllowConverse)
	{
		if (musicMode != MUS_Conversation)
		{
			// save our place in the ambient track
			if (musicMode == MUS_Ambient && CanSetAsSavedSection(player.SongSection))
                savedSection = player.SongSection;

			player.ClientSetMusic(currentSong, info.SongConversationSection, 255, MTRAN_Fade);
            SetHackTimer();
			musicMode = MUS_Conversation;
		}
	}
	else if (player.IsInState('Dying') && bAllowOther)
	{
		if (musicMode != MUS_Dying)
		{
            // save our place in the ambient track
            if (musicMode == MUS_Ambient && CanSetAsSavedSection(player.SongSection))
                savedSection = player.SongSection;

			musicMode = MUS_Dying;
			player.ClientSetMusic(currentSong, 1, 255, MTRAN_Fade);
            SetHackTimer();
		}
	}
	else
	{
		// only check for combat music every second
        if (musicCheckTimer >= 1.0)
		{
			musicCheckTimer = 0.0;
			aggro = 0;

			// check a 100 foot radius around me for combat
            // XXXDEUS_EX AMSD Slow Pawn Iterator
            //foreach RadiusActors(class'ScriptedPawn', npc, 1600)
            if (bAllowCombat)
                aggro = player.GetCombatants(true);
                
            //SARGE: Don't stop combat music until aggro has returned to zero.
            if (aggro > 0 && musicMode == MUS_Combat)
				musicChangeTimer = 0.0;

			if (aggro >= iAllowCombatMusic && aggro > 0)
			{
				if (musicMode != MUS_Combat)
				{
					// save our place in the ambient track
					if (musicMode == MUS_Ambient && CanSetAsSavedSection(player.SongSection))
						savedSection = player.SongSection;

					musicMode = MUS_Combat;
					player.ClientSetMusic(currentSong, info.SongCombatSection, 255, MTRAN_FastFade);
                    SetHackTimer();
				}
			}
			else if (musicMode != MUS_Ambient)
			{
				// wait until we've been out of combat for 5 seconds before switching music
				if (musicChangeTimer >= 5.0)
				{
					// fade slower for combat transitions
					if (musicMode == MUS_Combat)
						player.ClientSetMusic(currentSong, savedSection, 255, MTRAN_SlowFade);
					else if (musicMode == MUS_Dying || musicMode == MUS_Outro)
						player.ClientSetMusic(currentSong, savedSection, 255, MTRAN_FastFade);
					else
						player.ClientSetMusic(currentSong, savedSection, 255, MTRAN_Fade);
                    
                    musicMode = MUS_Ambient;
					musicChangeTimer = 0.0;
                    SetHackTimer();
				}
			}
		}
	}
}

event OnPreTravel()
{
    //Disable('Tick');
}

event OnTravelPostAccept()
{
    //Enable('Tick');
}

defaultproperties
{
     iAllowCombatMusic=2
     iEnhancedMusicSystem=1
}
