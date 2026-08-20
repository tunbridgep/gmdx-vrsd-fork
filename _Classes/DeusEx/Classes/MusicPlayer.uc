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
var Music currentSong;
var int currentLevelSection;
var EMusicMode musicMode;
var byte savedSection;
var float musicCheckTimer;
var float musicChangeTimer;
var float fMusicHackTimer;                                           //SARGE: A hack for fixing music fading when loading music.

var globalconfig int iAllowCombatMusic;                                        //SARGE: Enable/Disable combat music, or make it require 2 enemies

var globalconfig int iEnhancedMusicSystem;                                        //SARGE: Should the music system be a bit smarter about playing tracks?

var bool bDeadReset;                                                    //SARGE: Dirty hack!

function SetNewSong(Music song, optional byte section)
{
    local PlayerPawn player;
    local bool bFade;
    local int i;

    player = GetGameInfo().GetPlayerPawn();
        
    //Reset the music volume for when we change songs while in combat or whatever
    /*
    if (DeusExPlayer(player) != None)
        DeusExPlayer(player).SoundVolumeHackFix();
    */

    if (default.currentSong != song || iEnhancedMusicSystem == 0 || default.currentLevelSection != section)
    {
        //Fade out when we're changing to an empty track
        if (string(default.currentSong) != "Title_Music.Title_Music")
            bFade = (section == 255 || song == None);

        default.currentSong = song;
        default.musicMode = MUS_Ambient;
        default.savedSection = section;
        default.musicCheckTimer = 0.0;
        default.musicChangeTimer = 0.0;
        SetHackTimer(false);
        
        //Log("SetNewSong Changing Song: " $ default.currentSong @ section);

        //If changing to none, or if new section is 255, slow transition.
        if (bFade)
            player.ClientSetMusic(default.currentSong,section,255,MTRAN_SlowFade);
        else
            player.ClientSetMusic(default.currentSong,section,255,MTRAN_Instant);
    }
    //Just in case, reset our part
    else if (default.fMusicHackTimer > 0)
        player.ClientSetMusic(song,default.savedSection,255,MTRAN_Instant);
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

function private SetHackTimer(bool bCombat)
{
    if (bCombat)
        default.fMusicHackTimer = 15;
    else
        default.fMusicHackTimer = 8;
}

function SetDefaultLevelMusic(DeusExLevelInfo info)
{
    local PlayerPawn player;
    player = GetGameInfo().GetPlayerPawn();

    //SARGE: Might be placebo. Supposed to fix stupid bugs with level transitions having the same track.
    if (info.SongAmbientSection != default.currentLevelSection)
        default.savedSection = info.SongAmbientSection;

    //Always start our default song when adding a new player
    SetNewSong(player.Level.Song,info.SongAmbientSection);
    DeusExPlayer(player).DebugMessage("SongSection: " $ info.SongAmbientSection);
    
    //If we're in a different section of the same song, then reset it
    if (default.musicMode != MUS_Ambient)
    {
        //default.musicMode = MUS_Ambient;
        //default.musicChangeTimer = 5.0;
        //SetNewSection(default.savedSection, true);
    }
    default.musicCheckTimer = 5.0;
    default.musicChangeTimer = 5.0;
    default.currentLevelSection = info.SongAmbientSection;
}

function SetNewSection(byte section, optional bool bInstant)
{
    local PlayerPawn player;
    player = GetGameInfo().GetPlayerPawn();
        
    Log("SetNewSong Changing Section: " $ default.currentSong @ section);

    if (bInstant)
        player.ClientSetMusic(default.currentSong,section,255,MTRAN_Instant);
    else
        player.ClientSetMusic(default.currentSong,section,255,MTRAN_Fade);

    //If we're doing a transition already, we need to apply the sound hack fix
    //if (default.fMusicHackTimer > 0 && DeusExPlayer(player) != None)
    //    DeusExPlayer(player).SoundVolumeHackFix();
    
    SetHackTimer(false);

    Log("SetNewSong Changed Section: " $ section @ player.SongSection);
}

function PlayerLogin(PlayerPawn P)
{
	local DeusExLevelInfo info;
    //Log("PlayerLogin" @ p.Level.Song @ p.Level.SongSection);
    
    //Fix up song ambient section if it's not set.
    info = GetLevelInfo();
    
    if (info.SongAmbientSection == -1)
        info.SongAmbientSection = p.Level.SongSection;
    
    DeusExPlayer(P).DebugMessage("New Song:" @ p.Level.Song @ "Section: " $ p.level.SongSection @ "info.SongAmbientSection: " $ info.SongAmbientSection);

    SetDefaultLevelMusic(info);
    ReplaceMusicEvents();

    if (default.bDeadReset)
        DeusExPlayer(P).ClientSetMusic(default.currentSong,default.savedSection,255,MTRAN_Instant);
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

//SARGE: This is a tad complex...
function bool CanSetAsSavedSection(int section, DeusExLevelInfo info)
{
    if (default.fMusicHackTimer > 0)
        return false;

    if (section == 255)
        return false;
    
    if (info.MusicType == MT_Normal)
        return section != 1 && section != info.SongConversationSection && section != info.SongCombatSection && (section != 5 || string(default.currentSong) == "NYCStreets_Music.NYCStreets_Music" || string(default.currentSong) == "Tunnels_Music.Tunnels_Music");

    if (info.MusicType == MT_SingleTrack)
        return true;
    
    if (info.MusicType == MT_ConversationOnly)
        return section != info.SongConversationSection;
    
    if (info.MusicType == MT_CombatOnly)
        return section != info.SongCombatSection;
}

//Update music state every frame
function Tick(float deltaTime)
{
	//local bool bCombat; //SARGE: Replaced with aggro below
    local int aggro;
    local DeusExPlayer player;
	local DeusExLevelInfo info;
    local bool bAllowConverse, bAllowCombat, bAllowOther;

    default.fMusicHackTimer = FMAX(default.fMusicHackTimer - deltaTime,0);
		
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

	default.musicCheckTimer += deltaTime;
	default.musicChangeTimer += deltaTime;

    //Log("Ticking MusicPlayer: " $ deltaTime @ info @ default.fMusicHackTimer @ player.GetStateName());
    //Log("  " @ bAllowConverse @ bAllowCombat @ bAllowOther @ default.musicMode);

    //SARGE: Failsafe                    
    //if (default.fMusicHackTimer == 0 && default.musicMode == MUS_Ambient)
    //    default.savedSection = info.SongAmbientSection;

	if (player.IsInState('Interpolating'))
	{
		// don't mess with the music on any of the intro maps
		if ((info != None) && (info.MissionNumber < 0))
		{
            default.savedSection = info.SongAmbientSection;
			default.musicMode = MUS_Outro;
			return;
		}

		if (default.musicMode != MUS_Outro && bAllowOther)
		{
            //Always reset the track when transitioning through outtros
            default.savedSection = info.SongAmbientSection;
			player.ClientSetMusic(default.currentSong, 5, 255, MTRAN_FastFade);
			default.musicMode = MUS_Outro;
            SetHackTimer(false);
		}
	}
	else if (player.IsInState('Conversation') && bAllowConverse)
	{
		if (default.musicMode != MUS_Conversation)
		{
			// save our place in the ambient track
			if (default.musicMode == MUS_Ambient && CanSetAsSavedSection(player.SongSection,info))
                default.savedSection = player.SongSection;

			player.ClientSetMusic(default.currentSong, info.SongConversationSection, 255, MTRAN_Fade);
            SetHackTimer(false);
			default.musicMode = MUS_Conversation;
		}
	}
	else if (player.IsInState('Dying') && bAllowOther)
	{
		if (default.musicMode != MUS_Dying)
		{
            // save our place in the ambient track
            if (default.musicMode == MUS_Ambient && CanSetAsSavedSection(player.SongSection,info))
                default.savedSection = player.SongSection;

			default.musicMode = MUS_Dying;
            default.bDeadReset = true;
			player.ClientSetMusic(default.currentSong, 1, 255, MTRAN_Fade);
            SetHackTimer(false);
		}
	}
	else
	{
		// only check for combat music every second
        if (default.musicCheckTimer >= 1.0)
		{
			default.musicCheckTimer = 0.0;
			aggro = 0;

			// check a 100 foot radius around me for combat
            // XXXDEUS_EX AMSD Slow Pawn Iterator
            //foreach RadiusActors(class'ScriptedPawn', npc, 1600)
            if (bAllowCombat)
                aggro = player.GetCombatants(true);
                
            //SARGE: Don't stop combat music until aggro has returned to zero.
            if (aggro > 0 && default.musicMode == MUS_Combat)
				default.musicChangeTimer = 0.0;

			if (aggro >= iAllowCombatMusic && aggro > 0)
			{
				if (default.musicMode != MUS_Combat)
				{
					// save our place in the ambient track
					if (default.musicMode == MUS_Ambient && CanSetAsSavedSection(player.SongSection,info))
						default.savedSection = player.SongSection;

					default.musicMode = MUS_Combat;
					player.ClientSetMusic(default.currentSong, info.SongCombatSection, 255, MTRAN_FastFade);
                    SetHackTimer(true);
				}
			}
			else if (default.musicMode != MUS_Ambient)
			{
				// wait until we've been out of combat for 5 seconds before switching music
				if (default.musicChangeTimer >= 5.0)
				{
					// fade slower for combat transitions
					if (default.musicMode == MUS_Combat)
						player.ClientSetMusic(default.currentSong, default.savedSection, 255, MTRAN_SlowFade);
					else if (default.musicMode == MUS_Dying || default.musicMode == MUS_Outro)
						player.ClientSetMusic(default.currentSong, default.savedSection, 255, MTRAN_FastFade);
					else
						player.ClientSetMusic(default.currentSong, default.savedSection, 255, MTRAN_Fade);
                    
                    default.musicMode = MUS_Ambient;
					default.musicChangeTimer = 0.0;
                    SetHackTimer(false);
				}
			}
            else if (default.fMusicHackTimer == 0 && default.musicMode == MUS_Ambient)
                default.savedSection = info.SongAmbientSection;
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
