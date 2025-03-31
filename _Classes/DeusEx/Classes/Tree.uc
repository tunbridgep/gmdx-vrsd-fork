//=============================================================================
// Tree.
//=============================================================================
class Tree extends OutdoorThings
	abstract;

//SARGE: Handle special LOD.
//If we have a HDTP mesh, automatically switch from it
//when we're too far away.
//The HDTP tree meshes are AWFUL for performance, hopefully this
//can fix it up a bit.
var DeusExPlayer player;
var bool closeEnough;
var bool previouslyCloseEnough;

var string Altmesh;

var() float soundFreq;		// chance of making a sound every 5 seconds

//Account for our janky LOD system...
exec function UpdateHDTPsettings()
{
    if (bHDTPFailsafe)
        Super.UpdateHDTPsettings();
    else
    {
        if (HDTPMesh != "")
            Mesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),IsHDTP() && closeEnough);
        if (HDTPSkin != "")
            Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),IsHDTP() && closeEnough);
        if (HDTPTexture != "")
            Texture = class'HDTPLoader'.static.GetTexture2(HDTPTexture,string(default.Texture),IsHDTP() && closeEnough);

        if (IsHDTP() && altmesh != "" && closeEnough)
        {
            if(location.X + location.Y %2 > 0)
            {
                mesh = class'HDTPLoader'.static.GetMesh(altmesh);
                multiskins[2] = class'HDTPLoader'.static.GetTexture("HDTPDecos.HDTPTreeTex3");
            }
            else
                multiskins[2] = class'HDTPLoader'.static.GetTexture("HDTPDecos.HDTPTreeTex2");
        }
    }
}

//SARGE: Automatically use the non-HDTP mesh if we're too far away
simulated function Tick(float deltaTime)
{
    Super.Tick(deltaTime);

    if (HDTPMesh == "" || !class'DeusExPlayer'.static.IsHDTPInstalled())
        return;

    if (player == None)
        player = DeusExPlayer(GetPlayerPawn());

    if (player != None)
    {
        //Get distances, if it's less than 3500 units, or we're in a different zone, change to the HDTP model
        //NOTE: HDTP Model Toggle 1 is "optimised" mode, model 2 is the standard model but without the janky LOD system.
        closeEnough = iHDTPModelToggle != 1 || (player.headregion.zoneNumber == region.zoneNumber && VSize(player.Location - Location) < 3500);
        if (closeEnough != previouslyCloseEnough)
            UpdateHDTPSettings();

        //bUnlit = !closeEnough || !IsHDTP();
        //bUnlit = true;
        bUnlit = false;

        previouslyCloseEnough = closeEnough;
    }
}


function Timer()
{
	if (FRand() < soundFreq)
	{
		// play wind sounds at random pitch offsets
		if (FRand() < 0.5)
			PlaySound(sound'WindGust1', SLOT_Misc,,, 2048, 0.7 + 0.6 * FRand());
		else
			PlaySound(sound'WindGust2', SLOT_Misc,,, 2048, 0.7 + 0.6 * FRand());
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(4.0 + 2.0 * FRand(), True);
}

defaultproperties
{
     soundFreq=0.200000
     ItemName="Tree"
     bStatic=False
     Mass=2000.000000
     Buoyancy=5.000000
	 bHDTPFailsafe=False
     bHDTPOptimisation=True
}
