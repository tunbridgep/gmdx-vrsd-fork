//=============================================================================
// ScorchMark.
//=============================================================================
class ScorchMark extends DeusExDecal;

function BeginPlay()
{
	if (FRand() < 0.5)
		texture = Texture'HDTPItems.Skins.HDTPFlatFXTex39';
	Super.BeginPlay();
}

defaultproperties
{
     Texture=Texture'HDTPItems.Skins.HDTPFlatFXtex38'
     DrawScale=0.046250
}
