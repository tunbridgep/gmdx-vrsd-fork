//=============================================================================
// PersonaScreenInventory
//=============================================================================

class PersonaScreenInventory extends PersonaScreenBaseWindow;

var PersonaActionButtonWindow btnEquip;
var PersonaActionButtonWindow btnUse;
var PersonaActionButtonWindow btnDrop;
var PersonaActionButtonWindow btnChangeAmmo;

var Window                        winItems;
var PersonaInventoryInfoWindow    winInfo;
var PersonaItemButton             selectedItem;			// Currently Selected Inventory item
var PersonaInventoryCreditsWindow winCredits;
var PersonaItemDetailWindow       winNanoKeyRing;
var PersonaItemDetailWindow       winAmmo;

var Bool bUpdatingAmmoDisplay;
var float TimeSinceLastUpdate;

// Inventory object belt
var PersonaInventoryObjectBelt invBelt;
var HUDObjectSlot		       selectedSlot;

var	int invButtonWidth;
var int	invButtonHeight;

var int	smallInvWidth;									// Small Inventory Button Width
var int	smallInvHeight;									// Small Inventory Button Heigth

// Drag and Drop Stuff
var Bool         bDragging;
var ButtonWindow dragButton;							// Button we're dragging around
var ButtonWindow lastDragOverButton;
var Window       lastDragOverWindow;
var Window       destroyWindow;							// Used to defer window destroy

var localized String InventoryTitleText;
var localized String EquipButtonLabel;
var localized String UnequipButtonLabel;
var localized String UseButtonLabel;
var localized String DropButtonLabel;
var localized String ChangeAmmoButtonLabel;
var localized String NanoKeyRingInfoText;
var localized String NanoKeyRingLabel;
var localized String DroppedLabel;
var localized String AmmoLoadedLabel;
var localized String WeaponUpgradedLabel;
var localized String CannotBeDroppedLabel;
var localized String AmmoInfoText;
var localized String AmmoTitleLabel;
var localized String NoAmmoLabel;
var localized String DeclinedTitleLabel;
var localized String DeclinedDesc;

var Float lastRefresh;                                                          //RSD
var Float refreshInterval;                                                      //RSD
var PersonaInventoryHomeButton homeButton;                                      //RSD: home for our drag, in case the rotation fails or we want to draw a swap
var bool bHomeButtonHack;                                                       //RSD: meh

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	PersonaNavBarWindow(winNavBar).btnInventory.SetSensitivity(False);

	EnableButtons();
    //Force an update
    SignalRefresh();

}

function cancelButtonRotation()                                                 //RSD: To reset item orientation if we're dragging while closing the window
{
	if (bDragging && dragButton != none && dragButton.IsA('PersonaInventoryItemButton'))
	{
        PersonaInventoryItemButton(dragButton).ResetRotation();
    }
}

// ---------------------------------------------------------------------
// Tick()
//
// Used to destroy windows that need to be destroyed during
// MouseButtonReleased calls, which normally causes a CRASH
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	if (destroyWindow != None)
	{
        destroyWindow.Destroy();
		bTickEnabled = False;
		//return;                                                                 //RSD: Added to avoid lower branch
	}

	/*if (lastRefresh >= refreshInterval)                                         //RSD: Now refresh info (especially for ChargedPickups) every 0.2s
	{
		lastRefresh = 0.0;
		UpdateInventoryInfo()
	}
	else
	{
		lastRefresh += deltaTime;
	}*/
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateTitleWindow(9, 5, InventoryTitleText);
	CreateInfoWindow();
	CreateCreditsWindow();
	CreateObjectBelt();
	CreateButtons();
	CreateItemsWindow();
	CreateNanoKeyRingWindow();
	CreateAmmoWindow();
	CreateInventoryButtons();
	CreateStatusWindow();
}

// ----------------------------------------------------------------------
// CreateStatusWindow()
// ----------------------------------------------------------------------

function CreateStatusWindow()
{
	winStatus = PersonaStatusLineWindow(winClient.NewChild(Class'PersonaStatusLineWindow'));
	winStatus.SetPos(337, 243);
    UpdateDeclinedDisplay();
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(9, 339);
	winActionButtons.SetWidth(267);

	btnChangeAmmo = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnChangeAmmo.SetButtonText(ChangeAmmoButtonLabel);

	btnDrop = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnDrop.SetButtonText(DropButtonLabel);

	btnUse = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUse.SetButtonText(UseButtonLabel);

	btnEquip = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnEquip.SetButtonText(EquipButtonLabel);

	PlaySound(Sound'MetalDrawerOpen',0.75);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = PersonaInventoryInfoWindow(winClient.NewChild(Class'PersonaInventoryInfoWindow'));
	winInfo.SetPos(337, 17);
	winInfo.SetSize(238, 218);
}

// ----------------------------------------------------------------------
// CreateObjectBelt()
// ----------------------------------------------------------------------

function CreateObjectBelt()
{
    if (invBelt == None)
	{
		invBelt = PersonaInventoryObjectBelt(NewChild(Class'PersonaInventoryObjectBelt'));
		invBelt.SetWindowAlignments(HALIGN_Right, VALIGN_Bottom, 0, 0);
		invBelt.SetInventoryWindow(Self);
	}
	else
	{
		invBelt.CopyObjectBeltInventory();
		invBelt.AskParentForReconfigure();
	}
}

// ----------------------------------------------------------------------
// CreateCreditsWindow()
// ----------------------------------------------------------------------

function CreateCreditsWindow()
{
	winCredits = PersonaInventoryCreditsWindow(winClient.NewChild(Class'PersonaInventoryCreditsWindow'));
	winCredits.SetPos(165, 3);
	winCredits.SetWidth(108);
	winCredits.SetCredits(Player.Credits);
}

// ----------------------------------------------------------------------
// CreateNanoKeyRingWindow()
// ----------------------------------------------------------------------

function CreateNanoKeyRingWindow()
{
	winNanoKeyRing = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winNanoKeyRing.SetPos(335, 285);
	winNanoKeyRing.SetWidth(121);
	winNanoKeyRing.SetIcon(Class'NanoKeyRing'.Default.LargeIcon);
	winNanoKeyRing.SetItem(player.KeyRing);
	winNanoKeyRing.SetText(NanoKeyRingInfoText);
	winNanoKeyRing.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winNanoKeyRing.SetCountLabel(NanoKeyRingLabel);
	winNanoKeyRing.SetCount(player.KeyRing.GetKeyCount());
	winNanoKeyRing.SetIconSensitivity(True);
}

// ----------------------------------------------------------------------
// CreateAmmoWindow()
// ----------------------------------------------------------------------

function CreateAmmoWindow()
{
	winAmmo = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winAmmo.SetPos(456, 285);
	winAmmo.SetWidth(120);
	winAmmo.SetIcon(Class'AmmoShell'.Default.LargeIcon);
	winAmmo.SetIconSize(Class'AmmoShell'.Default.largeIconWidth, Class'AmmoShell'.Default.largeIconHeight);
	winAmmo.SetText(AmmoInfoText);
	winAmmo.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winAmmo.SetIgnoreCount(True);
	winAmmo.SetIconSensitivity(True);
}

// ----------------------------------------------------------------------
// CreateItemsWindow()
// ----------------------------------------------------------------------

function CreateItemsWindow()
{
	winItems = winClient.NewChild(Class'Window');
	winItems.SetPos(9, 19);
	winItems.SetSize(266, 319);
}

// ----------------------------------------------------------------------
// CreateInventoryButtons()
//
// Loop through all the Inventory items and draw them in our Inventory
// grid as buttons
//
// As we're doing this, we're going to regenerate the inventory grid
// stored in the player, since it sometimes (very rarely) gets corrupted
// and this is a nice hack to make sure it stays clean should that
// occur.  Ooooooooooo did I say "nice hack"?
// ----------------------------------------------------------------------

