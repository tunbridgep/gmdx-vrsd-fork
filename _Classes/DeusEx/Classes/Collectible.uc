//=============================================================================
// A Collectible.
// These items disappear on pickup, but are tracked in your stats.
//=============================================================================
class Collectible extends DeusExDecoration abstract;

var localized string FoundString;
const maxCollectibles = 13;

//Destroy upon pickup.
//Taken from NanoKey.uc
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    local string msg;

    frobber.collectiblesFound++;
    msg = sprintf(FoundString,frobber.collectiblesFound,maxCollectibles);

    frobber.ClientMessage(class'DeusExPickup'.default.PickupMessage @ itemArticle @ itemName @ msg, 'Pickup');
    Destroy();

    //Unlock the Collector outfit
    if (frobber.collectiblesFound >= maxCollectibles && frobber.OutfitManager != None)
        frobber.OutfitManager.Unlock("collectible_outfit",true);

    return False;
}

defaultproperties
{
    //Mesh=LodMesh'DeusExDeco.NYEagleStatue'
    //DrawScale=0.100000
    itemArticle="the"
    ItemName="Small Buddha Statue (Collectible)"
    FoundString="(%d/%d Found)"
    Mesh=LodMesh'DeusExDeco.HKBuddha'
    DrawScale=0.200000
    CollisionRadius=10.0
    CollisionHeight=16.0
    Mass=15.000000
    Buoyancy=15.000000
    Physics=PHYS_Falling
}
