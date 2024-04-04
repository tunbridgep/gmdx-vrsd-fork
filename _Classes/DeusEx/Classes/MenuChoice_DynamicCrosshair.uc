//-----------------------------------------------------------
//Sarge: Enable/disable Dynamic Crosshair
//-----------------------------------------------------------
class MenuChoice_DynamicCrosshair extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bDynamicCrosshair));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bDynamicCrosshair = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bDynamicCrosshair));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Use a small dot-crosshair when no weapon is equipped, and some items have no crosshairs"
     actionText="|&Dynamic Crosshair"
}
