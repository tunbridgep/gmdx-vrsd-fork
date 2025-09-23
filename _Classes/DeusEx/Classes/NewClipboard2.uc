//=============================================================================
// Flask.
// SARGE: The previous developer was a fucking idiot, so this is
// a horrible mess. I have tried to fix it as much as possible...
//=============================================================================
class NewClipboard2 extends InformationDevices;

var() bool              sClip;
var() bool              sClip2;

var transient bool bUpdatedTextTag;

var const localized string TitleText;

//We need to do this
function UpdateTextTag()
{
    local DeusExPlayer player;
    local string str;

    //Figure out our texttag based on our passed in HackText
    //This is a holdover from GMDX v9 where it used strings instead of a text package.
    if (textTag == '')
    {
        player = DeusExPlayer(GetPlayerPawn());
        if (player != None && player.flagBase != None)
        {
            str = "Clipboard";

            if (sClip)
                str = str $ "01";
            
            if (sClip2)
                str = str $ "02";

            textTag = player.flagBase.StringToName(str);
        }
    }
}

//SARGE: Fix this!
function string GetItemTitle()
{
    return TitleText;
}

function Tick(float deltaTime)
{
    super.Tick(deltaTime);

    if (!bUpdatedTextTag)
        UpdateTextTag();

    bUpdatedTextTag = true;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     TextPackage="GMDXText"
     TitleText="Orders"
     HitPoints=10
     FragType=Class'DeusEx.WoodFragment'
     bCanBeBase=True
     ItemName="Clipboard"
     bPushable=False
     Mesh=LodMesh'GameMedia.Clipboard2'
     CollisionRadius=11.500000
     CollisionHeight=0.800000
     Mass=8.000000
     Buoyancy=3.000000
}
