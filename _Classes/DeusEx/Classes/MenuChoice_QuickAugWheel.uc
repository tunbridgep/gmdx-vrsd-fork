//-----------------------------------------------------------
//Sarge: Enable/disable quick aug wheel
//-----------------------------------------------------------
class MenuChoice_QuickAugWheel extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bQuickAugWheel));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bQuickAugWheel = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bQuickAugWheel));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Enable/Disable the highlighted augmentation when closing the augmentation wheel. Cancel with right click."
     actionText="|&Quick Augmentation Wheel"
}
