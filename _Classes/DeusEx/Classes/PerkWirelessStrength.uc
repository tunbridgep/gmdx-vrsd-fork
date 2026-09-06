//=============================================================================
// PerkWirelessStrength.
//=============================================================================
class PerkWirelessStrength extends Perk;

//SARGE: Determines if an actor can be hacked at range.
//NOTE: This doesn't check range.
static function bool WirelessStrengthCheck(DeusExPlayer P,Actor target)
{
    if (P == None || P.PerkManager == None || !P.PerkManager.GetPerkWithClass(class'PerkWirelessStrength').bPerkObtained || target == None)
        return false;

    if (P.GetInventoryCount('Multitool') == 0)
        return false;

    if (!target.IsA('HackableDevices') || HackableDevices(target).hackStrength == 0.0)
        return false;

    return true;
}

defaultproperties
{
    PerkName="WIRELESS STRENGTH"
    PerkDescription="Multitools gain considerably increased wireless signal strength, enabling an agent to hack security systems at range."
    PerkSkill=Class'DeusEx.SkillTech'
    PerkCost=250
    PerkLevelRequirement=2
    PerkValue=768   //How far we can frob hackables with multitools.
}
