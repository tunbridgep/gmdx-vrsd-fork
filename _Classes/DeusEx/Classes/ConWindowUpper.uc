//=============================================================================
// ConWindowSpeech
//=============================================================================
class ConWindowUpper extends AlignWindow;

var TextWindow txtLabel;
var TextWindow txtCredits;

var localized string Credits;

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
    //Don't create the credits display if it's disabled
    if (!player.bCreditsInDialog)
        return;

    SetChildVAlignment(VALIGN_Bottom);

	txtLabel = TextWindow(NewChild(Class'TextWindow', False));
	txtLabel.SetTextColor(player.ThemeManager.GetDialogHighlightColor(false));
	txtLabel.SetTextAlignments(HALIGN_Left, VALIGN_Top);
    txtLabel.SetText(Credits);
    //txtLabel.SetHeight(height);
    txtLabel.Show();

	txtCredits = TextWindow(NewChild(Class'TextWindow', False));
    txtCredits.SetTextColor(player.ThemeManager.GetDialogTextColor(false,true));
	txtCredits.SetTextAlignments(HALIGN_Left, VALIGN_Top);
    txtCredits.SetText("0");
    //txtCredits.SetHeight(height); //SARGE: Set this to 10000 and change valign to bottom if you're still having issues with it displaying
    txtCredits.Show();
}



function SetName(String newName)
{
	if (newName == "")
	{
		txtLabel.Show(False);
	}
	else
	{
		txtLabel.SetText(newName $ ": ");
		txtLabel.Show(True);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// SetCreditsText()
// ----------------------------------------------------------------------

function SetCreditsText(int CreditsAmount)
{
	if (txtCredits != None)
		txtCredits.SetText(creditsAmount);
}

// ----------------------------------------------------------------------
// SetLabelFont()
// ----------------------------------------------------------------------

function SetLabelFont(Font newLabelFont)
{
	if (txtLabel != None)
		txtLabel.SetFont(newLabelFont);
}

// ----------------------------------------------------------------------
// SetCreditsFont()
// ----------------------------------------------------------------------

function SetCreditsFont(Font newCreditsFont)
{
	if (txtCredits != None)
		txtCredits.SetFont(newCreditsFont);
}

defaultproperties
{
    Credits="Credits:"
}
