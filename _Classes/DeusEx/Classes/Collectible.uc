//=============================================================================
// A Collectible.
// These items disappear on pickup, but are tracked in your stats.
//=============================================================================
class Collectible extends DeusExPickup;

enum ECollectibleType
{
    Style_Buddha,
    Style_Eagle,
};

var(GMDX) ECollectibleType CollectibleType;
var localized string collectibleNames[5];

//DIRTY HACK
//We can't set DrawScale in the same frame as changing the model, aparrently
var float newScale;

function Tick(float deltaTime)
{
    DrawScale = newScale;
}

//Destroy upon pickup.
//Taken from NanoKey.uc
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    frobber.collectiblesFound++;
    Destroy();
    return False;
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
		
    //Disappear if collectibles are not enabled
    if (!class'DeusExPlayer'.default.bCollectiblesEnabled)
    {
        Log("Destroying Collectible");
        Destroy();
        return;
    }

    switch (CollectibleType)
    {
        case Style_Buddha:
            Mesh=LodMesh'DeusExDeco.HKBuddha';
            newScale=0.200000;
            ItemName=collectibleNames[0];
            break;
        case Style_Eagle:
            Mesh=LodMesh'DeusExDeco.NYEagleStatue';
            newScale=0.100000;
            ItemName=collectibleNames[1];
            break;
    }

    PickupViewMesh = Mesh;
    PlayerViewMesh = Mesh;
    DrawScale = newScale;
}

defaultproperties
{
    Mesh=LodMesh'DeusExDeco.HKBuddha'
    DrawScale=0.200000
    Mass=10.000000
    CollisionRadius=10.0
    CollisionHeight=12.0
    Mass=15.000000
    Buoyancy=15.000000
    ItemName="Collectible"
    //Physics=PHYS_None
    CollectibleNames(0)="Buddha Statue"
    CollectibleNames(1)="Eagle Statue"
}
