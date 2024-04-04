//-----------------------------------------------------------
//Sarge: Enable/disable belt autofill
//-----------------------------------------------------------
class MenuChoice_HackingLockouts extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bHackLockouts));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bHackLockouts = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bHackLockouts));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Security Terminals will prevent access after being hacked a certain number of times, based on Computer skill. Hardcore features this behaviour by default"
     actionText="|&Hacking Lockouts"
}
