//=============================================================================
// HUDObjectBelt
//=============================================================================
class HUDObjectBelt expands HUDBaseWindow;

var TileWindow winSlots;				// Window containing slots
var HUDObjectSlot objects[12];

var int	KeyRingSlot;
var Bool bInteractive;

// Defaults
var Texture texBackgroundLeft;
var Texture texBackgroundRight;
var Texture texBorder[3];

//SARGE: Allow up to 12 slots now
var int numSlots;
var int extraSize;
var Texture texBorderBig;
	
var RadioBoxWindow winRadio;                //SARGE: Made global so we can delete and recreate it

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
    RecreateBelt();
}

function RecreateBelt()
{
    if (player.bBiggerBelt)
    {
        keyringSlot = 11;
        extraSize = 100;
        numSlots = 12;
    }
    else
    {
        keyringSlot = 9;
        extraSize = 0;
        numSlots = 10;
    }
	
    CreateSlots();
    
    ConfigureSlots();

	CreateNanoKeySlot();

	PopulateBelt();
}

// Set belt mode
// Used for having different text on the inventory belt vs the HUD belt

function SetInventoryBelt(bool option)
{
    local int i;
	for (i=0; i<numSlots; i++)
        objects[i].bInventorySlot = option;
}

// ----------------------------------------------------------------------
// CreateSlots()
//
// Creates the Slots
// ----------------------------------------------------------------------

function CreateSlots()
{
	local int i;

    if (winRadio != None || winSlots != None)
        return;

	// Radio window used to contain objects so they can be selected
	// with the mouse on the inventory screen.

	winRadio = RadioBoxWindow(NewChild(Class'RadioBoxWindow'));
	winRadio.bOneCheck = False;

	winSlots = TileWindow(winRadio.NewChild(Class'TileWindow'));
	winSlots.SetMargins(0, 0);
	winSlots.SetMinorSpacing(0);
	winSlots.SetOrder(ORDER_LeftThenUp);

	for (i=0; i<12; i++)
	{
		objects[i] = HUDObjectSlot(winSlots.NewChild(Class'HUDObjectSlot'));
		objects[i].SetObjectNumber(i);
        //Some annoying logic here
        if (i < 9)
            objects[i].beltText = string(i + 1);
        else if (i == 9)
            objects[i].beltText = "0";
        else if (i == 10)
            objects[i].beltText = "-";
        else
            objects[i].beltText = "=";
		objects[i].Lower();

	}
}

function ConfigureSlots()
{

	// Hardcoded size, baby!
    SetSize(541+extraSize, 69);
    
    winRadio.SetSize(504+extraSize+extraSize, 54);
    winRadio.SetPos(10-extraSize, 6);

    //SARGE: DIRTY HACK!
    if (player.bBiggerBelt)
    {
        // Last item is a little shorter
        objects[9].SetWidth(50);
        objects[11].SetWidth(44);
        objects[10].Show();
        objects[11].Show();
    }
    else
    {
        // Last item is a little shorter
        objects[11].SetWidth(50);
        objects[9].SetWidth(44);
        //hide the extras
        objects[10].Hide();
        objects[11].Hide();
    }

}

// ----------------------------------------------------------------------
// CreateNanoKeySlot()
//
// The last object slot contains the NanoKeyRing, which lets the user
// easily open doors for which they have the code (Know the code!)
// SARGE: Complete overhaul. Instead of simply assigning the keyring, now we only assign it
// if we have smart keyring disabled, and remove it otherwise
// ----------------------------------------------------------------------

