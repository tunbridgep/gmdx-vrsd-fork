//Trash: This is where new perks are created.

class Perk extends Actor;

// Trash: Perk Stats.

var string perkName;
var string perkDescription;
var Skill perkSkill;
var int perkCost;
var int perkLevelRequirement;
var float perkValue;

var travel bool bPerkObtained;

function bool PurchasePerk()
{
    local DeusExPlayer player;

    if (player != none && bPerkObtained == false)
    {
        if (player.SkillPointsAvail >= PerkCost)
        {
            player.SkillPointsAvail -= PerkCost;
            player.PlaySound(Sound'GMDXSFX.Generic.Select',SLOT_None);
            bPerkObtained = true;

            return true;
        }
    }
    else
    return false;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     perkName="DEFAULT PERK NAME - ERROR!"
     perkDescription="DEFAULT PERK DESCRIPTOIN - ERROR!"
     PerkCost=50
     perkLevelRequirement=1
     perkValue=1.0
}