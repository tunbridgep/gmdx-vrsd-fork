//=============================================================================
// MenuChoice_GMDXPerkConfig
//=============================================================================

class MenuChoice_GMDXPerkConfig extends MenuUIChoiceAction;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Action=MA_MenuScreen
     Invoke=Class'DeusEx.MenuScreenGMDXOptionsPerkConfig'
     HelpText="Enable/Disable Perks. Disabled perks will not appear in the Perk selection screen, but will still be usable if already acquired."
     actionText="Perk Config"
}
