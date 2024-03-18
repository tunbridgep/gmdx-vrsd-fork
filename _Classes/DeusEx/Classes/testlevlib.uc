//=============================================================================
// Mission00.
//=============================================================================
class testlevlib extends MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
//
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local UNATCOTroop troop;
	local LAM lam;

	Super.FirstFrame();

   CanQuickSave=true;

}

// ----------------------------------------------------------------------
// PreTravel()
//
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------

function PreTravel()
{
	Super.PreTravel();
}

defaultproperties
{
}
