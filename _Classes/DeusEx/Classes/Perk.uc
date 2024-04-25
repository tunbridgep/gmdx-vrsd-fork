//=============================================================================
// Perk.
//=============================================================================

// Trash: This is where new perks are created 
// PERK SYSTEM #1: Inherit from this and change PerkStats as needed

class Perk extends Actor;

// Trash: Perk Stats.

var string PerkName;            // Trash: Self Explanatory
var string PerkDescription;     // Trash: Self Explanatory
var class<Skill> PerkSkill;     // Trash: What skill does the perk belong to? Leave blank to make it a general skill
var int PerkCost;               // Trash: How much does it cost to buy this perk?
var int PerkLevelRequirement;   // Trash: What's the skill requirement to buy this perk?
var float PerkValue;            // Trash: Optional, what's the value that you want increased when this perk is obtained? For example, 1.25 could mean you heal 25% faster

var travel bool bPerkObtained;  // Trash: Do you own this perk?

// ----------------------------------------------------------------------
// PreBeginPlay()
// ----------------------------------------------------------------------

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

// ----------------------------------------------------------------------
// ReturnPerkSkill()
// ----------------------------------------------------------------------

function Skill ReturnPerkSkill()
{
    local DeusExPlayer player;

	return player.SkillSystem.GetSkillFromClass(PerkSkill);
}

// ----------------------------------------------------------------------
// PurchasePerk()
// ----------------------------------------------------------------------

function PurchasePerk()
{
    local DeusExPlayer player;

    if (player != none && bPerkObtained == false)
    {
        if (player.SkillPointsAvail >= PerkCost)
        {
            player.SkillPointsAvail -= PerkCost;
            player.PlaySound(Sound'GMDXSFX.Generic.Select',SLOT_None);
            bPerkObtained = true;
        }
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     PerkName="DEFAULT PERK NAME - ERROR!"
     PerkDescription="DEFAULT PERK DESCRIPTOIN - ERROR!"
     PerkCost=50
     PerkLevelRequirement=1
     PerkValue=1.0
}