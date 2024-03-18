//=============================================================================
// AirBubble.
//=============================================================================
class PlasmaParticleSpoof expands Effects;

auto state Flying
{
	simulated function BeginState()
	{
		Super.BeginState();

        Velocity = VRand() * 400;
        Velocity.Z = FRand() * 300;
		DrawScale = FRand() * 0.045;
		if (FRand() < 0.4)
		Velocity.Z = 0 - 350 + (FRand() * 240);
		else if (FRand() < 0.6)
		Velocity.Z = FRand() * 20;
	}
	simulated function Tick(float deltaTime)
{
	// fade out the object smoothly 2 seconds before it dies completely
	if (LifeSpan <= 0.1)
	{
		ScaleGlow = LifeSpan;
	}
}
}

defaultproperties
{
     Physics=PHYS_Projectile
     LifeSpan=0.650000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'HDTPDecos.Skins.HDTPAlarmLightTex4'
     DrawScale=0.050000
     LightBrightness=255
     LightHue=80
     LightSaturation=64
     LightRadius=4
}
