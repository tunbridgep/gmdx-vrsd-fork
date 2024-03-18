//=============================================================================
// AirBubble.
//=============================================================================
class AirBubble expands Effects;

var() float RiseRate;
var vector OrigVel;

auto state Flying
{
	simulated function Tick(float deltaTime)
	{
		Velocity.X = OrigVel.X + 8 - FRand() * 17;
		Velocity.Y = OrigVel.Y + 8 - FRand() * 17;
		Velocity.Z = RiseRate * (FRand() * 0.2 + 0.9);

		if (!Region.Zone.bWaterZone)
			Destroy();
	}

	simulated function BeginState()
	{
		Super.BeginState();

        if (FRand() < 0.2)
        {
        RiseRate=42;
        }
        else if (FRand() < 0.4)
        {
        RiseRate=44;
        DrawScale += FRand() * 0.09;
        }
        if (FRand() < 0.6)
        {
        RiseRate=46;
        DrawScale += FRand() * 0.12;
        }
        else if (FRand() < 0.8)
        {
        RiseRate=50;
        DrawScale += FRand() * 0.15;
        }
        else
        {
        DrawScale += FRand() * 0.18;
        RiseRate += 8;
        }

		OrigVel = Velocity;
	}
}

defaultproperties
{
     RiseRate=50.000000
     Physics=PHYS_Projectile
     LifeSpan=10.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'DeusExItems.Skins.FlatFXTex45'
     DrawScale=0.022000
}
