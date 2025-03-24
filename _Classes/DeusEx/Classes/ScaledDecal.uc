//=============================================================================
// ScaledDecal.
// SARGE: Used by WaterPool and BloodPool to generalise resizing
//=============================================================================
class ScaledDecal extends DeusExDecal abstract;

var float spreadTime;
var private float maxDrawScale;
var private float time;
var const float maxDrawScaleDivisor;
var const float maxDrawScaleDivisorHDTP;

function SetMaxDrawScale(float scale)
{
    //DeusExPlayer(GetPlayerPawn()).ClientMessage(maxDrawScaleDivisorHDTP);
    //DeusExPlayer(GetPlayerPawn()).ClientMessage("Setting max draw scale to: " $ scale $ ", which equates to " $ GetMaxDrawScaleModified());
    maxDrawScale = scale;
}

function float GetMaxDrawScale()
{
    return maxDrawScale;
}

function float GetMaxDrawScaleModified()
{
    if (IsHDTP() && maxDrawScaleDivisorHDTP != 0)
        return MaxDrawScale / maxDrawScaleDivisorHDTP;
    else if (maxDrawScaleDivisor != 0)
        return MaxDrawScale / maxDrawScaleDivisor;
    else
        return MaxDrawScale;
}

simulated function Tick(float deltaTime)
{
	time += deltaTime;
	if (time <= spreadTime)
	{
		DrawScale = GetMaxDrawScaleModified() * time / spreadTime;
		ReattachDecal(vect(0.1,0.1,0));
	}
}

//When updating, just set our draw scale without expanding
function DoHDTP()
{
    Super.DoHDTP();

    if (bInitialHDTPUpdate)
        return;

    time = spreadTime + 1;
    DrawScale = GetMaxDrawScaleModified();
}

defaultproperties
{
     spreadTime=1.000000
     maxDrawScale=2.500000
     Texture=Texture'DeusExItems.Skins.FlatFXTex47'
     ScaleGlow=1.400000
}

