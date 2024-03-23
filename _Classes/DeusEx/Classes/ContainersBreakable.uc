//=============================================================================
// SARGE: Added a new class to handle all breakable container functions.
//=============================================================================

class BreakableContainers extends Containers abstract;

function bool DoLeftFrob(DeusExPlayer frobber, bool objectInHand)
{
    if (objectInHand)
        return false;
    frobber.PutInHand(frobber.lastMeleeWeapon);
    return super.DoLeftFrob(frobber,objectInHand);
}
