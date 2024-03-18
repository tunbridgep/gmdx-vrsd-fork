//=============================================================================
// AirBubble.
//=============================================================================
class PlasmaParticleSpoof2 expands Effects;

auto state Flying
{
	simulated function BeginState()
	{
		Super.BeginState();

        Velocity = VRand() * 300;
        Velocity.Z = FRand() * 200;
		DrawScale = FRand() * 0.05;
		if (FRand() < 0.4)
		Velocity.Z = 0 - 250 + (FRand() * 140);
		else if (FRand() < 0.6)
		Velocity.Z = FRand() * 10;
	}
	simulated function Tick(float deltaTime)
{
	// fade out the object smoothly 2 seconds before it dies completely
	if (LifeSpan <= 0.25)
	{
		ScaleGlow = LifeSpan / 2.0;
	}
}
}

defaultproperties
{
     Physics=PHYS_Projectile
     LifeSpan=0.800000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=FireTexture'Effects.Fire.Spark_Electric'
     DrawScale=0.050000
     LightBrightness=255
     LightHue=80
     LightSaturation=64
     LightRadius=4
}
