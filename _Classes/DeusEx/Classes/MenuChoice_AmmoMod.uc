//=============================================================================
// MenuChoice_AmmoMod
//=============================================================================

class MenuChoice_AmmoMod extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(player.fGlobalAmmoMod * 10));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.fGlobalAmmoMod = int(GetValue()) * 0.1;
    player.SaveConfig();
}

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators()
{
	local int enumIndex;

	for(enumIndex=0;enumIndex<numTicks;enumIndex++)
		SetEnumeration(enumIndex, class'StringUtils'.static.FormatFloatString((enumIndex+1) * 0.1,0.1));
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(defaultValue);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     numTicks=50
     startValue=1
     endValue=50
     defaultValue=10
     HelpText="Global modifier for ammo capacity. If ammo capacities are too low, adjust this to increase them."
     actionText="|&Global Ammo Modifier"
}
