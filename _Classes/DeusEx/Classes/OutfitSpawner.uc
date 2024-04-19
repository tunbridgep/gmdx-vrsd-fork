//=============================================================================
// OutfitSpawner
// Spawns an outfit, or does nothing depending on if the outfits mod is installed.
//=============================================================================
class OutfitSpawner extends ClothesRack;

var(JCOutfits) const string id; //IDs of the outfit to spawn
var(JCOutfits) const string itemArticle;
var(JCOutfits) const string PickupMessage;

function Timer()
{
    local DeusExPlayer P;
    P = DeusExPlayer(GetPlayerPawn());
    if (P == None || P.OutfitManager == None)
        Destroy();
}

function PostPostBeginPlay()
{
    SetTimer(0.1, True);
    Super.PostPostBeginPlay();
}

function Frob(Actor Frobber, Inventory frobWith)
{
    local DeusExPlayer P;
    
    P = DeusExPlayer(Frobber);
    if (P != None && P.OutfitManager != None)
    {
        P.ClientMessage(PickupMessage @ itemArticle @ P.OutfitManager.GetOutfitNameByID(id), 'Pickup');
        P.OutfitManager.Unlock(id);
        Destroy();
    }
}

defaultproperties
{
     ItemName="Fashionable Outfit"
     PickupMessage="You found"
     ItemArticle="a"
     bHighlight=True
}
