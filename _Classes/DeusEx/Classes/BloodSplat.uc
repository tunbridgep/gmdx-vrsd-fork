//=============================================================================
// BloodSplat.
//=============================================================================
class BloodSplat extends DeusExDecal;

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

exec function UpdateHDTPsettings()
{
	local Rotator rot;
	local float rnd;

    super.UpdateHDTPsettings();
	rnd = FRand();
	if (rnd < 0.25)
		Texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex3","DeusExItems.Skins.FlatFXTex3",IsHDTP());
	else if (rnd < 0.5)
		Texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex5","DeusExItems.Skins.FlatFXTex5",IsHDTP());
	else if (rnd < 0.75)
		Texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex6","DeusExItems.Skins.FlatFXTex6",IsHDTP());

    //if (IsHDTP()) //SARGE: Turns out the crappy texture can cope too!
        DrawScale += FRand() * 0.12;  //better textures can cope with greater size variation -DDL

}

defaultproperties
{
     MultiDecalLevel=2
     HDTPTexture="HDTPItems.Skins.HDTPFlatFXtex2"
     HDTPDrawScale=0.025000
     Texture=Texture'DeusExItems.Skins.FlatFXTex2'
     DrawScale=0.250000
}
