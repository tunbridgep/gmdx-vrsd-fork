//=============================================================================
// ExplosionMedium.
//=============================================================================
class ExplosionMedium extends AnimatedSprite;

simulated function PostBeginPlay()
{
	local int i;
	local float shakeTime, shakeRoll, shakeVert;
	local float size;
	local DeusExPlayer player;
	local float dist;
    local SFXExp exp;

	Super.PostBeginPlay();

	exp = Spawn(class'SFXExp');
	if (exp != none)
	   exp.scaleFactor = 9;

        Spawn(class'FireComet', None);
        Spawn(class'FireComet', None);

        Spawn(class'RockchipLarge',None);

        player = DeusExPlayer(GetPlayerPawn());

        if (player!=none)
        {
   		dist = Abs(VSize(player.Location - Location));
   		if (dist < 512)
   		     {
   		        size = (10000 * FRand()) / (1+dist);
   		        if (size > 256)
   		            size = 256;
                shakeTime = 0.4;
                shakeRoll = 128.0 + 224.0 + size;
                shakeVert = 3.0 + 4.0;
                player.ShakeView(shakeTime, shakeRoll, shakeVert);
             }
        }
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
     animSpeed=0.085000
     numFrames=6
     frames(0)=Texture'DeusExItems.Skins.FlatFXTex14'
     frames(1)=Texture'DeusExItems.Skins.FlatFXTex15'
     frames(2)=Texture'DeusExItems.Skins.FlatFXTex16'
     frames(3)=Texture'DeusExItems.Skins.FlatFXTex17'
     frames(4)=Texture'DeusExItems.Skins.FlatFXTex18'
     frames(5)=Texture'DeusExItems.Skins.FlatFXTex19'
     Texture=Texture'DeusExItems.Skins.FlatFXTex14'
     DrawScale=5.500000
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=32
     LightHue=40
     LightSaturation=192
     LightRadius=24
}
