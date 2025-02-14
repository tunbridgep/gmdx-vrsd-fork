//=============================================================================
// CustomSniperRifle.
//=============================================================================
class CustomSniperRifle expands WeaponRifle;

simulated function renderoverlays(Canvas canvas)
{
	if(bHasSilencer)
	  multiskins[4] = default.MultiSkins[4];
	else
	  multiskins[4] = texture'pinkmasktex';
	if(bHasLaser)
	  multiskins[3] = default.MultiSkins[3];
	else
	  multiskins[3] = texture'pinkmasktex';

	multiskins[6] = handsTex;

	super.renderoverlays(canvas); //(weapon)

	if(bHasSilencer)
	  multiskins[3] = default.MultiSkins[3];
	else
	  multiskins[3] = texture'pinkmasktex';
	if(bHasLaser)
	  multiskins[4] = default.MultiSkins[4];
	else
	  multiskins[4] = texture'pinkmasktex';

	multiskins[6] = none;

}

function CheckWeaponSkins()
{

	if(bHasSilencer)
		multiskins[3] = default.MultiSkins[3];
	else
		multiskins[3] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[4] = default.MultiSkins[4];
	else
		multiskins[4] = texture'pinkmasktex';

}


defaultproperties
{
     ShotTime=0.500000
     ScopeFOV=40
     bCanHaveSilencer=False
     ReloadCount=10
     PickupAmmoCount=8
     shakemag=400.000000
     InventoryGroup=126
     ItemName="Custom Sniper Rifle"
     Description="A heavily customised Sniper Rifle. Faster rate of fire, larger magazine size & greater accuracy. Due to heavy barrel modification a silencer cannot be fitted."
}