function CreateInventoryButtons()
{
	local Inventory anItem;
	local PersonaInventoryItemButton newButton;

	// First, clear the player's inventory grid.
    // DEUS_EX AMSD Due to not being able to guarantee order of delivery for functions,
    // do NOT clear inventory in multiplayer, else we risk clearing AFTER a lot of the sets
    // below.
    if (player.Level.NetMode == NM_Standalone)
        player.ClearInventorySlots();

	// Iterate through the inventory items, creating a unique button for each
	anItem = player.Inventory;

	while(anItem != None)
	{
		if (anItem.bDisplayableInv)
		{
			// Create another button
			newButton = PersonaInventoryItemButton(winItems.NewChild(Class'PersonaInventoryItemButton'));
			newButton.SetClientObject(anItem);
			newButton.SetInventoryWindow(Self);

			if (anItem.IsA('ChargedPickup') && !ChargedPickup(anItem).bActivatable)
				newButton.bDimIcon = true;                                      //RSD: Dim ChargedPickups if they're at 0%

			// If the item has a large icon, use it.  Otherwise just use the
			// smaller icon that's also shared by the object belt

			if ( anItem.largeIcon != None )
			{
				if ((anItem.default.invSlotsX != anItem.default.invSlotsY) && (anItem.invSlotsX == anItem.default.invSlotsY)) //RSD: Check if we have the right sizing (resets on load)
				{
					anItem.largeIconWidth = anItem.default.largeIconHeight;
					anItem.largeIconHeight = anItem.default.largeIconWidth;
				}
				else                                                            //RSD: Failsafe
				{
				    anItem.largeIconWidth = anItem.default.largeIconWidth;
					anItem.largeIconHeight = anItem.default.largeIconHeight;
				}
                if (anItem.IsA('DeusExWeapon') && DeusExWeapon(anItem).largeIconRot != none && anItem.largeIconWidth == anItem.default.largeIconHeight) //RSD: Account for inventory rotation
					newButton.SetIcon(DeusExWeapon(anItem).largeIconRot);
				else
					newButton.SetIcon(anItem.largeIcon);
				newButton.SetIconSize(anItem.largeIconWidth, anItem.largeIconHeight);
			}
			else
			{
				newButton.SetIcon(anItem.icon);
				newButton.SetIconSize(smallInvWidth, smallInvHeight);
			}

			newButton.SetSize(
				(invButtonWidth  * anItem.invSlotsX) + 1,
				(invButtonHeight * anItem.invSlotsY) + 1);

			// Okeydokey, update the player's inventory grid with this item.
			player.SetInvSlots(anItem, 1);

			// If this item is currently equipped, notify the button
			if ( anItem == player.inHand )
				newButton.SetEquipped( True );

			// If this inventory item already has a position, use it.
			if (( anItem.invPosX != -1 ) && ( anItem.invPosY != -1 ))
			{
				SetItemButtonPos(newButton, anItem.invPosX, anItem.invPosY);
			}
			else
			{
				// Find a place for it.
				if (player.FindInventorySlot(anItem))
					SetItemButtonPos(newButton, anItem.invPosX, anItem.invPosY);
				else
					newButton.Destroy();		// Shit!
			}
		}

		anItem = anItem.Inventory;
	}
	homeButton = PersonaInventoryHomeButton(winItems.NewChild(Class'PersonaInventoryHomeButton')); //RSD: Also set the homeButton
	homeButton.SetInventoryWindow(Self);
	homeButton.SetPos(-1,-1);
	homeButton.SetSize(0,0);
}

// ----------------------------------------------------------------------
// SetItemButtonPos()
// ----------------------------------------------------------------------

