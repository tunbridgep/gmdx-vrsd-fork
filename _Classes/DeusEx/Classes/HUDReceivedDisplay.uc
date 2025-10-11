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

// ----------------------------------------------------------------------
//SARGE: OH BOY!
//So, we can now show A LOT of items....
//Specifically when you get 50 credits a pop for selling Zyme...
//As a result, we need to handle the items list in a more thorough manner...
// ----------------------------------------------------------------------
var HUDReceivedDisplayItem displayItems[60];
var int displayItemNum;

struct ItemInfo
{
    var Texture icon;
    var string label;
    var int quantity;
    //var bool bDeclined;
    var bool bNoGroup;
    var string owner;
    var bool bHidden;
    var float batchTime; //SARGE: HACK to only consider items added in a previous batch
};

var ItemInfo items[30];
var ItemInfo declineditems[30];
var int itemNum;
var int declinedItemNum;

//Whenever we add a new item to the list, we need to
//make sure it's not already on the list. If it is, update that items text instead...
function bool RollUp(Texture icon, int quantity, bool bDeclined)
{
    local int i;

    for (i = 0;i < displayItemNum;i++)
    {
        if (displayItems[i].itemIcon == icon && displayItems[i].bItemDeclined == bDeclined)
        {
            displayItems[i].itemQuantity += quantity;
            displayItems[i].Update();
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

function bool AddCredits(Int count)
{
    local string label;
    local Texture icon;
    icon = class'Credits'.default.Icon;
    label = class'Credits'.default.beltDescription;
    return AddGenericIcon("",icon,label,count,false,false);
}

// ----------------------------------------------------------------------
// AddGenericIcon()
// SARGE: Allow displaying arbitrary icons without an associated item
// ----------------------------------------------------------------------

function bool AddGenericIcon(string owner, Texture icon, string label, optional int quantity, optional bool bDeclined, optional bool bNoGroup)
{
    local int i;

    if (quantity == 0)
        quantity = 1;

    if (HasOwnedItem(owner,icon,label,quantity,bDeclined,bNoGroup,player.saveTime))
        return false;
    
    if (bDeclined)
    {
        if (declinedItemNum >= ArrayCount(declinedItems))
            return false;

        declinedItems[declinedItemNum].icon = icon;
        declinedItems[declinedItemNum].label = label;
        declinedItems[declinedItemNum].quantity = quantity;
        declinedItems[declinedItemNum].bNoGroup = bNoGroup;
        declinedItems[declinedItemNum].owner = owner;
        declinedItems[declinedItemNum].bHidden = false;
        declinedItems[declinedItemNum].batchTime = player.saveTime;
        //Log("Add Declined Item: " $ icon);

        //Remove any non-declined items that match 
        for (i = 0;i < declinedItemNum;i++)
        {
            Log("penis" @ items[i].owner @ declinedItems[itemNum].owner @ items[i].icon @ declinedItems[itemNum].icon);
            if (items[i].owner != "" && items[i].owner == declinedItems[itemNum].owner && items[i].icon == declinedItems[itemNum].icon && items[i].quantity == declinedItems[itemNum].quantity)
            {
                items[i].bHidden = true;
                break;
            }
        }
        
        declinedItemNum++;
    }
    else
    {
        if (itemNum >= ArrayCount(items))
            return false;

        items[itemNum].icon = icon;
        items[itemNum].label = label;
        items[itemNum].quantity = quantity;
        items[itemNum].bNoGroup = bNoGroup;
        items[itemNum].owner = owner;
        items[itemNum].bHidden = false;
        items[itemNum].batchTime = player.saveTime;
        //Log("Add Item: " $ icon);

        //Remove any declined items that match 
        for (i = 0;i < declinedItemNum;i++)
        {
            Log("penis" @ items[i].owner @ declinedItems[itemNum].owner @ items[i].icon @ declinedItems[itemNum].icon);
            if (declineditems[i].owner != "" && declinedItems[i].owner == items[itemNum].owner && declinedItems[i].icon == items[itemNum].icon && declinedItems[i].quantity == items[itemNum].quantity)
            {
                Log("Adding hitten item: " $ declinedItems[i].icon);
                declinedItems[i].bHidden = true;
                break;
            }
        }
        
        itemNum++;
    }

    RecreateItemDisplay();

    return true;
}

// ----------------------------------------------------------------------
// RecreateItemDisplay()
// ----------------------------------------------------------------------

function private bool _CreateDisplay(Texture icon, string label, int quantity, bool bDeclined, bool bNoGroup)
{
    local int times, qLabel, i;
	local HUDReceivedDisplayItem item;
    local bool bCreated;

    //Log("Create Display for " $ icon @ label @ quantity @ bDeclined @ bNoGroup);

    if (bNoGroup && quantity <= 4)
    {
        times = quantity;
        qLabel = 1;
    }
    else
    {
        times = 1;
        qLabel = quantity;
    }

    if (bNoGroup || !Rollup(icon,quantity,bDeclined))
    {
        for (i = 0;i < times;i++)
        {
            item = HUDReceivedDisplayItem(winTile.NewChild(Class'HUDReceivedDisplayItem'));
            item.SetItemIcon(icon, label, qLabel, bDeclined);
            displayItems[displayItemNum++] = item;
            bCreated = true;
        }
    }

    return bCreated;
}

function RecreateItemDisplay()
{
    local int create, i;
    local bool bCreated;
    local Texture icon;
    local string label;
    local int quantity;
    local bool bNoGroup;
		
    DeleteItemWindows();

    for (i = 0;i < itemNum;i++)
    {
        icon = items[i].icon;
        label = items[i].label;
        quantity = items[i].quantity;
        bNoGroup = items[i].bNoGroup;

        if (!items[i].bHidden)
            bCreated = _CreateDisplay(icon,label,quantity,false,bNoGroup) || bCreated;
    }

    for (i = 0;i < declinedItemNum;i++)
    {
        icon = declinedItems[i].icon;
        label = declinedItems[i].label;
        quantity = declinedItems[i].quantity;
        bNoGroup = declinedItems[i].bNoGroup;
        if (!declinedItems[i].bHidden)
            bCreated = _CreateDisplay(icon,label,quantity,true,bNoGroup) || bCreated;
    }

    if (bCreated)
        Show();

    displayTimer = 0.0;
    bTickEnabled = True;
    AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// AddItem()
// ----------------------------------------------------------------------

function bool AddItem(Inventory invItem, Int count, optional bool bDeclined, optional bool bNoGroup)
{
    return AddItemFrom(None,invItem,count,bDeclined,bNoGroup);
}

// ----------------------------------------------------------------------
// AddItemFrom()
// SARGE: Now we can associate specific actors with each item.
// ----------------------------------------------------------------------

function bool AddItemFrom(Actor owner, Inventory invItem, Int count, optional bool bDeclined, optional bool bNoGroup)
{
    return AddItemFromID(string(owner.name), invItem, count, bDeclined, bNoGroup);
}

function bool AddItemFromID(string owner, Inventory invItem, Int count, optional bool bDeclined, optional bool bNoGroup)
{
    local string labelText;
    local texture icon;

    //SARGE: Add a "+" to the item name for upgraded weapons
    if (invItem.isA('DeusExWeapon'))
        labelText = DeusExWeapon(invItem).GetBeltDescription(player);
    else if (invItem.isA('NanoKey') && invItem.beltDescription == "") //SARGE: Fix for keys not displaying properly for whatever reason
        labelText = class'NanoKey'.default.beltDescription;
    else
        labelText = invItem.beltDescription;

    if (invItem.IsA('DeusExAmmo'))
        icon = DeusExAmmo(invItem).GetHDTPIcon();
    else
        icon = invItem.default.icon;

    return AddGenericIcon(owner, icon, labelText, count, bDeclined, bNoGroup);
}

// ----------------------------------------------------------------------
// HasOwnedItem()
// ----------------------------------------------------------------------

function bool HasOwnedItem(string owner, Texture icon, string label, int quantity, bool bDeclined, bool bNoGroup, float batchTime)
{
    local int i;

    if (!bDeclined)
    {
        for (i = 0;i < itemNum;i++)
        {
            if (items[i].owner != "" && items[i].owner == owner && items[i].icon == icon && items[i].quantity == quantity && items[i].batchTime < batchTime)
                return true;
        }
    }
    else
    {
        for (i = 0;i < declinedItemNum;i++)
        {
            if (declinedItems[i].owner != "" && declinedItems[i].owner == owner && declinedItems[i].icon == icon && declinedItems[i].quantity == quantity && declinedItems[i].batchTime < batchTime)
                return true;
        }
    }
    return false;
}

// ----------------------------------------------------------------------
// RemoveItems()
// ----------------------------------------------------------------------

function RemoveItems()
{
    itemNum = 0;
    declinedItemNum = 0;
    DeleteItemWindows();
	Hide();
}

// ----------------------------------------------------------------------
// DeleteItemWindows()
// ----------------------------------------------------------------------

function DeleteItemWindows()
{
	local Window itemWindow;
	local Window nextWindow;
    local int i;

    for (i = 0;i < displayItemNum;i++)
        displayItems[i] = None;

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

    displayItemNum = 0;
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
