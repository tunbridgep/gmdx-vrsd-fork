//=============================================================================
// WoundManager.
// SARGE: This handles Wounds on the player, including adding and removing them, etc.
//=============================================================================

class WoundManager extends Actor;

var private DeusExPlayer PlayerAttached;

var private travel int numWounds;
var private travel Wound WoundsList[20];

function Initialize(DeusExPlayer newPlayer)
{
    PlayerAttached = newPlayer;

    SetupWound(class'WoundBloodLoss');
    SetupWound(class'WoundBurning');
    SetupWound(class'WoundDrowning');
    SetupWound(class'WoundFalling');
    SetupWound(class'WoundPoison');
    SetupWound(class'WoundRadiation');
    SetupWound(class'WoundShock');
    SetupWound(class'WoundShot');
}

function int GetWoundNumber()
{
    return numWounds;
}

function Wound GetWoundByIndex(int id)
{
    if (id < numWounds)
        return WoundsList[id];
    else
        return None;
}

function Wound GetWoundByType(class<Wound> woundType)
{
    local int i;

    for (i = 0;i < numWounds;i++)
        if (woundsList[i].Class == woundType)
            return woundsList[i];
    return None;
}

function bool HasWounds()
{
    local int i;

    for (i = 0;i < numWounds;i++)
        if (woundsList[i].HasWound())
            return true;

    return false;
}

function private SetupWound(class<Wound> woundClass)
{
	local Wound woundInstance;
    local int i;

    for (i = 0;i < numWounds;i++)
        if (WoundsList[i].Class == woundClass)
            woundInstance = WoundsList[i];

    if (woundInstance == None)
    {
        woundInstance = Spawn(woundClass, Self);
        woundsList[numWounds++] = woundInstance;
        PlayerAttached.DebugMessage("Creating new wound: " $ woundClass);
    }
    
    woundInstance.player = PlayerAttached;
}

function ClearAllWounds()
{
    local int i;

    //Remove wounds
    for (i = 0;i < numWounds;i++)
    {
        if (WoundsList[i] != None)
        {
            WoundsList[i].RemoveWound();
        }
    }
}

function AddWoundDamage(class<Wound> woundType, int Amount)
{
    local Wound W;
    local int i;

    for(i = 0;i < numWounds;i++)
        if (WoundsList[i].Class == woundType)
            W = WoundsList[i];

    if (W == None)
        return;
    
    PlayerAttached.DebugMessage("Adding wound damage of type " $ string(woundType) $ ": " $ Amount);
    W.AddWoundDamage(Amount);
}

/*
function AddWound(class<Wound> wound)
{
	local Wound woundInstance;
    local int i;
    
    for (i = 0;i < numWounds;i++)
        if (WoundsList[i].class == wound)
        {
            WoundsList[i].bHasIt = true;
            return;
        }
}
*/

defaultproperties
{
     bHidden=True
     bTravel=True
}
