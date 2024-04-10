//=============================================================================
// ConWindowSpeech
//=============================================================================
class ConWindowSpeech extends AlignWindow;

var TextWindow txtName;
var TextWindow txtSpeech;

var bool bForcePlay;

var DeusExPlayer player;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetChildVAlignment(VALIGN_Top);

    player = DeusExPlayer(GetPlayerPawn());

	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
    local Color backgroundColor, textColor, highlightColor;

	txtName = TextWindow(NewChild(Class'TextWindow', False));
	txtName.SetTextColor(player.ThemeManager.GetDialogTextColor());
	txtName.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	txtName.Hide();

	txtSpeech = TextWindow(NewChild(Class'TextWindow', False));
	txtSpeech.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	txtSpeech.Hide();
}

// ----------------------------------------------------------------------
// SetSpeechFont()
// ----------------------------------------------------------------------

function SetSpeechFont(Font newSpeechFont)
{
	if (txtSpeech != None)
		txtSpeech.SetFont(newSpeechFont);
}

// ----------------------------------------------------------------------
// SetNameFont()
// ----------------------------------------------------------------------

function SetNameFont(Font newNameFont)
{
	if (txtName != None)
		txtName.SetFont(newNameFont);
}

// ----------------------------------------------------------------------
// SetName()
// ----------------------------------------------------------------------

function SetName(String newName)
{
	if (newName == "")
	{
		txtName.SetText("");
		txtName.Show(False);
	}
	else
	{
		txtName.SetText(newName $ ": ");
		txtName.Show(True);
	}
}

// ----------------------------------------------------------------------
// SetSpeech()
// ----------------------------------------------------------------------

function SetSpeech(String newSpeech, optional Actor speakingActor)
{
	if (newSpeech == "")
	{
		txtSpeech.SetText("");
		txtSpeech.Show(False);
	}
	else
	{
		txtSpeech.SetText(newSpeech);

		// Use a different color for the player's text
		if ((speakingActor != None) && (DeusExPlayer(speakingActor) != None))
			txtSpeech.SetTextColor(player.ThemeManager.GetDialogHighlightColor());
		else	
			txtSpeech.SetTextColor(player.ThemeManager.GetDialogTextColor());

		txtSpeech.Show(True);
	}
}

// ----------------------------------------------------------------------
// AppendSpeech()
// ----------------------------------------------------------------------

function AppendSpeech(String newSpeech)
{
	txtSpeech.AppendText(CR() $ CR() $ newSpeech);
}

// ----------------------------------------------------------------------
// SetForcePlay()
// ----------------------------------------------------------------------

function SetForcePlay(bool bNewForcePlay)
{
	bForcePlay = bNewForcePlay;

	if (bForcePlay)
		txtSpeech.SetTextAlignments(HALIGN_Center, VALIGN_Top);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
