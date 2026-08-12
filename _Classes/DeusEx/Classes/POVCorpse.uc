//=============================================================================
// POVCorpse.
//=============================================================================
class POVCorpse extends DeusExPickup;

var travel String carcClassString;
var travel String KillerBindName;
var travel Name   CarcassTag; //cyberp
var travel Name   KillerAlliance;
var travel Name   Alliance;
var travel bool   bNotDead;
var travel bool   bEmitCarcass;
var travel int    CumulativeDamage;
var travel int    MaxDamage;
var travel string CorpseItemName;
var travel Name   CarcassName;
var travel Inventory Inv;
var Texture pMultitex[8];
var bool    bHasSkins;

//GMDX

var string savedName;                                                           //SARGE: vRSD seemingly forgot to add this?

//SARGE: Weapon Offset Stuff
var ViewmodelFOVManager FOVManager;                                      //SARGE: Manage Viewmodel FOV
var const vector weaponOffsets;                                                 //Sarge: Our weapon offsets. Leave at (0,0,0) to disable using offsets
var const vector OldPlayerViewOffset;

var travel bool bSearched;                                                      //Sarge: Carried over from Carcasses so they are retained when we make a new one by putting the corpse down
var travel int PickupAmmoCount;                                                 //Sarge: Carried over from Carcasses so they are retained when we make a new one by putting the corpse down

var travel bool bFirstBloodPool;                                                //SARGE: Stores whether or not the carcass has created a blood pool yet.
var travel bool bNoDefaultPools;                                                //SARGE: If set, don't make pools at all, unless we receive gunshot wounds or the corpse is otherwise damaged.

var string carcassID;                                                           //SARGE: Unique identifier per carcass. Kept when picking up and putting down

//END GMDX:

//Augmentique Data
//Now that pawns can have custom outfits, we need to store the outfit data
//when we pick it up, so we can restore it when we put it down.
struct AugmentiqueCarcassData
{
    var Texture textures[9];
    var bool bRandomized;
    var bool bUnique;
};

var travel AugmentiqueCarcassData augmentiqueData;

//Function to fix weapon offsets
function DoWeaponOffset()
{
    FOVManager.SetViewmodelOffset(Self);
}

//SARGE: Called when the item is added to the players hands
function Draw(DeusExPlayer frobber)
{
    SetWeaponHandTex();
    DoWeaponOffset();
}

function Display(bool overlay)
{
    super.Display(overlay);

    if (overlay)
        Multiskins[1] = handsTex;
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
    if (FOVManager == None)
        FOVManager = new(Self) class'ViewmodelFOVManager';
    DoWeaponOffset();
}

simulated event RenderOverlays( canvas Canvas )
{
    //SARGE: TODO: Allow setting POV skins
    //multiskins[0] = POVSkin;
    multiskins[1] = handstex;
    
    super.RenderOverlays(canvas);
    multiskins[1] = none;
}

function Destroyed()
{
    CriticalDelete(FOVManager);
    FOVManager = None;
	Super.Destroyed();
}

defaultproperties
{
     weaponOffsets=(X=15.00,Y=15.00,Z=-5.00)
     MaxDamage=10
     bDisplayableInv=False
     ItemName="body"
     OldPlayerViewOffset=(X=20.000000,Y=13.000000,Z=-5.000000)
     PlayerViewOffset=(X=20.000000,Y=13.000000,Z=-5.000000)
     PlayerViewMesh=LodMesh'DeusExItems.POVCorpse'
     PickupViewMesh=LodMesh'DeusExItems.TestBox'
     LandSound=Sound'DeusExSounds.Generic.FleshHit1'
     Mesh=LodMesh'DeusExItems.TestBox'
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     Mass=40.000000
     Buoyancy=30.000000
}
