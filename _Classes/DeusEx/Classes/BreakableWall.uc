//=============================================================================
// BreakableWall.
//=============================================================================
class BreakableWall expands DeusExMover;

//SARGE: Added "Left Click Frob" and "Right Click Frob" support
//Simply pull out a melee weapon
function bool DoLeftFrob(DeusExPlayer frobber)
{
    frobber.SelectMeleePriority(minDamageThreshold);
    return false;
}

function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    if (frobber.bRightClickToolSelection && objectInHand && frobber.inHand == frobber.primaryWeapon)
        return DoLeftFrob(frobber);

    return Super.DoRightFrob(frobber,objectInHand);
}


defaultproperties
{
     bPickable=False
     bBreakable=True
     doorStrength=0.400000
     bHighlight=False
     bFrobbable=False
     minDamageThreshold=20
     FragmentScale=3.000000
     FragmentClass=Class'DeusEx.Rockchip'
     ExplodeSound1=Sound'DeusExSounds.Generic.SmallExplosion1'
     ExplodeSound2=Sound'DeusExSounds.Generic.LargeExplosion1'
     bOwned=True
}
