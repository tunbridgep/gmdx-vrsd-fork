//=============================================================================
// OutfitSpawner
// Spawns an outfit, or does nothing depending on if the outfits mod is installed.
//=============================================================================
class OutfitSpawner extends DeusExDecoration;

var(Augmentique) const string id; //IDs of the outfit to spawn
var(Augmentique) const localized string PickupMessage;
var(Augmentique) const localized string PickupName;       //Allow us to use a custom Inspect Name
var(Augmentique) const string LookupTexture;              //This lets us use textures contained within JCOutfits.u without having it as a dependency,
                                                          //which will let us play maps containing spawners without Augmentique installed

var OutfitManagerBase outfitManager;

function Frob(Actor Frobber, Inventory frobWith)
{
    outfitManager.spawnerPickup(self);
}

defaultproperties
{
     HitPoints=10
     bPushable=False
     FragType=Class'DeusEx.PaperFragment'
     Texture=Texture'ClothesRackTex1'
     Mesh=LodMesh'DeusExDeco.ClothesRack'
     //ItemName="Fashionable Outfit"
     ItemName="Augmentique Collectable"
     PickupMessage="You found a %s"
     PickupName="%s"
     bHighlight=True
     CollisionRadius=13.000000
     CollisionHeight=64.750000
     Mass=60.000000
     Buoyancy=70.000000
     //Physics=PHYS_Falling
}
