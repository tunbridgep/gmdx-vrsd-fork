//=============================================================================
// SARGE: Added a new class to handle all breakable container functions.
//=============================================================================

class BreakableContainers extends Containers abstract;

function bool DoLeftFrob(DeusExPlayer frobber)
{
    frobber.PutInHand(frobber.lastMeleeWeapon);
    return false;
}
