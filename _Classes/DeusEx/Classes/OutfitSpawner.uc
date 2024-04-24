//=============================================================================
// OutfitSpawner
// Spawns an outfit, or does nothing depending on if the outfits mod is installed.
//=============================================================================
class OutfitSpawner extends DeusExDecoration;

var(JCOutfits) const string id; //IDs of the outfit to spawn
var(JCOutfits) const string itemArticle;
var(JCOutfits) const string PickupMessage;
var(JCOutfits) const string PickupName;

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
     ItemName="Fashionable Outfit"
     PickupMessage="You found"
     ItemArticle="a"
     bHighlight=True
     CollisionRadius=13.000000
     CollisionHeight=64.750000
     Mass=60.000000
     Buoyancy=70.000000
     //Physics=PHYS_Falling
}
