//=============================================================================
// ExplosionMedium.
//=============================================================================
class ExplosionExtra extends AnimatedSprite;

simulated function Tick(float deltaTime)
{
	time += deltaTime;
	totalTime += deltaTime;

	DrawScale = 0.5 + (0.2 * totalTime / duration); //CyberP: 0.9 was 0.5 & 6.0 was 3.0
	ScaleGlow = ((duration*2) - totalTime) / (duration*2);

	if (time >= animSpeed)
	{
		Texture = frames[nextFrame++];
		if (nextFrame >= numFrames)
			Destroy();

		time -= animSpeed;
	}
}

simulated function PostBeginPlay()
{
    local vector offs;

    super.PostBeginPlay();

    Spawn(class'FireComet', None);
    offs = Location;
    offs.Z += 10;
    offs.X += 12;
    offs.Y += 12;
    //Spawn(class'RockchipXL',None,,offs);

    if (class'HDTPLoader'.static.HDTPInstalled())
    {
        /*
        //SARGE: Missing a frame here? Not sure if intentional. Re-did it below.
        frames[0]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashLarge1");
        frames[1]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashLarge5");
        frames[3]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashSmall2");
        frames[4]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashSmall3");
        */
        frames[0]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashLarge1");
        frames[1]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashLarge5");
        frames[2]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashLarge5");
        frames[3]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashSmall2");
        frames[4]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashSmall3");
        Texture=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashLarge1");

    }
    else
        Destroy();
}

defaultproperties
{
     numFrames=5
     DrawScale=0.500000
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=32
     LightHue=40
     LightSaturation=192
     LightRadius=24
}
