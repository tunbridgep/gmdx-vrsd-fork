//=============================================================================
// ScorchMark.
//=============================================================================
class ScorchMark extends DeusExDecal;

function BeginPlay()
{
	if (FRand() < 0.5)
		texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex39","DeusExItems.Skins.FlatFXTex39",IsHDTP());
;
	Super.BeginPlay();
}

defaultproperties
{
     HDTPTexture="HDTPItems.Skins.HDTPFlatFXtex38"
	 Texture=Texture'DeusExItems.Skins.FlatFXTex38'
     HDTPDrawScale=0.046250
}
