//=============================================================================
// HUDActiveItem
//=============================================================================

class HUDActiveItem extends HUDActiveItemBase;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	CreateEnergyBar();

	bTickEnabled = TRUE;
}

// ----------------------------------------------------------------------
// Tick()
//
// Used to update the energy bar
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	local ChargedPickup item;

	item = ChargedPickup(GetClientObject());

    if ((item != None) && (Player.PlayerIsRemoteClient()))
        if (!VerifyItemCarried())
        {
            Player.RemoveChargedDisplay(item);
            item = None;
        }


	if ((item != None) && (winEnergy != None))
	{
        if (item.bDrained) //SARGE: If it's drained, don't show the power level for the next one.
            winEnergy.SetCurrentValue(0);
        else
            winEnergy.SetCurrentValue(item.GetCurrentCharge());
	}

}

//SARGE: Draw dim if a charged pickup is drained
function bool DrawDim()
{
	local ChargedPickup item;
	item = ChargedPickup(GetClientObject());

    return (item != None && item.bDrained);
}

// ----------------------------------------------------------------------
// VerifyItemCarried()
// If the player is no longer carrying this item, we shouldn't be displaying
// anymore.
// ----------------------------------------------------------------------

function bool VerifyItemCarried()
{
   local inventory CurrentItem;
   local bool bFound;

   bFound = false;

   for (CurrentItem = player.Inventory; ((CurrentItem != None) && (!bFound)); CurrentItem = CurrentItem.inventory)
   {
      if (CurrentItem == GetClientObject())
         bFound = true;
   }

   return bFound;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     iconDrawStyle=DSTY_Masked
}
