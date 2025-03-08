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
var private DecalInfo decalInfos[16384];
const MAX_DECALS = 16384;

var private DeusExPlayer player;

//Add a decal to the list of decals
function AddDecal(DeusExDecal decal)
{
    local int re;
    local int max;

    //player.ClientMessage("Adding decal " $ decal $ ", " $ totalDecals);

    if (decal == None || decal.bHidden)
        return;
    
    decalInfos[currentDecal].decalClass = decal.Class;
    decalInfos[currentDecal].decalPos = decal.Location;
    decalInfos[currentDecal].decalRot = decal.Rotation;
    decalInfos[currentDecal].drawScale = decal.DrawScale;
    decalInfos[currentDecal].owner = decal.Owner;
    decalInfos[currentDecal].lifespan = decal.lifespan;
        
    if (decal.IsA('ScaledDecal'))
        decalInfos[currentDecal].maxDrawScale = ScaledDecal(decal).GetMaxDrawScale();

    re = currentDecal;

    //log ("Decal added: " $ decal.Class);

    //Set the max number of decals based on our decals setting
    if (player.iPersistentDebris == 0)
        return;
    else if (player.iPersistentDebris <= 2)
        max = 2048;
    else if (player.iPersistentDebris == 3)
        max = 4096;
    else if (player.iPersistentDebris == 4)
        max = 8192;
    else if (player.iPersistentDebris == 5)
        max = MAX_DECALS;


    if (totalDecals < max)
        totalDecals++;

    if (currentDecal < max - 1)
    {
        currentDecal++;
    }
    else
    {
        //player.ClientMessage("WRAP AROUND!");
        //player.ClientMessage("totalDecals: " $ totalDecals $ ", currentDecal: " $ currentDecal $ ", MAX: " $ MAX_DECALS);
        currentDecal = 0;
    }
    //player.ClientMessage("totalDecals: " $ totalDecals $ ", currentDecal: " $ currentDecal $ ", MAX: " $ MAX_DECALS);
}

function ClearList()
{
    //player.ClientMessage("List Cleared");
    totalDecals = 0;
    currentDecal = 0;
    //player.clientmessage("numbers: " $ totalDecals $ ", " $ currentDecal);
}

function Setup(DeusExPlayer P)
{
    player = P;
}

function HideAllDecals()
{
    local DeusExDecal decal;
    foreach AllActors(class'DeusExDecal', decal)
        //decal.Destroy();
        decal.bHidden = true; //DO NOT USE DESTROY, it randomly breaks the game and stops games from loading!
}

function PopulateDecalsList()
{
    local DeusExDecal decal;
    ClearList();
    foreach AllActors(class'DeusExDecal', decal)
    {
        if (player.iPersistentDebris > 1 || decal.IsA('BloodPool'))
            AddDecal(decal);
    }
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

    //player.clientmessage("Recreating decals: " $ startAt $ "-" $ num);

    //log("RecreateDecals: " $ startAt $ ", " $ num);

    for(index = startAt;index < num;index++)
    {

        decal = spawn(decalInfos[index].decalClass,decalInfos[index].owner,, decalInfos[index].decalPos, decalInfos[index].decalRot);
        decal.drawScale = decalInfos[index].drawScale;
        decal.lifespan = decalInfos[index].lifespan;
        decal.bInitialHDTPUpdate = false;
        
        //log("Recreating decal " $ index $ ": " $ decal.class);
        //player.clientmessage("Recreating decal " $ decal.class);

        if (decal.IsA('ScaledDecal'))
        {
            //Make them redraw at full size instantly
            ScaledDecal(decal).SetMaxDrawScale(decalInfos[index].maxDrawScale);
            ScaledDecal(decal).UpdateHDTPsettings();
            ScaledDecal(decal).spreadTime = 0.00001;
        }
        else
        {
            //decal.ReattachDecal();
            decal.UpdateHDTPsettings();
        }
    }
    //player.clientmessage("numbers: " $ totalDecals $ ", " $ currentDecal);
}

defaultproperties
{
    bHidden=True
}
