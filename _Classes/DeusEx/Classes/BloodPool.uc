//=============================================================================
// BloodPool.
//=============================================================================
class BloodPool extends ScaledDecal;

function BeginPlay()
{
	// Gore check
	if (Level.Game.bLowGore || Level.Game.bVeryLowGore)
	{
		Destroy();
		return;
	}
	Super.BeginPlay();
}

function DoHDTP()
{
    super.DoHDTP();
    if (IsHDTP())
        spreadTime=4.000000;
    else
        spreadTime=5.000000;
}

defaultproperties
{
     spreadTime=5.000000
     maxDrawScale=1.5
     HDTPTexture="HDTPItems.Skins.HDTPFlatFXtex1"
     Texture=Texture'DeusExItems.Skins.FlatFXTex1'
     maxDrawScaleDivisor=40
     maxDrawScaleDivisorHDTP=640
}
