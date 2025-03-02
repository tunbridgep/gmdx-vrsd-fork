//=============================================================================
// HUDBaseWindowMenu
// SARGE: Exactly the same as HUDBaseWindow, but uses the Menu theme, insead of the HUD Theme
//=============================================================================

class HUDBaseWindowMenu extends HUDBaseWindow;

var ColorTheme theme;

event InitWindow()
{
	Super.InitWindow();
	theme = player.ThemeManager.GetCurrentMenuColorTheme();
    StyleChanged();
}

// ----------------------------------------------------------------------
// StyleChanged()
// SARGE: Use the Menu theme instead of the HUD Theme
// ----------------------------------------------------------------------

event StyleChanged()
{
    if (theme == None)
        return;

	coLBackground = theme.GetColorFromName('MenuColor_Background');
	colBorder     = theme.GetColorFromName('MenuColor_ButtonFace');
	colText       = theme.GetColorFromName('MenuColor_ButtonTextFocus');
	colHeaderText = theme.GetColorFromName('MenuColor_HeaderText');

	//bDrawBorder            = player.GetHUDBordersVisible();
    bDrawBorder = true;                     //SARGE: No setting for menus

	if (player.GetMenuTranslucency())
		borderDrawStyle = DSTY_Translucent;
	else
		borderDrawStyle = DSTY_Masked;

	if (player.GetMenuTranslucency())
		backgroundDrawStyle = DSTY_Translucent;
	else
		backgroundDrawStyle = DSTY_Masked;
}
