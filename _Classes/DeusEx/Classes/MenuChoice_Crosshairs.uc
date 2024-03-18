//=============================================================================
// MenuChoice_Crosshairs
//=============================================================================

class MenuChoice_Crosshairs extends MenuChoice_VisibleHidden;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bCrosshairVisible));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bCrosshairVisible = !bool(GetValue());

	//GMDX: update laser/Xhair toggle
	if ((player.bCrosshairVisible)&&(DeusExWeapon(player.inHand)!=none)&&(DeusExWeapon(player.InHand).bLasing))
   {
      player.SetLaser(false,false);
   }
   player.bWasCrosshair=player.bCrosshairVisible;
   player.bFromCrosshair=false;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bCrosshairVisible));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Toggles Crosshairs visibility."
     actionText="Cross|&hairs"
}
