//=============================================================================
// PersonaAugmentationItemButton
//=============================================================================
class PersonaAugmentationItemButton extends PersonaItemButton;

var PersonaLevelIconWindow winLevels;
var bool  bActive;
var int   hotkeyNumber;
var bool  onWheel;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
    colIcon = class'Augmentation'.default.colInactive;
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	local String str;
    local bool onWheel;

	Super.DrawWindow(gc);

	// Draw the hotkey info in lower-left corner
	if (hotkeyNumber >= 3)
	{
		str = "F" $ hotkeyNumber;
		gc.SetFont(Font'FontMenuSmall_DS');
		gc.SetAlignments(HALIGN_Left, VALIGN_Top);
		gc.SetTextColor(colHeaderText);
		gc.DrawText(2, iconPosHeight - 9, iconPosWidth - 2, 10, str);
	}
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winLevels = PersonaLevelIconWindow(NewChild(Class'PersonaLevelIconWindow'));
	winLevels.SetPos(30, 54);
	winLevels.SetSelected(True);
}

// ----------------------------------------------------------------------
// SetHotkeyNumber()
// ----------------------------------------------------------------------

function SetHotkeyNumber(int num)
{
	hotkeyNumber = num;
}

// ----------------------------------------------------------------------
// SetActive()
// ----------------------------------------------------------------------

function SetActive(Augmentation aug)
{
	bActive = aug.IsActive();
    colIcon = aug.GetAugColor();
}

// ----------------------------------------------------------------------
// SetLevel()
// ----------------------------------------------------------------------

function SetLevel(int newLevel)
{
	if (winLevels != None)
		winLevels.SetLevel(newLevel);
}

// ----------------------------------------------------------------------
// SetHeartUpgraded()
// SARGE: Set red icons when upgraded by heart.
// ----------------------------------------------------------------------

function SetHeartUpgraded(bool heart)
{
	if (winLevels != None)
		winLevels.SetHeart(heart);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     buttonHeight=59
}
