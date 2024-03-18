//=============================================================================
// WeaponModFullAuto
//
//Full-auto Mod
//=============================================================================
class WeaponModFullAuto extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
	if (weapon != None)
	{
	    if (weapon.IsA('WeaponStealthPistol'))
	    {
	        weapon.bAutomatic = True;
	        weapon.bFullAuto = True;
        }
        else
		    weapon.bFullAuto = True;
	}
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveModFullAuto && !weapon.bFullAuto);
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     maxCopies=5
     bCanHaveMultipleCopies=True
     ItemName="Weapon Modification (Full-Auto)"
     Icon=Texture'GMDXSFX.Skins.BeltIconModFullAuto'
     largeIcon=Texture'GMDXSFX.Skins.LargeIconModFullAuto'
     Description="Contains all the tools necessary to modify a wide range of weapon semi-automatic firing mechanisms into fully-automatic. Instructions also included."
     beltDescription="MOD AUTO"
     Skin=Texture'GMDXSFX.Skins.WeaponModTexFullAuto'
}
