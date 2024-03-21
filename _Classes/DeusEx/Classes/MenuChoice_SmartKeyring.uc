//-----------------------------------------------------------
//Sarge: Enable/disable Smart Keyring
//-----------------------------------------------------------
class MenuChoice_SmartKeyring extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bSmartKeyring));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bSmartKeyring = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(1);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Keyring is selected when interacting with locked doors. Belt slot 0 is made available to general items."
     actionText="|&Smart Keyring"
}
