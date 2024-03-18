//=============================================================================
// BloodSpurt.
//=============================================================================
class SFXExplosionLarge extends AnimatedSprite;

simulated function PostBeginPlay()
{
local SFXExp exp;

	Super.PostBeginPlay();

	exp = Spawn(class'SFXExp');
	if (exp != none)
	exp.scaleFactor = 15;
}

simulated function Tick(float deltaTime)
{
	time += deltaTime;
	totalTime += deltaTime;

	DrawScale = 0.9 + (6.0 * totalTime / duration); //CyberP: 0.9 was 0.5 & 6.0 was 3.0
	ScaleGlow = ((duration*2) - totalTime) / (duration*2);

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
     animSpeed=0.030000
     numFrames=24
     frames(0)=Texture'GMDXSFX.Effects.ef_ExLrg001'
     frames(1)=Texture'GMDXSFX.Effects.ef_ExLrg002'
     frames(2)=Texture'GMDXSFX.Effects.ef_ExLrg003'
     frames(3)=Texture'GMDXSFX.Effects.ef_ExLrg004'
     frames(4)=Texture'GMDXSFX.Effects.ef_ExLrg005'
     frames(5)=Texture'GMDXSFX.Effects.ef_ExLrg006'
     frames(6)=Texture'GMDXSFX.Effects.ef_ExLrg007'
     frames(7)=Texture'GMDXSFX.Effects.ef_ExLrg008'
     frames(8)=Texture'GMDXSFX.Effects.ef_ExLrg009'
     frames(9)=Texture'GMDXSFX.Effects.ef_ExLrg010'
     frames(10)=Texture'GMDXSFX.Effects.ef_ExLrg011'
     frames(11)=Texture'GMDXSFX.Effects.ef_ExLrg012'
     frames(12)=Texture'GMDXSFX.Effects.ef_ExLrg013'
     frames(13)=Texture'GMDXSFX.Effects.ef_ExLrg014'
     frames(14)=Texture'GMDXSFX.Effects.ef_ExLrg015'
     frames(15)=Texture'GMDXSFX.Effects.ef_ExLrg016'
     frames(16)=Texture'GMDXSFX.Effects.ef_ExLrg017'
     frames(17)=Texture'GMDXSFX.Effects.ef_ExLrg018'
     frames(18)=Texture'GMDXSFX.Effects.ef_ExLrg019'
     frames(19)=Texture'GMDXSFX.Effects.ef_ExLrg020'
     frames(20)=Texture'GMDXSFX.Effects.ef_ExLrg021'
     frames(21)=Texture'GMDXSFX.Effects.ef_ExLrg022'
     frames(22)=Texture'GMDXSFX.Effects.ef_ExLrg023'
     frames(23)=Texture'GMDXSFX.Effects.ef_ExLrg024'
     Texture=Texture'GMDXSFX.Effects.ef_ExLrg001'
}
