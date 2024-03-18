//=============================================================================
// AugmentationUpgradeCannister.
//
// Allows the player to upgrade any augmentation
//=============================================================================
class AugmentationUpgradeCannisterOverdrive extends DeusExPickup;

var localized string MustBeUsedOn;

//extremely sleepy hack to stop the skin from resetting when dropped or thrown. Note to self: sort it out after having got some sleep.
FUNCTION Tick(float deltaTime)
{
  super.Tick(deltaTime);

  if (Physics == PHYS_Falling)
  {
  Multiskins[1]=FireTexture'Effects.Electricity.Nano_SFX';
  Multiskins[2]=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundTop_1';
  }
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.Clear();
	winInfo.SetTitle(itemName);
	winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR() $ MustBeUsedOn);

	return True;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     MustBeUsedOn="Must be used on Augmentations Screen."
     ItemName="Augmentation Override Cannister"
     ItemArticle="an"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPAugUpCan'
     PickupViewMesh=LodMesh'HDTPItems.HDTPAugUpCan'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPAugUpCan'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit1'
     Icon=Texture'GMDXSFX.UI.AugOverride'
     largeIcon=Texture'GMDXSFX.UI.AugOverrideBelt'
     largeIconWidth=24
     largeIconHeight=41
     Description="An augmentation upgrade cannister with intricately-programmed scripts designed to override certain functionality of the 'Environmental Resistance' and 'Aqualung' augmentations. |nThis specialized upgrade cannister can be used to upgrade any augmentation by two tech levels, however using it on one of the two specified augmentations it was designed for will upgrade it from an 'Active' augmentation to 'Automatic', but will only increase its tech level by one.|n|n<UNATCO OPS FILE NOTE JR189-VIOLET> The Environmental Resistance and Aqualung augmentations share the same sub-routines. Hypothetically-speaking both would benefit from this device even if applied to one, should you happen to have both installed. -- Jaime Reyes <END NOTE>"
     beltDescription="AUG OVER"
     Mesh=LodMesh'HDTPItems.HDTPAugUpCan'
     MultiSkins(1)=FireTexture'Effects.Electricity.Nano_SFX'
     MultiSkins(2)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundTop_1'
     CollisionRadius=3.200000
     CollisionHeight=5.180000
     Mass=10.000000
     Buoyancy=12.000000
}
