//=============================================================================
// HUDActiveAug
//=============================================================================

class HUDActiveAug extends HUDActiveItemBase;

var Color colBlack;

var int    hotKeyNum;
var String hotKeyString;

var bool bHasChargeBar;

// ----------------------------------------------------------------------
// DrawHotKey()
// ----------------------------------------------------------------------

function DrawHotKey(GC gc)
{
	gc.SetAlignments(HALIGN_Right, VALIGN_Top);
	gc.SetFont(player.FontManager.GetFont(TT_AugHotKey));  //'FontTiny' //CyberP: for hud scaling

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
        bHasChargeBar = Augmentation(newClientObject).bHasChargeBar;

        if (bHasChargeBar)
            CreateEnergyBar();
        bTickEnabled = bHasChargeBar;
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
        colItemIcon = aug.GetAugColor(true);
}

// ----------------------------------------------------------------------
// Tick()
//
// Used to update the energy bar
// SARGE: Copied from HudActiveItem
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
    local Augmentation aug;
    aug = Augmentation(GetClientObject());

	if (aug != None && bHasChargeBar)
    {
        if (aug.IsCharging())
            winEnergy.SetCurrentValue(((aug.chargeTime - aug.currentChargeTime) / aug.chargeTime) * 100);
        else
            winEnergy.SetCurrentValue(0);
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colItemIcon=(B=0)
}
