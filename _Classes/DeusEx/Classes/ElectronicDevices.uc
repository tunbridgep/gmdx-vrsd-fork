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
function bool IsDiscovered(DeusExPlayer player, string code, optional string code2, optional bool bReallyKnown)
{
    //if bReallyKnown is set, then we are only checking if the player literally knows the code.
    //Otherwise, they are considered to have known it if it was read somewhere but not saved, or if no keypad cheese is turned off.
    //NOTE: This requires the code to literally be in their notes. They can't have just read it somewhere.
    if (bReallyKnown)
    {
        //Check usernames and passwords
        if (code != "")
            return player.HasCodeNote(code,code2,true);
    }
    else
    {
        //Check usernames and passwords
        if (code != "")
            return codeExcepted || player.iNoKeypadCheese == 0 || player.HasCodeNote(code,code2);
    }

    return false;
}

defaultproperties
{
	bInvincible=true
	FragType=Class'DeusEx.PlasticFragment'
	bPushable=false
}
