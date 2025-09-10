//=============================================================================
// HUDReceivedDisplay
//=============================================================================
class HUDReceivedDisplay extends HUDSharedBorderWindow;

var TileWindow winTile;
var TextWindow txtReceived;
var Font  fontReceived;
var Float displayTimer;
var Float displayLength;
var int   topMargin;

var localized string TextReceivedLabel;
var localized string TextGivenLabel; //SARGE: Added

/*
//SARGE: Can't use this in other files.
//So this will instead use an INT
//wew lad!
//0 = combine
//1 = replace
//2 = showall
enum ERollupType
{
    RT_Combine,         //Roll up the items into a single stack, combining everything together
    RT_Replace,         //New instances replace old instances
    RT_ShowAll,         //Every object is shown individually, with no counts.
}
*/

// ----------------------------------------------------------------------
//SARGE: OH BOY!
//So, we can now show A LOT of items....
//Specifically when you get 50 credits a pop for selling Zyme...
//As a result, we need to handle the items list in a more thorough manner...
// ----------------------------------------------------------------------
var HUDReceivedDisplayItem items[20];
var int itemNum;

//Whenever we add a new item to the list, we need to
//make sure it's not already on the list. If it is, update that items text instead...
function bool RollUp(Texture icon, int rollupType, int quantity, bool bDeclined)
{
    local int i;

    for (i = 0;i < itemNum && i < ArrayCount(items);i++)
    {
        if (items[i] != None && items[i].itemIcon == icon && items[i].bItemDeclined == bDeclined)
        {
            //if set to replace, replace the quantity
            if (rollupType == 1)
                items[i].itemQuantity = quantity;
            else //otherwise add to it
                items[i].itemQuantity += quantity;
            items[i].Update();
            AskParentForReconfigure();
            return true;
        }
    }
    return false;
}

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateTileWindow();
	CreateReceivedLabel();

	StyleChanged();

	bTickEnabled = False;
}

// ----------------------------------------------------------------------
// CreateTileWindow()
// ----------------------------------------------------------------------

function CreateTileWindow()
{
	winTile = TileWindow(NewChild(Class'TileWindow'));

	winTile.SetOrder(ORDER_RightThenDown);
	winTile.SetChildAlignments(HALIGN_Left, VALIGN_Center);
	winTile.SetPos(0, topMargin);
	winTile.SetMargins(10, 10);
	winTile.SetMinorSpacing(4);
	winTile.MakeWidthsEqual(False);
	winTile.MakeHeightsEqual(True);
}

// ----------------------------------------------------------------------
// CreateReceivedLabel()
// ----------------------------------------------------------------------

function CreateReceivedLabel()
{
	txtReceived = TextWindow(winTile.NewChild(Class'TextWindow'));
	txtReceived.SetFont(fontReceived);
	txtReceived.SetText(TextReceivedLabel);
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	displayTimer += deltaSeconds;

	if (displayTimer > displayLength)
		RemoveItems();
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize()
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	local float tileWidth, tileHeight;

	if ((!bWidthSpecified) && (!bHeightSpecified))
	{
		winTile.QueryPreferredSize(preferredWidth, preferredHeight);

		preferredHeight += topMargin;
		if (preferredHeight < minHeight)
			preferredHeight = minHeight;
	}
	else if (bWidthSpecified)
	{
		preferredHeight = winTile.QueryPreferredHeight(preferredWidth);
		preferredHeight += topMargin;

		if (preferredHeight < minHeight)
			preferredHeight = minHeight;
	}
	else
	{
		preferredWidth = winTile.QueryPreferredWidth(preferredHeight);
	}
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	winTile.ConfigureChild(0, topMargin, width, height);
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(window child)
{
	ConfigurationChanged();

	return True;
}

// ----------------------------------------------------------------------
// AddCredits()
// SARGE: Added because adding Credits via items is a major PITA
// ----------------------------------------------------------------------

function bool AddCredits(Int count, optional int rollupType)
{
    local string label;
    local Texture icon;
    icon = class'Credits'.default.Icon;
    label = class'Credits'.default.beltDescription;
    return AddGenericIcon(icon,label,count,false);
}

// ----------------------------------------------------------------------
// AddGenericIcon()
// SARGE: Allow displaying arbitrary icons without an associated item
// ----------------------------------------------------------------------

function bool AddGenericIcon(Texture icon, string label, optional int quantity, optional bool bDeclined, optional int rollupType)
{
	local HUDReceivedDisplayItem item;
    local int create, i;

    if (rollupType != 2 && RollUp(icon,rollupType,quantity,bDeclined))
    {
        displayTimer = 0.0;
        return false;
    }
    
    //If we're set to unroll, make 1 item for each, with count of 1 for each one
    create = 1;
    if (rollupType == 2)
    {
        create = quantity;
        quantity = 1;
    }

    for (i = 0;i < create;i++)
    {
        item = HUDReceivedDisplayItem(winTile.NewChild(Class'HUDReceivedDisplayItem'));
        item.SetItemIcon(icon, label, quantity, bDeclined);
        items[itemNum++] = item;
    }

	displayTimer = 0.0;
	Show();
	bTickEnabled = True;
	AskParentForReconfigure();
    return true;
}

// ----------------------------------------------------------------------
// AddItem()
// ----------------------------------------------------------------------

function bool AddItem(Inventory invItem, Int count, optional bool bDeclined, optional int rollup)
{
    local string labelText;
	
    //SARGE: Add a "+" to the item name for upgraded weapons
    if (invItem.isA('DeusExWeapon'))
        labelText = DeusExWeapon(invItem).GetBeltDescription(player);
    else
        labelText = invItem.beltDescription;

    return AddGenericIcon(invItem.icon, labelText, count, bDeclined, rollup);
}

// ----------------------------------------------------------------------
// RemoveItems()
// ----------------------------------------------------------------------

function RemoveItems()
{
	local Window itemWindow;
	local Window nextWindow;
    local int i;

    for (i = 0;i < ArrayCount(items);i++)
        items[i] = None;

	bTickEnabled = False;

	itemWindow = winTile.GetTopChild();
	while( itemWindow != None )
	{
		nextWindow = itemWindow.GetLowerSibling();

		// Don't destroy the "Received" TextWindow()
		if (!itemWindow.IsA('TextWindow'))
		{
			itemWindow.Destroy();
		}

		itemWindow = nextWindow;
	}

	Hide();
}

// ----------------------------------------------------------------------
// GetTimeRemaining()
// ----------------------------------------------------------------------

function float GetTimeRemaining()
{
	if (IsVisible())
		return displayLength - displayTimer;
	else
		return 0.0;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	Super.StyleChanged();

	if (txtReceived != None)
		txtReceived.SetTextColor(colText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontReceived=Font'DeusExUI.FontMenuHeaders_DS'
     displayLength=3.000000
     TopMargin=5
     TextReceivedLabel="Received:"
     TextGivenLabel="Given:"
}
