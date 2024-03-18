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
		Texture = Texture'HDTPItems.Skins.HDTPFlatFXTex3';
	else if (rnd < 0.5)
		Texture = Texture'HDTPItems.Skins.HDTPFlatFXTex5';
	else if (rnd < 0.75)
		Texture = Texture'HDTPItems.Skins.HDTPFlatFXTex6';

	DrawScale += FRand() * 0.12;  //better textures can cope with greater size variation -DDL

	Super.BeginPlay();
}

defaultproperties
{
     MultiDecalLevel=2
     Texture=Texture'HDTPItems.Skins.HDTPFlatFXtex2'
     DrawScale=0.025000
}
