//-----------------------------------------------------------
//CyberP: Enable Disable head decapitation
//-----------------------------------------------------------
class MenuChoice_ExtraDetails extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bExtraObjectDetails));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bExtraObjectDetails = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bExtraObjectDetails));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="Breakable objects display hitpoints & throwable objects display mass. Not recommended for the sake of consistency."
     actionText="|&Extra Object Details"
}
