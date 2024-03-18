//=============================================================================
// Fireball.
//=============================================================================
class Fireball extends DeusExProjectile;

var() float mpDamage;
var texture texes[5];
var FireSmoke smoke;
var bool bSpawned;

#exec OBJ LOAD FILE=Effects
#exec OBJ LOAD FILE=HDTPAnim

simulated function Tick(float deltaTime)
{
	local float value;
	local float sizeMult;
	local fireball f;
	// don't Super.Tick() becuase we don't want gravity to affect the stream
	time += deltaTime;
	if(!bSpawned && time > 0.05)
	{
		f = spawn(class'fireball',owner,tag,location-self.Velocity*0.05,rotation);
		if(f != none)
		{
			f.bSpawned = true; //stop infinite repeats
			f.Damagetype = 'Burned';
			f.damage = 0;
			bSpawned=true;
		}
	}
//
//	value = 1.0+time;
//	if (MinDrawScale > 0)
//		sizeMult = MaxDrawScale/MinDrawScale;
//	else
//		sizeMult = 1;
//
//	DrawScale = (-sizeMult/(value*value) + (sizeMult+1))*MinDrawScale;
//	ScaleGlow = Default.ScaleGlow/(value*value*value);

	DrawScale += deltaTime*3;
	SetCollisionSize( DrawScale*12, DrawScale*12 );
	LightRadius = 6 * DrawScale; //CyberP: was 2

	if ( LifeSpan <= 0.2 )
	{
		ScaleGlow = LifeSpan * 5;
		DrawScale += deltaTime;
		Velocity.Z += 50*deltaTime;
		if ( smoke != None )
		{
			smoke.Velocity = Velocity / 1.5;
			smoke.LifeSpan = 0.75 + FRand()*0.75;
			smoke.origLifeSpan = smoke.LifeSpan;
			smoke.bRelinquished = true;
			smoke = None;
		}
	}
	/*else
	{
		if ( smoke == None )
			smoke = Spawn( class'FireSmoke' );

		smoke.setLocation( Location - vect(0,0,0.7)*CollisionHeight );
		smoke.LifeSpan = 3;
		smoke.ScaleGlow = Default.LifeSpan - LifeSpan;
		smoke.DrawScale = 1.5 * DrawScale;
	}*/
}

function ZoneChange(ZoneInfo NewZone)
{
	Super.ZoneChange(NewZone);

	// If the fireball enters water, extingish it
	if (NewZone.bWaterZone)
		Destroy();
}

simulated function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other)
{
	local int i;
	local DeusExDecal mark;
	local Rockchip chip;

	// don't draw damage art on destroyed movers
	if (DeusExMover(Other) != None)
		if (DeusExMover(Other).bDestroyed)
			ExplosionDecal = None;

	// draw the explosion decal here, not in Engine.Projectile
	if (ExplosionDecal != None)
	{
		mark = DeusExDecal(Spawn(ExplosionDecal, Self,, HitLocation, Rotator(HitNormal)));
		if (mark != None)
		{
			//rejigged for bigger decals
			mark.DrawScale = mark.default.drawscale * FClamp(default.damage/3, 0.5, 4.0);
			mark.ReattachDecal();
		}

		ExplosionDecal = None;
	}

	//DEUS_EX AMSD Don't spawn these on the server.
	if ((Level.NetMode == NM_DedicatedServer) && (Role == ROLE_Authority))
	  return;

	if (bDebris)
	{
		for (i=0; i<Damage/5; i++)
			if (FRand() < 0.8)
		 {
				chip = spawn(class'Rockchip',,,HitLocation+HitNormal);
			//DEUS_EX AMSD In multiplayer, don't propagate these to
			//other players (or from the listen server to clients).
			if (chip != None)
			   chip.RemoteRole = ROLE_None;
		 }
	}
}

// just in case
function Destroyed()
{
	if ( smoke != None )
		smoke.Destroy();

	Super.Destroyed();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	texture = texes[rand(5)];

	drawscale *= 1.0 + (0.3 * (frand() - 0.5)); //vary the drawscale a bit, to make the fire more organic

	if ( Level.NetMode != NM_Standalone )
		Damage = mpDamage;
}

defaultproperties
{
     mpDamage=5.000000
     texes(0)=WetTexture'HDTPanim.Effects.FlmThrwr01'
     texes(1)=WetTexture'HDTPanim.Effects.FlmThrwr02'
     texes(2)=WetTexture'HDTPanim.Effects.FlmThrwr03'
     texes(3)=WetTexture'HDTPanim.Effects.FlmThrwr04'
     texes(4)=WetTexture'HDTPanim.Effects.FlmThrwr05'
     blastRadius=1.000000
     DamageType=Flamed
     AccurateRange=640
     maxRange=640
     bIgnoresNanoDefense=True
     ItemName="Fireball"
     ItemArticle="a"
     speed=800.000000
     MaxSpeed=800.000000
     Damage=5.000000
     MomentumTransfer=500
     ExplosionDecal=Class'DeusEx.BurnMark'
     LifeSpan=0.750000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=WetTexture'HDTPanim.Effects.FlmThrwr01'
     DrawScale=0.001000
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=224
     LightHue=16
     LightSaturation=128
     LightRadius=16
}
