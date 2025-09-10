//=============================================================================
// HUDReceivedDisplayItem
//=============================================================================
class HUDReceivedDisplayItem extends TileWindow;

var DeusExPlayer player;

var Window     winIcon;
var TextWindow winLabel;

var Color colText;
var Color colDecline;
var Font fontLabel;

var Texture itemIcon;
var int itemQuantity;           //SARGE: Number added in brackets after the label.
var string itemLabel;
var bool bItemDeclined;

var const localized string msgDeclined;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetOrder(ORDER_DownThenRight);
	SetChildAlignments(HALIGN_Center, VALIGN_Top);
	SetMargins(0, 0);
	SetMinorSpacing(2);
	MakeWidthsEqual(False);
	MakeHeightsEqual(False);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

//This is the REAL function
function SetItemIcon(Texture icon, coerce string label, optional int quantity, optional bool bDeclined)
{
    itemIcon = icon;
    itemLabel = label;
    itemQuantity = quantity;
    bItemDeclined = bDeclined;

	winIcon = NewChild(Class'Window');
	winIcon.SetSize(42, 37);
	winIcon.SetBackgroundStyle(DSTY_Masked);
	winIcon.SetBackground(itemIcon);

	winLabel = TextWindow(NewChild(Class'TextWindow'));
	winLabel.SetFont(fontLabel);
	winLabel.SetTextColor(colText);
	winLabel.SetTextAlignments(HALIGN_Center, VALIGN_Top);
    
    //SARGE: Special case for handling declined items. Yuck.
    if (bItemDeclined)
    {
        winIcon.SetTileColorRGB(64,64,64);
        //labelText = msgDeclined;
        winLabel.SetTextColor(colDecline);
        //winIcon.SetTileColor(colDecline);
    }

    Update();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colText = theme.GetColorFromName('HUDColor_NormalText');
	colDecline = theme.GetColorFromName('HUDColor_ButtonTextDisabled');

	if (winLabel != None)
		winLabel.SetTextColor(colText);
}

//SARGE: Function to force a refresh of the text;
function Update()
{
    local string label;

    label = itemLabel;
    if (itemQuantity > 1)
        label = label @ "(" $ itemQuantity $ ")";

	winLabel.SetText(label);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontLabel=Font'DeusExUI.FontMenuSmall_DS'
     msgDeclined="-"
}
