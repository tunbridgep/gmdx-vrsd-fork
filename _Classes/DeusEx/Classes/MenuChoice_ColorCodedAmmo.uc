//-----------------------------------------------------------
//CyberP: Enable Disable Color-coded ammo
//-----------------------------------------------------------
class MenuChoice_ColorCodedAmmo extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bColorCodedAmmo));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bColorCodedAmmo = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bColorCodedAmmo));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="If set to Enabled, alternate ammo is color-coded in the toolbelt."
     actionText="|&Color Coded Ammo"
}
