//=============================================================================
// MenuChoice_Crosshairs
//=============================================================================

class MenuChoice_Crosshairs extends MenuUIChoiceEnum;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(player.iCrosshairVisible);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.iCrosshairVisible = int(GetValue());
    player.UpdateCrosshair();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(0);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Toggles Crosshairs visibility."
     actionText="Cross|&hairs"
     enumText(0)="Hidden"
     enumText(1)="Visible"
     enumText(2)="Outer Only"
}
