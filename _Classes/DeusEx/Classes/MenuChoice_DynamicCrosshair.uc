//-----------------------------------------------------------
//Sarge: Enable/disable Dynamic Crosshair
//-----------------------------------------------------------
class MenuChoice_DynamicCrosshair extends MenuUIChoiceEnum;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(player.dynamicCrosshair);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.dynamicCrosshair = GetValue();
    player.UpdateCrosshair();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(player.dynamicCrosshair);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Use a small dot-crosshair (or no crosshair) when no weapon is equipped, and in a few other cases."
     actionText="|&Dynamic Crosshair"
	 enumText(0)="Disabled"
     enumText(1)="Dot"
     enumText(2)="Nothing"
}
