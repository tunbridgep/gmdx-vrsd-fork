//-----------------------------------------------------------
//CyberP: Enable Disable Save Points costing credits
//-----------------------------------------------------------
class MenuChoice_ExtraHardcore extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bExtraHardcore));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bExtraHardcore = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bExtraHardcore));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="If set to Enabled, hardcore mode's save points require 100 credits to use. For veterans only."
     actionText="|&Hardcore Mode+"
}
