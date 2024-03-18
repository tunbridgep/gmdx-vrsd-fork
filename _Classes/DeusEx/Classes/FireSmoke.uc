class FireSmoke expands Effects;

//100% smoke39 code, shamelessly stolen. I am a monster.

// necessary for this smoke puff, but not for the texture in Flame? \=|
#exec OBJ LOAD FILE=Effects

var bool bRelinquished;
var bool bRelinquished2;
var float origLifeSpan;

simulated function Tick( float dt )
{
	Super.Tick(dt);

	if ( !bRelinquished )
		return;
    if (bRelinquished2)
    {
    Velocity.Z += 2;
    Drawscale += 0.02;
    if (lifespan <= 1)
    ScaleGlow = LifeSpan;
    }
    else
    {
	Velocity *= 1-dt;
	Velocity.Z += 200*dt;
	DrawScale += 2*dt;
	ScaleGlow = LifeSpan / origLifeSpan;
	}
}

defaultproperties
{
     Physics=PHYS_Projectile
     LifeSpan=10.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=FireTexture'Effects.Smoke.SmokePuff1'
     DrawScale=0.100000
     bCollideWorld=True
}
