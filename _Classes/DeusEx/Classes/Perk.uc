//=============================================================================
// Perk.
//=============================================================================

// Trash: This is where new perks are created 
// Inherit from this and change PerkStats as needed

class Perk extends object;

// Trash: Perk Stats.

var const localized string PerkName;               // Trash: Self Explanatory
var const localized string PerkDescription;        // Trash: Self Explanatory
var class<Skill> PerkSkill;        // Trash: What skill does the perk belong to? Leave blank to make it a general skill
var const Texture PerkIcon;
var const int PerkCost;                  // Trash: How much does it cost to buy this perk?
var const int PerkLevelRequirement;      // Trash: What's the skill requirement to buy this perk?
var const float PerkValue;               // Trash: Optional, what's the value that you want increased when this perk is obtained? For example, 1.25 could mean you heal 25% faster

enum EPerkValueDisplay
{
    Standard,
    Percentage,
    Delta_Percentage,
};

var const EPerkValueDisplay PerkValueDisplay;         // SARGE: How to display perk values when displaying in the perk menu. Standard = show the number. Percentage = multiply by 100. DeltaPercentage = multiply by 100, subtract 100;

var travel DeusExPlayer PerkOwner; // Trash: Who's the perk's owner?
var travel bool bPerkObtained;     // Trash: Do you own this perk?


// ----------------------------------------------------------------------
// GetPerkIcon()
// ----------------------------------------------------------------------

function Texture GetPerkIcon()     // Trash: Return the perk's icon if it's already there, if not just get the default skill icon
{
     if (PerkIcon != None)
     {
          return PerkIcon;
     }
     else
     {
          return PerkOwner.SkillSystem.GetSkillFromClass(PerkSkill).SkillIcon;
     }
}

// ----------------------------------------------------------------------
// IsPurchasable()
// ----------------------------------------------------------------------

function bool IsPurchasable() // Trash: Can you purchase this perk?
{
     return !bPerkObtained && (PerkSkill == None || PerkOwner.SkillSystem.GetSkillLevel(PerkSkill) >= PerkLevelRequirement) && PerkOwner.SkillPointsAvail >= PerkCost;
}

// ----------------------------------------------------------------------
// OnPerkPurchase()
// ----------------------------------------------------------------------

function OnPerkPurchase()    // Trash: Does purchasing this perk do something? See PerkDoorsman for an example
{

}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     PerkName="DEFAULT PERK NAME - ERROR!"
     PerkDescription="DEFAULT PERK DESCRIPTOIN - ERROR!"
     PerkCost=50
     PerkLevelRequirement=2
     PerkValue=1.0
     PerkValueDisplay=Percentage
     bPerkObtained=false
}
