//=============================================================================
// WeaponModRange
//
// Increases Accurate Range
//=============================================================================
class WeaponModDamage extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
	if (weapon != None)
	{
		//weapon.HitDamage += (weapon.Default.HitDamage * WeaponModifier);
		weapon.ModDamage += WeaponModifier;
	}
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveModDamage && !weapon.HasMaxDAMMod());
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WeaponModifier=0.100000
     maxCopies=5
     bCanHaveMultipleCopies=True
     ItemName="Weapon Modification (Damage)"
     Icon=Texture'GMDXSFX.Skins.WeaponModTexDamIcon'
     largeIcon=Texture'GMDXSFX.Skins.WeaponModTexDamIconLarge'
     Description="Cutting edge combustion mechanisms & pressurized gas formulas result in increased muzzle velocity and therefore potential lethality."
     beltDescription="MOD DAM"
     Skin=Texture'GMDXSFX.Skins.WeaponModTexDam'
}
