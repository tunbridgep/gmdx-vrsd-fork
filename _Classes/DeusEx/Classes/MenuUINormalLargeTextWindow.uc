//=============================================================================
// MenuUINormalLargeTextWindow
//=============================================================================

class MenuUINormalLargeTextWindow extends LargeTextWindow;

var DeusExPlayer player;

var Color colLabel;

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

	SetFont(player.FontManager.GetFont(TT_FontMenuSmall));
	SetTextMargins(0, 0);

	StyleChanged();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	// Title colors
	colLabel = theme.GetColorFromName('MenuColor_ListText');

	SetTextColor(colLabel);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colLabel=(R=255,G=255,B=255)
}
