//=============================================================================
// PersonaInventoryInfoWindow
//=============================================================================

class PersonaInventoryInfoWindow extends PersonaInfoWindow;

var TileWindow winTileAmmo;
var localized String AmmoLabel;
var localized String AmmoRoundsLabel;
var localized String ShowAmmoDescriptionsLabel;

var PersonaAmmoDetailButton      selectedAmmoButton;
var PersonaInfoItemWindow        lastAmmoLoaded;
var PersonaInfoItemWindow	     lastAmmoTypes;
var PersonaNormalLargeTextWindow lastAmmoDescription;
var PersonaLevelIconWindow       winIcons;
var PersonaActionButtonWindow    buttonUpgrade;
var PersonaButtonBarWindow       winActionButtons;
var Inventory                    assignThis;
var localized string msgAssign;
var localized string msgConf;
var localized string msgAssigned;
var localized string msgUnassigned;
/*function CreateWin()
{
local AlignWindow winIco;

	winIcons = PersonaLevelIconWindow(NewChild(Class'PersonaLevelIconWindow'));
	winIcons.SetPos(30, 54);
	winIcons.SetLevel(4);
	winIcons.iconSizeX=4;
	winIcons.iconSizeY=5;
	//winIcon.SetSelected(True);
} */
// ----------------------------------------------------------------------
// AddAmmoInfoWindow()
// ----------------------------------------------------------------------

function AddAmmoInfoWindow(DeusExAmmo ammo, bool bShowDescriptions)
{
	local AlignWindow winAmmo;
	local PersonaNormalTextWindow winText;
	local Window winIcon;
    local string outOf;

	if (ammo != None)
	{
	    outOf = "/";
		winAmmo = AlignWindow(winTile.NewChild(Class'AlignWindow'));
		winAmmo.SetChildVAlignment(VALIGN_Top);
		winAmmo.SetChildSpacing(4);

		// Add icon
		winIcon = winAmmo.NewChild(Class'Window');
		winIcon.SetBackground(ammo.Icon);
		winIcon.SetBackgroundStyle(DSTY_Masked);
		winIcon.SetSize(42, 37);

		// Add description
		winText = PersonaNormalTextWindow(winAmmo.NewChild(Class'PersonaNormalTextWindow'));
		winText.SetWordWrap(True);
		winText.SetTextMargins(0, 0);
		winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);

		if (bShowDescriptions)
		{
			winText.SetText(ammo.itemName @ "(" $ AmmoRoundsLabel @ ammo.AmmoAmount $ outOf $ player.GetAdjustedMaxAmmo(ammo) $ ")|n|n"); //RSD: Replaced ammo.MaxAmmo with adjusted
			winText.AppendText(ammo.description);
		}
		else
		{
			winText.SetText(ammo.itemName $ "|n|n" $ AmmoRoundsLabel @ ammo.AmmoAmount);
		}
	}

	AddLine();
}

// ----------------------------------------------------------------------
// AddAmmoCheckbox()
// ----------------------------------------------------------------------

function AddAmmoCheckbox(bool bChecked)
{
	local PersonaCheckboxWindow winCheck;

	winCheck = PersonaCheckboxWindow(winTile.NewChild(Class'PersonaCheckboxWindow'));
	winCheck.SetFont(Font'FontMenuSmall');
	winCheck.SetText(ShowAmmoDescriptionsLabel);
	winCheck.SetToggle(bChecked);
}

// ----------------------------------------------------------------------
// CreateAmmoTileWindow()
// ----------------------------------------------------------------------

function CreateAmmoTileWindow()
{
	local PersonaNormalTextWindow winText;

	if (winTileAmmo == None)
	{
		winTileAmmo = TileWindow(winTile.NewChild(Class'TileWindow'));
		//winTileAmmo.SetOrder(ORDER_Right); //Right
		winTileAmmo.SetChildAlignments(HALIGN_Left, VALIGN_Full);
		winTileAmmo.SetWindowAlignments(HALIGN_Full, VALIGN_Top);
		winTileAmmo.MakeWidthsEqual(False); //False
		winTileAmmo.MakeHeightsEqual(True);
		winTileAmmo.SetMargins(0, 0);
		winTileAmmo.SetMinorSpacing(1);  //4

		winText = PersonaNormalTextWindow(winTileAmmo.NewChild(Class'PersonaNormalTextWindow'));
		winText.SetWidth(36); //70
		winText.SetTextMargins(0, 6);
		winText.SetTextAlignments(HALIGN_Right, VALIGN_Center);
		winText.SetText(AmmoLabel);
	}
}

// ----------------------------------------------------------------------
// AddAmmo()
// ----------------------------------------------------------------------

function AddAmmo(Class<Ammo> ammo, bool bHasIt, optional int newRounds)
{
	local PersonaAmmoDetailButton ammoButton;

	if (winTileAmmo == None)
		CreateAmmoTileWindow();

	ammoButton = PersonaAmmoDetailButton(winTileAmmo.NewChild(Class'PersonaAmmoDetailButton'));
	ammoButton.SetAmmo(ammo, bHasIt, newRounds);
}

// ----------------------------------------------------------------------
// AddAmmoLoadedItem()
// ----------------------------------------------------------------------

function AddAmmoLoadedItem(String newLabel, String newText)
{
	lastAmmoLoaded = AddInfoItem(newLabel, newText);
}

// ----------------------------------------------------------------------
// UpdateAmmoLoaded()
// ----------------------------------------------------------------------

