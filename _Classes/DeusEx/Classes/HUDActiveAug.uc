//=============================================================================
// HUDActiveAug
//=============================================================================

class HUDActiveAug extends HUDActiveItemBase;

var Color colBlack;
var Color colAugActive;
var Color colAugInactive;
var Color colAugCharging;

var int    hotKeyNum;
var String hotKeyString;

// ----------------------------------------------------------------------
// DrawHotKey()
// ----------------------------------------------------------------------

function DrawHotKey(GC gc)
{
	gc.SetAlignments(HALIGN_Right, VALIGN_Top);
	gc.SetFont(Font'FontMenuSmall');  //'FontTiny' //CyberP: for hud scaling

	// Draw Dropshadow
	gc.SetTextColor(colBlack);
	gc.DrawText(16, 1, 15, 8, hotKeyString);

	// Draw Dropshadow
	gc.SetTextColor(colText);
	gc.DrawText(17, 0, 15, 8, hotKeyString);
}

// ----------------------------------------------------------------------
// SetObject()
//
// Had to write this because SetClientObject() is FINAL in Extension
// ----------------------------------------------------------------------

function SetObject(object newClientObject)
{
	if (newClientObject.IsA('Augmentation'))
	{
		// Get the function key and set the text
		SetKeyNum(Augmentation(newClientObject).GetHotKey());
		UpdateAugIconStatus();
	}
}

// ----------------------------------------------------------------------
// SetKeyNum()
// ----------------------------------------------------------------------

function SetKeyNum(int newNumber)
{
	// Get the function key and set the text
	hotKeyNum    = newNumber;
	hotKeyString = "F" $ String(hotKeyNum);
}

// ----------------------------------------------------------------------
// UpdateAugIconStatus()
// ----------------------------------------------------------------------

function UpdateAugIconStatus()
{
	local Augmentation aug;

	aug = Augmentation(GetClientObject());

	if (aug != None)
	{
		if (aug.IsActive())
			colItemIcon = colAugActive;
        else if (aug.IsCharging())
			colItemIcon = colAugCharging;
		else
			colItemIcon = colAugInactive;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colAugActive=(B=255)
     colAugInactive=(R=100,G=100,B=100)
     colAugCharging=(R=100,G=0,B=0)
     colItemIcon=(B=0)
}