function SetItemButtonPos(PersonaInventoryItemButton moveButton, int slotX, int slotY)
{
	moveButton.dragPosX = slotX;
	moveButton.dragPosY = slotY;

	moveButton.SetPos(
		moveButton.dragPosX * (invButtonWidth),
		moveButton.dragPosY * (invButtonHeight)
		);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local Class<DeusExAmmo> ammoClass;

	bHandled = True;

	// First check to see if this is an Ammo button
	if (buttonPressed.IsA('PersonaAmmoDetailButton'))
	{
		if (DeusExWeapon(selectedItem.GetClientObject()) != None)
		{
			// Before doing anything, check to see if this button is already
			// selected.

			if (!PersonaAmmoDetailButton(buttonPressed).bSelected)
			{
				winInfo.SelectAmmoButton(PersonaAmmoDetailButton(buttonPressed));
				ammoClass = LoadAmmo();
				DeusExWeapon(selectedItem.GetClientObject()).UpdateAmmoInfo(winInfo, ammoClass);
				EnableButtons();
			}
		}
	}
	// Check to see if this is the Ammo button
	else if ((buttonPressed.IsA('PersonaItemDetailButton')) &&
	         (PersonaItemDetailButton(buttonPressed).icon == Class'AmmoShell'.Default.LargeIcon))
	{
		SelectInventory(PersonaItemButton(buttonPressed));
		UpdateAmmoDisplay();
	}
	// Now check to see if it's an Inventory button
	else if (buttonPressed.IsA('PersonaItemButton'))
	{
		winStatus.ClearText();
		SelectInventory(PersonaItemButton(buttonPressed));
	}
	// Otherwise must be one of our action buttons
	else
	{
		switch( buttonPressed )
		{
			case btnChangeAmmo:
				WeaponChangeAmmo();
				break;

			case btnEquip:
				EquipSelectedItem();
				break;

			case btnUse:
				UseSelectedItem();
				break;

			case btnDrop:
				DropSelectedItem();
				break;

			default:
				bHandled = False;
				break;
		}
	}

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// ToggleChanged()
// ----------------------------------------------------------------------

event bool ToggleChanged(Window button, bool bNewToggle)
{
	if (button.IsA('HUDObjectSlot') && (bNewToggle))
	{
		if ((selectedSlot != None) && (selectedSlot != HUDObjectSlot(button)))
			selectedSlot.HighlightSelect(False);

		selectedSlot = HUDObjectSlot(button);

		// Only allow to be highlighted if the slot isn't empty
		if (selectedSlot.item != None)
		{
			selectedSlot.HighlightSelect(bNewToggle);
			SelectInventoryItem(selectedSlot.item);
		}
		else
		{
			selectedSlot = None;
		}
	}
	else if (button.IsA('PersonaCheckboxWindow'))
	{
		player.bShowAmmoDescriptions = bNewToggle;
		player.SaveConfig();
		UpdateAmmoDisplay();
	}

	EnableButtons();

	return True;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local int keyIndex;
	local bool bKeyHandled;
    local string KeyName, Alias;

	bKeyHandled = True;

	if ( IsKeyDown( IK_Alt ) || IsKeyDown( IK_Shift ) || IsKeyDown( IK_Ctrl ))
		return False;

	// If a number key was pressed and we have a selected inventory item,
	// then assign the hotkey
	if (( key >= IK_0 ) && ( key <= IK_9 ) && (selectedItem != None) && (Inventory(selectedItem.GetClientObject()) != None))
	{
		invBelt.AssignObjectBeltByKey(Inventory(selectedItem.GetClientObject()), key);
	}
	else
	{
		switch( key )
		{
			// Allow a selected object to be dropped
			// TODO: Use the actual key(s) assigned to drop

			case IK_Backspace:
				DropSelectedItem();
				break;

			case IK_Delete:
				ClearSelectedSlot();
				break;

			case IK_Enter:
				UseSelectedItem();
				break;

            case IK_Space:                                                      //RSD: Space to rotate inventory item
				RotateItemButton();
				break;

			default:
				bKeyHandled = False;
		}
	}

    /*
    //Check for Secondary key pressed
    //SARGE: TODO: Implement this when the Secondary Weapon system isn't completely fucked
    if (!bKeyHandled)
    {
        KeyName =   player.ConsoleCommand("KEYNAME "$key );
        Alias = 	player.ConsoleCommand( "KEYBINDING "$KeyName );

        if ( Alias ~= "ShowScores" && selectedItem != None)
            player.AssignSecondary(Inventory(selectedItem.GetClientObject()));
    }
    */

	if (!bKeyHandled)
		return Super.VirtualKeyPressed(key, bRepeat);
	else
		return bKeyHandled;
}

// ----------------------------------------------------------------------
// UpdateDeclinedDisplay()
//
// Displays a list of Declined Items when no item is selected.
// ----------------------------------------------------------------------

function UpdateDeclinedDisplay()
{
	local Class<Inventory> invClass;
    local int i;

    winInfo.Clear();

    if (player.declinedItemsManager.GetDeclinedNumber() == 0)
        return;

    winInfo.SetTitle(DeclinedTitleLabel);
    winInfo.SetText(DeclinedDesc);
    winInfo.AddLine();

    for(i = 0; i < 100;i++)
    {
        if (player.declinedItemsManager.declinedTypes[i] != "")
        {
            invClass = class<Inventory>(DynamicLoadObject(player.declinedItemsManager.declinedTypes[i], class'Class', true));
            if (invClass != None)
                winInfo.AddDeclinedInfoWindow(invClass);
        }
    }
}

// ----------------------------------------------------------------------
// UpdateAmmoDisplay()
//
// Displays a list of ammo inside the info window (when the user clicks
// on the Ammo button)
// ----------------------------------------------------------------------

function UpdateAmmoDisplay()
{
	local Inventory inv;
	local DeusExAmmo ammo;
	local int ammoCount;

	if (!bUpdatingAmmoDisplay)
	{
		bUpdatingAmmoDisplay = True;

		winInfo.Clear();

		winInfo.SetTitle(AmmoTitleLabel);
		winInfo.AddAmmoCheckbox(player.bShowAmmoDescriptions);
		winInfo.AddLine();

		inv = Player.Inventory;
		while(inv != None)
		{
			ammo = DeusExAmmo(inv);

			if ((ammo != None) && (ammo.bShowInfo))
			{
				winInfo.AddAmmoInfoWindow(ammo, player.bShowAmmoDescriptions);
				ammoCount++;
			}

			inv = inv.Inventory;
		}

		if (ammoCount == 0)
		{
			winInfo.Clear();
			winInfo.SetTitle(AmmoTitleLabel);
			winInfo.SetText(NoAmmoLabel);
		}

		bUpdatingAmmoDisplay = False;
	}
}

// ----------------------------------------------------------------------
// SelectInventory()
// ----------------------------------------------------------------------

function SelectInventory(PersonaItemButton buttonPressed)
{
	local Inventory anItem;

	// Don't do extra work.
	if (buttonPressed != None)
	{
		if (!selectedItem.bSelected || buttonPressed != selectedItem)
		{
			// Deselect current button
			if (selectedItem != None)
				selectedItem.SelectButton(False);

			selectedItem = buttonPressed;

			ClearSpecialHighlights();
			HighlightSpecial(Inventory(selectedItem.GetClientObject()));
			SelectObjectBeltItem(Inventory(selectedItem.GetClientObject()), True);

			selectedItem.SelectButton(True);

			anItem = Inventory(selectedItem.GetClientObject());

			if (anItem != None)
				anItem.UpdateInfo(winInfo);

			EnableButtons();
		}
        //SARGE: Allow deselecting inventory items
        else
        {
            selectedItem.SelectButton(False);
			ClearSpecialHighlights();
            //SelectInventory(None);
            //SignalRefresh();
            UpdateDeclinedDisplay();
        }
	}
	else
	{
		if (selectedItem != None)
			PersonaInventoryItemButton(selectedItem).SelectButton(False);

		if (selectedSlot != None)
			selectedSlot.SetToggle(False);

		selectedItem = None;
	}
}

/*function UpdateInventoryInfo()                                                  //RSD: To refresh inventory info
{
	local Inventory anItem;

	if (selectedItem != None)
	{
		anItem = Inventory(selectedItem.GetClientObject());
		if (anItem != None)
			anItem.UpdateInfo(winInfo);
	}
}*/

// ----------------------------------------------------------------------
// SelectInventoryItem()
//
// Searches through the inventory items for the item passed in and
// selects it.
// ----------------------------------------------------------------------

function SelectInventoryItem(Inventory item)
{
	local PersonaInventoryItemButton itemButton;
	local Window itemWindow;

	// Special case for NanoKeyRing
	if (item != None)
	{
		if (item.IsA('NanoKeyRing'))
		{
			if (winNanoKeyRing != None)
			{
				SelectInventory(winNanoKeyRing.GetItemButton());
			}
		}
		else if (winItems != None)
		{
			// Search through the buttons
			itemWindow = winItems.GetTopChild();
			while(itemWindow != None)
			{
				itemButton = PersonaInventoryItemButton(itemWindow);
				if (itemButton != None)
				{
					if (itemButton.GetClientObject() == item)
					{
						SelectInventory(itemButton);
						break;
					}
				}

				itemWindow = itemWindow.GetLowerSibling();
			}
		}
	}
}

// ----------------------------------------------------------------------
// RefreshInventoryItemButtons()
//
// Refreshes all inventory item buttons.
// ----------------------------------------------------------------------

function RefreshInventoryItemButtons()
{
    local Window itemWindow;
    local PersonaInventoryItemButton itemButton;
    local Inventory SelectedInventory;

    if (winItems == None)
        return;

    //record selected item
    if (selectedItem != None)
        SelectedInventory = Inventory(selectedItem.GetClientObject());
    else
        SelectedInventory = None;

    //Delete buttons
    itemWindow = winItems.GetTopChild();

    selecteditem = None;
    while (itemWindow != None)
    {
        itemButton = PersonaInventoryItemButton(itemWindow);
        itemWindow = itemWindow.GetLowerSibling();
        if (itemButton != None)
        {
            itemButton.Destroy();
        }
    }

    //Create buttons
    CreateInventoryButtons();

    //Select new button version of selected item.
    //We don't use the selectinventoryitem call because the constant
    //item.update(wininfo) calls cause quite a slowdown when any item
    //is selected.  Since we aren't really selecting a different item,
    //we don't need to do that update.
	if (SelectedInventory != None)
	{
        // Search through the buttons
        itemWindow = winItems.GetTopChild();
        while(itemWindow != None)
        {
            itemButton = PersonaInventoryItemButton(itemWindow);
            if (itemButton != None)
            {
                if (itemButton.GetClientObject() == SelectedInventory)
                {
                    selecteditem = itemButton;
                    selectedItem.SelectButton(True);
                    break;
                }
            }

            itemWindow = itemWindow.GetLowerSibling();
        }
	}

   // if this does special highlighting, refresh that.
   if (SelectedInventory != None)
      HighlightSpecial(SelectedInventory);
}

// ----------------------------------------------------------------------
// SelectObjectBeltItem()
// ----------------------------------------------------------------------

function SelectObjectBeltItem(Inventory item, bool bNewToggle)
{
	invBelt.SelectObject(item, bNewToggle);
}

// ----------------------------------------------------------------------
// UseSelectedItem()
// ----------------------------------------------------------------------

function UseSelectedItem()
{
	local Inventory inv;
	local int numCopies;

	inv = Inventory(selectedItem.GetClientObject());

	if (inv != None)
	{
		// If this item was equipped in the inventory screen,
		// make sure we set inHandPending to None so it's not
		// drawn when we exit the Inventory screen

		if (player.inHandPending == inv)
			player.SetInHandPending(None);

		// If this is a binoculars, then it needs to be equipped
		// before it can be activated
		if (inv.IsA('Binoculars'))
			player.PutInHand(inv);

        inv.Activate();

		// Check to see if this is a stackable item, and keep track of
		// the count
		if ((inv.IsA('DeusExPickup')) && (DeusExPickup(inv).bCanHaveMultipleCopies))
			numCopies = DeusExPickup(inv).NumCopies - 1;
		else
			numCopies = 0;

		// Update the object belt
		invBelt.UpdateBeltText(inv);

		// Refresh the info!
		if (numCopies > 0)
			UpdateWinInfo(inv);
	}
}

// ----------------------------------------------------------------------
// DropSelectedItem()
// ----------------------------------------------------------------------

function DropSelectedItem()
{
	local Inventory anItem;
	local int numCopies;

	if (selectedItem == None)
		return;

	if (Inventory(selectedItem.GetClientObject()) != None)
	{
		// Now drop it, unless this is the NanoKeyRing
		if (!Inventory(selectedItem.GetClientObject()).IsA('NanoKeyRing'))
		{
			anItem = Inventory(selectedItem.GetClientObject());

			// If this is a DeusExPickup, keep track of the number of copies
			if (anItem.IsA('DeusExPickup'))
				numCopies = DeusExPickup(anItem).NumCopies;

			// First make sure the player can drop it!
			if (player.DropItem(anItem, True))
			{
				// Make damn sure there's nothing pending
            if ((player.inHandPending == anItem) || (player.inHand == anItem))
				   player.SetInHandPending(None);

				// Remove the item, but first check to see if it was stackable
				// and there are more than 1 copies available
   			if ( ((!anItem.IsA('DeusExPickup')) && !(anItem.IsA('DeusExWeapon') && DeusExWeapon(anItem).bDisposableWeapon)) ||
					 (anItem.IsA('DeusExPickup') && (numCopies <= 1)))
				{
					RemoveSelectedItem();
				}

				// Send status message
				winStatus.AddText(Sprintf(DroppedLabel, anItem.itemName));

				// Update the object belt
				invBelt.UpdateBeltText(anItem);

                //Force an update
                SignalRefresh();
			}
			else
			{
                //DEUS_EX AMSD Don't do this in multiplayer, because the way function repl
                //works, we'll ALWAYS end up here.
                if (player.Level.NetMode == NM_Standalone)
                    winStatus.AddText(Sprintf(CannotBeDroppedLabel, anItem.itemName));
			}
		}
	}
}

// ----------------------------------------------------------------------
// RemoveSelectedItem()
// ----------------------------------------------------------------------

function RemoveSelectedItem()
{
	local Inventory inv;

	if (selectedItem == None)
		return;

	inv = Inventory(selectedItem.GetClientObject());

	if (inv != None)
	{
		// Destroy the button
		selectedItem.Destroy();
		selectedItem = None;

		// Remove it from the object belt
		invBelt.RemoveObject(inv);

		// Remove it from the inventory screen
		UnequipItemInHand();

		ClearSpecialHighlights();

		SelectInventory(None);

		winInfo.Clear();
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// WeaponChangeAmmo()
// ----------------------------------------------------------------------

function WeaponChangeAmmo()
{
	local DeusExWeapon aWeapon;

	aWeapon = DeusExWeapon(selectedItem.GetClientObject());

	if ( aWeapon != None )
	{
		if ((Player.bRealUI || Player.bHardcoreMode) && Player.inHand != aWeapon) //RSD: If we have realtime UI and not holding the weapon, actually swap to that weapon and load in realtime too
		{
			if (aWeapon.CanCycleAmmo())                                         //RSD: Added hacky CanCycleAmmo() check
			{
				Player.inHandPending = aWeapon;
				aWeapon.bBeginAmmoSelectLoad = true;
				aWeapon.ammoSelectClass = none;

				// Send status message and update info window
				//winStatus.AddText(Sprintf(AmmoLoadedLabel, aWeapon.ammoSelectClass));
				//aWeapon.UpdateAmmoInfo(winInfo, Class<DeusExAmmo>(aWeapon.AmmoName));
				//aWeapon.UpdateInfo(winInfo);
				//winInfo.SetLoaded(aWeapon.ammoSelectClass);
			}
		}
		else                                                                    //RSD: Otherwise just load the ammo as we would before
        {
        aWeapon.CycleAmmo();

        // Send status message and update info window
		winStatus.AddText(Sprintf(AmmoLoadedLabel, aWeapon.ammoType.itemName));
		//aWeapon.UpdateAmmoInfo(winInfo, Class<DeusExAmmo>(aWeapon.AmmoName));
		aWeapon.UpdateInfo(winInfo);
		winInfo.SetLoaded(aWeapon.AmmoName, true);                              //RSD: Added true hack

		// Update the object belt
		invBelt.UpdateBeltText(aWeapon);
        }
	}
}

// ----------------------------------------------------------------------
// LoadAmmo()
// ----------------------------------------------------------------------

function Class<DeusExAmmo> LoadAmmo()
{
	local DeusExWeapon aWeapon;
	local Class<DeusExAmmo> ammo;

	aWeapon = DeusExWeapon(selectedItem.GetClientObject());

	if ( aWeapon != None )
	{
		ammo = Class<DeusExAmmo>(winInfo.GetSelectedAmmo());

		// Only change if this is a different kind of ammo

		if ((ammo != None) && (ammo != aWeapon.AmmoName))
		{
			if ((Player.bRealUI || Player.bHardcoreMode) && Player.inHand != aWeapon) //RSD: If we have realtime UI and not holding the weapon, actually swap to that weapon and load in realtime too
			{
				Player.inHandPending = aWeapon;
				aWeapon.bBeginAmmoSelectLoad = true;
				aWeapon.ammoSelectClass = ammo;

				// Send status message and update info window
				//winStatus.AddText(Sprintf(AmmoLoadedLabel, aWeapon.ammoSelectClass));
				//aWeapon.UpdateAmmoInfo(winInfo, Class<DeusExAmmo>(aWeapon.AmmoName));
				//aWeapon.UpdateInfo(winInfo);
				winInfo.SetLoaded(aWeapon.ammoSelectClass, true);               //RSD: Added true hack
			}
			else                                                                //RSD: Otherwise just load the ammo as we would before
			{
            aWeapon.LoadAmmoClass(ammo);

			// Send status message
			winStatus.AddText(Sprintf(AmmoLoadedLabel, ammo.Default.itemName));
			//aWeapon.UpdateAmmoInfo(winInfo, Class<DeusExAmmo>(aWeapon.AmmoName));
			aWeapon.UpdateInfo(winInfo);                                        //RSD: Added for realtime load
			winInfo.SetLoaded(aWeapon.AmmoName, true);                          //RSD: Added for realtime load, plus true hack

			// Update the object belt
			invBelt.UpdateBeltText(aWeapon);
            }
		}
	}

	return ammo;
}

// ----------------------------------------------------------------------
// EquipSelectedItem()
// ----------------------------------------------------------------------

function EquipSelectedItem()
{
	local Inventory inv;

	// If the object's in-hand, then unequip
	// it.  Otherwise put this object in-hand.

	inv = Inventory(selectedItem.GetClientObject());

	if ( inv != None )
	{
		// Make sure the Binoculars aren't activated.
		if ((player.inHand != None) && (player.inHand.IsA('Binoculars')))
			Binoculars(player.inHand).Activate();
		else if ((player.inHandPending != None) && (player.inHandPending.IsA('Binoculars')))
			Binoculars(player.inHandPending).Activate();

		if ((inv == player.inHand) || (inv == player.inHandPending))
		{
			UnequipItemInHand();
		}
		else
		{
			player.PutInHand(inv);
			PersonaInventoryItemButton(selectedItem).SetEquipped(True);
		}

		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// UnequipItemInHand()
// ----------------------------------------------------------------------

function UnequipItemInHand()
{
	if ((PersonaInventoryItemButton(selectedItem) != None) && ((player.inHand != None) || (player.inHandPending != None)))
	{
		player.PutInHand(None);
		player.SetInHandPending(None);

		PersonaInventoryItemButton(selectedItem).SetEquipped(False);
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// UpdateWinInfo()
// ----------------------------------------------------------------------

function UpdateWinInfo(Inventory inv)
{
	winInfo.Clear();

	if (inv != None)
	{
		winInfo.SetTitle(inv.ItemName);
		winInfo.SetText(inv.Description);
	}
}

// ----------------------------------------------------------------------
// RefreshWindow()
// ----------------------------------------------------------------------

function RefreshWindow(float DeltaTime)
{
    TimeSinceLastUpdate = TimeSinceLastUpdate + DeltaTime;
    if (TimeSinceLastUpdate >= 0.25)
    {
        TimeSinceLastUpdate = 0;
        if (!bDragging)
        {
            RefreshInventoryItemButtons();
            CleanBelt();
        }
    }

    log("Refresh");


    Super.RefreshWindow(DeltaTime);
}
// ----------------------------------------------------------------------
// SignalRefresh()
// ----------------------------------------------------------------------

function SignalRefresh()
{
    //Put it about a quarter of a second back from an update, so that
    //server has time to propagate.
    TimeSinceLastUpdate = 0;
}

// ----------------------------------------------------------------------
// CleanBelt()
// ----------------------------------------------------------------------

function CleanBelt()
{
    local Inventory CurrentItem;

    invBelt.hudBelt.ClearBelt();
    invBelt.objBelt.ClearBelt();
    invBelt.objBelt.PopulateBelt();
    if (selectedItem != None)
        SelectObjectBeltItem(Inventory(selectedItem.GetClientObject()), True);
}


// ----------------------------------------------------------------------
// RemoveItem()
//
// Removes this item from the screen.  If this is the selected item,
// does some additional processing.
// ----------------------------------------------------------------------

function RemoveItem(Inventory item)
{
	local Window itemWindow;

	if (item == None)
		return;

	// Remove it from the object belt
	invBelt.RemoveObject(item);

	if ((selectedItem != None) && (item == selectedItem.GetClientObject()))
	{
		RemoveSelectedItem();
	}
	else
	{
		// Loop through the PersonaInventoryItemButtons looking for a match
		itemWindow = winItems.GetTopChild();
		while( itemWindow != None )
		{
			if (itemWindow.GetClientObject() == item)
			{
				DeferDestroy(itemWindow);
//				itemWindow.Destroy();
				break;
			}

			itemWindow = itemWindow.GetLowerSibling();
		}
	}
}

// ----------------------------------------------------------------------
// DeferDestroy()
// ----------------------------------------------------------------------

function DeferDestroy(Window newDestroyWindow)
{
	destroyWindow = newDestroyWindow;

	if (destroyWindow != None)
		bTickEnabled = True;
}

// ----------------------------------------------------------------------
// InventoryDeleted()
//
// Called when some external force needs to remove an inventory
// item from the player. For instance, when an item is "used" and it's
// a single-use item, it destroys itself, which will ultimately
// result in this ItemDeleted() call.
// ----------------------------------------------------------------------

function InventoryDeleted(Inventory item)
{
	if (item != None)
	{
		// Remove the item from the screen
		RemoveItem(item);
	}
}

// ----------------------------------------------------------------------
// ClearSelectedSlot()
// ----------------------------------------------------------------------

function ClearSelectedSlot()
{
	if (selectedSlot == None)
		return;

	// Make sure this isn't the NanoKeyRing
	if ((selectedSlot.item != None) && (!selectedSlot.item.IsA('NanoKeyRing')))
	{
		selectedSlot.SetToggle(False);
		ClearSlotItem(selectedSlot.item);
		selectedSlot = None;

		winInfo.Clear();
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// ClearSlotItem()
// ----------------------------------------------------------------------

function ClearSlotItem(Inventory item)
{
	invBelt.RemoveObject(item);
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	local Inventory inv;

	// Make sure all the buttons exist!
	if ((btnChangeAmmo == None) || (btnDrop == None) || (btnEquip == None) || (btnUse == None))
		return;

	if ( selectedItem == None )
	{
		btnChangeAmmo.DisableWindow();
		btnDrop.DisableWindow();
		btnEquip.DisableWindow();
		btnUse.DisableWindow();
	}
	else
	{
		btnChangeAmmo.EnableWindow();
		btnEquip.EnableWindow();
		btnUse.EnableWindow();
		btnDrop.EnableWindow();

		inv = Inventory(selectedItem.GetClientObject());

		if (inv != None)
		{
			// Anything can be dropped, except the NanoKeyRing
			btnDrop.EnableWindow();

			if (inv.IsA('WeaponMod'))
			{
				btnChangeAmmo.DisableWindow();
				btnUse.DisableWindow();
			}
			else if (inv.IsA('NanoKeyRing'))
			{
				btnChangeAmmo.DisableWindow();
				btnDrop.DisableWindow();
				btnEquip.DisableWindow();
				btnUse.DisableWindow();
			}
			// Augmentation Upgrade Cannisters cannot be used
			// on this screen
			else if ( inv.IsA('AugmentationUpgradeCannister') )
			{
				btnUse.DisableWindow();
				btnChangeAmmo.DisableWindow();
			}
			// Ammo can't be used or equipped
			else if ( inv.IsA('Ammo') )
			{
				btnUse.DisableWindow();
				btnEquip.DisableWindow();
			}
			else
			{
				if ((inv == player.inHand ) || (inv == player.inHandPending))
					btnEquip.SetButtonText(UnequipButtonLabel);
				else
					btnEquip.SetButtonText(EquipButtonLabel);
			}

			// If this is a weapon, check to see if this item has more than
			// one type of ammo in the player's inventory that can be
			// equipped.  If so, enable the "AMMO" button.
			if ( inv.IsA('DeusExWeapon') )
			{
				btnUse.DisableWindow();

				if ( DeusExWeapon(inv).NumAmmoTypesAvailable() < 2 )
					btnChangeAmmo.DisableWindow();
			}
			else
			{
				btnChangeAmmo.DisableWindow();
			}
		}
		else
		{
			btnChangeAmmo.DisableWindow();
			btnDrop.DisableWindow();
			btnEquip.DisableWindow();
			btnUse.DisableWindow();
		}
	}
}

// ----------------------------------------------------------------------
// UpdateDragMouse()
// ----------------------------------------------------------------------

function UpdateDragMouse(float newX, float newY)
{
	local Window findWin;
	local Float relX, relY;
	local Int slotX, slotY, sX, sY, dX, dY;
	local PersonaInventoryItemButton invButton;
	local HUDObjectSlot objSlot;
	local Bool bValidDrop;
	local Bool bOverrideButtonColor;
    local Inventory thisItem;

	findWin = FindWindow(newX, newY, relX, relY);

	// If we're dragging an inventory button, behave one way, if we're
	// dragging a hotkey button, behave another

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{
		invButton = PersonaInventoryItemButton(dragButton);

		// If we're over the Inventory Items window, check to see
		// if there's enough space to deposit this item here.

		bValidDrop = False;
		bOverrideButtonColor = False;

		if ((findWin == winItems) || (findWin == dragButton ) || (findWin == homeButton)) //RSD: Added homeButton so it doesn't affect the display
		{
            if ( findWin == dragButton || findWin == homeButton)                //RSD: Added homeButton so it doesn't affect the display
				ConvertCoordinates(Self, newX, newY, winItems, relX, relY);

			bValidDrop = CalculateItemPosition(
				Inventory(dragButton.GetClientObject()),
				relX, relY,
				slotX, slotY);

			// If the mouse is still in the window, don't actually hide the
			// button just yet.

			if (bValidDrop && (player.IsEmptyItemSlot(Inventory(invButton.GetClientObject()), slotX, slotY)))
				SetItemButtonPos(invButton, slotX, slotY);

            //player.BroadcastMessage("X:" @ invButton.dragPosX $ ", Y:" @ invButton.dragPosY);

			//RSD: Since rotation moves the default position to (-1,-1), check if we're still there and show homeButton instead
			if ((invButton.dragPosX == -1 || invButton.dragPosX == -1) && homeButton != none)
            {
				homeButton.SetDropFill(true);
                invButton.bValidSlot = False;
				invButton.bDimIcon   = False;
				bOverrideButtonColor = True;
				invButton.ResetFill();
			}
			else if (homeButton != none)
				homeButton.ResetFill();
		}

		// Check to see if we're over the Object Belt
		else if (HUDObjectSlot(findWin) != None)
		{
			bValidDrop = True;

			if (HUDObjectSlot(findWin).item != None)
				if (HUDObjectSlot(findWin).item.IsA('NanoKeyRing'))
					bValidDrop = False;

			HUDObjectSlot(findWin).SetDropFill(bValidDrop);
		}

		// Check to see if we're over another inventory item
		else if (PersonaInventoryItemButton(findWin) != None)
		{
			// If we're dragging a weapon mod and we're over a weapon, check to
			// see if the mod can be dropped here.
			//
			// Otherwise this is a bad drop location

            //CyberP: this is a bit demanding. Should probably optimize at some point //RSD to the rescue!
           if (PersonaInventoryItemButton(findWin) != dragButton && PersonaInventoryItemButton(findWin).GetClientObject().IsA('Inventory')) //RSD: Everything's an Inventory object, no need to separate
           //IsA('DeusExPickup') || PersonaInventoryItemButton(findWin).GetClientObject().IsA('DeusExWeapon'))
		   {
		    /*if (DeusExPickup(PersonaInventoryItemButton(findWin).GetClientObject()) != None)
		     {
		      sX = DeusExPickup(PersonaInventoryItemButton(findWin).GetClientObject()).invSlotsX;
		      sY = DeusExPickup(PersonaInventoryItemButton(findWin).GetClientObject()).invSlotsY;
		     }
            else if (DeusExWeapon(PersonaInventoryItemButton(findWin).GetClientObject()) != None)
             {
              sX = DeusExWeapon(PersonaInventoryItemButton(findWin).GetClientObject()).invSlotsX;
		      sY = DeusExWeapon(PersonaInventoryItemButton(findWin).GetClientObject()).invSlotsY;
             }*/
             if (Inventory(PersonaInventoryItemButton(findWin).getClientObject()) != None) //RSD: Everything's an Inventory object, no need to separate
             {
		      sX = Inventory(PersonaInventoryItemButton(findWin).GetClientObject()).invSlotsX;
		      sY = Inventory(PersonaInventoryItemButton(findWin).GetClientObject()).invSlotsY;
             }
             /*if (invButton.GetClientObject().IsA('DeusExPickup'))
		     {
		      dX = DeusExPickup(invButton.GetClientObject()).invSlotsX;
		      dY = DeusExPickup(invButton.GetClientObject()).invSlotsY;
		     }
            else if (invButton.GetClientObject().IsA('DeusExWeapon'))
             {
              dX = DeusExWeapon(invButton.GetClientObject()).invSlotsX;
		      dY = DeusExWeapon(invButton.GetClientObject()).invSlotsY;
             }*/
             if (invButton.GetClientObject().IsA('Inventory'))                  //RSD: Everything's an Inventory object, no need to separate
		     {
		      dX = Inventory(invButton.GetClientObject()).invSlotsX;
		      dY = Inventory(invButton.GetClientObject()).invSlotsY;
		      //dX = invButton.safeInvX;                                          //RSD: Need to use saved value otherwise we can swap with the rotated value, ECH
		      //dY = invButton.safeInvY;                                          //RSD: Need to use saved value otherwise we can swap with the rotated value, ECH
		     }
           if (sX == dX && sY == dY)
             {
                PersonaInventoryItemButton(findWin).SetDropFill(False,True);
                invButton.bDimIcon   = False;                                   //RSD: Don't dim icon if swap is valid
                bOverrideButtonColor = True;
                invButton.bValidSlot = False;                                   //RSD: Hide the slot window
				invButton.ResetFill();                                          //RSD
                homeButton.SetDropFill(False,True);                             //RSD: Also show where we're going to swap to
             }
             else
             {
                PersonaInventoryItemButton(findWin).SetDropFill(False);
                if (homeButton != none)                                         //RSD
                    homeButton.ResetFill();
             }
           }


			// Check for weapon mods being dragged over weapons
			if ((dragButton.GetClientObject().IsA('WeaponMod')) && (findWin.GetClientObject().IsA('DeusExWeapon')))
			{
				if (WeaponMod(invButton.GetClientObject()).CanUpgradeWeapon(DeusExWeapon(findWin.GetClientObject())))
				{
					bValidDrop = True;
					PersonaInventoryItemButton(findWin).SetDropFill(True);
					invButton.bValidSlot = False;
					invButton.bDimIcon   = False;
					bOverrideButtonColor = True;

					invButton.ResetFill();
					if (homeButton != none)                                     //RSD
                    	homeButton.ResetFill();
				}
			}
            else if ((dragButton.GetClientObject().IsA('BioelectricCell')) && (findWin.GetClientObject().IsA('ChargedPickup')))
			{
				if (ChargedPickup(findWin.GetClientObject()).Charge < ChargedPickup(findWin.GetClientObject()).default.Charge)
				{
					bValidDrop = True;
					PersonaInventoryItemButton(findWin).SetDropFill(True);
					invButton.bValidSlot = False;
					invButton.bDimIcon   = False;
					bOverrideButtonColor = True;

					invButton.ResetFill();
					if (homeButton != none)                                     //RSD
                    	homeButton.ResetFill();
				}
			}
			// Check for ammo being dragged over weapons
			else if ((dragButton.GetClientObject().IsA('DeusExAmmo')) && (findWin.GetClientObject().IsA('DeusExWeapon')))
			{
				if (DeusExWeapon(findWin.GetClientObject()).CanLoadAmmoType(DeusExAmmo(dragButton.GetClientObject())))
				{
					bValidDrop = True;
					PersonaInventoryItemButton(findWin).SetDropFill(True);
					invButton.bValidSlot = False;
					invButton.bDimIcon   = False;
					bOverrideButtonColor = True;

					invButton.ResetFill();
					if (homeButton != none)                                     //RSD
                    	homeButton.ResetFill();
				}
			}
		}
		else if (homeButton != none)                                            //RSD
			homeButton.ResetFill();

		if (!bOverrideButtonColor)
		{
			invButton.SetDropFill(bValidDrop);
			invButton.bDimIcon = !bValidDrop;

			if (HUDObjectSlot(findWin) != None)
				invButton.bValidSlot = False;
			else
				invButton.bValidSlot = bValidDrop;
		}
	}
	else
	{
		// This is an Object Belt item we're dragging

		objSlot = HUDObjectSlot(dragButton);
		bValidDrop = False;

		// Can only be dragged over another object slot
		if (findWin.IsA('HUDObjectSlot'))
		{
			if (HUDObjectSlot(findWin).item != None)
			{
				if (!HUDObjectSlot(findWin).item.IsA('NanoKeyRing'))
				{
					bValidDrop = True;
				}
			}
			else
			{
				bValidDrop = True;
			}

			HUDObjectSlot(findWin).SetDropFill(bValidDrop);
		}

		objSlot.bDimIcon = !bValidDrop;
	}

	// Unhighlight the previous window we were over
	if ((lastDragOverButton != None) && (lastDragOverButton != findWin))
	{
		if (lastDragOverButton.IsA('HUDObjectSlot'))
		{
			HUDObjectSlot(lastDragOverButton).ResetFill();
		}
		else if (lastDragOverButton.IsA('PersonaInventoryItemButton') && !bHomeButtonHack) //RSD: Hack below hides the button, so don't do that (BLEH)
		{
			PersonaInventoryItemButton(lastDragOverButton).ResetFill();
		}
	}

	// Keep track of the last button window we were over
	lastDragOverButton = ButtonWindow(findWin);
	lastDragOverWindow = findWin;
	if (lastDragOverButton == homeButton)                                       //RSD: Hack to get by our stupid homeButton
	{
        lastDragOverButton = invButton;
        bHomeButtonHack = true;
	}
	else
    	bHomeButtonHack = false;
}

// ----------------------------------------------------------------------
// CalculateItemPosition()
//
// Calculates exactly where this item belongs in the window based on
// the position passed in (relative to "winItems") and the inventory
// item.
//
// Returns TRUE if this is a valid drop slot (not out of bounds)
// ----------------------------------------------------------------------

function bool CalculateItemPosition(
	Inventory item,
	float pointX,
	float pointY,
	out int slotX,
	out int slotY)
{
	local int invWidth;
	local int invHeight;
	local int adjustX;
	local int adjustY;
	local bool bResult;

	bResult = True;

	// First get the width and height of the inventory icon
	invWidth  = item.largeIconWidth;
	invHeight = item.largeIconHeight;

	// Calculate the first square that represents where this object is
	adjustX = 0;
	adjustY = 0;

	if (invWidth > invButtonWidth)
		adjustX = ((invWidth/2) - (invButtonWidth / 2));

	if (invHeight > invButtonHeight)                                            //RSD: was width again, corrected to height (fixes rotated item dragging)
		adjustY = ((invHeight/2) - (invButtonHeight /2));

	// Check to see if we're outside the range of where the
	// slots are located.
	if ((pointX - adjustX) > (invButtonWidth  * player.maxInvCols))
	{
		slotX = player.maxInvCols - 1;
		if (slotX < 0)
			slotX = 0;

		bResult = False;
	}
	else
	{
		slotX = (pointX - adjustX) / invButtonWidth;

		if (slotX < 0)
			slotX = 0;
	}

	if ((pointY - adjustY) > (invButtonHeight * player.maxInvRows))
	{
		slotY = player.maxInvRows - 1;
		bResult = False;
	}
	else
	{
		slotY = (pointY - adjustY) / invButtonHeight;
	}

	return bResult;
}

// ----------------------------------------------------------------------
// StartButtonDrag()
// ----------------------------------------------------------------------

function StartButtonDrag(ButtonWindow newDragButton)
{
	// Show the object belt
	dragButton = newDragButton;

	ClearSpecialHighlights();

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{
		SelectInventory(None);

        PersonaInventoryItemButton(dragButton).setSafeRotation();               //RSD: can now rotate, so save the working values before we start dragging
        SetHomeButton(PersonaInventoryItemButton(dragButton));

		// Clear the space used by this button in the grid so we can
		// still place the button here.
		player.SetInvSlots(Inventory(dragButton.GetClientObject()), 0);
	}
	else
	{
		// Make sure no hud icon is selected
		if (selectedSlot != None)
			selectedSlot.SetToggle(False);
	}

    SignalRefresh();
	bDragging  = True;
}

function SetHomeButton(PersonaInventoryItemButton invButton)                    //RSD: Set up our fake button highlight
{
	local Inventory inv;

    inv = Inventory(invButton.GetClientObject());
    if (homeButton != none)
    {
	homeButton.dragPosX = inv.invPosX;
	homeButton.dragPosY = inv.invPosY;
	homeButton.invSlotsX = invButton.safeInvX;
	homeButton.invSlotsY = invButton.safeInvY;

    homeButton.SetPos(
		homeButton.dragPosX * (invButtonWidth),
		homeButton.dragPosY * (invButtonHeight)
		);
    homeButton.SetSize((invButtonWidth  * homeButton.invSlotsX) + 1,
				(invButtonHeight * homeButton.invSlotsY) + 1);
    }
	//player.BroadcastMessage("X:" @ homeButton.dragPosX $ ", Y:" @ homeButton.dragPosY);
}

function resetHomeButton()                                                      //RSD: Remove our fake button highlight
{
    if (homeButton != none)
    {
    homeButton.dragPosX = -1;
	homeButton.dragPosY = -1;
	homeButton.invSlotsX = 0;
	homeButton.invSlotsY = 0;
	homeButton.SetPos(
		homeButton.dragPosX * (invButtonWidth),
		homeButton.dragPosY * (invButtonHeight)
		);
    homeButton.SetSize((invButtonWidth  * homeButton.invSlotsX) + 1,
				(invButtonHeight * homeButton.invSlotsY) + 1);
	}
}

// ----------------------------------------------------------------------
// FinishButtonDrag()
// ----------------------------------------------------------------------

function FinishButtonDrag()
{
	local int beltSlot;
	local Inventory dragInv;
	local PersonaInventoryItemButton dragTarget;
	local HUDObjectSlot itemSlot;
    local int invX, invY, posX, posY;
    local string rechargedMsg;
    local ChargedPickup ChargedTarget;                                          //RSD: Added
    local float mult;                                                           //RSD: Added

	// Take a look at the last window we were over to determine
	// what to do now.  If we were over the Inventory Items window,
	// then move the item to a new slot.  If we were over the Object belt,
	// then assign this item to the appropriate key

	if (dragButton == None)
	{
		EndDragMode();
		return;
	}

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{
		dragInv    = Inventory(dragButton.GetClientObject());
		dragTarget = PersonaInventoryItemButton(lastDragOverButton);

		// Check if this is a weapon mod and we landed on a weapon
		if ( (dragInv.IsA('WeaponMod')) && (dragTarget != None) && (dragTarget.GetClientObject().IsA('DeusExWeapon')) )
		{
			if (WeaponMod(dragInv).CanUpgradeWeapon(DeusExWeapon(dragTarget.GetClientObject())))
			{
				// 0.  Unhighlight highlighted weapons
				// 1.  Apply the weapon upgrade
				// 2.  Remove from Object Belt
				// 3.  Destroy the upgrade (will cause button to be destroyed)
				// 4.  Highlight the weapon.

				WeaponMod(dragInv).ApplyMod(DeusExWeapon(dragTarget.GetClientObject()));

            Player.RemoveObjectFromBelt(dragInv);
            //invBelt.objBelt.RemoveObjectFromBelt(dragInv);

				// Send status message
				winStatus.AddText(Sprintf(WeaponUpgradedLabel, DeusExWeapon(dragTarget.GetClientObject()).itemName));

            //DEUS_EX AMSD done here for multiplayer propagation.
            WeaponMod(draginv).DestroyMod();
				//player.DeleteInventory(dragInv);

                ReturnButton(PersonaInventoryItemButton(dragButton));           //RSD: Fixing inventory overlap exploit for weapon mods

				dragButton = None;
				SelectInventory(dragTarget);
			}
			else
			{
				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
		}
        else if ( (dragInv.IsA('BioelectricCell')) && (dragTarget != None) && (dragTarget.GetClientObject().IsA('ChargedPickup')) )
		{
			ChargedTarget = ChargedPickup(dragTarget.GetClientObject());        //RSD: Making a new var for it so there aren't a billion constructor calls
            //if (ChargedPickup(dragTarget.GetClientObject()).Charge < ChargedPickup(dragTarget.GetClientObject()).default.Charge)
            if (ChargedTarget.Charge < ChargedTarget.default.Charge)
			{
				// 0.  Unhighlight highlighted weapons
				// 1.  Apply the weapon upgrade
				// 2.  Remove from Object Belt
				// 3.  Destroy the upgrade (will cause button to be destroyed)
				// 4.  Highlight the weapon.
                /*if (ChargedPickup(dragTarget.GetClientObject()).IsA('AdaptiveArmor') || ChargedPickup(dragTarget.GetClientObject()).IsA('Rebreather'))
                {
				   ChargedPickup(dragTarget.GetClientObject()).Charge += ChargedPickup(dragTarget.GetClientObject()).default.Charge*0.15;
				   if (ChargedPickup(dragTarget.GetClientObject()).Charge >= ChargedPickup(dragTarget.GetClientObject()).default.Charge)
                   {
                      winStatus.AddText("Fully Recharged");
                      ChargedPickup(dragTarget.GetClientObject()).Charge = ChargedPickup(dragTarget.GetClientObject()).default.Charge;
                   }
                   else
                      winStatus.AddText("Recharged by 15%");
				}
                else
                {
                   ChargedPickup(dragTarget.GetClientObject()).Charge += ChargedPickup(dragTarget.GetClientObject()).default.Charge*0.3;
                   if (ChargedPickup(dragTarget.GetClientObject()).Charge >= ChargedPickup(dragTarget.GetClientObject()).default.Charge)
                   {
                      winStatus.AddText("Fully Recharged");
                      ChargedPickup(dragTarget.GetClientObject()).Charge = ChargedPickup(dragTarget.GetClientObject()).default.Charge;
                   }
                   else
                      winStatus.AddText("Recharged by 30%");
                }*/
                mult = ChargedTarget.default.ChargeMult;                        //RSD: No more special cases for charge rates
                if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkFieldRepair').bPerkObtained == true)                              //RSD: Field Repair perk
                   mult *= 1.5;
                ChargedTarget.Charge += mult*ChargedTarget.default.Charge;
                if (ChargedTarget.Charge >= ChargedTarget.default.Charge)
                {
                   winStatus.AddText("Fully Recharged");
                   ChargedTarget.Charge = ChargedTarget.default.Charge;
                }
                else
                   winStatus.AddText("Recharged by"@int(100*mult)$"%");
                ChargedTarget.bActivatable=true;                                //RSD: Since now you can hold one at 0%
                ChargedTarget.unDimIcon();                                      //RSD

            Player.RemoveObjectFromBelt(dragInv);
            //invBelt.objBelt.RemoveObjectFromBelt(dragInv);

				// Send status message
				//rechargedMsg = string(int(ChargedPickup(dragTarget.GetClientObject()).default.Charge*0.3));

            //DEUS_EX AMSD done here for multiplayer propagation.
            BioelectricCell(draginv).UseOnce();
            Player.PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);
				//player.DeleteInventory(dragInv);

				dragButton = None;
				SelectInventory(dragTarget);
			}
			else
			{
				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
		}
		// Check if this is ammo and we landed on a weapon
		else if ((dragInv.IsA('DeusExAmmo')) && (dragTarget != None) && (dragTarget.GetClientObject().IsA('DeusExWeapon')) )
		{
			if (DeusExWeapon(dragTarget.GetClientObject()).CanLoadAmmoType(DeusExAmmo(dragInv)))
			{
				// Load this ammo into the weapon
				DeusExWeapon(dragTarget.GetClientObject()).LoadAmmoType(DeusExAmmo(dragInv));

				// Send status message
				winStatus.AddText(Sprintf(AmmoLoadedLabel, DeusExAmmo(dragInv).itemName));

				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
		}
		//CyberP: begin
		else if (dragTarget != None && dragTarget != dragButton && dragTarget.GetClientObject().IsA('Inventory'))
        //(dragtarget.GetClientObject().IsA('DeusExPickup') || dragtarget.GetClientObject().IsA('DeusExWeapon'))) //RSD: Everything's an Inventory object, no need to separate
		{
		  /*if (DeusExPickup(dragTarget.GetClientObject()) != None)
		  {
		    invX = DeusExPickup(dragTarget.GetClientObject()).invSlotsX;
		    invY = DeusExPickup(dragTarget.GetClientObject()).invSlotsY;
		  }
          else if (DeusExWeapon(dragTarget.GetClientObject()) != None)
          {
            invX = DeusExWeapon(dragTarget.GetClientObject()).invSlotsX;
		    invY = DeusExWeapon(dragTarget.GetClientObject()).invSlotsY;
          }*/
          if (Inventory(dragTarget.GetClientObject()) != None)                  //RSD: Everything's an Inventory object, no need to separate
          {
            invX = Inventory(dragTarget.GetClientObject()).invSlotsX;
            invY = Inventory(dragTarget.GetClientObject()).invSlotsY;
          }
          if (invX == dragInv.invSlotsX && invY == dragInv.invSlotsY)
          {
              /*if (DeusExPickup(dragTarget.GetClientObject()) != None)
              {
                     posY = DeusExPickup(dragTarget.GetClientObject()).invPosY;
                     posX = DeusExPickup(dragTarget.GetClientObject()).invPosX;
                     DeusExPickup(dragTarget.GetClientObject()).invPosY = dragInv.invPosY;
                     DeusExPickup(dragTarget.GetClientObject()).invPosX = dragInv.invPosX;
              }
              else if (DeusExWeapon(dragTarget.GetClientObject()) != None)
              {
                     posY = DeusExWeapon(dragTarget.GetClientObject()).invPosY;
                     posX = DeusExWeapon(dragTarget.GetClientObject()).invPosX;
                     DeusExWeapon(dragTarget.GetClientObject()).invPosY = dragInv.invPosY;
                     DeusExWeapon(dragTarget.GetClientObject()).invPosX = dragInv.invPosX;
              }*/
              if (Inventory(dragTarget.GetClientObject()) != None)              //RSD: Everything's an Inventory object, no need to separate
              {
                     posY = Inventory(dragTarget.GetClientObject()).invPosY;
                     posX = Inventory(dragTarget.GetClientObject()).invPosX;
                     Inventory(dragTarget.GetClientObject()).invPosY = dragInv.invPosY;
                     Inventory(dragTarget.GetClientObject()).invPosX = dragInv.invPosX;
              }
              dragInv.invPosX = posX;
              dragInv.invPosY = posY;
              swapButtonRotations(PersonaInventoryItemButton(dragButton),dragTarget); //RSD: We might be swapping two objects with different starting orientations
              ReturnButton(PersonaInventoryItemButton(dragButton));
              ReturnButton(dragTarget);
              SignalRefresh();
	      }
		}
		//CyberP: end
		//else                                                                  //RSD: Removed to make sure a failed swap still performs these actions, avoiding the inventory overlap exploit
		//{
		if (dragButton != none)                                                 //RSD: Added check to avoid a bunch of accessed nones
		{
			if (dragTarget != none && dragTarget == dragButton)                 //RSD: Added dragTarget != none to avoid a bunch of accessed nones
			{
				if (PersonaInventoryItemButton(dragButton).dragPosX != -1 && PersonaInventoryItemButton(dragButton).dragPosX != -1) //RSD: Need special check so we don't get borked slot placement for rotated items
            		MoveItemButton(PersonaInventoryItemButton(dragButton), PersonaInventoryItemButton(dragButton).dragPosX, PersonaInventoryItemButton(dragButton).dragPosY );
  		        else
  		        	ReturnButton(PersonaInventoryItemButton(dragButton));
			}
			else if ( HUDObjectSlot(lastDragOverButton) != None )
			{
				beltSlot = HUDObjectSlot(lastDragOverButton).objectNum;

				// Don't allow to be moved over NanoKeyRing
                //SARGE: Change this to work if the nanokey slot is draggable
				if (HUDObjectSlot(lastDragOverButton).bAllowDragging)
				{
					invBelt.AddObject(dragInv, beltSlot);
				}

				// Restore item to original slot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
			else if (lastDragOverButton != dragButton)
			{
				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
        }
		//}
	}
	else		// 'ObjectSlot'
	{
		// Check to see if this is a valid drop location (which are only
		// other object slots).
		//
		// Swap the two items and select the one that was dragged
		// but make sure the target isn't the NanoKeyRing

		itemSlot = HUDObjectSlot(lastDragOverButton);

		if (itemSlot != None)
		{
			if (((itemSlot.Item != None) && (!itemSlot.Item.IsA('NanoKeyRing'))) || (itemSlot.Item == None))
			{
				invBelt.SwapObjects(HUDObjectSlot(dragButton), itemSlot);
				itemSlot.SetToggle(True);
			}
		}
		else
		{
			// If the player drags the item outside the object belt,
			// then remove it.

			ClearSlotItem(HUDObjectSlot(dragButton).item);
		}
	}

    EndDragMode();
}
/*
// ----------------------------------------------------------------------
// EndDragMode()
// ----------------------------------------------------------------------

function EndDragMode()
{
	// Make sure the last inventory item dragged over isn't still highlighted
	if (lastDragOverButton != None)
	{
		if (lastDragOverButton.IsA('PersonaInventoryItemButton'))
			PersonaInventoryItemButton(lastDragOverButton).ResetFill();
		else
			HUDObjectSlot(lastDragOverButton).ResetFill();

		lastDragOverButton = None;
	}

	bDragging = False;

	// Select the item
	if (dragButton != None)
	{
		if (dragButton.IsA('PersonaInventoryItemButton'))
			SelectInventory(PersonaInventoryItemButton(dragButton));
		else if (dragButton.IsA('ToggleWindow'))
			ToggleWindow(dragButton).SetToggle(True);

		dragButton = None;
	}

    SignalRefresh();
}
*/
// ----------------------------------------------------------------------
// EndDragMode()
// mod by eshkrm implemented for GMDX //CyberP: removed as caused crashes.
// ----------------------------------------------------------------------

/*function EndDragMode()
{
   // Make sure the last inventory item dragged over isn't still highlighted
   if (lastDragOverButton != None)
   {
      if (lastDragOverButton.IsA('PersonaInventoryItemButton'))
         PersonaInventoryItemButton(lastDragOverButton).ResetFill();
      else
         HUDObjectSlot(lastDragOverButton).ResetFill();
   }

   bDragging = False;

   // Select the dragged item...
   if (dragButton != None)
   {
      if (dragButton.IsA('PersonaInventoryItemButton'))
      {
         SelectInventory(PersonaInventoryItemButton(dragButton));

         // ...but drop it if player dragged it outside the inventory window
         if (lastDragOverButton == None)
            DropSelectedItem();
      }
      else if (dragButton.IsA('ToggleWindow'))
      {
         ToggleWindow(dragButton).SetToggle(True);
      }
   }

   dragButton = None;
   lastDragOverButton = None;

   SignalRefresh();
}
*/

function EndDragMode()
{
	// Make sure the last inventory item dragged over isn't still highlighted
	if (lastDragOverButton != None)
	{
		if (lastDragOverButton.IsA('PersonaInventoryItemButton'))
			PersonaInventoryItemButton(lastDragOverButton).ResetFill();
		else
			HUDObjectSlot(lastDragOverButton).ResetFill();

		lastDragOverButton = None;
	}

	bDragging = False;

	// Select the item
	if (dragButton != None)
	{
		if (dragButton.IsA('PersonaInventoryItemButton'))
			SelectInventory(PersonaInventoryItemButton(dragButton));
		else if (dragButton.IsA('ToggleWindow'))
			ToggleWindow(dragButton).SetToggle(True);

		dragButton = None;
	}

    SignalRefresh();
}
// ----------------------------------------------------------------------
// MoveItemButton()
// ----------------------------------------------------------------------

function MoveItemButton(PersonaInventoryItemButton anItemButton, int col, int row)
{
	//player.SetInvSlots(Inventory(anItemButton.GetClientObject()), 0);         //RSD: Removed because redundant with StartButtonDrag(), and causes overlap exploit with rotated items
	player.PlaceItemInSlot(Inventory(anItemButton.GetClientObject()), col, row );
	SetItemButtonPos(anItemButton, col, row);

	if (Inventory(anItemButton.GetClientObject()).IsA('ChargedPickup') && !ChargedPickup(Inventory(anItemButton.GetClientObject())).bActivatable)
        anItemButton.bDimIcon = true;                                           //RSD: Dim ChargedPickups if they're at 0%

    resetHomeButton();                                                          //RSD: item rotation
    //Set it to refresh again
    SignalRefresh();
}

// ----------------------------------------------------------------------
// ReturnButton()
// ----------------------------------------------------------------------

function ReturnButton(PersonaInventoryItemButton anItemButton)
{
	local Inventory inv;

	inv = Inventory(anItemButton.GetClientObject());

    anItemButton.ResetRotation();                                               //RSD: item rotation
    resetHomeButton();                                                          //RSD: item rotation

	player.PlaceItemInSlot(inv, inv.invPosX, inv.invPosY);
	SetItemButtonPos(anItemButton, inv.invPosX, inv.invPosY);

    if (inv.IsA('ChargedPickup') && !ChargedPickup(inv).bActivatable)
    {
        anItemButton.bDimIcon = true;                                           //RSD: Dim ChargedPickups if they're at 0%
    }
    else
        anItemButton.bDimIcon = false;
}

// ----------------------------------------------------------------------
// HighlightSpecial()
// ----------------------------------------------------------------------

function HighlightSpecial(Inventory item)
{
	if (item != None)
	{
		if (item.IsA('WeaponMod'))
			HighlightModWeapons(WeaponMod(item));
		else if (item.IsA('BioelectricCell'))
            HighlightCellCharged(BioelectricCell(item));
		else if (item.IsA('DeusExAmmo'))
			HighlightAmmoWeapons(DeusExAmmo(item));
	}
}

function HighlightCellCharged(BioelectricCell biocell)
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			anItem = Inventory(itemButton.GetClientObject());
			if ((anItem != None) && (anItem.IsA('ChargedPickup')))
			{
				if ((biocell != None) && (ChargedPickup(anItem).Charge < ChargedPickup(anItem).default.Charge))
				{
					itemButton.HighlightWeapon(True);
				}
			}
			else
			{
				itemButton.ResetFill();
			}
		}
		itemWindow = itemWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// HighlightModWeapons()
//
// Highlights/Unhighlights any weapons that can be upgraded with the
// weapon mod passed in
// ----------------------------------------------------------------------

function HighlightModWeapons(WeaponMod weaponMod)
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			anItem = Inventory(itemButton.GetClientObject());
			if ((anItem != None) && (anItem.IsA('DeusExWeapon')))
			{
				if ((weaponMod != None) && (weaponMod.CanUpgradeWeapon(DeusExWeapon(anItem))))
				{
					itemButton.HighlightWeapon(True);
				}
			}
			else
			{
				itemButton.ResetFill();
			}
		}
		itemWindow = itemWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// HighlightAmmoWeapons()
//
// Highlights/Unhighlights any weapons that can be used with the
// selected ammo
// ----------------------------------------------------------------------

function HighlightAmmoWeapons(DeusExAmmo ammo)
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			anItem = Inventory(itemButton.GetClientObject());
			if ((anItem != None) && (anItem.IsA('DeusExWeapon')))
			{
				if ((ammo != None) && (DeusExWeapon(anItem).CanLoadAmmoType(ammo)))
				{
					itemButton.HighlightWeapon(True);
				}
			}
			else
			{
				itemButton.ResetFill();
			}
		}
		itemWindow = itemWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// ClearSpecialHighlights()
// ----------------------------------------------------------------------

function ClearSpecialHighlights()
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			itemButton.ResetFill();
		}

		itemWindow = itemWindow.GetLowerSibling();
	}
}

function WeaponUpdateInfo(DeusExWeapon weaponFrom)                              //RSD: Called by weaponFrom to force an update
{
     local DeusExWeapon aWeapon;

     aWeapon = DeusExWeapon(selectedItem.GetClientObject());

     if (aWeapon != none && aWeapon == weaponFrom)
     {
        // Send status message and update info window
        winStatus.AddText(Sprintf(AmmoLoadedLabel, aWeapon.ammoType.itemName));
		aWeapon.UpdateInfo(winInfo);
		//winInfo.SetLoaded(aWeapon.AmmoName);

		// Update the object belt
		invBelt.UpdateBeltText(aWeapon);
     }
}

function RotateItemButton()
{
	local bool bRotated;
    local Inventory inv;
    local float newX, newY, newInvX, newInvY;

    if (bDragging && dragButton!= none && dragButton.IsA('PersonaInventoryItemButton'))
   		if (dragButton.GetClientObject().IsA('DeusExWeapon'))                   //RSD: ONLY try DeusExWeapon since they're the large ones AND we need to hack extra traveling vars
    		bRotated = PersonaInventoryItemButton(dragButton).RotateButton();

    if (bRotated)
    {
    	lastDragOverButton = none;
    	SetItemButtonPos(PersonaInventoryItemButton(dragButton), -1,-1);

		GetCursorPos(newX,newY);
		ConvertCoordinates(dragButton, newX, newY, self, newInvX, newInvY);
		UpdateDragMouse(newInvX, newInvY);
   	}
}

function swapButtonRotations(PersonaInventoryItemButton dragSource, PersonaInventoryItemButton dragTarget) //RSD: For swapping items with different starting rotations. Some DANGEROUS conditionals here
{
    local Inventory invSource, invTarget;
    local int invX, invY;

    invSource = Inventory(dragSource.GetClientObject());
    invTarget = Inventory(dragTarget.GetClientObject());

    if (!(invSource.IsA('DeusExWeapon') && invTarget.IsA('DeusExWeapon'))       //RSD: Don't even try unless we're a DeusExWeapon
        || invSource.invSlotsX == invSource.invSlotsY || invTarget.invSlotsX == invTarget.invSlotsY) //RSD: ...or if the sizes are the same
    {
        dragTarget.setSafeRotation();                                           //RSD: Make sure we have starting values we can use
        return;
    }

    //RSD: Recall safeInvX is what actually gets used in ReturnButton() now
    invX = invTarget.invSlotsX;
    invY = invTarget.invSlotsY;
    dragTarget.safeInvX = dragSource.safeInvX;
    dragTarget.safeInvY = dragSource.safeInvY;
    dragSource.safeInvX = invX;
    dragSource.safeInvY = invY;
    //RSD: Source is already set in RotateButton(), only need to set target icon
    if ((dragTarget.safeInvX == invTarget.default.invSlotsX))                   //RSD: ECHHH
	{
        dragTarget.safeIconWidth = invTarget.default.largeIconWidth;
        dragTarget.safeIconHeight = invTarget.default.largeIconHeight;
    }
    else
    {
        dragTarget.safeIconWidth = invTarget.default.largeIconHeight;
        dragTarget.safeIconHeight = invTarget.default.largeIconWidth;
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     invButtonWidth=53
     invButtonHeight=53
     smallInvWidth=40
     smallInvHeight=35
     InventoryTitleText="Inventory"
     EquipButtonLabel="|&Equip"
     UnequipButtonLabel="Un|&equip"
     UseButtonLabel="|&Use"
     DropButtonLabel="|&Drop"
     ChangeAmmoButtonLabel="Change Amm|&o"
     NanoKeyRingInfoText="Click icon to see a list of Nano Keys."
     NanoKeyRingLabel="Keys: %s"
     DroppedLabel="%s dropped"
     AmmoLoadedLabel="%s loaded"
     WeaponUpgradedLabel="%s upgraded"
     CannotBeDroppedLabel="%s cannot be dropped here"
     AmmoInfoText="Click icon to see a list of Ammo."
     AmmoTitleLabel="Ammunition"
     NoAmmoLabel="No Ammo Available"
     DeclinedTitleLabel="Declined Items"
     DeclinedDesc="Declined Items will not be picked up from corpses."
     refreshInterval=0.200000
     clientBorderOffsetY=33
     ClientWidth=585
     ClientHeight=361
     clientOffsetX=33
     clientOffsetY=10
     clientTextures(0)=Texture'DeusExUI.UserInterface.InventoryBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.InventoryBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.InventoryBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.InventoryBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.InventoryBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.InventoryBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.InventoryBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.InventoryBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.InventoryBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.InventoryBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.InventoryBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.InventoryBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
