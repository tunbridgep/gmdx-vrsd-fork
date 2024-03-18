//-----------------------------------------------------------
//CyberP: Enable Disable head decapitation
//-----------------------------------------------------------
class MenuChoice_ExtraGore extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bDecap));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bDecap = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bDecap));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="if enabled, NPC head gibs to high caliber weaponry. !WARNING! Incomplete behaviour: Artists required. Apply now."
     actionText="|&Head Gibbing"
}
