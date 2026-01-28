//=============================================================================
// Carried Ammo.
// SARGE: A temporary object allowing the player to carry ammo with left-frob.
// SARGE: Updated, now we can carry pretty much anything. So the name is a misnomer.
//=============================================================================
class CarriedAmmo extends DeusExDecoration;

var travel string ammoClass;        //SARGE: This is a string because if we store classes, the game crashes.
var travel int ammoAmount;          //SARGE: Ammo: AmmoAmount, Weapon: PickupAmmoCount
var travel int ClipCount;           //SARGE: Weapon: ClipCount
var travel float Charge;            //SARGE: ChargedPickup: Charge

//Weapon stuff....what a doozie!
//SARGE: Leaving this for now, it's too hard!
/*
var travel bool	bHadScope;
var travel bool	bHadSilencer;
var travel bool	bHadLaser;
var travel bool	bHasScope;
var travel bool	bHasSilencer;
var travel bool	bHasLaser;
var travel bool	bFullAuto;
var travel bool	bModified;

var travel float ModBaseAccuracy;
var travel float ModReloadCount;
var travel float ModAccurateRange;
var travel float ModReloadTime;
var travel float ModRecoilStrength;
var travel float ModShotTime;
var travel float ModDamage;

var travel int ReloadCount;
var travel float AccurateRange;
var travel float BaseAccuracy;
var travel float ReloadTime;
var travel float RecoilStrength;
*/

static function bool CreateCarriedAmmoFor(DeusExPlayer pawn,Inventory item)
{
    local CarriedAmmo carrier;
    
    carrier = CarriedAmmo(class'SpawnUtils'.static.SpawnSafe(class'CarriedAmmo',item,item.Tag,item.Location,item.Rotation));

    if (carrier == None)
        return false;

    carrier.ammoClass = string(item.Class);


    if (item.IsA('DeusExAmmo'))
    {
        carrier.ammoAmount = DeusExAmmo(item).AmmoAmount;
    }
    else if (item.IsA('DeusExWeapon'))
    {
        carrier.ammoAmount = DeusExWeapon(item).PickupAmmoCount;
        carrier.ClipCount = DeusExWeapon(item).ClipCount;
    }
    else if (item.IsA('ChargedPickup'))
    {
        carrier.ammoAmount = ChargedPickup(item).numCopies;
        carrier.Charge = ChargedPickup(item).Charge;
    }
    else if (item.IsA('Credits'))
    {
        carrier.ammoAmount = Credits(item).NumCredits;
    }
    else if (item.IsA('DeusExPickup'))
    {
        carrier.ammoAmount = DeusExPickup(item).NumCopies;
    }

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

static function Inventory CreateRealAmmoFor(CarriedAmmo carrier)
{
    local Inventory item;
    local class<Inventory> ammoClassClass;

    ammoClassClass = class<Inventory>(DynamicLoadObject(carrier.ammoClass, class'Class'));
    
    item = Inventory(class'SpawnUtils'.static.SpawnSafe(ammoClassClass,carrier,carrier.Tag,carrier.Location,carrier.Rotation));

    if (item == None)
        return None;

    if (item.IsA('DeusExAmmo'))
    {
        DeusExAmmo(item).ammoAmount = carrier.AmmoAmount;
    }
    else if (item.IsA('DeusExWeapon'))
    {
        DeusExWeapon(item).pickupammocount = carrier.AmmoAmount;
        DeusExWeapon(item).clipcount = carrier.ClipCount;
    }
    else if (item.IsA('ChargedPickup'))
    {
        ChargedPickup(item).numCopies = carrier.AmmoAmount;
        ChargedPickup(item).Charge = carrier.Charge;
    }
    else if (item.IsA('Credits'))
    {
        Credits(item).NumCredits = carrier.AmmoAmount;
    }
    else if (item.IsA('DeusExPickup'))
    {
        DeusExPickup(item).numCopies = carrier.AmmoAmount;
    }

    item.velocity = carrier.velocity;
    carrier.Destroy();
    return item;
}
