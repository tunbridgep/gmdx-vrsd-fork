//=============================================================================
// Vice. By RSD for addictive substances
//=============================================================================
class Vice extends RSDEdible                                                    //SARGE: Extend Edible because some vices can be food items when the addiction system is disabled
	abstract;

var int AddictionType;                                                          //RSD: 0 for nicotine, 1 for alcohol, 2 for zyme
var float AddictionIncrement;                                                   //RSD: Amount added to AddictionLevelsArray element
var float DrugIncrement;                                                        //RSD: Amount added to DrugsTimerArray element
var float MaxDrugTimer;                                                         //RSD: Limit for how long a current drug can be active;
var localized string AddictionDescription;                                      //RSD: Special description for if the player has the addiction system active
var bool bUseHunger;                                                            //Sarge: Whether or not a vice uses the hunger system when we have the addiction system disabled

//RSD: Superclass for all addictive drug types
// 0 - Cigarettes (Cigarettes.uc)
// 1 - Alcohol (Liquor40oz.uc, LiquorBottle.uc, WineBottle.uc)
// 2 - Zyme (VialCrack.uc)

//SARGE: We need to have this in here, because some vice's (alcohol) can also be food items
//if the addiction system is disabled.
function bool RestrictedUse(DeusExPlayer player)
{
    return bUseHunger && !player.bAddictionSystem && (player != none && player.fullUp >= 100 && (player.bHardCoreMode || player.bRestrictedMetabolism));
}

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

    //SARGE: New Addiction System
    player.AddictionManager.AddAddiction(AddictionType,AddictionIncrement,DrugIncrement);

    return;
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
