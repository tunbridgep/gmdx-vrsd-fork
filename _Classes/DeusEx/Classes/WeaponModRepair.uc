//=============================================================================
// WeaponModRepair by dasraiser for GMDX
//
// Fix Weapon based on skill
//
//NOTES:
//
// WeaponModifier is used as percentage multiplier for
//
//damage,  misfires, range, reload speed, jamming
//and perhaps accuracy, perhaps as there are plenty of accuracy penalties already
//=============================================================================
/*

var basis

DeusExWeapon:bHasRepairTool used for testing if it was attached to weapon,
all weapons will have this attached by default, so no need for bCanHave..

base skill set
untrained 50%
trained 75%
advance 75% +50% all weapons at bot
master 75% +100% all weapons at bot

durability mod reduces speed of degrade


NOT ADDING self:NumberCharges, used by skill system SkillMaintenance [TBA], allow player multiple uses
*/
class WeaponModRepair extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
	if (weapon != None)
		weapon.bHasSilencer = True;
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveSilencer && !weapon.bHasSilencer);
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     maxCopies=5
     bCanHaveMultipleCopies=True
     ItemName="Weapon Repair Tool"
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponModSilencer'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModSilencer'
     Description="Repair Tool Description"
     beltDescription="MOD Repair"
     Skin=Texture'GMDXUI.Skins.WeaponModTexRepair'
}
