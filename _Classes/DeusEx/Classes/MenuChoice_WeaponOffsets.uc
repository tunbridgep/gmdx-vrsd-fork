//-----------------------------------------------------------
//Sarge: Enable/disable enhanced weapon offsets
//-----------------------------------------------------------
class MenuChoice_WeaponOffsets extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bEnhancedWeaponOffsets));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bEnhancedWeaponOffsets = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bEnhancedWeaponOffsets));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Change weapon viewmodels to display better on widescreen resolutions."
     actionText="|&Enhanced Weapon Offsets"
}
