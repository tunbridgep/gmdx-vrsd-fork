//=============================================================================
// ElectronicDevices.
//=============================================================================
class ElectronicDevices extends DeusExDecoration
	abstract;

// ----------------------------------------------------------------------
// No Keypad Cheese
// ----------------------------------------------------------------------

//Allows us to determine if a code should be considered discovered
function bool IsDiscovered(DeusExPlayer player, string code)
{
    return !player.bNoKeypadCheese || player.GetCodeNote(code);// || player.GetCodeEmail(code) || player.GetExceptedCode(code);
}

defaultproperties
{
     bInvincible=True
     FragType=Class'DeusEx.PlasticFragment'
     bPushable=False
}
