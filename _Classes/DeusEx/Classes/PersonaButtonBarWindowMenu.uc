//=============================================================================
// PersonaButtonBarWindowMenu
//=============================================================================

class PersonaButtonBarWindowMenu expands PersonaButtonBarWindow;

event StyleChanged()
{
	local ColorTheme theme;
	theme = player.ThemeManager.GetCurrentMenuColorTheme();
	colBackground = theme.GetColorFromName('MenuColor_Background');

	if (player.GetMenuTranslucency())
		borderDrawStyle = DSTY_Translucent;
	else
		borderDrawStyle = DSTY_Masked;

	if (player.GetMenuTranslucency())
		backgroundDrawStyle = DSTY_Translucent;
	else
		backgroundDrawStyle = DSTY_Masked;

	if (winFiller != None)
	{
		winFiller.SetTileColor(colBackground);
		winFiller.SetBackgroundStyle(backgroundDrawStyle);
	}
}