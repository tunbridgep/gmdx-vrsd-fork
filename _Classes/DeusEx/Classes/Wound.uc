//=============================================================================
// Wound.
// SARGE: Handles the implementation for a given wound.
//=============================================================================

class Wound extends Actor;

var Texture WoundIcon;

var const localized string WoundName;
var const localized string WoundDescription;
var const localized string WoundPoints;
var const localized string WoundAfflicted;

var transient DeusExPlayer player;

var private travel bool bHasIt;
var private travel int woundDamage; //How much "damage" we've taken for this wound time
var const int DamageThreshold; //At what point we have a chance to get a wound when damage is taken.

var private const int requiredMedkits;  //SARGE: Number of medkits required to cure this wound

var const float woundData[4];           //SARGE: Allow assigning data to wounds

var const bool bNoDisplay;              //SARGE: Don't display in the list. It's essentially hidden.

var const Sound WoundSound;             //SARGE: Play a sound when we get a trauma.

function int GetRequiredMedkits()
{
    if (bHasIt)
        return requiredMedkits;
    else
        return 0;
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
    //Don't increment non-displayed wonuds.
    if (bNoDisplay)
        return;

    woundDamage += amount;

    player.DebugMessage(string(Self.Class) $ ": total wound damage is: " $ woundDamage);

    //For now, simply give us the wound when we reach the max damage
    if (woundDamage >= DamageThreshold && !bHasIt && player.bWoundSystem)
    {
        bHasIt = true;
        WoundAdded();
    }
}

function WoundAdded()
{
    player.ClientMessage(sprintf(WoundAfflicted,WoundName));
    player.PlaySound(WoundSound,SLOT_None);
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
    winInfo.SetText(winInfo.CR());
    winInfo.SetText(sprintf(WoundPoints,woundDamage,damageThreshold));
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
     WoundSound=Sound'RSDCrap.Misc.Trauma'
     WoundName="Default Trauma."
     WoundDescription="Report this as a bug!"
     WoundPoints="Current Wound Progress: %d/%d"
     WoundAfflicted="You are suffering from %s"
     requiredMedkits=1
     DamageThreshold=350
     bHidden=True
     bTravel=True
}