function CreateNanoKeySlot()
{
		if (player != None && player.KeyRing != None && objects[KeyRingSlot] != None)
		{
            if (!player.bSmartKeyring)
            {
                if (objects[KeyRingSlot].item != None)
                    RemoveObjectFromBelt(objects[KeyRingSlot].item);
    			objects[KeyRingSlot].SetItem(player.KeyRing);
            }
            else if (objects[KeyRingSlot].item != None && objects[KeyRingSlot].item.IsA('NanoKeyRing'))
            {
                RemoveObjectFromBelt(objects[KeyRingSlot].item);
            }
			objects[KeyRingSlot].AllowDragging(player.bSmartKeyring);
		}
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	local Color newBackground;

	gc.SetStyle(backgroundDrawStyle);

	if (( player != None ) && (player.Level.NetMode != NM_Standalone) && ( player.bBuySkills ))
	{
		newBackground.r = colBackground.r / 2;
		newBackground.g = colBackground.g / 2;
		newBackground.b = colBackground.b / 2;
		gc.SetTileColor(newBackground);
	}
	else
		gc.SetTileColor(colBackground);


    //SARGE: No idea why this needs adjusting...
    if (player.bBiggerBelt)
        gc.DrawTexture(  2, 6, 8, 54, 0, 0, texBackgroundLeft);
    else
        gc.DrawTexture(  2, 6, 9, 54, 0, 0, texBackgroundLeft);

    gc.DrawTexture(514+extraSize, 6, 8, 54, 0, 0, texBackgroundRight);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	local Color newCol;

	if (bDrawBorder)
	{
		gc.SetStyle(borderDrawStyle);
		if (( player != None ) && ( player.bBuySkills ))
		{
			newCol.r = colBorder.r / 2;
			newCol.g = colBorder.g / 2;
			newCol.b = colBorder.b / 2;
			gc.SetTileColor(newCol);
		}
		else
			gc.SetTileColor(colBorder);

		gc.DrawTexture(  0, 0, 256, 69, 0, 0, texBorder[0]);
        if (player.bBiggerBelt)
        {
            gc.DrawTexture(256, 0, 512, 69, 0, 0, texBorderBig);
            gc.DrawTexture(612, 0,  29, 69, 0, 0, texBorder[2]);
        }
        else
        {
            gc.DrawTexture(256, 0, 256, 69, 0, 0, texBorder[1]);
            gc.DrawTexture(512, 0,  29, 69, 0, 0, texBorder[2]);
        }
	}
}

// ----------------------------------------------------------------------
// UpdateInHand()
//
// Called when the player's "inHand" variable changes
// ----------------------------------------------------------------------

function UpdateInHand()
{
	local int slotIndex;
	
    //SARGE: Update Keyring Slot. This is now required due to smart keyring
    CreateNanoKeySlot();

	// highlight the slot and unhighlight the other slots
	if ((player != None) && (!bInteractive))
	{
		if (player.bAlternateToolbelt > 0)
		{
			RefreshAlternateToolbelt();
			return;
		}
	
		for (slotIndex=0; slotIndex<ArrayCount(objects); slotIndex++)
		{
            if (objects[slotIndex].item != None)
            {
                // Grey Backpack for last equipped object in the player's hand
                objects[slotIndex].HighlightSelect(objects[slotIndex].item == player.primaryWeapon);

                if ((player.inHandPending != None) && //(player.inHandPending != player.inHand) &&
                    (objects[slotIndex].item == player.inHandPending))
                    objects[slotIndex].SetToggle(true);
                else
                    objects[slotIndex].SetToggle(false);
            }
		}
	}
}


//Refresh the Toolbelt, needed after a load game
//Since we normally only set the highlights
//Also, allows the grey and white highlights to work independently.
function RefreshAlternateToolbelt()
{
	local int slotIndex;
    local bool placeholderSlot;

	if ((player != None) && (!bInteractive))
	{
		for (slotIndex=0; slotIndex<ArrayCount(objects); slotIndex++)
		{
            placeholderSlot = player.GetPlaceholder(slotIndex);

			//Grey background follows
			objects[slotIndex].HighlightSelect(slotIndex == player.advBelt && !placeholderSlot && objects[slotIndex].item != None);
			
			//White outline stays with our selcted weapon
			if (player.inHandPending != None)
				objects[slotIndex].SetToggle(slotIndex == player.inHandPending.beltPos);
			else
				objects[slotIndex].SetToggle(false);
		}
	}
}

// ----------------------------------------------------------------------
// SetInteractive()
// ----------------------------------------------------------------------

function SetInteractive(bool bNewInteractive)
{
	bInteractive = bNewInteractive;
}

// ----------------------------------------------------------------------
// IsValidPos()
// ----------------------------------------------------------------------

function bool IsValidPos(int pos)
{
	// Don't allow NanoKeySlot to be used
	if ((pos >= 0) && (pos < numSlots))
		return true;
	else
		return false;
}

