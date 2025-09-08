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
    local bool bStrict;
    local bool bHasCode;

    //If we have one of the super generic codes, we need to run in generic mode.
    bStrict = code2 != "" && (!player.IsObfuscatedCode(code) && !player.isObfuscatedCode(code2));

    //if bReallyKnown is set, then we are only checking if the player literally knows the code.
    //Otherwise, they are considered to have known it if it was excepted, or if no keypad cheese is turned off.
    //NOTE: This requires the code to literally be in their notes. They can't have just read it somewhere.
    if (bReallyKnown)
    {
        //Check usernames and passwords
        if (bStrict)
            return player.HasCodeNoteStrict(code,code2,true);
        if (code2 != "")
            return player.HasCodeNote(code,true) || player.HasCodeNote(code2,true);
        else if (code != "")
            return player.HasCodeNote(code,true);
    }
    else
    {
        //Check usernames and passwords
        if (bStrict)
            return codeExcepted || player.iNoKeypadCheese == 0 || player.HasCodeNoteStrict(code,code2);
        if (code2 != "")
            return codeExcepted || player.iNoKeypadCheese == 0 || ((player.HasCodeNote(code) || player.GetExceptedCode(code)) && (player.HasCodeNote(code2) || player.GetExceptedCode(code2)));
        else if (code != "")
            return codeExcepted || player.iNoKeypadCheese == 0 || player.HasCodeNote(code) || player.GetExceptedCode(code);
    }

    return false;
}

defaultproperties
{
	bInvincible=true
	FragType=Class'DeusEx.PlasticFragment'
	bPushable=false
}
