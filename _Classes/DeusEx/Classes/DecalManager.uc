//=============================================================================
// Decal Manager
//=============================================================================

// SARGE: This is likely the hackiest thing I will ever do.
// Decals aren't supported server-side, so we've gotta recreate them....
// what a mess...

class DecalManager extends Actor;

struct DecalInfo
{
    var class<DeusExDecal> decalClass;
    var vector decalPos;
    var float drawScale;
    var float maxDrawScale;
    var Rotator decalRot;
    var Actor owner;
    var float lifespan;
};

var private int totalDecals;
var private int currentDecal;
var private DecalInfo decalInfos[8192];
const MAX_DECALS = 8192;

var private DeusExPlayer player;

//Add a decal to the list of decals
function AddDecal(DeusExDecal decal)
{
    local int re;

    //player.ClientMessage("Adding decal " $ decal $ ", " $ totalDecals);

    decalInfos[currentDecal].decalClass = decal.Class;
    decalInfos[currentDecal].decalPos = decal.Location;
    decalInfos[currentDecal].decalRot = decal.Rotation;
    decalInfos[currentDecal].drawScale = decal.DrawScale;
    decalInfos[currentDecal].owner = decal.Owner;
    decalInfos[currentDecal].lifespan = decal.lifespan;
        
    if (decal.IsA('BloodPool'))
        decalInfos[currentDecal].maxDrawScale = BloodPool(decal).maxDrawScale;

    re = currentDecal;

    if (totalDecals < MAX_DECALS)
        totalDecals++;

    if (currentDecal < MAX_DECALS - 1)
    {
        currentDecal++;
    }
    else
    {
        player.ClientMessage("WRAP AROUND!");
        player.ClientMessage("totalDecals: " $ totalDecals $ ", currentDecal: " $ currentDecal $ ", MAX: " $ MAX_DECALS);
        currentDecal = 0;
    }
    //player.ClientMessage("totalDecals: " $ totalDecals $ ", currentDecal: " $ currentDecal $ ", MAX: " $ MAX_DECALS);
}

function ClearList()
{
    player.ClientMessage("List Cleared");
    totalDecals = 0;
    currentDecal = 0;
    //player.clientmessage("numbers: " $ totalDecals $ ", " $ currentDecal);
}

function Setup(DeusExPlayer P)
{
    local DeusExDecal decal;
    player = P;
    
    foreach AllActors(class'DeusExDecal', decal)
        decal.Destroy();
}

function PopulateDecalsList()
{
    local DeusExDecal decal;
    ClearList();
    foreach AllActors(class'DeusExDecal', decal)
        AddDecal(decal);
}

function int GetTotalDecals()
{
    return totalDecals;
}

function RecreateDecals(optional int startAt, optional int num)
{
    local DeusExDecal decal;

    local int index;
        
    //Allow batching
    if (num == 0)
        num = totalDecals;

    num += startAt;

    if (num > totalDecals)
        num = totalDecals;

    player.clientmessage("Recreating decals: " $ startAt $ "-" $ num);

    for(index = startAt;index < num;index++)
    {

        decal = spawn(decalInfos[index].decalClass,decalInfos[index].owner,, decalInfos[index].decalPos, decalInfos[index].decalRot);
        decal.drawScale = decalInfos[index].drawScale;
        decal.lifespan = decalInfos[index].lifespan;
        
        log("Recreating decal " $ index $ ": " $ decal.class);
        //player.clientmessage("Recreating decal " $ decal.class);

        if (decal.IsA('BloodPool'))
        {
            //Make them redraw at full size instantly
            BloodPool(decal).maxDrawScale = decalInfos[index].maxDrawScale;
            BloodPool(decal).spreadTime = 0.00001;
        }

        decal.ReattachDecal();
    }
    //player.clientmessage("numbers: " $ totalDecals $ ", " $ currentDecal);
}

defaultproperties
{
    bHidden=True
}
