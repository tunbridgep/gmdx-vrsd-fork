//-----------------------------------------------------------
//CyberP: Enable Disable double click holstering
//-----------------------------------------------------------
class MenuChoice_HardcoreFilter extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bHardcoreFilterOption));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bHardcoreFilterOption= !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bHardcoreFilterOption));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="In hardcore mode you face enemies in greater numbers. Enable this option to have this feature in other difficulty modes."
     actionText="|&Overwhelming Odds"
}
