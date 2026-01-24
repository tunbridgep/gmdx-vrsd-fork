//=============================================================================
// PersonaHeaderTextWindow
//=============================================================================

class PersonaHeaderTextWindow extends TextWindow;

var DeusExPlayer player;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	SetFont(player.FontManager.GetFont(TT_FontMenuHeaders));
	SetTextMargins(0, 0);
	SetTextAlignments(HALIGN_Left, VALIGN_Center);

	StyleChanged();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colText;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	// Title colors
	colText = theme.GetColorFromName('HUDColor_HeaderText');

	SetTextColor(colText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     //fontText=Font'RSDCrap.DXRFontMenuHeaders'
}
