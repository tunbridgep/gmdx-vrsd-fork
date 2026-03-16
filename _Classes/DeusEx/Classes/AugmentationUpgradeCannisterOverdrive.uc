//=============================================================================
// AugmentationUpgradeCannister.
//
// Allows the player to upgrade any augmentation
// SARGE: This whole class was a total mess, cleaned it up good!
//=============================================================================
class AugmentationUpgradeCannisterOverdrive extends AugmentationUpgradeCannister;

function SetSkin()
{
    if (IsHDTP())
    {
        Skin = None;
        MultiSkins[1] = FireTexture'Effects.Electricity.Nano_SFX';
        MultiSkins[2] = Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundTop_1';
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ItemName="Augmentation Override Cannister"
     Skin=Texture'RSDCrap.Skins.AugmentationUpgradeCannisterOverdriveTex1'
     Icon=Texture'GMDXSFX.UI.AugOverride'
     largeIcon=Texture'GMDXSFX.UI.AugOverrideBelt'
     Description="An augmentation upgrade cannister with intricately-programmed scripts designed to override certain functionality of the 'Environmental Resistance' and 'Aqualung' augmentations. |nThis specialized upgrade cannister can be used to upgrade any augmentation by two tech levels, however using it on one of the two specified augmentations it was designed for will upgrade it from an 'Active' augmentation to 'Automatic', but will only increase its tech level by one.|n|n<UNATCO OPS FILE NOTE JR189-VIOLET> The Environmental Resistance and Aqualung augmentations share the same sub-routines. Hypothetically-speaking both would benefit from this device even if applied to one, should you happen to have both installed. -- Jaime Reyes <END NOTE>"
     beltDescription="AUG OVER"
}
