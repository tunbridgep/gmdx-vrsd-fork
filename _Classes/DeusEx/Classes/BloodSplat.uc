//=============================================================================
// BloodSplat.
//=============================================================================
class BloodSplat extends DeusExDecal;

function BeginPlay()
{
	local Rotator rot;
	local float rnd;

	// Gore check
	if (Level.Game.bLowGore || Level.Game.bVeryLowGore)
	{
		Destroy();
		return;
	}

	rnd = FRand();
	if (rnd < 0.25)
		Texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXTex2","DeusExItems.Skins.FlatFXTex2",IsHDTP());
	else if (rnd < 0.5)
		Texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXTex5","DeusExItems.Skins.FlatFXTex5",IsHDTP());
	else if (rnd < 0.75)
		Texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXTex6","DeusExItems.Skins.FlatFXTex6",IsHDTP());

	DrawScale += FRand() * 0.12;  //better textures can cope with greater size variation -DDL

	Super.BeginPlay();
}

defaultproperties
{
     MultiDecalLevel=2
     HDTPTexture="HDTPItems.Skins.HDTPFlatFXtex2"
     HDTPDrawScale=0.025000
     Texture=Texture'DeusExItems.Skins.FlatFXTex2'
     DrawScale=0.200000
}
