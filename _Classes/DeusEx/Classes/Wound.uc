//=============================================================================
// Wound.
// SARGE: Handles the implementation for a given wound.
//=============================================================================

class Wound extends Actor;

var Texture WoundIcon;

var const localized string WoundName;
var const localized string WoundDescription;

var transient DeusExPlayer player;

var private travel bool bHasIt;
var private travel int woundDamage; //How much "damage" we've taken for this wound time
var const int MaxWoundDamage; //At what point we have a chance to get a wound when damage is taken.

var private const int requiredMedkits;  //SARGE: Number of medkits required to cure this wound

function int GetRequiredMedkits()
{
    return requiredMedkits;
}

function bool HasWound()
{
    return bHasIt;
}

function AddWoundDamage(int amount)
{
    woundDamage += amount;

    player.DebugMessage(string(Self.Class) $ ": total wound damage is: " $ woundDamage);

    //For now, simply give us the wound when we reach the max damage
    if (woundDamage >= maxWoundDamage)
        bHasIt = true;
}

function RemoveWound()
{
    bHasIt = false;
    woundDamage = 0;
}

function UpdateInfo(PersonaInfoWindow winInfo)
{
	winInfo.Clear();
	winInfo.SetTitle(WoundName);
    winInfo.SetText(WoundDescription);
    /*
	winInfo.Clear();
	winInfo.SetTitle(SkillName);
	winInfo.SetText(sprintf(SkillPointsToMaster,totalcost)); //SARGE: We need to do this here, sprintf can only take 4 values.
    winInfo.SetText(winInfo.CR());
    */
}

defaultproperties
{
     WoundIcon=Texture'DeusExUI.UserInterface.SkillIconMedicine'
     WoundName="Default Trauma."
     WoundDescription="Report this as a bug!"
     requiredMedkits=1
     MaxWoundDamage=1500
     bHidden=True
     bTravel=True
}
