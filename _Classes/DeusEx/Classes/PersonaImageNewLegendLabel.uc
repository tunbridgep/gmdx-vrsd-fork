//=============================================================================
// PersonaImageNewLegendLabel
//=============================================================================

class PersonaImageNewLegendLabel extends TileWindow;

var PersonaHeaderTextWindow winLegend;
var PersonaHeaderTextWindow winIcon;

var localized String NewLegendLabel;

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

	SetOrder(ORDER_Right);
	SetChildAlignments(HALIGN_Full, VALIGN_Top);
	SetMargins(0, 0);
	SetMinorSpacing(0);
	MakeWidthsEqual(False);
	MakeHeightsEqual(True);

	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winIcon = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winIcon.SetFont(player.FontManager.GetFont(TT_FontHUDWingDings));
	winIcon.SetText("C");

	winLegend = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winLegend.SetText(NewLegendLabel);
}

//SARGE: Crash Fix due to Player being required for new font support
function DestroyWindow()
{
    player = None;
	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     NewLegendLabel=" = New Image"
}
