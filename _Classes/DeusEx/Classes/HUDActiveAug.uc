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
	gc.DrawText(-16, 1, 47, 40, hotKeyString);

	// Draw Dropshadow
	gc.SetTextColor(colText);
	gc.DrawText(-15, 0, 47, 40, hotKeyString);
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
        bTickEnabled = bHasChargeBar || Augmentation(newClientObject).AugmentationType == AUG_Automatic;
		UpdateAugIconStatus();
	}
}

// ----------------------------------------------------------------------
// SetKeyNum()
// ----------------------------------------------------------------------

function SetKeyNum(int newNumber)
{
	hotKeyNum    = newNumber;

	// Get the function key
    hotKeyString = player.KeybindManager.GetBindingString(KB_Aug0,newNumber-3);
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


    //refresh hotkey
    SetKeyNum(hotKeyNum);
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

    //SARGE: Update the aug icon colour when it's active.
    if (aug != None && aug.displayAsActiveTime + deltaSeconds >= player.saveTime)
        colItemIcon = aug.GetAugColor(true);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colItemIcon=(B=0)
}
