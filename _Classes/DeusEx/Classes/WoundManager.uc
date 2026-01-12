//=============================================================================
// WoundManager.
// SARGE: This handles Wounds on the player, including adding and removing them, etc.
//=============================================================================

class WoundManager extends object;

var private DeusExPlayer PlayerAttached;

var private travel int numWounds;
var private travel Wound WoundsList[20];

enum EWoundDamageType
{
    WOUND_Shot,
    WOUND_Fire,
    WOUND_Shock,
    WOUND_Bleeding,
    WOUND_Falling,
    WOUND_Drowning,
    WOUND_Radiation,
    WOUND_Poison
};

struct WoundDamage
{
    var EWoundDamageType DamageType;
    var int totalDamage;
};

var private travel WoundDamage WoundDamages[8];

function Initialize(DeusExPlayer newPlayer)
{
    PlayerAttached = newPlayer;
}

function ClearAllWounds()
{
    local int i;

    //Remove wounds
    for (i = 0;i < numWounds;i++)
    {
        if (WoundsList[i] != None)
        {
            //WoundsList[i].Destroy();
            WoundsList[i] = None;
        }
    }

    numWounds = 0;
    
    //Reset wound damage
    for (i = 0;i < 8;i++)
        WoundDamages[i].totalDamage = 0;
}

function AddWoundDamage(EWoundDamageType damageType, int Amount)
{
    PlayerAttached.DebugMessage("Adding wound damage of type " $ string(damageType) $ ": " $ Amount);
    WoundDamages[damageType].totalDamage += Amount;
}

function private AddWound(class<Wound> wound)
{
	local Wound woundInstance;
    local int i;
    
    //If we already have it, don't re-add it.
    for (i = 0;i < numWounds;i++)
        if (WoundsList[i].class == wound)
            return;


	woundInstance = new(self) wound;

	WoundsList[numWounds] = woundInstance;
	//WoundsList[numWounds].PerkOwner = PlayerAttached;

    numWounds++;
}
