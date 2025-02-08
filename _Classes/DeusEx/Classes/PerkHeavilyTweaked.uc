//=============================================================================
// PerkHeavilyTweaked.
//=============================================================================
class PerkHeavilyTweaked extends Perk;

//Make all GEP Guns in the players inventory accept laser and scope mods
function OnPerkPurchase()
{
	local Inventory item;
    local WeaponGEPGun gep;

    item = PerkOwner.Inventory;
    do
    {
        if (item == None) //This should never happen
            return;

        if (item.isA('WeaponGEPGun'))
        {
            gep = WeaponGEPGun(item);
            gep.bCanHaveScope = true;
            gep.bCanHaveLaser = true;
        }
        item = item.Inventory;
    }
    until (item == None);
}

defaultproperties
{
    PerkName="HEAVILY TWEAKED"
    PerkDescription="An agent is able to attach scopes and laser sights to the GEP gun, enabling laser guidance and fly-by-wire capabilities."
    PerkSkill=Class'DeusEx.SkillWeaponHeavy'
    PerkCost=100
    PerkLevelRequirement=2
}

