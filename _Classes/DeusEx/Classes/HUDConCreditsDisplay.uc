//=============================================================================
// HUDConCreditsDisplay
//=============================================================================
class HUDConCreditsDisplay expands HUDBaseWindow;

var localized string CreditsLabel;
var TextWindow txtCredits;
var Color CreditsColor;
var Font  fontCredits;

event InitWindow()
{
	Super.InitWindow();

	CreateCreditsLabel();

	StyleChanged();
}

// ----------------------------------------------------------------------
// CreateCreditsLabel()
// ----------------------------------------------------------------------

function CreateCreditsLabel()
{
	txtCredits = TextWindow(NewChild(Class'TextWindow'));
	txtCredits.SetFont(fontCredits);
	txtCredits.SetText(CreditsLabel);
	txtCredits.SetTextColor(CreditsColor);
}

function SetTextFont(Font newFont)
{
	txtCredits.SetFont(newFont);
}

function SetCredits(int amount)
{
    txtCredits.SetText(CreditsLabel @ amount);
}

defaultproperties
{
     fontCredits=Font'DeusExUI.FontMenuHeaders_DS'
     CreditsLabel="Credits:"
     CreditsColor=(B=255)
}
