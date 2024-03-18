//-----------------------------------------------------------
//CyberP: Enable Disable translucency for carried deco
//-----------------------------------------------------------
class MenuChoice_Hitmarker extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bHitmarkerOn));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bHitmarkerOn = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bHitmarkerOn));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="If Enabled, a hitmarker appears within your crosshairs that indicates whether you damaged the target."
     actionText="|&Hitmarker"
}
