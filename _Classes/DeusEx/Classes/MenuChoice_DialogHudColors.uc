//-----------------------------------------------------------
//Sarge: Enable/disable HUD colour scheme in dialog menus
//-----------------------------------------------------------
class MenuChoice_DialogHUDColors extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bDialogHUDColors));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bDialogHUDColors = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bDialogHUDColors));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Use selected HUD Theme in dialog menus"
     actionText="|&Dialog HUD Colors"
}