// ----------------------------------------------------------------------
// ClearPosition()
// ----------------------------------------------------------------------

function ClearPosition(int pos)
{
	if (IsValidPos(pos))
		objects[pos].SetItem(None);
}

// ----------------------------------------------------------------------
// ClearBelt()
//
// Removes all items from belt
// ----------------------------------------------------------------------

function ClearBelt()
{
	local int beltPos;

	for(beltPos=0; beltPos<numSlots; beltPos++)
    {
        if (player.bBeltMemory && objects[beltPos].bAllowDragging)
            player.SetPlaceholder(beltPos,objects[beltPos].item.icon);
		ClearPosition(beltPos);
    }
}

// ----------------------------------------------------------------------
// RemoveObjectFromBelt()
// Sarge: Added optional parameter to make the slot be a placeholder
// ----------------------------------------------------------------------

function RemoveObjectFromBelt(Inventory item, optional bool Placeholder)
{
	local int i;

    //Sarge: Previously, there was a StartPos variable, which would be 0 for MP and 1 for SP.
    //This was designed to skip the nano key slot.
    //Now that we have smart keyring, we can get rid of the check entirely, and instead
    //only allow a position to be valid if the object in it is draggable.
	for (i=0; IsValidPos(i); i++)
	{
		if (objects[i].GetItem() == item && objects[i].bAllowDragging)
		{
            if (placeholder)
                player.SetPlaceholder(i,objects[i].item.icon);

			objects[i].SetItem(None);
			item.bInObjectBelt = False;
			item.beltPos = -1;

			break;
		}
	}
}

// ----------------------------------------------------------------------
// UpdateObjectText()
// ----------------------------------------------------------------------

function UpdateObjectText(int pos)
{
	// First find the object
	if (IsValidPos(pos))
		objects[pos].UpdateItemText();
}

// ----------------------------------------------------------------------
// AddObjectToBelt()
// ----------------------------------------------------------------------

function bool AddObjectToBelt(Inventory newItem, int pos, bool bOverride)
{
	local int  i;
    local bool FoundPlaceholder;
	local bool retval;

	retval = true;

	if ((newItem != None ) && (newItem.Icon != None))
	{
		// If this is the NanoKeyRing, force it into slot 0 //SARGE: Or slot 11
		if (newItem.IsA('NanoKeyRing') && !player.bSmartKeyring)
		{
			ClearPosition(KeyRingSlot);
			pos = KeyRingSlot;
		}
        //SARGE: Don't put it on the belt at all if we have smart keyring on
        else if (newItem.IsA('NanoKeyRing'))
            return true;

		if (  (!IsValidPos(pos)) ||
            (  (Player.Level.NetMode != NM_Standalone) &&
               (Player.bBeltIsMPInventory) &&
               (!newItem.TestMPBeltSpot(pos)) ) )
		{
            //Sarge: Previously, there was a FirstPos variable, which would be 0 for MP and 1 for SP.
            //This was designed to skip the nano key slot.
            //Now that we have smart keyring, we can get rid of the check entirely, and instead
            //only allow a position to be valid if the object in it is draggable.
            //Sarge: First, check for an existing placeholder slot
            //Then, if we don't find one, check for an empty slot if we have autofill enabled.
                if (Player.Level.NetMode == NM_Standalone)
                {
                    for (i=0; IsValidPos(i); i++)
                    {
                        //Additionally, allow slots with the same icon if we have a placeholder
                        if (player.GetPlaceholderIcon(i) == newItem.default.icon)
                        {
                            if (player.bBeltMemory)
                            {
                                FoundPlaceholder = true;
                                break;
                            }
                            else
                                player.ClearPlaceholder(i); //Since we're not using placeholders, clear any that exist so we don't get belt weirdness.
                        }
                    }
                }
			
            //No placeholder slot found, check for an empty one
            if (!FoundPlaceholder && (player.bBeltAutofill || player.bForceBeltAutofill))
            {
                for (i=0; IsValidPos(i) && i < numSlots; i++)
                {
                    if (( (Player.Level.NetMode == NM_Standalone) || (!Player.bBeltIsMPInventory) || (newItem.TestMPBeltSpot(i))))
                    {
                        //First, always allow empty slots if we have autofill turned on
                        if (objects[i].GetItem() == None && (!player.GetPlaceholder(i) || !player.bBeltMemory) && objects[i].bAllowDragging)
                            break;
                    }
                }
            }

            //Now check if we found a valid slot
            if (!IsValidPos(i))
			{
				if (bOverride)
					pos = i;
			}
			else
				pos = i;
		}

		if (IsValidPos(pos))
		{
			// If there's already an object here, remove it
			if ( objects[pos].GetItem() != None )
				RemoveObjectFromBelt(objects[pos].GetItem());

			objects[pos].SetItem(newItem);

			if (newItem.IsA('ChargedPickup') && !ChargedPickup(newItem).bActivatable)
			{
				objects[pos].bDimIcon = true;                                   //RSD: Dim ChargedPickups if they're at 0%
			}
			else if (newItem.IsA('WeaponNanoSword') && WeaponNanoSword(newItem).chargeManager != None && WeaponNanoSword(newItem).chargeManager.IsUsedUp())
				objects[pos].bDimIcon = true;                                   //SARGE: Dim NanoSword at 0%
			else
				objects[pos].bDimIcon = false;
		}
		else
		{
			retval = false;
		}
	}
	else
		retval = false;

	// The inventory item needs to know it's in the object
	// belt, as well as the location inside the belt.  This is used
	// when traveling to a new map.

	if ((retVal) && (Player.Role == ROLE_Authority))
	{
		newItem.bInObjectBelt = True;
		newItem.beltPos = pos;
	}

	UpdateInHand();

	return (retval);
}

