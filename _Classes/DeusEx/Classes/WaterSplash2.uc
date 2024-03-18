//=============================================================================
// WaterSplash2
//=============================================================================
class WaterSplash2 extends DeusExFragment;

auto state Flying
{
	simulated function BeginState()
	{
		Velocity = VRand() * 120; //300
		Velocity.Z = FRand() * 280 + 280; //200+200
		DrawScale = FRand() * 0.15;
		SetRotation(Rotator(Velocity));
	}
}

defaultproperties
{
     elasticity=0.400000
     LifeSpan=0.600000
     DrawType=DT_Sprite
     Texture=Texture'Effects.Generated.WtrDrpSmall'
     bUnlit=True
     CollisionRadius=0.100000
     CollisionHeight=1.150000
     bCollideWorld=False
     bBounce=False
}
