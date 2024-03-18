//=============================================================================
// BloodMeleeHit //CyberP: used when shot too, not just melee
//=============================================================================
class BloodExplodeHit extends Effects;

simulated function Tick(float deltaTime)
{
	DrawScale -= 0.0275;//2 * (Default.LifeSpan - LifeSpan) / Default.LifeSpan;
	//ScaleGlow = LifeSpan / Default.LifeSpan;
}

defaultproperties
{
     LifeSpan=0.325000
     DrawType=DT_Sprite
     Style=STY_Modulated
     Texture=Texture'HDTPItems.Skins.HDTPFlatFXtex6'
     DrawScale=0.550000
     ScaleGlow=2.000000
     bUnlit=True
     Mass=0.000000
}
