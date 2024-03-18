//=============================================================================
// Skill.
//=============================================================================
class Skill extends Actor
	intrinsic;

var() localized string		SkillName;
var() localized string		Description;
var   Texture               SkillIcon;
var() bool					bAutomatic;
var() bool					bConversationBased;
var() int					Cost[3];
var() float					LevelValues[4];
var travel int				CurrentLevel;		// 0 is unskilled, 3 is master
var() class<SkilledTool>	itemNeeded;

// which player am I attached to?
var DeusExPlayer Player;

// Pointer to next skill
var travel Skill next;

// Printable skill level strings
var Localized string skillLevelStrings[4];
var localized string SkillAtMaximum;
var localized string      PerksDescription; //CyberP: perks
var localized string      PerksDescription2; //CyberP: perks
var localized string      PerksDescription3; //CyberP: perks
var string      PerkName, PerkName2, PerkName3;  //CyberP: not localized as perk name is passed in code
var int					  PerkCost[3];       //CyberP: perks
var localized string LocalizedPerkName;       //CyberP: change this to change perk name displayed in-game without fucking up the system
var localized string LocalizedPerkName2;
var localized string LocalizedPerkName3;
// ----------------------------------------------------------------------
// network replication
// ----------------------------------------------------------------------

replication
{
    //variables server to client
    reliable if ((Role == ROLE_Authority) && (bNetOwner))
        CurrentLevel, next;

    //functions client to server
    reliable if (Role < ROLE_Authority)
        IncLevel, Use, DecLevel;

}

// ----------------------------------------------------------------------
// PreBeginPlay()
// ----------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( (Level.NetMode != NM_StandAlone ) && (Level.Game != None) && (Level.Game.IsA('DeusExMPGame')) )
	{
      CurrentLevel = DeusExMPGame(Level.Game).MPSkillStartLevel;
	}
}

// ----------------------------------------------------------------------
// Use()
// ----------------------------------------------------------------------

function bool Use()
{
	local bool bDoIt;

	bDoIt = True;

	if (itemNeeded != None)
	{
		bDoIt = False;

		if ((Player.inHand != None) && (Player.inHand.Class == itemNeeded))
		{
			SkilledTool(Player.inHand).PlayUseAnim();

			// alert NPCs that I'm messing with stuff
			if (Player.FrobTarget != None)
				if (Player.FrobTarget.bOwned && Player.perkNamesArray[35] != 1)     //RSD: Unless you have the Sleight of Hand perk //RSD: WHY DID I COMMENT THAT OUT?! GAHHHH
					Player.FrobTarget.AISendEvent('MegaFutz', EAITYPE_Visual);

			bDoIt = True;
		}
	}

	return bDoIt;
}

// ----------------------------------------------------------------------
// accessor functions
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// GetCost()
// ----------------------------------------------------------------------

simulated function int GetCost()
{
	return Cost[CurrentLevel];
}

// ----------------------------------------------------------------------
// GetCurrentLevel()
// ----------------------------------------------------------------------

simulated function int GetCurrentLevel()
{
	return CurrentLevel;
}

// ----------------------------------------------------------------------
// GetCurrentLevelString()
//
// Returns a string representation of the current skill level.
// ----------------------------------------------------------------------

simulated function String GetCurrentLevelString()
{
	return skillLevelStrings[currentLevel];
}

// ----------------------------------------------------------------------
// IncLevel()
// ----------------------------------------------------------------------

function bool IncLevel(optional DeusExPlayer usePlayer)
{
	local DeusExPlayer localPlayer;

	// First make sure we're not maxed out
	if (CurrentLevel < 3)
	{
		// If "usePlayer" is passed in, then we want to use this
		// as the basis for making our calculations, temporarily
		// overriding whatever this skill's player is set to.

		if (usePlayer != None)
			localPlayer = usePlayer;
		else
			localPlayer = Player;

		// Now, if a player is defined, then check to see if there enough
		// skill points available.  If no player is defined, just do it.
		if (localPlayer != None)
		{
			if ((localPlayer.SkillPointsAvail >= Cost[CurrentLevel]))
			{
				// decrement the cost and increment the current skill level
				localPlayer.SkillPointsAvail -= GetCost();
				localPlayer.PlaySound(Sound'GMDXSFX.Generic.Select',SLOT_None);
				CurrentLevel++;
				return True;
			}
		}
		else
		{
			CurrentLevel++;
			return True;
		}
	}

	return False;
}

