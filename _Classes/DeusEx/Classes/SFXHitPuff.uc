//=============================================================================
// SFXHitPuff.
//=============================================================================
class SFXHitPuff extends AnimatedSprite;

	simulated function Tick(float deltaTime)
{
   if (Region.Zone.bWaterZone)
		Destroy();

	time += deltaTime;
	totalTime += deltaTime;

	DrawScale = 0.15 + (1.5 * totalTime / duration);
	ScaleGlow = (duration - totalTime) / duration;

	if (time >= animSpeed)
	{
		Texture = frames[nextFrame++];
		if (nextFrame >= numFrames)
			Destroy();

		time -= animSpeed;
	}
}

defaultproperties
{
     animSpeed=0.007000
     numFrames=30
     frames(0)=Texture'GMDXSFX.Effects.ef_HitPuff1_001'
     frames(1)=Texture'GMDXSFX.Effects.ef_HitPuff1_002'
     frames(2)=Texture'GMDXSFX.Effects.ef_HitPuff1_003'
     frames(3)=Texture'GMDXSFX.Effects.ef_HitPuff1_004'
     frames(4)=Texture'GMDXSFX.Effects.ef_HitPuff1_005'
     frames(5)=Texture'GMDXSFX.Effects.ef_HitPuff1_006'
     frames(6)=Texture'GMDXSFX.Effects.ef_HitPuff1_007'
     frames(7)=Texture'GMDXSFX.Effects.ef_HitPuff1_008'
     frames(8)=Texture'GMDXSFX.Effects.ef_HitPuff1_009'
     frames(9)=Texture'GMDXSFX.Effects.ef_HitPuff1_010'
     frames(10)=Texture'GMDXSFX.Effects.ef_HitPuff1_011'
     frames(11)=Texture'GMDXSFX.Effects.ef_HitPuff1_012'
     frames(12)=Texture'GMDXSFX.Effects.ef_HitPuff1_013'
     frames(13)=Texture'GMDXSFX.Effects.ef_HitPuff1_014'
     frames(14)=Texture'GMDXSFX.Effects.ef_HitPuff1_015'
     frames(15)=Texture'GMDXSFX.Effects.ef_HitPuff1_016'
     frames(16)=Texture'GMDXSFX.Effects.ef_HitPuff1_017'
     frames(17)=Texture'GMDXSFX.Effects.ef_HitPuff1_018'
     frames(18)=Texture'GMDXSFX.Effects.ef_HitPuff1_019'
     frames(19)=Texture'GMDXSFX.Effects.ef_HitPuff1_020'
     frames(20)=Texture'GMDXSFX.Effects.ef_HitPuff1_021'
     frames(21)=Texture'GMDXSFX.Effects.ef_HitPuff1_022'
     frames(22)=Texture'GMDXSFX.Effects.ef_HitPuff1_023'
     frames(23)=Texture'GMDXSFX.Effects.ef_HitPuff1_024'
     frames(24)=Texture'GMDXSFX.Effects.ef_HitPuff1_025'
     frames(25)=Texture'GMDXSFX.Effects.ef_HitPuff1_026'
     frames(26)=Texture'GMDXSFX.Effects.ef_HitPuff1_027'
     frames(27)=Texture'GMDXSFX.Effects.ef_HitPuff1_028'
     frames(28)=Texture'GMDXSFX.Effects.ef_HitPuff1_029'
     frames(29)=Texture'GMDXSFX.Effects.ef_HitPuff1_030'
     Texture=Texture'GMDXSFX.Effects.ef_HitPuff1_001'
}
