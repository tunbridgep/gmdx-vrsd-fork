//=============================================================================
// SkillComputer.
//=============================================================================
class SkillComputer extends Skill;

var int mpCost1;
var int mpCost2;
var int mpCost3;
var float mpLevel0;
var float mpLevel1;
var float mpLevel2;
var float mpLevel3;

var localized string strHardcore;               //"HARDCORE MODE ADDITIONS:"
var localized string strNewHackSystem;          //"NEW HACKING SYSTEM ADDITIONS:"
var localized string strDescExtra;              //The info about the new hacking system

//SARGE: If playing on Hardcore or with the new hack system, update description
simulated function bool UpdateInfo(Object winObject)
{
    local string title;
	local PersonaInfoWindow winInfo;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

    Super.UpdateInfo(winObject);

    if (player == None || (!player.bHackLockouts && !player.bHardCoreMode))
        return True;
    
    if (player.bHardCoreMode)
        title = strHardcore;
    else if (player.bHackLockouts)
        title = strNewHackSystem;
        
    wininfo.SetText(winInfo.CR() $ title $ winInfo.CR() $ winInfo.CR() $ strDescExtra);

	return True;
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

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
//GMDX: upped level 4 so can be leisurely (was 4)

defaultproperties
{
     mpCost1=1000
     mpCost2=1000
     mpCost3=1000
     mpLevel0=0.400000
     mpLevel1=0.400000
     mpLevel2=1.000000
     mpLevel3=5.000000
     SkillName="Computers"
     Description="The covert manipulation of computers and security consoles.|n|nTotal skill points to master: 6000.|n|nUNTRAINED: An agent can use terminals to read bulletins and news. |n|nTRAINED: An agent can hack computers and security consoles of intermediate security systems and siphon up to half of an ATM's funds. |n|nADVANCED: An agent can hack computers featuring advanced defense systems and siphon all credits from ATMs, and achieves a moderate increase in detection time.|n|nMASTER: An agent is an elite hacker that no system can withstand, gaining the ability to spoof additional credits from ATMs and evading detection for long periods."
     strHardcore="HARDCORE MODE ADDITIONS:"
     strNewHackSystem="NEW HACKING SYSTEM ADDITIONS:"
     strDescExtra="Devices will reboot after a certain time, returning to their default state. Additionally, hacking the same terminal repeatedly will result in network detection, preventing future hacking attempts.|n|nReboot Times:|n2 minutes at TRAINED, plus 1 additional minute on ADVANCED and MASTER (4 Minutes Total)|n|nMaximum Successful Hacks:|n2 plus 1 additional hack on ADVANCED and MASTER (4 Total)"
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconComputer'
     cost(0)=1000
     cost(1)=2000
     cost(2)=3000
     LevelValues(0)=1.000000
     LevelValues(1)=1.000000
     LevelValues(2)=2.000000
     LevelValues(3)=16.000000
}
