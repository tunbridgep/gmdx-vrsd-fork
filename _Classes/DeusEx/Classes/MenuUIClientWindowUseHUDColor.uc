//=============================================================================
// MenuUIClientWindow
//=============================================================================

class MenuUIClientWindowUseHUDColor extends MenuUIClientWindow;                 //RSD: Exists so I can use HUD colors in Computer Menus


// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()                                                            //RSD: overrides StyleChanged() in MenuUIClientWindow.uc
{
	local ColorTheme theme;

	// Translucency
	if (player.GetMenuTranslucency())
		backgroundDrawStyle = DSTY_Translucent;
	else
		backgroundDrawStyle = DSTY_Masked;

	// Background color
	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
