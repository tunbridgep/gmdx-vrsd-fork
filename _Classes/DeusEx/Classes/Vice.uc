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

//RSD: Superclass for all addictive drug types
// 0 - Cigarettes (Cigarettes.uc)
// 1 - Alcohol (Liquor40oz.uc, LiquorBottle.uc, WineBottle.uc)
// 2 - Zyme (VialCrack.uc)

//SARGE: We need to have this in here, because some vice's (alcohol) can also be food items
//if the addiction system is disabled.
function bool RestrictedUse(DeusExPlayer player)
{
    return !player.bAddictionSystem && (player != none && player.fullUp >= 100 && (player.bHardCoreMode || player.bRestrictedMetabolism));
}

//Add to the players FullUp bar, but only if we aren't using vices
function FillUp(DeusExPlayer player)
{
    if (!player.bAddictionSystem)
        Super.FillUp(player);
}

function Eat(DeusExPlayer player)
{
    if (player.bAddictionSystem)
        HandleViceEffects(player);
}

//Allow healing, but only if we're not using the addiction system
function int GetHealAmount(DeusExPlayer player)
{
    if (player.bAddictionSystem)
        return 0;
    else
        return healAmount;
}

function string GetDescription(DeusExPlayer player)
{
    if (player.bAddictionSystem)
        return AddictionDescription;
   	else
        return Description;
}

function HandleViceEffects(DeusExPlayer player)
{
    //SARGE: New Addiction System
    player.AddictionManager.AddAddiction(AddictionType,AddictionIncrement,DrugIncrement);
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
