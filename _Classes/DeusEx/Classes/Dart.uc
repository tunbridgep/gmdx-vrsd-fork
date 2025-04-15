//=============================================================================
// Dart.
//=============================================================================
class Dart extends DeusExProjectile;

var float mpDamage;
var ParticleGenerator smokeGen;

//Ygll: new utility function to create spark effect on wall impact
function CreateSparkHitWallEffect()
{
	local GMDXSparkFade fade;
	local GMDXImpactSpark s;
	local GMDXImpactSpark2 t;
	local int i;

	//hit location little spark	explosion
	fade = spawn(class'GMDXSparkFade');
	if (fade != None)
	{
		fade.DrawScale = 0.16;
		fade.LightBrightness = 15;
	}

	//flying spark
	for (i=0; i<4; i++)
	{
		s = spawn(class'GMDXImpactSpark');
		if( s != None  )
		{
			s.LifeSpan=FRand()*0.12;
			s.DrawScale = FRand() * 0.06;
		}

		t = spawn(class'GMDXImpactSpark2');
		if( t != None )
		{
			t.LifeSpan=FRand()*0.12;
			t.DrawScale = FRand() * 0.06;
		}
	}
}

simulated function DoProjectileHitEffects(bool bWallHit)
{
	Super.DoProjectileHitEffects(bWallHit);

	//Ygll: Spark effect when hitting hard surface
	if(bWallHit)
	{
		CreateSparkHitWallEffect();
	}
}

simulated function Tick(float deltaTime)
{
    Super.Tick(deltaTime);

	if (bStuck && smokeGen != None)
		  smokeGen.DelayedDestroy();
}

function Timer()
{
	local DeusExPlayer player;

    player = DeusExPlayer(GetPlayerPawn());

    if (player != None)
    {
		if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkSharpEyed').bPerkObtained)
		{
			smokeGen = Spawn(class'ParticleGenerator', Self);
			if (smokeGen != None)
			{
			  smokeGen.RemoteRole = ROLE_None;
				smokeGen.particleTexture = Texture'DeusExItems.Skins.FlatFXTex46';
				smokeGen.particleDrawScale = 0.07;
				smokeGen.checkTime = 0.03;
				smokeGen.riseRate = 0.0;
				smokeGen.ejectSpeed = 0.0;
				smokeGen.ScaleGlow=0.5;
				smokeGen.particleLifeSpan = 0.5;
				smokeGen.bRandomEject = False;
				smokeGen.SetBase(Self);
			}
		}
   }
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	PlaySound(sound'MetalDrawerClos',SLOT_Pain,2.0,,2048);
	SetTimer(0.08, False);
}

simulated function Destroyed()
{
	if (smokeGen != None)
		smokeGen.DelayedDestroy();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
		Damage = mpDamage;
}

defaultproperties
{
     mpDamage=25.000000
     bBlood=true
     bStickToWall=true
     blastRadius=36.000000
     DamageType=shot
     AccurateRange=1600
     maxRange=3200
     spawnAmmoClass=Class'DeusEx.AmmoDart'
     bIgnoresNanoDefense=true
     ItemName="Dart"
     ItemArticle="a"
     gravMult=0.450000
     speed=2000.000000
     MaxSpeed=3000.000000
     Damage=18.000000
     MomentumTransfer=1000
     ImpactSound=Sound'DeusExSounds.Generic.BulletHitFlesh'
     LifeSpan=560.000000
     Mesh=LodMesh'DeusExItems.Dart'
     CollisionRadius=3.000000
     CollisionHeight=0.500000
}
