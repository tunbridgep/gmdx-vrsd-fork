//-----------------------------------------------------------
//Sarge: Enable/disable credits in dialog
//-----------------------------------------------------------
class MenuChoice_DialogCredits extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bCreditsInDialog));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bCreditsInDialog = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bCreditsInDialog));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Show Credits Balance in the Dialog Window"
     actionText="|&Show Credits in Dialog Window"
}
