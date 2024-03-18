//=============================================================================
// PersonaInventoryItemButton                                                   //RSD: Class for a fake inventory button that we can use for the home space
//=============================================================================
class PersonaInventoryHomeButton extends PersonaItemButton;

var bool bEquipped;						// True if item Equipped

// Drag/Drop Stuff
var bool bDragStart;
var bool bDimIcon;
var bool bAllowDragging;
var bool bDragging;
var bool bValidSlot;
var Int  clickX;
var Int  clickY;
var Int  dragPosX;
var Int  dragPosY;
var Int  invSlotsX;                                                             //RSD: inventory X slots to reset to if we cancel
var Int  invSlotsY;                                                             //RSD: inventory Y slots to reset to if we cancel

var PersonaScreenInventory winInv;		// Pointer back to the window

enum FillModes
{
	FM_WeaponModTrue,
	FM_WeaponModFalse,
	FM_Selected,
	FM_DropGood,
	FM_DropBad,
	FM_DropSwap,
	FM_None
};

var FillModes fillMode;

var Color colDragGood;
var Color colDragBad;
var Color colWeaponModTrue;
var Color colWeaponModFalse;
var Color colDropGood;
var Color colDropBad;
var Color colNone;

// Texture and Color for background
var Color		fillColor;
var Texture		fillTexture;

var localized String CountLabel;
var localized String RoundLabel;
var localized String RoundsLabel;

var Color colDropSwap; //CyberP:
var Color colIconDimmed; //RSD
// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	local Inventory anItem;
	local String str;
	local DeusExWeapon weapon;
	local float strWidth, strHeight;

	//if (( !bDragging ) || ( bDragging && bValidSlot ))
	//{
		// Draw the background
		SetFillColor();
		gc.SetStyle(DSTY_Translucent);
		gc.SetTileColor(fillColor);
		gc.DrawPattern(1, 1, width - 2, height - 2, 0, 0, fillTexture);
	/*}

	if ( !bDragging )
	{
		gc.SetStyle(DSTY_Masked);
		if (bDimIcon)
			gc.SetTileColor(colIconDimmed);                                     //RSD
		else
		gc.SetTileColor(colIcon);

		// Draw icon centered in button
		gc.DrawTexture(((width) / 2)  - (iconPosWidth / 2),
					   ((height) / 2) - (iconPosHeight / 2),
					   iconPosWidth, iconPosHeight,
					   0, 0,
					   icon);
	}

	// Draw selection border width/height of button
	if (bSelected)
	{
		gc.SetTileColor(colSelectionBorder);
		gc.SetStyle(DSTY_Masked);
		gc.DrawBorders(0, 0, width, height, 0, 0, 0, 0, texBorders);
	}*/
}

// ----------------------------------------------------------------------
// SetInventoryWindow()
// ----------------------------------------------------------------------

function SetInventoryWindow(PersonaScreenInventory newWinInv)
{
	winInv = newWinInv;
}

// ----------------------------------------------------------------------
// AllowDragging()
// ----------------------------------------------------------------------

function AllowDragging(bool bNewDragMode)
{
	bAllowDragging = bNewDragMode;
}

// ----------------------------------------------------------------------
// SelectButton()
// ----------------------------------------------------------------------

function SelectButton(Bool bNewSelected)
{
	bSelected = bNewSelected;

	if (bSelected)
		fillMode = FM_Selected;
	else
		fillMode = FM_None;
}

// ----------------------------------------------------------------------
// HighlightWeapon()
// ----------------------------------------------------------------------

function HighlightWeapon(bool bNewToggle)
{
	if (bNewToggle)
		fillMode = FM_WeaponModTrue;
	else
		fillMode = FM_WeaponModFalse;
}

// ----------------------------------------------------------------------
// SetDropFill()
// ----------------------------------------------------------------------

function SetDropFill(bool bGoodDrop, optional bool bBlueOverride)
{
	if (bGoodDrop)
		fillMode = FM_DropGood;
	else
		fillMode = FM_DropBad;
	if (bBlueOverride)
	    fillMode = FM_DropSwap;
}

// ----------------------------------------------------------------------
// ResetFill()
// ----------------------------------------------------------------------

function ResetFill()
{
	fillMode = FM_None;
}

// ----------------------------------------------------------------------
// SetFillColor()
// ----------------------------------------------------------------------

function SetFillColor()
{
	switch(fillMode)
	{
		case FM_WeaponModTrue:
			fillColor = colWeaponModTrue;
			break;
		case FM_WeaponModFalse:
			fillColor = colWeaponModFalse;
			break;
		case FM_Selected:
			fillColor = colFillSelected;
			break;
		case FM_DropBad:
			fillColor = colDropBad;
			break;
		case FM_DropGood:
			fillColor = colDropGood;
			break;
		case FM_DropSwap:
            fillColor = colDropSwap;
            break;
		case FM_None:
			fillColor = colNone;
			break;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bAllowDragging=True
     fillMode=FM_None
     colDragGood=(G=255)
     colDragBad=(R=255)
     colWeaponModTrue=(R=32,G=128,B=32)
     colWeaponModFalse=(R=128,G=32,B=32)
     colDropGood=(R=32,G=128,B=32)
     colDropBad=(R=128,G=32,B=32)
     fillTexture=Texture'Extension.Solid'
     CountLabel="Count: %d"
     RoundLabel="%d Rd"
     RoundsLabel="%d Rds"
     colDropSwap=(R=16,G=32,B=128)
     colIconDimmed=(R=64,G=64,B=64)
}
