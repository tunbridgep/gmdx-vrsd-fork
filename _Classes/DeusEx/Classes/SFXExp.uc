//=============================================================================
// ExplosionLarge.
//=============================================================================
class SFXExp extends AnimatedSprite;

var float scaleFactor;
var float scaleFactor2;
var float GlowFactor;

	simulated function Tick(float deltaTime)
{
	time += deltaTime;
	totalTime += deltaTime;

	DrawScale = (0.2*ScaleFactor) + ((1*scaleFactor2) * totalTime / duration); //CyberP: 0.9 was 0.5 & 6.0 was 3.0
	ScaleGlow = GlowFactor*(duration - totalTime) / duration;

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
     scaleFactor=1.000000
     scaleFactor2=1.000000
     GlowFactor=0.800000
     animSpeed=0.140000
     numFrames=12
     frames(0)=Texture'GMDXSFX.Effects.ef_ExpSmoke001'
     frames(1)=Texture'GMDXSFX.Effects.ef_ExpSmoke002'
     frames(2)=Texture'GMDXSFX.Effects.ef_ExpSmoke003'
     frames(3)=Texture'GMDXSFX.Effects.ef_ExpSmoke004'
     frames(4)=Texture'GMDXSFX.Effects.ef_ExpSmoke005'
     frames(5)=Texture'GMDXSFX.Effects.ef_ExpSmoke006'
     frames(6)=Texture'GMDXSFX.Effects.ef_ExpSmoke007'
     frames(7)=Texture'GMDXSFX.Effects.ef_ExpSmoke008'
     frames(8)=Texture'GMDXSFX.Effects.ef_ExpSmoke009'
     frames(9)=Texture'GMDXSFX.Effects.ef_ExpSmoke010'
     frames(10)=Texture'GMDXSFX.Effects.ef_ExpSmoke011'
     frames(11)=Texture'GMDXSFX.Effects.ef_ExpSmoke012'
     Texture=Texture'GMDXSFX.Effects.ef_ExpSmoke001'
}
