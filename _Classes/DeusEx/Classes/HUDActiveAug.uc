//=============================================================================
// HUDActiveAug
//=============================================================================

class HUDActiveAug extends HUDActiveItemBase;

var Color colBlack;

var int    hotKeyNum;
var String hotKeyString;

var transient PersonaLevelIconWindow winLevels;

//SARGE: Added
var bool bShowDots;
var int augLevel;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
    winLevels = PersonaLevelIconWindow(NewChild(Class'PersonaLevelIconWindow'));
    winLevels.Hide();
    winLevels.SetPos(4, 29);
    winLevels.SetSelected(true);
}

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

	// Draw Text
	gc.SetTextColor(colText);
	gc.DrawText(-15, 0, 47, 40, hotKeyString);

    //SARGE: Draw Aug Levels
    if (winLevels != None)
    {
        if (bShowDots)
        {
            winLevels.Show();
            winLevels.SetLevel(augLevel);
        }
        else
        {
            winLevels.Hide();
        }
    }
}

// ----------------------------------------------------------------------
// SetObject()
//
// Had to write this because SetClientObject() is FINAL in Extension
// ----------------------------------------------------------------------

function SetObject(object newClientObject)
{
	if (Augmentation(newClientObject) != None)
	{
		// Get the function key and set the text
		SetKeyNum(Augmentation(newClientObject).GetHotKey());
        bHasChargeBar = Augmentation(newClientObject).bHasChargeBar;

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

    if (aug == None)
        return;

	if (bHasChargeBar && winEnergy != None)
    {
        winEnergy.Show();
        if (aug.IsCharging())
            winEnergy.SetCurrentValue(((aug.chargeTime - aug.currentChargeTime) / aug.chargeTime) * 100);
        else
            winEnergy.SetCurrentValue(0);
    }

    //SARGE: Update the aug icon colour when it's active.
    if (aug.displayAsActiveTime + deltaSeconds >= player.saveTime)
        colItemIcon = aug.GetAugColor(true);
    
    //Update info for the dots display
    augLevel = aug.CurrentLevel;
    bShowDots = class'DeusExPlayer'.default.bShowAugLevelsInHUD && !aug.IsCharging();
}

event DestroyWindow()
{
    winLevels = None;
    //DestroyAllChildren();
    super.DestroyWindow();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colItemIcon=(B=0)
}
