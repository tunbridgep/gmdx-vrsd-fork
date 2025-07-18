//=============================================================================
// A Collectible.
// These items disappear on pickup, but are tracked in your stats.
//=============================================================================
class Collectible extends DeusExDecoration abstract;

//Destroy upon pickup.
//Taken from NanoKey.uc
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    frobber.collectiblesFound++;
    Destroy();
    return False;
}

defaultproperties
{
    //Mesh=LodMesh'DeusExDeco.NYEagleStatue'
    //DrawScale=0.100000
    ItemName="Small Buddha Statue (Collectible)"
    Mesh=LodMesh'DeusExDeco.HKBuddha'
    DrawScale=0.200000
    CollisionRadius=10.0
    CollisionHeight=12.0
    Mass=15.000000
    Buoyancy=15.000000
    Physics=PHYS_None
}
