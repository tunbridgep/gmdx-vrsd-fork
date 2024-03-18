//=============================================================================
// Vice. By RSD for addictive substances
//=============================================================================
class Vice extends DeusExPickup
	abstract;

var int AddictionType;                                                          //RSD: 0 for nicotine, 1 for alcohol, 2 for zyme
var float AddictionIncrement;                                                   //RSD: Amount added to AddictionLevelsArray element
var float DrugIncrement;                                                        //RSD: Amount added to DrugsTimerArray element
var float MaxDrugTimer;                                                         //RSD: Limit for how long a current drug can be active;
var localized string AddictionDescription;                                      //RSD: Special description for if the player has the addiction system active

//RSD: Superclass for all addictive drug types
// 0 - Cigarettes (Cigarettes.uc)
// 1 - Alcohol (Liquor40oz.uc, LiquorBottle.uc, WineBottle.uc)
// 2 - Zyme (VialCrack.uc)

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local string str;
    local DeusExPlayer player;

	player = DeusExPlayer(GetPlayerPawn());

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.SetTitle(itemName);

    if (player.bAddictionSystem)
    	winInfo.SetText(AddictionDescription $ winInfo.CR() $ winInfo.CR());
   	else
		winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());

	if (bCanHaveMultipleCopies)
	{
		// Print the number of copies
		str = CountLabel @ String(NumCopies);
		winInfo.AppendText(str);
	}

	return True;
}

function UseOnce()
{
    local DeusExPlayer player;

    super.UseOnce();

    player = DeusExPlayer(GetPlayerPawn());
    if (player.bAddictionSystem)
        HandleViceEffects();
}

function HandleViceEffects()
{
    local DeusExPlayer player;

    player = DeusExPlayer(GetPlayerPawn());

    player.AddictionLevelsArray[AddictionType] += AddictionIncrement;           //RSD: Add to the addiction meter
    if (player.AddictionLevelsArray[AddictionType] > 100.0)
    	player.AddictionLevelsArray[AddictionType] = 100.0;

   	player.DrugsTimerArray[AddictionType] += DrugIncrement;                     //RSD: Add to the drug timer
   	if (player.DrugsTimerArray[AddictionType] > MaxDrugTimer)
   		player.DrugsTimerArray[AddictionType] = MaxDrugTimer;
   	if (player.DrugsWithdrawalArray[AddictionType] == 1)                        //RSD: Remove any withdrawal symptoms
   	{
   		player.DrugsWithdrawalArray[AddictionType] = 0;
   		player.DrugsWasWithdrawalArray[AddictionType] = 0;                      //RSD: Reset this "bool" so we'll get the addiction message again when it runs out
   		player.DrugsWithdrawalTimerArray[AddictionType] = 0.;                   //RSD: Reset this timer as well
    }

    if (AddictionType == 1)                                                     //RSD: need this for a hack in DrugEffects() in DeusExPlayer.uc
    	player.DrunkLevel = int(player.DrugsTimerArray[1]/120.0+1.0);
}

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		Super.BeginState();

		//UseOnce();
	}
Begin:
}

defaultproperties
{
     AddictionType=1
     AddictionIncrement=10.000000
     DrugIncrement=120.000000
     MaxDrugTimer=600.000000
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
}
