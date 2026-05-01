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
	rnd = FRand();
	if(rnd < 0.1)
		rnd = 0.2;

	if (IsHDTP())
		randomScale = rnd * 0.09;
	else if (IsNewBlood())
		randomScale = rnd * -0.45;
	else //vanilla but bigger
		randomScale = rnd * 0.05;

	Super.BeginPlay();
}

function DoHDTP()
{
    super.DoHDTP();
    switch (bloodTex)
    {
        case 0: Texture = class'HDTPLoader'.static.GetTexture3("HDTPItems.Skins.HDTPFlatFXtex2","RSDCrap.Blood.FlatFXTex2","DeusExItems.Skins.FlatFXTex2",IsHDTP(),IsNewBlood()); break;
        case 1: Texture = class'HDTPLoader'.static.GetTexture3("HDTPItems.Skins.HDTPFlatFXtex3","RSDCrap.Blood.FlatFXTex3","DeusExItems.Skins.FlatFXTex3",IsHDTP(),IsNewBlood()); break;
		case 2: Texture = class'HDTPLoader'.static.GetTexture3("HDTPItems.Skins.HDTPFlatFXtex5","RSDCrap.Blood.FlatFXTex5","DeusExItems.Skins.FlatFXTex5",IsHDTP(),IsNewBlood()); break;
		case 3: Texture = class'HDTPLoader'.static.GetTexture3("HDTPItems.Skins.HDTPFlatFXtex6","RSDCrap.Blood.FlatFXTex6","DeusExItems.Skins.FlatFXTex6",IsHDTP(),IsNewBlood()); break;
    }

    DrawScale += randomScale;  //better textures can cope with greater size variation -DDL
}

defaultproperties
{
     MultiDecalLevel=2
     HDTPTexture="HDTPItems.Skins.HDTPFlatFXtex2"
     HDTPDrawScale=0.005000
     Texture=Texture'DeusExItems.Skins.FlatFXTex2'
     DrawScale=0.450000
}
