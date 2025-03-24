//=============================================================================
// ScorchMark.
//=============================================================================
class ScorchMark extends DeusExDecal;

var int scorchTex;

function BeginPlay()
{
        
    if (FRand() < 0.5)
        scorchTex = 0;
    else
        scorchTex = 1;

    super.BeginPlay();
}

function DoHDTP()
{
    Super.DoHDTP();
	if (scorchTex == 1)
		texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex39","DeusExItems.Skins.FlatFXTex39",IsHDTP());
}

defaultproperties
{
     HDTPTexture="HDTPItems.Skins.HDTPFlatFXtex38"
	 Texture=Texture'DeusExItems.Skins.FlatFXTex38'
     HDTPDrawScale=0.046250
}
