//=============================================================================
// PerkPiercing.
//=============================================================================
class PerkPiercing extends Perk;

//SARGE: Centralise the piercing perk logic.
function static float GetPiercingPerkMult(DeusExPlayer Player)
{
    local Perk perkPiercing;
    if (Player != none && player.PerkManager != None)
    {
        perkPiercing = Player.PerkManager.GetPerkWithClass(default.class);
        if (perkPiercing.bPerkObtained && player.inHand != none) //SARGE: TODO: Fix this.
            if (player.inHand.IsA('WeaponCombatKnife') || player.inHand.IsA('WeaponShuriken') ||
            player.inHand.IsA('WeaponCrowbar') || player.inHand.IsA('WeaponNanoSword') || player.inHand.IsA('WeaponBaton')) //SARGE: Added Baton
                return perkPiercing.PerkValue;
    }
    return 1.0; //No change;
}

defaultproperties
{
    PerkName="PIERCING"
    PerkDescription="An agent is more likely to cause organic targets to flinch in pain when struck by low-tech weaponry, and an agent deals %d%% more damage to bots and security systems with low-tech weaponry."
    PerkSkill=Class'DeusEx.SkillWeaponLowTech'
    PerkCost=250
    PerkLevelRequirement=2
    PerkValueDisplay=Delta_Percentage
    PerkValue=1.2
}
