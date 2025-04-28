//=============================================================================
// SkillWeaponPistol.
//=============================================================================
class SkillWeaponPistol extends Skill;

var int mpCost1;
var int mpCost2;
var int mpCost3;
var float mpLevel0;
var float mpLevel1;
var float mpLevel2;
var float mpLevel3;

simulated function PreBeginPlay()
{
    local DeusExLevelInfo info;
    local DeusExPlayer player;
    local bool bGivePistols;

    player = DeusExPlayer(GetPlayerPawn());

    Super.PreBeginPlay();

    //== Y|y: we only want to bump this up to Trained when starting a new game
    if ( Level.NetMode == NM_Standalone && player != None)
    {
        //== Y|y: this will detect if we're doing it from one of the intro (non-cinematic) maps
        foreach AllActors(class'DeusExLevelInfo', info)
        {
            if(info.MissionNumber < 0)
                bGivePistols = true;
        }

        //== Y|y: This detects if the player is starting a new game during an existing one
        if(player.bShowMenu)
            bGivePistols = true;

        //SARGE: If we have the "start pistols at trained" setting, give a skill level,
        //otherwise, give us the skill points for the value of the first level.
        if (bGivePistols && player.bPistolStartTrained)
            CurrentLevel = 1;
        else if (bGivePistols)
        {
            player.SkillPointsTotal = player.default.SkillPointsTotal + cost[0];
            player.SkillPointsAvail = player.default.SkillPointsAvail + cost[0];
        }
    }

    if ( Level.NetMode != NM_Standalone )
    {
        cost[0] = mpCost1;
        cost[1] = mpCost2;
        cost[2] = mpCost3;
        LevelValues[0] = mpLevel0;
        LevelValues[1] = mpLevel1;
        LevelValues[2] = mpLevel2;
        LevelValues[3] = mpLevel3;
    }
}

defaultproperties
{
     mpCost1=2000
     mpCost2=2000
     mpCost3=2000
     mpLevel0=-0.100000
     mpLevel1=-0.250000
     mpLevel2=-0.370000
     mpLevel3=-0.500000
     SkillName="Weapons: Pistol"
     Description="The use of hand-held weapons, including the standard 10mm pistol, its stealth variant, and the mini-crossbow. Total Skill points to master: 9000 |n|nUNTRAINED: An agent can use pistols.|n|nTRAINED: Accuracy and damage increases slightly, while reloading is faster.|n|nADVANCED: Accuracy and damage increases moderately, while reloading is even more rapid.|n|nMASTER: An agent is lethally precise with pistols."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponPistol'
     cost(0)=1500
     cost(1)=3000
     cost(2)=4500
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
}
