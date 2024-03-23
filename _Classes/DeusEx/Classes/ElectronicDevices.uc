//=============================================================================
// ElectronicDevices.
//=============================================================================
class ElectronicDevices extends DeusExDecoration
	abstract;

//SARGE: Added "Left Click Frob" and "Right Click Frob" support
//Returns if it was able to be frobbed or not.
function bool DoLeftFrob(DeusExPlayer frobber, bool objectInHand)
{
    if (frobber.inHand.isA('Multitool'))
        return true;
    return false;
}
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    return true;
}


// ----------------------------------------------------------------------
// No Keypad Cheese
// ----------------------------------------------------------------------

//Allows us to determine if a code should be considered discovered
function bool IsDiscovered(DeusExPlayer player, string code)
{
    return !player.bNoKeypadCheese || player.GetCodeNote(code) || player.GetExceptedCode(code);
}

defaultproperties
{
     bInvincible=True
     FragType=Class'DeusEx.PlasticFragment'
     bPushable=False
}
