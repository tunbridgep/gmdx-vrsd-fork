//=============================================================================
// BloodMeleeHit //CyberP: used when shot too, not just melee
//=============================================================================
class BloodMeleeHit extends GMDXEffect;

simulated function PreBeginPlay()
{
	local Rotator rota;

	Super.PreBeginPlay();

	rota = Rotation;
	rota.Yaw += 32768.0;
	SetRotation(rota);
}

function BeginPlay()
{
	// Gore check
	if (Level.Game.bLowGore || Level.Game.bVeryLowGore)
		Destroy();
}

simulated function Tick(float deltaTime)
{
	DrawScale *= 1.1;
}

defaultproperties
{
     LifeSpan=0.200000
     DrawType=DT_Sprite
     Style=STY_Modulated
     HDTPTexture="HDTPItems.Skins.HDTPFlatFXtex2"
	 Texture=Texture'DeusExItems.Skins.FlatFXtex2'
     DrawScale=0.050000
     ScaleGlow=2.000000
     bUnlit=True
     Mass=0.000000
}
