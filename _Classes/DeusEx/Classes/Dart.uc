//=============================================================================
// Dart.
//=============================================================================
class Dart extends DeusExProjectile;

var float mpDamage;
var ParticleGenerator smokeGen;

simulated function Tick(float deltaTime)
{
    Super.Tick(deltaTime);

	if (bStuck)
	   if (smokeGen != None)
		   smokeGen.DelayedDestroy();
}

function Timer()
{
local DeusExPlayer player;

    player = DeusExPlayer(GetPlayerPawn());

    if (player != none)
    {
	if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkSharpEyed').bPerkObtained == true)
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
     bBlood=True
     bStickToWall=True
     blastRadius=36.000000
     DamageType=shot
     AccurateRange=1600
     maxRange=3200
     spawnAmmoClass=Class'DeusEx.AmmoDart'
     bIgnoresNanoDefense=True
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
