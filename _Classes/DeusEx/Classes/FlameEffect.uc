//=============================================================================
// Flame
// Smoke39 - fancy effect for on-fire stuff
//=============================================================================
class FlameEffect extends Effects;

var vector origVel, vel, lastvel;
var float dropamt;
var bool bRescale;

// set up location, velocity, draw scale
function BeginPlay()
{
	local rotator r;
	local vector v;
	local float f;

	r.Yaw = FRand() * 65536;

	f = FRand() * Owner.CollisionRadius;

	v = f * vector(r);
	v += Owner.Location;
	v.Z += (FRand()-FRand()) * Owner.CollisionHeight;
	v.Z -= Owner.collisionheight * dropamt;
	SetLocation(v);

	f = Owner.CollisionRadius - f;
	f *= 50 * LifeSpan;

	origVel = f*vector(r) + (1+FRand())*vect(0,0,150);
	vel = origVel;
	Velocity = Owner.Velocity + vel;

	if(bRescale)
		Drawscale = default.drawscale*((owner.collisionradius+owner.collisionheight)/60); //since average pawn is rad+height = 60ish

	DrawScale *= 1 + Frand();
}

// shrink, curve in
simulated function Tick( float dt )
{
	local float f;

	DrawScale = Default.DrawScale * LifeSpan / Default.LifeSpan;
	if(owner != none)
		lastvel = owner.Velocity;

	f = dt / (Default.LifeSpan/2);
	vel.X -= origVel.X * f;
	vel.Y -= origVel.Y * f;
	Velocity = lastvel + vel;
}

defaultproperties
{
     bRescale=True
     Physics=PHYS_Projectile
     LifeSpan=0.400000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=FireTexture'Effects.Fire.OneFlame_J'
     DrawScale=1.650000
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=224
     LightHue=16
     LightSaturation=128
     LightRadius=8
}
