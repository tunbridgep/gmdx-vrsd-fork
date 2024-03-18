//=============================================================================
// WaterSplash  //CyberP:
//=============================================================================
class WaterSplash extends DeusExFragment;

auto state Flying
{
	simulated function BeginState()
	{
		Velocity = VRand() * 200; //300
		Velocity.Z = FRand() * 150 + 150; //200+200
		DrawScale = FRand() * 0.15;
		SetRotation(Rotator(Velocity));
	}
}

defaultproperties
{
     elasticity=0.400000
     LifeSpan=0.300000
     DrawType=DT_Sprite
     Texture=Texture'Effects.Generated.WtrDrpSmall'
     bUnlit=True
     CollisionRadius=0.100000
     CollisionHeight=0.150000
     bCollideWorld=False
     bBounce=False
}
