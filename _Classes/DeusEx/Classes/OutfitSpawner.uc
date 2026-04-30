//=============================================================================
// OutfitSpawner
// Spawns an outfit, or does nothing depending on if the outfits mod is installed.
//=============================================================================
class OutfitSpawner extends DeusExDecoration;

var(Augmentique) const string id; //IDs of the outfit to spawn
var(Augmentique) const string LookupTexture;              //This lets us use textures contained within Augmentique.u without having it as a dependency,
                                                          //which will let us play maps containing spawners without Augmentique installed

var(Augmentique) const string LinkedObjects[5];           //If this object is removed for being invalid, all linked objects will also be removed

var(Augmentique) const string requiredFlag;               //If required flag is set, then this flag must be true for the object to appear. Checked on a timer.
var(Augmentique) const bool requiredFlagInverted;         //If required flag is set, then it must be FALSE instead of TRUE

var OutfitManagerBase outfitManager;

function Frob(Actor Frobber, Inventory frobWith)
{
    outfitManager.spawnerPickup(self);
}

static function ShowObj(Actor obj)
{
    obj.DrawScale = obj.default.DrawScale;
    obj.SetCollision(obj.default.bCollideActors, obj.default.bBlockActors, obj.default.bBlockPlayers);
    obj.SetCollisionSize(obj.default.CollisionRadius,obj.default.CollisionHeight);
    obj.LightType=obj.default.LightType;
    obj.SetPhysics(obj.default.Physics);
}

static function HideObj(Actor obj)
{
    obj.DrawScale = 0.00001;
    obj.SetCollision(false,false,false);
    obj.SetCollisionSize(0,0);
    obj.LightType=LT_None;
    obj.SetPhysics(PHYS_None);
}

function ShowLinkedObjects(bool bShow)
{
    local Actor a;
    local int i;

    //Hide objects linked to spawner
    foreach AllActors(class'Actor', a)
    {
        for(i = 0;i < ArrayCount(LinkedObjects);i++)
        {
            if (LinkedObjects[i] != "" && LinkedObjects[i] == string(a.Name))
            {
                if (bShow)
                    ShowObj(a);
                else
                    HideObj(a);
            }
        }
    }
}

//If the outfit is invalid, hide it.
function ShowSpawner(bool bShow)
{
    if (bShow)
    {
        ShowLinkedObjects(true);
        ShowObj(self);
    }
    else
    {
        ShowLinkedObjects(false);
        HideObj(self);
    }
}

defaultproperties
{
     bBlockPlayers=false;
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
