//=============================================================================
// OutfitSpawner
// Spawns an outfit, or does nothing depending on if the outfits mod is installed.
//=============================================================================
class OutfitSpawner extends DeusExDecoration;

var(Augmentique) const string id; //IDs of the outfit to spawn
var(Augmentique) const string LookupTexture;              //This lets us use textures contained within Augmentique.u without having it as a dependency,
                                                          //which will let us play maps containing spawners without Augmentique installed

var(Augmentique) const string LinkedObjects[5];           //If this object is removed for being invalid, all linked objects will also be removed

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
     //ItemName="Augmentique Collectable"
     bHighlight=True
     CollisionRadius=13.000000
     CollisionHeight=64.750000
     Mass=60.000000
     Buoyancy=70.000000
     //Physics=PHYS_Falling
}
