//-----------------------------------------------------------
//RSD: Enable Limited Eating and Halved Withdrawal Delay
//-----------------------------------------------------------
class MenuChoice_RestrictedMetabolism extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bRestrictedMetabolism));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bRestrictedMetabolism = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bRestrictedMetabolism));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="The player can only eat/drink so much before getting full, and withdrawal symptoms occur twice as quickly. Enabled on Hardcore."
     actionText="|&Restricted Metabolism"
}
