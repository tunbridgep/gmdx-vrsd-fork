//=============================================================================
// WeaponModAuto (Rate of fire)
//
// Rate of Fire Mod
//=============================================================================
class WeaponModAuto extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
	if (weapon != None)
	{
		weapon.ShotTime += (weapon.Default.ShotTime * WeaponModifier);
		if (weapon.ShotTime < 0.0)
			weapon.ShotTime = 0.0;
		weapon.ModShotTime += WeaponModifier;
	}
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveModShotTime && !weapon.HasMaxROFMod());
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WeaponModifier=-0.100000
     maxCopies=5
     bCanHaveMultipleCopies=True
     ItemName="Weapon Modification (Rate of Fire)"
     Icon=Texture'ShifterEX.Icons.BeltIconModAuto'
     largeIcon=Texture'ShifterEX.Icons.LargeIconModAuto'
     Description="A universal rate of fire modification pack equipped with various tools used for modifying key mechanisms commonly found in many firearms such as bolts, case ejectors, springs and even magnetic accelerators found in hi-tech weaponry resulting in increased RPM (Rounds Per Minute)."
     beltDescription="MOD ROF"
     Skin=Texture'ShifterEX.Items.WeaponModTexAuto'
}