// ----------------------------------------------------------------------
// GetObjectFromBelt()
// ----------------------------------------------------------------------

function Inventory GetObjectFromBelt(int pos)
{
	if (IsValidPos(pos))
		return (objects[pos].GetItem());
	else
		return (None);
}

// ----------------------------------------------------------------------
// SetVisibility()
// ----------------------------------------------------------------------

function SetVisibility( bool bNewVisibility )
{
	Show( bNewVisibility );
}

// ----------------------------------------------------------------------
// PopulateBelt()
//
// Looks through the player's inventory and rebuilds the object belt
// based on the inventory items.  This needs to be done after a load
// game
// ----------------------------------------------------------------------

function PopulateBelt()
{
	local Inventory anItem;
	local HUDObjectBelt belt;
	local DeusExPlayer player;

	// Get a pointer to the player
	player = DeusExPlayer(DeusExRootWindow(GetRootWindow()).parentPawn);

	for (anItem=player.Inventory; anItem!=None; anItem=anItem.Inventory)
		if (anItem.bInObjectBelt)
      {
			AddObjectToBelt(anItem, anItem.beltPos, True);
      }
	 
	//Set the highlight
}

// ----------------------------------------------------------------------
// RefreshHUDDisplay()
// ----------------------------------------------------------------------

function RefreshHUDDisplay(float DeltaTime)
{
    ClearBelt();
    PopulateBelt();
    UpdateInHand();
    Super.RefreshHUDDisplay(DeltaTime);
}

// ----------------------------------------------------------------------
// AssignWinInv()
// ----------------------------------------------------------------------

function AssignWinInv(PersonaScreenInventory newWinInventory)
{
	local Int slotIndex;

	// Update the individual slots
	for (slotIndex=0; slotIndex<numSlots; slotIndex++)
		objects[slotIndex].AssignWinInv(newWinInventory);

	UpdateInHand();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBackgroundLeft=Texture'DeusExUI.UserInterface.HUDObjectBeltBackground_Left'
     texBackgroundRight=Texture'DeusExUI.UserInterface.HUDObjectBeltBackground_Right'
     texBorder(0)=Texture'DeusExUI.UserInterface.HUDObjectBeltBorder_1'
     texBorder(1)=Texture'DeusExUI.UserInterface.HUDObjectBeltBorder_2'
     texBorder(2)=Texture'DeusExUI.UserInterface.HUDObjectBeltBorder_3'
     texBorderBig=Texture'RSDCrap.UserInterface.HUDObjectBeltBorder_2_big'
}
