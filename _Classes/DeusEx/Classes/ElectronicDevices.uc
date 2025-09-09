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
function bool IsDiscovered(DeusExPlayer player, string code, optional string code2)
{
    //Check usernames and passwords
    if (code2 != "")
        return codeExcepted || player.iNoKeypadCheese == 0 || ((player.HasCodeNote(code) || player.GetExceptedCode(code)) && (player.HasCodeNote(code2) || player.GetExceptedCode(code2)));

    if (code != "")
        return codeExcepted || player.iNoKeypadCheese == 0 || player.HasCodeNote(code) || player.GetExceptedCode(code);

    return false;
}

defaultproperties
{
	bInvincible=true
	FragType=Class'DeusEx.PlasticFragment'
	bPushable=false
}
