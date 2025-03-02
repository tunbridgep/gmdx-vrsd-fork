//=============================================================================
// PersonaListWindowMenu
// SARGE: Exactly the same as PersonaListWindow, but uses the Menu theme, insead of the HUD Theme
//=============================================================================

class PersonaListWindowMenu extends PersonaListWindow;

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Int colIndex;

	// Background color
	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	colText          = theme.GetColorFromName('MenuColor_ListText');
	colTextHighlight = theme.GetColorFromName('MenuColor_ListTextHighlight');
	colHighlight     = theme.GetColorFromName('MenuColor_ListHighlight');
	colFocus         = theme.GetColorFromName('MenuColor_ListFocus');

	SetTextColor(colText);
	SetHighlightTextColor(colTextHighlight);
	SetHighlightTexture(texHighlight);
	SetHighlightColor(colHighlight);
	SetFocusTexture(texFocus);
	SetFocusColor(colFocus);

	// Loop through columns, setting text color
	for (colIndex=0; colIndex<GetNumColumns(); colIndex++)
		SetColumnColor(colIndex, colText);
}

