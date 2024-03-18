//=============================================================================
// WaterSplash2
//=============================================================================
class WaterSplash3 extends DeusExFragment;

auto state Flying
{
	simulated function BeginState()
	{
		Velocity = VRand() * 100; //300
		Velocity.Z = FRand() * 350 + 350; //200+200
		DrawScale = FRand() * 0.2;
		SetRotation(Rotator(Velocity));
	}
}

defaultproperties
{
     elasticity=0.400000
     LifeSpan=0.750000
     DrawType=DT_Sprite
     Texture=Texture'Effects.Generated.WtrDrpSmall'
     bUnlit=True
     CollisionRadius=0.000000
     CollisionHeight=0.100000
     bCollideWorld=False
     bBounce=False
}
