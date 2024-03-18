//-----------------------------------------------------------
//CyberP: Enable Disable Color-coded ammo
//-----------------------------------------------------------
class MenuChoice_HalveAmmoCapacity extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bHalveAmmo));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bHalveAmmo = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bHalveAmmo));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="If set to Enabled, total ammo carrying capacity is halved for all weapons. Choose before starting a new game on any difficulty mode."
     actionText="|&Halve Ammo Capacity"
}
