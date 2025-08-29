//=============================================================================
// DeusExLevelInfo
//=============================================================================
class DeusExLevelInfo extends Info
	native;

var() String				MapName;
var() String				MapAuthor;
var() localized String		MissionLocation;
var() int					missionNumber;  // barfy, lowercase "m" due to SHITTY UNREALSCRIPT NAME BUG!
var() Bool					bMultiPlayerMap;
var() class<MissionScript>	Script;
var() int					TrueNorth;
var() localized String		startupMessage[4];		// printed when the level starts
var() String				ConversationPackage;  // DEUS_EX STM -- added so SDK users will be able to use their own convos
var() bool                  bNoSpawnFlies;                                      //RSD: Are we a sterile environment that shouldn't spawn flies?
var() byte                  SongCombatSection;                                  //SARGE: Allow us to define a custom section for combat. By default this is 3
var() int                   SongAmbientSection;                                 //SARGE: Allow us to define a custom section for ambience, since SongSection is read-only.
var() int                   ChairRandomizationToken;                            //SARGE: For Junk Randomization, use a custom token instead of getting a new one. Used for randomising certain maps together             

//SARGE: Replace the bBarOrClub variable with a more complex music system.
enum EMusicType
{
    MT_Normal,              //Music has all the normal tracks, as you'd expect
    MT_SingleTrack,         //Music is a single continous track (used for training music), so never change for any reason.
    MT_ConversationOnly,    //Music only has a standard and conversation track. Used for the Underworld Bar on the final visit to NYC
    MT_CombatOnly,          //Music only has a standard and combat track. Used for most bars.
};

var() EMusicType MusicType;

function SpawnScript()
{
	local MissionScript scr;
	local bool bFound;

	// check to see if this script has already been spawned
	if (Script != None)
	{
		bFound = False;
		foreach AllActors(class'MissionScript', scr)
			bFound = True;

		if (!bFound)
		{
			if (Spawn(Script) == None)
				log("DeusExLevelInfo - WARNING! - Could not spawn mission script '"$Script$"'");
			else
				log("DeusExLevelInfo - Spawned new mission script '"$Script$"'");
		}
		else
			log("DeusExLevelInfo - WARNING! - Already found mission script '"$Script$"'");
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	SpawnScript();
}

defaultproperties
{
     ConversationPackage="DeusExConversations"
     Texture=Texture'Engine.S_ZoneInfo'
     bAlwaysRelevant=True
     SongCombatSection=3
     SongAmbientSection=-1
     ChairRandomizationToken=-1
}
