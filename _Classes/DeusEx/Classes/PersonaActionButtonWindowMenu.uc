//=============================================================================
// PersonaActionButtonWindowMenu
// SARGE: Same as PersonaActionButtonWindow, but uses the menu theme
// Used for the Hacking interface in ComputerScreenHack
//=============================================================================

class PersonaActionButtonWindowMenu extends PersonaActionButtonWindow;

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	bTranslucent  = player.GetMenuTranslucency();

	colButtonFace = theme.GetColorFromName('MenuColor_ButtonFace');
	colText[0]    = theme.GetColorFromName('MenuColor_ButtonTextNormal');
	
	colText[1]    = theme.GetColorFromName('MenuColor_ButtonTextFocus');
	colText[2]    = colText[1];

	colText[3]    = theme.GetColorFromName('MenuColor_ButtonTextDisabled');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
