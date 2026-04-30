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
var private travel string copiedData[53];

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
    local AugmentationCannister Can;
    local Credits CR;
    
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
    Can = AugmentationCannister(item);
    CR = Credits(item);

    if (A != None) //Ammo is super easy, just store the amount
    {
        carrier.copiedData[0] = string(A.AmmoAmount);
    }
    else if (Can != None) //Cannisters need to store both their relevant augs
    {
        carrier.copiedData[0] = string(Can.AddAugs[0]);
        carrier.copiedData[1] = string(Can.AddAugs[1]);
        carrier.copiedData[2] = string(Can.AugListNum);

    }
    else if (CR != None) //Copy over the credits amount
    {
        carrier.copiedData[0] = string(CR.numCredits);
    }
    else if (P != None) //For DeusExPickups, store the numCopies, charge and the skin information.
    {
        carrier.copiedData[0] = string(P.numCopies);
        carrier.copiedData[1] = string(P.Charge);
        carrier.copiedData[2] = string(P.textureSet);

        for (i = 0;i < 50;i++)
            carrier.copiedData[3+i] = string(P.PickUpList[i]);
    }
    else if (W != None) //For DeusExWeapons, store the pickupammocount, clipcount and the weapon mod information.
    {

        //These are based off the CopyModsFrom function in DeusExWeapon.uc
        //If that's wrong, then this is also wrong.
        carrier.copiedData[0] = string(W.pickupAmmoCount);
        carrier.copiedData[1] = string(int(W.bModified));
        carrier.copiedData[2] = string(W.ClipCount);
        carrier.copiedData[3] = string(W.ModBaseAccuracy);
        carrier.copiedData[4] = string(W.ModReloadCount);
        carrier.copiedData[5] = string(W.ModAccurateRange);
        carrier.copiedData[6] = string(W.ModReloadTime);
        carrier.copiedData[7] = string(W.ModRecoilStrength);
        carrier.copiedData[8] = string(int(W.bHadLaser));
        carrier.copiedData[9] = string(int(W.bHadSilencer));
        carrier.copiedData[10] = string(int(W.bHadScope));
        carrier.copiedData[11] = string(int(W.bHasLaser));
        carrier.copiedData[12] = string(int(W.bHasSilencer));
        carrier.copiedData[13] = string(int(W.bHasScope));
        carrier.copiedData[14] = string(int(W.bFullAuto));
        carrier.copiedData[15] = string(W.ReloadCount);
        carrier.copiedData[16] = string(W.AccurateRange);
        carrier.copiedData[17] = string(W.BaseAccuracy);
        carrier.copiedData[18] = string(W.ReloadTime);
        carrier.copiedData[19] = string(W.RecoilStrength);
        carrier.copiedData[20] = string(W.ModShotTime);
        carrier.copiedData[21] = string(W.ModDamage);
        
        //If we're using the GL, we need to copy the old values instead
        //This is a dirty, disgusting, filthy, garbage hack!
        if (W.AmmoName == class'Ammo20mm')
        {
            carrier.copiedData[2] = string(W.ARLoaded);
            carrier.copiedData[15] = string(W.ARClipSize);
        }

        //DTS Charge
        if (WeaponNanoSword(W) != None)
            carrier.copiedData[22] = string(WeaponNanoSword(W).chargeManager.GetCurrentCharge());

        carrier.copiedData[23] = W.currentWeaponSkin;


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

// ----------------------------------------------------------------------
// Landed()
//
// Called when we hit the ground
// ----------------------------------------------------------------------

function Landed(vector HitNormal)
{
    ActuallyCreateRealObjectFor(self);
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
    local AugmentationCannister Can;
    local Credits CR;
    
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
    Can = AugmentationCannister(item);
    CR = Credits(item);
    
    if (A != None) //Ammo is super easy, just copy the amount
    {
        A.AmmoAmount = int(carrier.copiedData[0]);
    }
    else if (Can != None) //Cannisters need to store both their relevant augs
    {
        Can.SetAugs(carrier.copiedData[0],carrier.copiedData[1]);
        Can.AugListNum = int(carrier.copiedData[2]);
    }
    else if (CR != None) //Copy over the credits amount
    {
        CR.numCredits = int(carrier.copiedData[0]);
    }
    else if (P != None) //For DeusExPickups, copy the numCopies, charge and the skin information.
    {
        P.numCopies = int(carrier.copiedData[0]);
        P.Charge = float(carrier.copiedData[1]);
        P.textureSet = int(carrier.copiedData[2]);

        for (i = 0;i < 50;i++)
            P.PickUpList[i] = int(carrier.copiedData[3+i]);

        P.UpdateHDTPSettings();
    }
    else if (W != None) //For DeusExWeapons, store the pickupammocount, clipcount and the weapon mod information.
    {
        //These are based off the CopyModsFrom function in DeusExWeapon.uc
        //If that's wrong, then this is also wrong.
        W.pickupAmmoCount = int(carrier.copiedData[0]);
        W.bModified = bool(carrier.copiedData[1]);
        W.ClipCount = int(carrier.copiedData[2]);
        W.ModBaseAccuracy = float(carrier.copiedData[3]);
        W.ModReloadCount = float(carrier.copiedData[4]);
        W.ModAccurateRange = float(carrier.copiedData[5]);
        W.ModReloadTime = float(carrier.copiedData[6]);
        W.ModRecoilStrength = float(carrier.copiedData[7]);
        W.bHadLaser = bool(carrier.copiedData[8]);
        W.bHadSilencer = bool(carrier.copiedData[9]);
        W.bHadScope = bool(carrier.copiedData[10]);
        W.bHasLaser = bool(carrier.copiedData[11]);
        W.bHasSilencer = bool(carrier.copiedData[12]);
        W.bHasScope = bool(carrier.copiedData[13]);
        W.bFullAuto = bool(carrier.copiedData[14]);
        W.ReloadCount = int(carrier.copiedData[15]);
        W.AccurateRange = float(carrier.copiedData[16]);
        W.BaseAccuracy = float(carrier.copiedData[17]);
        W.ReloadTime = float(carrier.copiedData[18]);
        W.RecoilStrength = float(carrier.copiedData[19]);
        W.ModShotTime = float(carrier.copiedData[20]);
        W.ModDamage = float(carrier.copiedData[21]);

        //Reset GL stats
        W.ARGLLoaded = 0;

        W.GivenFreeReload = true;
                    
        //Copy any charge from the target
        if (WeaponNanoSword(W) != None)
            WeaponNanoSword(W).chargeManager.SetCharge(int(carrier.copiedData[22]));
        
        W.currentWeaponSkin = carrier.copiedData[23];
        
        W.UpdateSkin();
        W.UpdateHDTPSettings();
    }
   
    //Finally, destroy the carrier
    carrier.Destroy();
    return item;
}
