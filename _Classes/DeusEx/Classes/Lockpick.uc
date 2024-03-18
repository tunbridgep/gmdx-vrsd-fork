//=============================================================================
// Lockpick.
//=============================================================================
class Lockpick expands SkilledTool;

function texture GetWeaponHandTex()
{
	local deusexplayer p;
	local texture tex;

    if (bIsRadar)
        return Texture'Effects.Electricity.Xplsn_EMPG';
    else if (bIsCloaked)
        return FireTexture'GameEffects.InvisibleTex';

	tex = texture'weaponhandstex';

	p = deusexplayer(owner);
	if(p != none)
	{
		switch(p.PlayerSkin)
		{
			//default, black, latino, ginger, albino, respectively
			case 0: tex = texture'weaponhandstex'; break;
			case 1: tex = texture'HDTPItems.skins.weaponhandstexblack'; break;
			case 2: tex = texture'HDTPItems.skins.weaponhandstexlatino'; break;
			case 3: tex = texture'HDTPItems.skins.weaponhandstexginger'; break;
			case 4: tex = texture'HDTPItems.skins.weaponhandstexalbino'; break;
		}
	}

	return tex;
}

function renderoverlays(canvas canvas)
{
	Multiskins[0] = getweaponhandtex();
	if (bIsCloaked)                                                             //RSD: Overhauled cloak/radar routines
	   Multiskins[1] = FireTexture'GameEffects.InvisibleTex';
    else if (bIsRadar)
       Multiskins[1] = Texture'Effects.Electricity.Xplsn_EMPG';
    else
	   multiskins[1]=none;//texture'HDTPItems.Skins.HDTPLockpickPOVTex1';
	multiskins[0] = Getweaponhandtex();

	super.renderoverlays(canvas);
	multiskins[1]=none;
	multiskins[0]=none;//texture'HDTPItems.Skins.HDTPLockpickTex1';
}


simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
		MaxCopies = 5;
}

// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
   return (BeltSpot == 7);
}

defaultproperties
{
     UseSound=Sound'DeusExSounds.Generic.LockpickRattling'
     maxCopies=20
     bCanHaveMultipleCopies=True
     ItemName="Lockpick"
     PlayerViewOffset=(X=16.000000,Y=8.000000,Z=-16.000000)
     PlayerViewMesh=LodMesh'DeusExItems.LockpickPOV'
     PickupViewMesh=LodMesh'DeusExItems.Lockpick'
     ThirdPersonMesh=LodMesh'DeusExItems.Lockpick3rd'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconLockPick'
     largeIcon=Texture'DeusExUI.Icons.LargeIconLockPick'
     largeIconWidth=45
     largeIconHeight=44
     Description="A disposable lockpick. The tension wrench is steel, but appropriate needles are formed from fast congealing polymers.|n|n<UNATCO OPS FILE NOTE AJ006-BLACK> Here's what they don't tell you: despite the product literature, you can use a standard lockpick to bypass all but the most high-class nanolocks. -- Alex Jacobson <END NOTE>"
     beltDescription="LOCKPICK"
     Mesh=LodMesh'DeusExItems.Lockpick'
     CollisionRadius=11.750000
     CollisionHeight=1.900000
     Mass=20.000000
     Buoyancy=10.000000
}
