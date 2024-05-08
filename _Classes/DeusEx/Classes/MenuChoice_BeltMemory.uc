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
	SetValue(int(!player.bBeltMemory));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="After consuming the last item in a belt slot, it's position will be preserved.|nIf Autofill is off, dropped items will also be preserved. Right-Click to clear."
     actionText="|&Belt Memory"
}
