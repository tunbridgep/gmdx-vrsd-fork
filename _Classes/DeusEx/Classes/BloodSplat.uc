//=============================================================================
// BloodSplat.
//=============================================================================
class BloodSplat extends DeusExDecal;

var int bloodTex;
var float randomScale;

function BeginPlay()
{
	local float rnd;

	// Gore check
	if (Level.Game.bLowGore || Level.Game.bVeryLowGore)
	{
		Destroy();
		return;
	}

	rnd = FRand();
    
    if (rnd < 0.25)
        bloodTex = 1;
	else if (rnd < 0.5)
        bloodTex = 2;
	else if (rnd < 0.75)
        bloodTex = 3;
    
    //better textures can cope with greater size variation -DDL
    //SARGE: Turns out the vanilla textures can cope too!
    randomScale = FRand() * 0.12;

	Super.BeginPlay();
}

function DoHDTP()
{
    super.DoHDTP();
    switch (bloodTex)
    {
        case 1: Texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex3","DeusExItems.Skins.FlatFXTex3",IsHDTP()); break;
		case 2: Texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex5","DeusExItems.Skins.FlatFXTex5",IsHDTP()); break;
		case 3: Texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex6","DeusExItems.Skins.FlatFXTex6",IsHDTP()); break;
    }

    DrawScale += randomScale;  //better textures can cope with greater size variation -DDL

}

defaultproperties
{
     MultiDecalLevel=2
     HDTPTexture="HDTPItems.Skins.HDTPFlatFXtex2"
     HDTPDrawScale=0.025000
     Texture=Texture'DeusExItems.Skins.FlatFXTex2'
     DrawScale=0.450000
}
