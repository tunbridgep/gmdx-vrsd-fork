//=============================================================================
// Fireball.
//=============================================================================
class FireballSpoof expands Effects;

var texture texes[5];
var FireSmoke smoke;
var bool bSpawned;
var float time;

#exec OBJ LOAD FILE=Effects
#exec OBJ LOAD FILE=HDTPAnim

simulated function Tick(float deltaTime)
{
	local float value;
	local float sizeMult;
	local FireballSpoof f;

	// don't Super.Tick() becuase we don't want gravity to affect the stream
	time += deltaTime;
	if(!bSpawned && time > 0.05)
	{
		f = spawn(class'FireballSpoof',owner,tag,location-self.Velocity*0.05,rotation);
		if(f != none)
		{
			f.bSpawned = true; //stop infinite repeats
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
		smoke.DrawScale = (0.5+FRand()) * DrawScale;
	}*/
}

function ZoneChange(ZoneInfo NewZone)
{
	Super.ZoneChange(NewZone);

	// If the fireball enters water, extingish it
	if (NewZone.bWaterZone)
		Destroy();
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
	Velocity.Z = 2;
}

defaultproperties
{
     texes(0)=WetTexture'HDTPanim.Effects.FlmThrwr01'
     texes(1)=WetTexture'HDTPanim.Effects.FlmThrwr02'
     texes(2)=WetTexture'HDTPanim.Effects.FlmThrwr03'
     texes(3)=WetTexture'HDTPanim.Effects.FlmThrwr04'
     texes(4)=WetTexture'HDTPanim.Effects.FlmThrwr05'
     LifeSpan=0.750000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=WetTexture'HDTPanim.Effects.FlmThrwr01'
     DrawScale=0.001000
     bUnlit=True
     LightEffect=LE_FireWaver
     LightHue=16
     LightSaturation=128
}
