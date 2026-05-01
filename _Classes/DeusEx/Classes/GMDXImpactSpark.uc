//=============================================================================
// GMDXImpactSpark
//=============================================================================
class GMDXImpactSpark extends DeusExFragment;

auto state Flying
{
	simulated function BeginState()
	{
		DrawScale = (FRand() * 0.05) + 0.01;
		Velocity = VRand() * 300;
		Velocity.Z = FRand() * 150 + 150;
		SetRotation(Rotator(Velocity));
        if (!class'DeusExPlayer'.default.bJohnWooSparks)
            LifeSpan = FRand()*0.2;
	}
	
	function ZoneChange(ZoneInfo NewZone)
	{
		Super.ZoneChange(NewZone);

		if (NewZone != None && NewZone.bWaterZone && Physics != PHYS_Swimming)
			SetPhysics(PHYS_Swimming);
	}
}

simulated function Tick(float deltaTime)
{
	// fade out the object smoothly
	if (class'DeusExPlayer'.default.bJohnWooSparks && LifeSpan > 0.0 && LifeSpan <= 2.5)
	{
		ScaleGlow = LifeSpan / 1.5;
		DrawScale -= 0.00025;
	}
}

defaultproperties
{
     elasticity=0.300000
     LifeSpan=1.500000
     DrawType=DT_Sprite
     Texture=FireTexture'Effects.Fire.SparkFX1'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideWorld=True
     bBounce=True
     Style=STY_Translucent
     RemoteRole=ROLE_None
}
