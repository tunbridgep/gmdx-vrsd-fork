//-----------------------------------------------------------
//Sarge: Enable/disable Aug Wheel "Disable All" Button
//-----------------------------------------------------------
class MenuChoice_AugWheelDisableAllButton extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bAugWheelDisableAll));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bAugWheelDisableAll = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bAugWheelDisableAll));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Enable/Disable the 'Disable All' button on the Augmentaiton Wheel"
     actionText="'|&Disable All' on Augmentation Wheel"
}
