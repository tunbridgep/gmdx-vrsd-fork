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
var() bool                  bBarOrClub;                 //CyberP: bar map, so no dynamic music
var() bool                  bNoSpawnFlies;                                      //RSD: Are we a sterile environment that shouldn't spawn flies?
var() byte                  SongCombatSection;                                  //SARGE: Allow us to define a custom section for combat. By default this is 3

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
}
