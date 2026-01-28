//=============================================================================
// Carried Object.
// SARGE: A temporary object allowing the player to carry objects with left-frob.
//=============================================================================
class CarriedObject extends DeusExDecoration;

var private travel Inventory carriedItem;

var private travel int rPhysicsType;

static function bool CreateCarriedObjectFor(DeusExPlayer pawn,Inventory item)
{
    local CarriedObject carrier;
    local int i;
    
    carrier = CarriedObject(class'SpawnUtils'.static.SpawnSafe(class'CarriedObject',item,item.Tag,item.Location,item.Rotation));

    if (carrier == None)
        return false;

    //Carrier created, now set it up
    carrier.rPhysicsType = item.Physics;

    carrier.Mesh = item.Mesh;
    carrier.itemName = item.itemName;
    carrier.SetCollisionSize(item.collisionradius,item.collisionheight);
    
    carrier.Skin = item.Skin;
    for (i = 0;i < 8;i++)
        carrier.multiskins[i] = item.multiskins[i];
    carrier.texture = item.texture;

    //Carrier ready, now try to pick it up...
    pawn.frobTarget = carrier;
    pawn.GrabDecoration();
    if (pawn.CarriedDecoration == carrier)
    {
        item.SetLocation(carrier.Location);
        item.SetPhysics(PHYS_None);
        item.SetCollision(False, False, False);
        item.SetBase(pawn);
        item.Mesh = None;
        carrier.carriedItem = item;
        return true;
    }
    else
    {
        carrier.Destroy();
        return false;
    }
}

//Destroy all linked items
function Destroyed()
{
    if (carriedItem != None)
        carriedItem.Destroy();

    Log("Carried object destroyed: " $ carriedItem);

    Super.Destroyed();
}

static function Inventory CreateRealObjectFor(CarriedObject carrier)
{
    //ammoClassClass = class<Inventory>(DynamicLoadObject(carrier.ammoClass, class'Class'));
    
    //item = Inventory(class'SpawnUtils'.static.SpawnSafe(ammoClassClass,carrier,carrier.Tag,carrier.Location,carrier.Rotation));
    //foreach carrier.BasedActors(class'Inventory', item)
    //    break;
    
    //foreach carrier.BasedActors(class'Inventory', item)
    //    Log("BasedActor: " $ item);

    local Inventory item;

    item = carrier.carriedItem;

    if (item == None)
        return None;

    Log("Physics: " $ carrier.rPhysicsType @ item.default.Physics);

    item.SetBase(None);
    item.SetLocation(carrier.Location);
    item.SetRotation(carrier.Rotation);
    //item.SetPhysics(carrier.rPhysicsType); //doesn't work??
    item.SetPhysics(item.default.Physics);
    item.SetCollision(item.Default.bCollideActors, item.Default.bBlockActors, item.Default.bBlockPlayers);
    item.velocity = carrier.velocity;
    item.Mesh = item.pickupViewMesh;
    carrier.carriedItem = none;
    carrier.Destroy();
    return item;
}
