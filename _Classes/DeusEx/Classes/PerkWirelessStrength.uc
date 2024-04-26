//=============================================================================
// PerkWirelessStrength.
//=============================================================================
class PerkWirelessStrength extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

// Trash: TODO Check PerkValue

defaultproperties
{
    PerkName="WIRELESS STRENGTH"
    PerkDescription="|nMultitools gain considerably increased wireless signal strength, enabling an agent to hack security systems at range.|n|nRequires: Electronics: ADVANCED"
    PerkSkill=Class'DeusEx.SkillTech'
    PerkCost=250
    perkLevelRequirement=1
    PerkValue=1
}