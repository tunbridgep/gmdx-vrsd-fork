//=============================================================================
// Carried Ammo.
// SARGE: A temporary object allowing the player to carry ammo with left-frob.
//=============================================================================
class CarriedAmmo extends DeusExDecoration;

var travel string ammoClass;       //SARGE: This is a string because if we store classes, the game crashes.
var travel int ammoAmount;

static function bool CreateCarriedAmmoFor(DeusExPlayer pawn,DeusExAmmo item)
{
    local CarriedAmmo carrier;
    
    carrier = CarriedAmmo(class'SpawnUtils'.static.SpawnSafe(class'CarriedAmmo',item,item.Tag,item.Location,item.Rotation));

    if (carrier == None)
        return false;

    carrier.ammoClass = string(item.Class);
    carrier.ammoAmount = item.AmmoAmount;
    carrier.Mesh = item.Mesh;
    carrier.itemName = item.itemName;
    carrier.SetCollisionSize(item.collisionradius,item.collisionheight);

    //Carrier created, now try to pick it up...
    pawn.frobTarget = carrier;
    pawn.GrabDecoration();
    if (pawn.CarriedDecoration == carrier)
    {
        item.Destroy();
        return true;
    }
    else
    {
        carrier.Destroy();
        return false;
    }

}

static function DeusExAmmo CreateRealAmmoFor(CarriedAmmo carrier)
{
    local DeusExAmmo item;
    local class<DeusExAmmo> ammoClassClass;

    ammoClassClass = class<DeusExAmmo>(DynamicLoadObject(carrier.ammoClass, class'Class'));
    
    item = DeusExAmmo(class'SpawnUtils'.static.SpawnSafe(ammoClassClass,carrier,carrier.Tag,carrier.Location,carrier.Rotation));

    if (item == None)
        return None;

    item.ammoAmount = carrier.AmmoAmount;
    item.velocity = carrier.velocity;
    carrier.Destroy();
    return item;
}
