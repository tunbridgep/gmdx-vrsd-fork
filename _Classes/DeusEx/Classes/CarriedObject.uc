//=============================================================================
// Carried Object.
// SARGE: A temporary object allowing the player to carry objects with left-frob.
//=============================================================================
class CarriedObject extends DeusExDecoration;

//var private travel int rPhysicsType;

var private travel string itemClass;

var private transient float spawnDelay;     //SARGE: When we frob exits, it will drop the item. We need to wait a small amount of time (1/10th of a second) to spawn the new object.

var private travel string copiedMesh;
var private travel string copiedName;
var private travel float copiedRadius;
var private travel float copiedHeight;
var private travel name copiedTag;
var private travel name copiedEvent;
var private travel string copiedSkin;
var private travel string copiedSkins[8];

//Copy over data in a custom data structure.
var private travel float copiedData[53];

//Setup the carrier to mimic the carried object
function ApplyProperties()
{
    local Mesh M;
    local int i;

    M = Mesh(DynamicLoadObject(copiedMesh, class'Mesh'));
    Mesh = M;
    itemName = copiedName;
    SetCollisionSize(copiedRadius,copiedHeight);
    
    if (copiedSkin != "")
        Skin = Texture(DynamicLoadObject(copiedSkin, class'Texture'));

    for (i = 0;i < 8;i++)
    {
        if (copiedSkins[i] != "")
            multiSkins[i] = Texture(DynamicLoadObject(copiedSkins[i], class'Texture'));
    }
    if (copiedSkins[8] != "")
        texture = Texture(DynamicLoadObject(copiedSkins[8], class'Texture'));
}

static function bool CreateCarriedObjectFor(DeusExPlayer pawn,Inventory item)
{
    local CarriedObject carrier;
    local int i;
    local DeusExPickup P;
    local DeusExAmmo A;
    local DeusExWeapon W;
    
    carrier = CarriedObject(class'SpawnUtils'.static.SpawnSafe(class'CarriedObject',item,item.Tag,item.Location,item.Rotation));

    if (carrier == None)
        return false;

    //Carrier created, now copy over the properties of the object to the carrier...
    carrier.copiedMesh = string(item.Mesh);
    carrier.copiedName = item.itemName;
    carrier.copiedRadius = item.collisionRadius;
    carrier.copiedHeight = item.collisionHeight;
    carrier.copiedTag = item.Tag;
    carrier.copiedEvent = item.Event;
    carrier.itemClass = string(item.Class);

    //Item Specific stuff
    P = DeusExPickup(item);
    A = DeusExAmmo(item);
    W = DeusExWeapon(item);

    if (A != None) //Ammo is super easy, just store the amount
    {
        carrier.copiedData[0] = A.AmmoAmount;
    }
    else if (P != None) //For DeusExPickups, store the numCopies, charge and the skin information.
    {
        carrier.copiedData[0] = P.numCopies;
        carrier.copiedData[1] = P.Charge;
        carrier.copiedData[2] = P.textureSet;

        for (i = 0;i < 50;i++)
            carrier.copiedData[3+i] = P.PickUpList[i];
    }
    else if (W != None) //For DeusExWeapons, store the pickupammocount, clipcount and the weapon mod information.
    {

        //These are based off the CopyModsFrom function in DeusExWeapon.uc
        //If that's wrong, then this is also wrong.
        carrier.copiedData[0] = W.pickupAmmoCount;
        carrier.copiedData[1] = int(W.bModified);
        carrier.copiedData[2] = W.ClipCount;
        carrier.copiedData[3] = W.ModBaseAccuracy;
        carrier.copiedData[4] = W.ModReloadCount;
        carrier.copiedData[5] = W.ModAccurateRange;
        carrier.copiedData[6] = W.ModReloadTime;
        carrier.copiedData[7] = W.ModRecoilStrength;
        carrier.copiedData[8] = int(W.bHadLaser);
        carrier.copiedData[9] = int(W.bHadSilencer);
        carrier.copiedData[10] = int(W.bHadScope);
        carrier.copiedData[11] = int(W.bHasLaser);
        carrier.copiedData[12] = int(W.bHasSilencer);
        carrier.copiedData[13] = int(W.bHasScope);
        carrier.copiedData[14] = int(W.bFullAuto);
        carrier.copiedData[15] = W.ReloadCount;
        carrier.copiedData[16] = W.AccurateRange;
        carrier.copiedData[17] = W.BaseAccuracy;
        carrier.copiedData[18] = W.ReloadTime;
        carrier.copiedData[19] = W.RecoilStrength;
        carrier.copiedData[20] = W.ModShotTime;
        carrier.copiedData[21] = W.ModDamage;
        
        //If we're using the GL, we need to copy the old values instead
        //This is a dirty, disgusting, filthy, garbage hack!
        if (W.AmmoName == class'Ammo20mm')
        {
            carrier.copiedData[2] = W.ARLoaded;
            carrier.copiedData[15] = W.ARClipSize;
        }

    }

    carrier.copiedSkin = string(item.Skin);
    for (i = 0;i < 8;i++)
        carrier.copiedSkins[i] = string(item.multiskins[i]);
    carrier.copiedSkins[8] = string(item.texture);

    //Carrier ready, now try to pick it up...
    pawn.frobTarget = carrier;
    pawn.GrabDecoration();
    if (pawn.CarriedDecoration == carrier)
    {
        item.Destroy();
        carrier.ApplyProperties();
        return true;
    }
    else
    {
        carrier.Destroy();
        return false;
    }
}

