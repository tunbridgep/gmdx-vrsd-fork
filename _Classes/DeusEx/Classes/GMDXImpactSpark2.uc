//=============================================================================
// GMDXImpactSpark2
//=============================================================================
class GMDXImpactSpark2 extends GMDXImpactSpark;

auto state Flying
{
	simulated function BeginState()
	{
		DrawScale = (FRand() * 0.07) + 0.01;
		Velocity = VRand() * 280;
		Velocity.Z = -50 + (FRand() * 300.0);
		SetRotation(Rotator(Velocity));
        if (!class'DeusExPlayer'.default.bJohnWooSparks)
            LifeSpan = FRand()*0.19;
	}
}

defaultproperties
{
     LifeSpan=2.000000
}
