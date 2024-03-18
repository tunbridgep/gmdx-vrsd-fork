//=============================================================================
// PersonaInfoItemWindow
//=============================================================================
class PersonaInfoItemWindow expands AlignWindow;

var DeusExPlayer player;
var TextWindow winLabel;
var TextWindow winText;
var Font fontText;
var Font fontTextHighlight;
var bool bHighlight;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Defaults for tile window
	SetChildVAlignment(VALIGN_Top);
	SetChildSpacing(10);

	winLabel = TextWindow(NewChild(Class'TextWindow'));
	winLabel.SetFont(fontText);
	winLabel.SetTextAlignments(HALIGN_Right, VALIGN_Top);
	winLabel.SetTextMargins(0, 0);
	winLabel.SetWidth(70);

	winText = TextWindow(NewChild(Class'TextWindow'));
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winText.SetFont(fontText);
	winText.SetTextMargins(0, 0);
	winText.SetWordWrap(True);

	// Get a pointer to the player
	player = DeusExPlayer(GetPlayerPawn());

	StyleChanged();
}

// ----------------------------------------------------------------------
// SetItemInfo()
// ----------------------------------------------------------------------

function SetItemInfo(coerce String newLabel, coerce String newText, optional bool bNewHighlight)
{
	winLabel.SetText(newLabel);
	winText.SetText(newText);
	SetHighlight(bNewHighlight);
}

//a: ah, finally. since this method is being called, that means we are a child of our our winItem instance (the row we created).
//so the instane of THIS class is a row that has instances of the left and right columns we need to populate, so let's get on with it.
function SetModInfo(coerce String newLabel, int count, optional bool bNewHighlight, optional int count2)
{
	local TextWindow winBracket;
	local PersonaLevelIconWindow winIcons;
	local PersonaLevelIconOffWindow winIconsOff;
	local ColorTheme theme;
	local Color bracketColor;

	local int countOff, bracketWidth, iconsWidth, iconsOffWidth;

	theme 		  = player.ThemeManager.GetCurrentHUDColorTheme();
	bracketColor  = theme.GetColorFromName('HUDColor_ButtonTextFocus');
	bracketWidth  = 2;
	countOff      = (5-count2) - count;
	iconsWidth    = 6 * count; //a: icon size is 5, but it draws 1px extra as padding.
	if (count2 > 0)
	    iconsWidth    -= count2 * 0.1;
	iconsOffWidth = 6 * countOff;

	winLabel.SetText(newLabel);

	winBracket = TextWindow(winText.NewChild(Class'TextWindow'));

	winBracket.SetWidth(bracketWidth);
	winBracket.SetTextMargins(0, 0);
	winBracket.SetTextColor(bracketColor);
	winBracket.SetText("[");

	//a: we can do anything with bNewHighlight here.
	//a: 0=1, we subtract when we set our level.
	if (count > 0)
	{
		//a: okay so SetItemInfo populates the right column (winText) with plain text.
        //But we went through all this trouble, because we can make the winText instance spawn an instance of our icons here instead.
		winIcons = PersonaLevelIconWindow(winText.NewChild(Class'PersonaLevelIconWindow'));

		//a: winIcons instance is a child of the right column, which is a child of our row (THIS class instance).
        //thus, 0,0 is the top left corner of their respective parent's content areas.
		winIcons.SetWidth(iconsWidth);
        winIcons.SetLevel(count - 1);
		winIcons.SetPos((bracketWidth + 2), 2);

		//a: make sure our ON icons are lit
		winIcons.SetSelected(true);
	}

	if (countOff > 0)
	{
		winIconsOff = PersonaLevelIconOffWindow(winText.NewChild(Class'PersonaLevelIconOffWindow'));

		winIconsOff.SetWidth(iconsOffWidth);
		//if (count2 > 0)
		//    winIconsOff.SetLevel((countOff - count2) - 1);
		//else
        winIconsOff.SetLevel(countOff - 1);
		winIconsOff.SetPos((iconsWidth + bracketWidth + 2), 2);
	}

	winBracket = TextWindow(winText.NewChild(Class'TextWindow'));

	winBracket.SetWidth(bracketWidth);
	winBracket.SetPos((bracketWidth + iconsWidth + iconsOffWidth + 3), 0);
	winBracket.SetTextMargins(0, 0);
	winBracket.SetTextColor(bracketColor);
	winBracket.SetText("]");
}

// ----------------------------------------------------------------------
// SetItemText()
// ----------------------------------------------------------------------

function SetItemText(coerce string newText)
{
	winText.SetText(newText);
}

// ----------------------------------------------------------------------
// SetHighlight()
// ----------------------------------------------------------------------

function SetHighlight(bool bNewHighlight)
{
	bHighlight = bNewHighlight;

	if (bHighlight)
		winText.SetFont(fontTextHighlight);
	else
		winText.SetFont(fontText);

	StyleChanged();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	winLabel.SetTextColor(theme.GetColorFromName('HUDColor_NormalText'));

	if (bHighlight)
		winText.SetTextColor(theme.GetColorFromName('HUDColor_HeaderText'));
	else
		winText.SetTextColor(theme.GetColorFromName('HUDColor_NormalText'));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontText=Font'DeusExUI.FontMenuSmall'
     fontTextHighlight=Font'DeusExUI.FontMenuHeaders'
}
