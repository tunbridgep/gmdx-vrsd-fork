//=============================================================================
// OutfitSpawner
// Spawns an outfit, or does nothing depending on if the outfits mod is installed.
//=============================================================================
class OutfitSpawner extends DeusExDecoration;

var(JCOutfits) const string id; //IDs of the outfit to spawn
var(JCOutfits) const string itemArticle;
var(JCOutfits) const string PickupMessage;
var(JCOutfits) const string PickupName;

function Timer()
{
    local DeusExPlayer P;
    P = DeusExPlayer(GetPlayerPawn());
    if (P == None || P.OutfitManager == None || !P.OutfitManager.ValidateSpawn(id))
        Destroy();
    
    if (PickupName == "")
        ItemName = P.OutfitManager.GetOutfitNameByID(id);
    else
        ItemName = PickupName;
}

function PostPostBeginPlay()
{
    SetTimer(1.0, False);
    Super.PostPostBeginPlay();
}

function Frob(Actor Frobber, Inventory frobWith)
{
    local DeusExPlayer P;
    
    P = DeusExPlayer(Frobber);
    if (P != None && P.OutfitManager != None)
    {
        P.ClientMessage(PickupMessage @ itemArticle @ ItemName , 'Pickup');
        P.OutfitManager.Unlock(id);
        Destroy();
    }
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
