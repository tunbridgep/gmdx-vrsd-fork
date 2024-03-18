//=============================================================================
// MenuChoice_AnimatedBar1
//=============================================================================

class MenuChoice_AnimatedBar2 extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------


function LoadSetting()
{
	SetValue(int(!player.bAnimBar2));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
local DeusExRootWindow root;

	player.bAnimBar2 = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bAnimBar2));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Alternate visuals for the stamina meter. Toggle has no effect during gameplay."
     actionText="|&Animated Stamina Bar"
}
