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
var EMusicMode musicMode;
var byte savedSection;
var float musicCheckTimer;
var float musicChangeTimer;
var float fMusicHackTimer;                                           //SARGE: A hack for fixing music fading when loading music.

var globalconfig int iAllowCombatMusic;                                        //SARGE: Enable/Disable combat music, or make it require 2 enemies

var globalconfig int iEnhancedMusicSystem;                                        //SARGE: Should the music system be a bit smarter about playing tracks?

function SetNewSong(Music song, optional byte section)
{
    local PlayerPawn player;
    local bool bFade;
    local int i;

    player = GetGameInfo().GetPlayerPawn();

    if (currentSong != song)
    {
        //Fade out when we're changing to an empty track
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
    
    //If we're in a different section of the same song, then reset it
    if (musicMode != MUS_Ambient)
    {
        //musicMode = MUS_Ambient;
        //musicChangeTimer = 5.0;
        //SetNewSection(savedSection, true);
    }
    //savedSection = info.SongAmbientSection;
    musicCheckTimer = 5.0;
    musicChangeTimer = 5.0;
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
    if (fMusicHackTimer > 0 && DeusExPlayer(player) != None)
        DeusExPlayer(player).SoundVolumeHackFix();
    
    SetHackTimer();

    Log("SetNewSong Changed Section: " $ section @ player.SongSection);
}

function PlayerLogin(PlayerPawn P)
{
	local DeusExLevelInfo info;
    Log("PlayerLogin" @ p.Level.Song @ p.Level.SongSection);
    
    //Fix up song ambient section if it's not set.
    info = GetLevelInfo();
    if (info.SongAmbientSection != p.Level.SongSection && info.SongAmbientSection == -1)
        info.SongAmbientSection = p.Level.SongSection;

    SetDefaultLevelMusic(info);
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

//Update music state every frame
function Tick(float deltaTime)
{
	//local bool bCombat; //SARGE: Replaced with aggro below
    local int aggro;
	local ScriptedPawn npc;
    local Pawn CurPawn;
    local PlayerPawn player;
	local DeusExLevelInfo info;
    local bool bAllowConverse, bAllowCombat, bAllowOther;

    fMusicHackTimer = FMAX(fMusicHackTimer - deltaTime,0);
		
    info = GetLevelInfo();

    player = GetGameInfo().GetPlayerPawn();

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
			player.ClientSetMusic(currentSong, 5, 255, MTRAN_FastFade);
			musicMode = MUS_Outro;
            SetHackTimer();
            savedSection = info.SongAmbientSection;
		}
	}
	else if (player.IsInState('Conversation') && bAllowConverse)
	{
		if (musicMode != MUS_Conversation)
		{
			// save our place in the ambient track
			if (musicMode == MUS_Ambient && fMusicHackTimer == 0)
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
            if (musicMode == MUS_Ambient && fMusicHackTimer == 0)
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
            {
                for (CurPawn = player.Level.PawnList; CurPawn != None; CurPawn = CurPawn.NextPawn)
                {
                    npc = ScriptedPawn(CurPawn);
                    if ((npc != None) && (VSize(npc.Location - player.Location) < (1600 + npc.CollisionRadius)))
                        if ((npc.GetStateName() == 'Attacking') && (npc.Enemy == player))
                        {
                            aggro++;
                            //SARGE: Bosses always have music
                            if (npc.IsA('AnnaNavarre') || npc.IsA('WaltonSimons') || npc.IsA('GuntherHermann'))
                                aggro = 9999;
                        }
                }
            }
                
            //SARGE: Don't stop combat music until aggro has returned to zero.
            if (aggro > 0 && musicMode == MUS_Combat)
				musicChangeTimer = 0.0;

			if (aggro >= iAllowCombatMusic && aggro > 0)
			{
				if (musicMode != MUS_Combat)
				{
					// save our place in the ambient track
					if (musicMode == MUS_Ambient && fMusicHackTimer == 0)
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
    Disable('Tick');
}

event OnTravelPostAccept()
{
    Enable('Tick');
}

/*

//SARGE: Resets the music timers and state.
//Now that we're using variables that persist per-session, we need to do this.
function ResetMusic()
{
	local DeusExLevelInfo info;
    info = GetLevelInfo();

    PopulateLevelAmbientSection(info);

    //default.fMusicHackTimer = 8.0;
    bMusicSystemReset = true;
}

// ----------------------------------------------------------------------
// UpdateDynamicMusic()
//
// Pattern definitions:
//   0 - Ambient 1
//   1 - Dying
//   2 - Ambient 2 (optional)
//   3 - Combat
//   4 - Conversation
//   5 - Outro
// ----------------------------------------------------------------------
function PopulateLevelAmbientSection(DeusExLevelInfo info)
{
    if (info != None && info.SongAmbientSection == 255)
    {
        info.SongAmbientSection = Level.SongSection;
        DebugMessage("Setting up SongAmbientSection: " $ info.SongAmbientSection);
    }

}

function UpdateDynamicMusic(float deltaTime)
{
	//local bool bCombat; //SARGE: Replaced with aggro below
    local int aggro;
	local ScriptedPawn npc;
    local Pawn CurPawn;
	local DeusExLevelInfo info;
    local bool bAllowConverse, bAllowCombat, bAllowOther;

    //Bail out and don't update if we're running dxrando
	if (Level.Song == None || RandomizerEnabled())
		return;

    default.fMusicHackTimer = FMAX(default.fMusicHackTimer - deltaTime,0);
		
    info = GetLevelInfo();

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

	if (IsInState('Interpolating'))
	{
		// don't mess with the music on any of the intro maps
		if ((info != None) && (info.MissionNumber < 0))
		{
			default.musicMode = MUS_Outro;
			return;
		}

		if (default.musicMode != MUS_Outro && bAllowOther)
		{
            // save our place in the ambient track
            if (default.previousMusicMode == MUS_Ambient && default.fMusicHackTimer == 0)
            {
                DebugMessage("SaveSection Outro: " $ SongSection);
                default.savedSection = SongSection;
            }

			default.musicMode = MUS_Outro;
			ClientSetMusic(Level.Song, 5, 255, MTRAN_FastFade);
		}
	}
	else if (IsInState('Conversation') && bAllowConverse)
	{
		if (default.musicMode != MUS_Conversation)
		{
			// save our place in the ambient track
			if (default.previousMusicMode == MUS_Ambient && default.fMusicHackTimer == 0)
            {
                DebugMessage("SaveSection Conversation: " $ SongSection);
				default.savedSection = SongSection;
            }

			default.musicMode = MUS_Conversation;
			ClientSetMusic(Level.Song, info.SongConversationSection, 255, MTRAN_Fade);
		}
	}
	else if (IsInState('Dying') && bAllowOther)
	{
		if (default.musicMode != MUS_Dying)
		{
            // save our place in the ambient track
            if (default.previousMusicMode == MUS_Ambient && default.fMusicHackTimer == 0)
            {
                DebugMessage("SaveSection Dying: " $ SongSection);
                default.savedSection = SongSection;
            }

			default.musicMode = MUS_Dying;
			ClientSetMusic(Level.Song, 1, 255, MTRAN_Fade);
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
            {
                for (CurPawn = Level.PawnList; CurPawn != None; CurPawn = CurPawn.NextPawn)
                {
                    npc = ScriptedPawn(CurPawn);
                    if ((npc != None) && (VSize(npc.Location - Location) < (1600 + npc.CollisionRadius)))
                        if ((npc.GetStateName() == 'Attacking') && (npc.Enemy == Self))
                        {
                            aggro++;
                            if (npc.IsA('AnnaNavarre') || npc.IsA('WaltonSimons') || npc.IsA('GuntherHermann'))
                                aggro = 9999;
                        }
                }
            }
                
            //SARGE: Don't stop combat music until aggro has returned to zero.
            if (aggro > 0)
				musicChangeTimer = 0.0;

			if (aggro >= iAllowCombatMusic && aggro > 0)
			{
				if (default.musicMode != MUS_Combat)
				{
					// save our place in the ambient track
					if (default.previousMusicMode == MUS_Ambient && default.fMusicHackTimer == 0)
                    {
                        DebugMessage("SaveSection Combat: " $ SongSection);
						default.savedSection = SongSection;
                    }

					default.musicMode = MUS_Combat;
					ClientSetMusic(Level.Song, info.SongCombatSection, 255, MTRAN_FastFade);
				}
			}
			else if (default.musicMode != MUS_Ambient)
			{
				// wait until we've been out of combat for 5 seconds before switching music
				if (musicChangeTimer >= 5.0)
				{
                    default.musicMode = MUS_Ambient;

					// fade slower for combat transitions
					if (default.previousMusicMode == MUS_Combat)
						ClientSetMusic(Level.Song, default.savedSection, 255, MTRAN_SlowFade);
					else
						ClientSetMusic(Level.Song, default.savedSection, 255, MTRAN_Fade);

					musicChangeTimer = 0.0;
				}
			}
		}
	}
}

//SARGE: This has been completely revamped entirely.
//DO NOT EDIT THIS UNLESS YOU KNOW WHAT THE FUCK YOU'RE DOING!
//IT IS EXTREMELY LIKELY TO BREAK ON EVEN MINOR CHANGES, IN RARE AND HARD TO DEBUG WAYS!
//IT'S A FUCKING MESS!
//Now has the following features:
//- Attempting to fix the horrible vanilla "fade out" bug.
//- Not restarting tracks on map change or reload to maps using the same track.
//- Different sections per map, that can be changed dynamically (like changing the combat music after talking to Page in area 51.)
//- Different ambient tracks per map based on triggers (like entering the lab under versalife, where a trigger changes the music), also saved in your savegame
//- Restoring the previous music part upon dying and reloading
//- Fading out slowly when moving to a silent map (like the catacombs) [EXCEPT from the title screen]
//- Not attempting to change to ambient sections for tracks that don't have them (the bar tracks, Tongs' lab, etc). In vanilla and GMDX v9, there's a noticeable cut when entering/leaving conversations or combat in these areas, in GMDX:AE there's no transition at all, which feels a lot smoother.
//- Re-added the GMDX v9 cut "bar music" feature that would prevent some track parts playing in bars conditionally (some bars have conversation music, this disables them) - now called the "Extended" option in the "Enhanced Music System" in GMDX:AE
//- Starting combat music based on a certain number of enemies (rather than being hardcoded to 1), and only leaving combat music when there's no active enemies left (so if it goes from 2 to 1 it doesn't stop even though it's below the threshold for combat music)
function ClientSetMusic(Music NewSong, byte NewSection, byte NewCdTrack, EMusicTransition NewTransition)
{

    local bool bChange;
    local bool bContinueOn;
	local DeusExLevelInfo info;
    //local bool bSection5Hack;

    //If using dxrando, use dxrando's music player instead.
    if (RandomizerEnabled())
    {
        Super.ClientSetMusic(NewSong,NewSection,NewCdTrack,NewTransition);
        return;
    }

    info = GetLevelInfo();
    
    DebugMessage("ClientSetMusic called:" @ NewSong @ NewSection @ NewTransition @ "Song is: " $ default.previousTrack @ SongSection @ default.previousLevelSection @ default.previousMusicMode @ bMusicSystemReset @ Level.SongSection @ saveTime @ default.fMusicHackTimer @ SongSection);

    //SARGE: Here's the really annoying part...
    //We've just been asked to change tracks or sections, we need to work out
    //whether it's okay to ignore it or continue.
    if (default.fMusicHackTimer > 0)
    {
        //DebugMessage("ClientSetMusic: Music Change Allowed (Fade Hack)");
        DebugMessage("ClientSetMusic: Music Fade Hack");
        NewTransition = MTRAN_Instant;
        SoundVolumeHackFix();
    }

    //Horrible bugfix!
    //For some reason it sometimes gets 255 on a track or two
    //So just reset it
    if (NewSection == 255 && info.SongAmbientSection != 255)
        NewSection = info.SongAmbientSection;
    
    //If we're changing to 255, fade out slowly
    if (NewSection == 255 || NewSong == None)
        NewTransition = MTRAN_SlowFade;

    //If we're changing to the opposite ambient section, make that our default
    if (NewSection == 0 && info.SongAmbientSection == 2 || NewSection == 2 && info.SongAmbientSection == 0)
    {
        DebugMessage("ClientSetMusic: Swapping Ambient from " $ info.SongAmbientSection $ " to " $ NewSection);
        info.SongAmbientSection = NewSection;
    }

    DebugMessage("ClientSetMusic: NewSection " $ NewSection @ ", reset: " $ bMusicSystemReset);
    bChange = true;

    //We've just loaded a game or switched maps with the same track, so we need to not change to the new music, IF we're already on ambient and aren't fadehacking
    if (bMusicSystemReset && default.fMusicHackTimer == 0 && default.previousMusicMode == MUS_Ambient && NewSection == info.SongAmbientSection && NewSong == default.previousTrack && info.SongAmbientSection == default.previousLevelSection)
        bChange = false;

    //If we've just loaded a game or switched maps, but still need to change, then change to our saved section rather than the default section.
    else if (bMusicSystemReset)
    {
        //Reset our song position if we're changing track/levelSection
        if (NewSong != default.previousTrack || info.SongAmbientSection != default.previousLevelSection)
            default.savedSection = info.SongAmbientSection;

        //Otherwise, switch back to our default section instead of the start
        else if (NewSection == info.SongAmbientSection)
            NewSection = default.savedSection;
    }

    if (bChange)
    {
        if (bMusicSystemReset) //This is a HACK to stop UpdateDynamicMusic from kicking in again.
            default.musicMode = MUS_Ambient;

        //Set the new track and remember what we changed to.
        Super.ClientSetMusic(NewSong,NewSection,NewCDTrack,NewTransition);
        DebugMessage("ClientSetMusic: Setting music to " $ NewSong @ NewSection @ NewTransition @ SongSection);
        default.previousTrack = NewSong;
        default.previousLevelSection = info.SongAmbientSection;
        default.previousMusicMode = default.musicMode;

        //Set the music hack timer.
        if (NewTransition == MTRAN_Instant)
            default.fMusicHackTimer = 1.0;
        else if (NewTransition == MTRAN_SlowFade)
            default.fMusicHackTimer = 8.0;
        else
            default.fMusicHackTimer = 5.0;
    }

    bMusicSystemReset = false;

}

*/
defaultproperties
{
     iAllowCombatMusic=2
     iEnhancedMusicSystem=1
}
