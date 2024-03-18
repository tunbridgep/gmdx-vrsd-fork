//=============================================================================
// GMDXImpactSpark
//=============================================================================
class GMDXImpactSpark extends DeusExFragment;

auto state Flying
{
	simulated function BeginState()
	{
		Velocity = VRand() * 330; //300
		Velocity.Z = FRand() * 190 + 190; //200+200
		DrawScale = FRand() * 0.09;
		SetRotation(Rotator(Velocity));
		LifeSpan = FRand()*0.1;
		Style=STY_Translucent;
		if (FRand() < 0.2)
		Velocity.Z = FRand() * 20;
	}
}

defaultproperties
{
     elasticity=0.400000
     LifeSpan=1.200000
     DrawType=DT_Sprite
     Texture=FireTexture'Effects.Fire.SparkFX1'
     bUnlit=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideWorld=False
     bBounce=False
}
