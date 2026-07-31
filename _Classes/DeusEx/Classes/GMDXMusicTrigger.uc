//=============================================================================
// GMDXMusicTrigger.
// SARGE: Updated version of MusicEvent which allows changing the current map track.
//=============================================================================
class GMDXMusicTrigger extends MusicEvent;

// When triggered, update the map music
function Trigger( actor Other, pawn EventInstigator )
{
	local DeusExLevelInfo info;

	foreach AllActors(class'DeusExLevelInfo', info)
		break;

    DeusExPlayer(GetPlayerPawn()).DebugMessage("Music Trigger Triggered!: " $ info.SongAmbientSection @ SongSection @ Song @ Level.Song);

    if (info != None && info.SongAmbientSection != SongSection && Song == Level.Song)
    {
        super.Trigger(Other, EventInstigator);
        info.SongAmbientSection = SongSection;
        class'MusicPlayer'.default.currentLevelSection = SongSection;
    }
    else if (Song != Level.Song)
    {
        super.Trigger(Other, EventInstigator);
    }
}