event TravelPostAccept()
{
    super.TravelPostAccept();

    ApplyProperties();

    //SetBase(GetPlayerPawn());
    //SetOwner(GetPlayerPawn());
}

simulated function Tick(float deltaTime)
{
    if (spawnDelay > 0)
    {
        spawnDelay -= deltaTime;
        if (spawnDelay <= 0)
            ActuallyCreateRealObjectFor(self);
    }
}

function Frob(Actor Frobber, Inventory frobWith)
{
    spawnDelay = -1;
    Super.Frob(Frobber,frobWith);
}

static function CreateRealObjectFor(CarriedObject carrier)
{
    carrier.spawnDelay = 0.2;
}

static function private Inventory ActuallyCreateRealObjectFor(CarriedObject carrier)
{
    //ammoClassClass = class<Inventory>(DynamicLoadObject(carrier.ammoClass, class'Class'));
    
    //item = Inventory(class'SpawnUtils'.static.SpawnSafe(ammoClassClass,carrier,carrier.Tag,carrier.Location,carrier.Rotation));
    //foreach carrier.BasedActors(class'Inventory', item)
    //    break;
    
    //foreach carrier.BasedActors(class'Inventory', item)
    //    Log("BasedActor: " $ item);

    local int i;
    local Inventory item;
    local Class<Actor> C;
    local Class<Ammo> ammoName;
    local DeusExPickup P;
    local DeusExAmmo A;
    local DeusExWeapon W;
    
    C = Class<Actor>(DynamicLoadObject(carrier.itemClass, class'Class'));

    if (C == None)
        return None;

    //Recreate the inventory item
    item = Inventory(class'SpawnUtils'.static.SpawnSafe(C,carrier,carrier.copiedTag,carrier.Location,carrier.Rotation));

    if (item == None)
        return None;

    //First, set some basic parameters
    item.velocity = carrier.velocity;
    item.event = carrier.copiedEvent;

    //Item Specific stuff
    P = DeusExPickup(item);
    A = DeusExAmmo(item);
    W = DeusExWeapon(item);
    
    if (A != None) //Ammo is super easy, just copy the amount
    {
        A.AmmoAmount = carrier.copiedData[0];
    }
    else if (P != None) //For DeusExPickups, copy the numCopies, charge and the skin information.
    {
        P.numCopies = carrier.copiedData[0];
        P.Charge = carrier.copiedData[1];
        P.textureSet = carrier.copiedData[2];

        for (i = 0;i < 50;i++)
            P.PickUpList[i] = carrier.copiedData[3+i];

        P.UpdateHDTPSettings();
    }
    else if (W != None) //For DeusExWeapons, store the pickupammocount, clipcount and the weapon mod information.
    {
        //These are based off the CopyModsFrom function in DeusExWeapon.uc
        //If that's wrong, then this is also wrong.
        W.pickupAmmoCount = carrier.copiedData[0];
        W.bModified = bool(carrier.copiedData[1]);
        W.ClipCount = carrier.copiedData[2];
        W.ModBaseAccuracy = carrier.copiedData[3];
        W.ModReloadCount = carrier.copiedData[4];
        W.ModAccurateRange = carrier.copiedData[5];
        W.ModReloadTime = carrier.copiedData[6];
        W.ModRecoilStrength = carrier.copiedData[7];
        W.bHadLaser = bool(carrier.copiedData[8]);
        W.bHadSilencer = bool(carrier.copiedData[9]);
        W.bHadScope = bool(carrier.copiedData[10]);
        W.bHasLaser = bool(carrier.copiedData[11]);
        W.bHasSilencer = bool(carrier.copiedData[12]);
        W.bHasScope = bool(carrier.copiedData[13]);
        W.bFullAuto = bool(carrier.copiedData[14]);
        W.ReloadCount = carrier.copiedData[15];
        W.AccurateRange = carrier.copiedData[16];
        W.BaseAccuracy = carrier.copiedData[17];
        W.ReloadTime = carrier.copiedData[18];
        W.RecoilStrength = carrier.copiedData[19];
        W.ModShotTime = carrier.copiedData[20];
        W.ModDamage = carrier.copiedData[21];

        //Reset GL stats
        W.ARGLLoaded = 0;

        W.GivenFreeReload = true;
        
        W.UpdateHDTPSettings();
    }
   
    //Finally, destroy the carrier
    carrier.Destroy();
    return item;
}
