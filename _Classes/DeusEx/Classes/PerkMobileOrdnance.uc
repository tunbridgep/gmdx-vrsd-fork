//=============================================================================
// PerkHeavilyTweaked.
//=============================================================================
class PerkMobileOrdnance extends Perk;

//Make all Flamethrowers take up 3 spaces instead of 6
function OnMapLoadAndPurchase()
{
	local Inventory item;
    local DeusExWeapon W;

    item = PerkOwner.Inventory;
    do
    {
        if (item == None) //This should never happen
            return;

        if ( item.isA('WeaponFlamethrower')/* || item.isA('WeaponGEPGun') || item.isA('WeaponPlasmaRifle')*/)
        {
            W = DeusExWeapon(item);
            W.ResizeHeavyWeapon(PerkOwner);
        }
        item = item.Inventory;
    }
    until (item == None);
}

defaultproperties
{
    PerkName="MOBILE ORDNANCE"
    PerkDescription="An agent is able to modify the chassis of flame weapons, stripping away unnecessary elements. Flamethrowers are reduced in size by 3 inventory spaces."
    PerkSkill=Class'DeusEx.SkillWeaponHeavy'
    PerkCost=250
    PerkLevelRequirement=3
}

