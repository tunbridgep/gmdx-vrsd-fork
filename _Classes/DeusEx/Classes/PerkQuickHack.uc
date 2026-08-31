//=============================================================================
// PerkQuickHack.
//=============================================================================
class PerkQuickHack extends Perk;

var localized string strHacked;

//SARGE: Determines if an actor can be quick hacked.
//This works by checking the individual types.
static function bool CanBeQuickHacked(DeusExPlayer P,Actor target)
{
    local AutoTurret turr;
    
    if (P == None || P.PerkManager == None || !P.PerkManager.GetPerkWithClass(class'PerkQuickHack').bPerkObtained || target == None)
        return false;

    if (P.CarriedDecoration != None)
        return false;

    if (P.inHand != None && !P.inHand.IsA('POVCorpse'))
        return false;

    //Low energy
    if (P.Energy < P.PerkManager.GetPerkWithClass(class'PerkQuickHack').PerkValue)
        return false;

    if (target.IsA('AutoTurretGun'))
        turr = AutoTurret(target.Owner);
    else if (target.IsA('AutoTurret'))
        turr = AutoTurret(target);
    
    if ((turr != None && turr.CanBeQuickHacked()) ||
        (target.IsA('Robot') && Robot(target).CanBeQuickHacked()) ||
        (target.IsA('SecurityCamera') && SecurityCamera(target).CanBeQuickHacked()))
            return true;

    return false;
}

static function PerformQuickHack(DeusExPlayer P, Actor target)
{
    local AutoTurret turr;
    
    P.ClientMessage(default.strHacked);

    if (target.IsA('AutoTurretGun'))
        turr = AutoTurret(target.Owner);
    else if (target.IsA('AutoTurret'))
        turr = AutoTurret(target);
    
    if (turr != None)
        turr.PerformQuickHack(P);
    else if (target.IsA('Robot'))
        Robot(target).PerformQuickHack(P);
    else if(target.IsA('SecurityCamera'))
        SecurityCamera(target).PerformQuickHack(P);
}

defaultproperties
{
    PerkName="QUICK HACK"
    PerkDescription="An agent modifies their augmentation interface, allowing them to expel a small amount of bioenergy (%d) to interfere with the internal systems of Bots, Cameras and Turrets. By using the Reload key while holstered, an agent can disable cameras and bots or take over the targeting routines of turrets at medium range for a few seconds.|n|nUnfortunately, network firewalls are quick to adapt and prevent repeated quick hacks on the same device."
    PerkSkill=Class'DeusEx.SkillComputer'
    PerkCost=450
    PerkLevelRequirement=2
    PerkValue=5
    PerkValueDisplay=Standard
    strHacked="Quick-Hack Initialized..."
	bPerkEnabled=false
}
