//-----------------------------------------------------------
//GMDX:
//-----------------------------------------------------------
class MenuChoice_XhairShrink extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bXhairShrink));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bXhairShrink = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bXhairShrink));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="If set to Enabled, the dynamic crosshair scales in thickness based on current accuracy."
     actionText="|&Scaling Crosshair"
}