// ----------------------------------------------------------------------
// DecLevel()
//
// Decrements a skill level, making sure the skill isn't already at
// the lowest skill level.  Cost of the skill is optionally added back
// to the player's SkilPointsAvail variable.
// ----------------------------------------------------------------------

function bool DecLevel(
	optional bool bGiveUserPoints,
	optional DeusExPlayer usePlayer )
{
	local DeusExPlayer localPlayer;

	// First make sure we're not already at the bottom
	if (CurrentLevel > 0)
	{
		// Decrement the skill level
		CurrentLevel--;

		// If "usePlayer" is passed in, then we want to use this
		// as the basis for making our calculations, temporarily
		// overriding whatever this skill's player is set to.

		if (usePlayer != None)
			localPlayer = usePlayer;
		else
			localPlayer = Player;

		// If a player exists and the 'bGiveUserPoints' flag is set,
		// then add the points to the player
		if (( bGiveUserPoints ) && (localPlayer != None))
			localPlayer.SkillPointsAvail += GetCost();

		return True;
	}

	return False;
}

// ----------------------------------------------------------------------
// CanAffordToUpgrade()
//
// Given the points passed in, checks to see if the skill can be
// upgraded to the next level.  Will always return False if the
// skill is already at the maximum level.
// ----------------------------------------------------------------------

simulated function bool CanAffordToUpgrade( int skillPointsAvailable )
{
	if ( CurrentLevel == 3 )
		return False;
	else if ( Cost[CurrentLevel] > skillPointsAvailable )
		return False;
	else
		return True;
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.Clear();
	winInfo.SetTitle(SkillName);
	winInfo.SetText(Description);
	if (IsA('SkillLockpicking') || IsA('SkillTech'))
       if (player != None && player.bHardCoreMode)                              //RSD: Edited these, were 5/10/15/50%, now 5/10/20/50%
          wininfo.SetText(winInfo.CR() $ "HARDCORE MODE VALUES:" $ winInfo.CR() $ winInfo.CR() $ skillLevelStrings[0] $ ": 5%" $ winInfo.CR() $
          skillLevelStrings[1] $ ": 10%" $ winInfo.CR() $ skillLevelStrings[2] $ ": 20%" $ winInfo.CR() $ skillLevelStrings[3] $ ": 50%");

	return True;
}

simulated function bool UpdatePerksInfo(Object winObject)    //CyberP: perks
{
	local PersonaInfoWindow winInfo;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

    PerkName = default.PerkName;
    PerkName2 = default.PerkName2;
    PerkName3 = default.PerkName3;
	winInfo.Clear();
	winInfo.SetTitle(SkillName);
	/*winInfo.SetText(PerksDescription);
	winInfo.SetText(LineBreaker);
	winInfo.SetText(PerksDescription2);
	winInfo.SetText(LineBreaker);
	winInfo.SetText(PerksDescription3);
	winInfo.SetText(LineBreaker); */
	winInfo.CreatePerkButtons(PerksDescription,PerksDescription2,PerksDescription3, PerkCost[0],
    PerkCost[1], PerkCost[2], PerkName, PerkName2, PerkName3, LocalizedPerkName, LocalizedPerkName2, LocalizedPerkName3, SkillIcon);
    //Totalitarian: WARNING! THE WHOLE PERK SYSTEM PASSES PERK NAME! DO NOT CHANGE THE NAME OF PERKS
    //Totalitarian: INSTEAD CHANGE THE LocalizedPerkName VAR
	return True;
}
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     skillLevelStrings(0)="UNTRAINED"
     skillLevelStrings(1)="TRAINED"
     skillLevelStrings(2)="ADVANCED"
     skillLevelStrings(3)="MASTER"
     SkillAtMaximum="Skill at Maximum Level"
     PerksDescription="PERK 1 |n|nDescript |n|nRequires: Placeholder Skill (Trained) |nSkill Points Needed: x |n"
     PerksDescription2="PERK 2|n|nDescript |n|nRequires: Placeholder Skill (Advanced) |nSkill Points Needed: x |n"
     PerksDescription3="PERK 3|n|nDescript |n|nRequires: Placeholder Skill (Master) |nPoints Needed: x |n"
     bHidden=True
     bTravel=True
     NetUpdateFrequency=5.000000
}
