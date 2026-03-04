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
var const int DamageThreshold; //At what point we have a chance to get a wound when damage is taken.

var private const int requiredMedkits;  //SARGE: Number of medkits required to cure this wound

var const float woundData[4];           //SARGE: Allow assigning data to wounds

var const bool bNoDisplay;              //SARGE: Don't display in the list. It's essentially hidden.

function int GetRequiredMedkits()
{
    return requiredMedkits;
}

function bool HasWound()
{
    return bHasIt;
}

function int GetDamage()
{
    return woundDamage;
}

//FOR NOW this is the same as HasWound.
//Will be tiered soon.
function string GetSeverity()
{
    if (bHasIt)
        return "Afflicted";
    else
        return "Unaffected";
}

function AddWoundDamage(int amount)
{
    woundDamage += amount;

    player.DebugMessage(string(Self.Class) $ ": total wound damage is: " $ woundDamage);

    //For now, simply give us the wound when we reach the max damage
    if (woundDamage >= DamageThreshold && !bHasIt)
    {
        bHasIt = true;
        WoundAdded();
    }
}

function WoundAdded()
{
}

function WoundRemoved()
{
}

function RemoveWound()
{
    bHasIt = false;
    woundDamage = 0;
    WoundRemoved();
}

function UpdateInfo(PersonaInfoWindow winInfo)
{
	winInfo.Clear();
	winInfo.SetTitle(WoundName);
    winInfo.SetText(sprintf(WoundDescription,int(woundData[0])));
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
     DamageThreshold=450
     bHidden=True
     bTravel=True
}