function UpdateAmmoLoaded(String newText)
{
	if (lastAmmoLoaded != None)
		lastAmmoLoaded.SetItemText(newText);
}

// ----------------------------------------------------------------------
// AddAmmoTypesItem()
// ----------------------------------------------------------------------

function AddAmmoTypesItem(String newLabel, String newText)
{
	lastAmmoTypes = AddInfoItem(newLabel, newText);
}

// ----------------------------------------------------------------------
// UpdateAmmoTypes()
// ----------------------------------------------------------------------

function UpdateAmmoTypes(String newText)
{
	if (lastAmmoTypes != None)
		lastAmmoTypes.SetItemText(newText);
}

// ----------------------------------------------------------------------
// AddAmmoDescription()
// ----------------------------------------------------------------------

function AddAmmoDescription(String newDesc)
{
	lastAmmoDescription = SetText(newDesc);
}

// ----------------------------------------------------------------------
// UpdateAmmoDescription()
// ----------------------------------------------------------------------

function UpdateAmmoDescription(String newDesc)
{
	if (lastAmmoDescription != None)
		lastAmmoDescription.SetText(newDesc);
}

// ----------------------------------------------------------------------
// GetSelectedAmmo()
// ----------------------------------------------------------------------

function Class<Ammo> GetSelectedAmmo()
{
	local Window currentWindow;

	if (selectedAmmoButton != None)
	{
		return selectedAmmoButton.GetAmmo();
	}
	else
	{
		currentWindow = winTileAmmo.GetTopChild();
		while(currentWindow != None)
		{
			if (PersonaAmmoDetailButton(currentWindow) != None)
			{
				if (PersonaAmmoDetailButton(currentWindow).IsLoaded())
				{
					return PersonaAmmoDetailButton(currentWindow).GetAmmo();
					break;
				}
			}
			currentWindow = currentWindow.GetLowerSibling();
		}
	}

	return None;
}

// ----------------------------------------------------------------------
// SetLoaded()
//
// Loops through all the ammo, setting the background color to green if
// the ammo is loaded, otherwise black.
// ----------------------------------------------------------------------

function SetLoaded(Class<Ammo> ammo, optional bool bNoSelectSound)              //RSD: Added bNoSelectSound
{
	local Window currentWindow;

	currentWindow = winTileAmmo.GetTopChild();
	while(currentWindow != None)
	{
		if (PersonaAmmoDetailButton(currentWindow) != None)
		{
			if (bNoSelectSound)                                                 //RSD: Hack to stop ammo load buttons from multiply playing selectbutton sounds
				PersonaAmmoDetailButton(currentWindow).bNoSelectSound = true;
			else
			    PersonaAmmoDetailButton(currentWindow).bNoSelectSound = false;
            PersonaAmmoDetailButton(currentWindow).SetLoaded(currentWindow.GetClientObject() == ammo);
			PersonaAmmoDetailButton(currentWindow).SelectButton(currentWindow.GetClientObject() == ammo);

			// Keep track of the selected button
			if (currentWindow.GetClientObject() == ammo)
				selectedAmmoButton = PersonaAmmoDetailButton(currentWindow);
		}
		currentWindow = currentWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// SelectAmmoButton()
// ----------------------------------------------------------------------

function SelectAmmoButton(PersonaAmmoDetailButton selectedButton)
{
	local Window currentWindow;

	currentWindow = winTileAmmo.GetTopChild();
	while(currentWindow != None)
	{
		if (PersonaAmmoDetailButton(currentWindow) != None)
		{
			PersonaAmmoDetailButton(currentWindow).SetLoaded(selectedButton == currentWindow);
			PersonaAmmoDetailButton(currentWindow).SelectButton(selectedButton == currentWindow);
		}
		currentWindow = currentWindow.GetLowerSibling();
	}

	// Keep track of the selected button
	selectedAmmoButton = selectedButton;
}

//function AddSecondaryButton(DeusExWeapon wep)
function AddSecondaryButton(Inventory wep)                                      //RSD: Changed to Inventory for parent class' version
{
   if (wep != None)
   {
    SetText(msgAssign);
    winActionButtons = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetWidth(32); //149
	winActionButtons.FillAllSpace(False);
	buttonUpgrade = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	buttonUpgrade.SetButtonText(msgConf);
	assignThis = wep;
   AddLine();
   }
}

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
    local DeusExBaseWindow TopWin;
    local int i;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	bHandled   = True;

    topWin = DeusExRootWindow(GetRootWindow()).GetTopWindow();

		switch(buttonPressed)
		{
			case buttonUpgrade:

               if (assignThis != None && player.assignedWeapon != None && player.assignedWeapon == assignThis)
               {
                   player.AssignSecondary(none);
                   player.ClientMessage(msgUnassigned);
               }
               else if (assignThis != None)
               {
                   player.AssignSecondary(assignThis);
                   player.ClientMessage(msgAssigned);
               }
			   break;

			default:
				bHandled = False;
				break;
		}
	return bHandled;
}
// ----------------------------------------------------------------------
// Clear()
// ----------------------------------------------------------------------

function Clear()
{
	Super.Clear();
	winTileAmmo = None;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     AmmoLabel="Ammo:"
     AmmoRoundsLabel="Rounds:"
     ShowAmmoDescriptionsLabel="Show Ammo Descriptions"
     msgAssign="Assign as Secondary Item:"
     msgConf="Assign"
     msgAssigned="Secondary Item Assigned"
     msgUnassigned="Secondary Item Unassigned"
}
