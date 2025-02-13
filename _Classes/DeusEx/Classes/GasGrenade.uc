//=============================================================================
// GasGrenade.
//=============================================================================
class GasGrenade extends ThrownProjectile;

var float	mpBlastRadius;
var float	mpProxRadius;
var float	mpGasDamage;
var float	mpFuselength;
var() bool  bScriptedGrenade;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		blastRadius=mpBlastRadius;
		proxRadius=mpProxRadius;
		Damage=mpGasDamage;
		fuseLength=mpFuseLength;
		bIgnoresNanoDefense=True;
	}
}

simulated function Tick(float deltaTime)
{
   if (bScriptedGrenade)
       return;
   else
       super.Tick(deltaTime);
}

simulated function BeginPlay()
{
	local DeusExPlayer aplayer;

    if (!bScriptedGrenade)
	    Super.BeginPlay();
    else
    {
        SetCollision(False, False, False);
	}
}

defaultproperties
{
     mpBlastRadius=512.000000
     mpProxRadius=128.000000
     mpGasDamage=20.000000
     mpFuselength=1.500000
     fuseLength=3.000000
     proxRadius=176.000000
     AISoundLevel=0.100000
     bBlood=False
     bDebris=False
     DamageType=KnockedOut
     spawnWeaponClass=Class'DeusEx.WeaponGasGrenade'
     ItemName="Gas Grenade"
     speed=1200.000000
     MaxSpeed=1200.000000
     Damage=10.000000
     MomentumTransfer=50000
     ImpactSound=Sound'DeusExSounds.Weapons.GasGrenadeExplode'
     LifeSpan=0.000000
     Mesh=LodMesh'HDTPItems.HDTPGasgrenadePickup'
     CollisionRadius=4.300000
     CollisionHeight=1.400000
     Mass=5.000000
     Buoyancy=2.000000
     rearmSkillRequired=1
}
