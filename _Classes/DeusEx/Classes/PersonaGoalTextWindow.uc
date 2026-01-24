//=============================================================================
// PersonaGoalTextWindow
//=============================================================================

class PersonaGoalTextWindow extends TextWindow;

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

	SetFont(player.FontManager.GetFont(TT_FontMenuSmall));
	SetTextAlignments(HALIGN_Left, VALIGN_Center);
	SetTextMargins(5, 2);
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
