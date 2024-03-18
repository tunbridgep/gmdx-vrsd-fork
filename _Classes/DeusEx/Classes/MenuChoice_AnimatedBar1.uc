//=============================================================================
// MenuChoice_AnimatedBar1
//=============================================================================

class MenuChoice_AnimatedBar1 extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------


function LoadSetting()
{
	SetValue(int(!player.bAnimBar1));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bAnimBar1 = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bAnimBar1));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Alternate visuals for the bioenergy meter. Toggle has no effect during gameplay."
     actionText="|&Animated Bioenergy Bar"
}
