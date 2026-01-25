//=============================================================================
// PersonaTitleTextWindow
//=============================================================================

class PersonaTitleTextWindow extends TextWindow;

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

	StyleChanged();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colTitle;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	// Title colors
	colTitle = theme.GetColorFromName('HUDColor_TitleText');

	SetTextColor(colTitle);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
