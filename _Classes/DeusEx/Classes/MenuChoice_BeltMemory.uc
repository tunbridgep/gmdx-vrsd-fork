//-----------------------------------------------------------
//Sarge: Enable/disable belt autofill
//-----------------------------------------------------------
class MenuChoice_BeltMemory extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bBeltMemory));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bBeltMemory = !bool(GetValue());
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
     HelpText="Belt slots are limited to the last object placed in them."
     actionText="|&Belt Memory"
}
