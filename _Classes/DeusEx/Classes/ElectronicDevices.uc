//=============================================================================
// ElectronicDevices.
//=============================================================================
class ElectronicDevices extends DeusExDecoration
	abstract;

var(GMDX) bool codeExcepted;                            //SARGE: If set, this device is completely excepted from No Keypad Cheese checks

// ----------------------------------------------------------------------
// No Keypad Cheese
// ----------------------------------------------------------------------

//Allows us to determine if a code should be considered discovered
function bool IsDiscovered(DeusExPlayer player, string code)
{
    return codeExcepted || player.iNoKeypadCheese == 0 || player.GetCodeNote(code) || player.GetExceptedCode(code);
}

defaultproperties
{
     bInvincible=True
     FragType=Class'DeusEx.PlasticFragment'
     bPushable=False
}
