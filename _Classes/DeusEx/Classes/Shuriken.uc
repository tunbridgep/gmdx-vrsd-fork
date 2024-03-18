//=============================================================================
// Shuriken.
//=============================================================================
class Shuriken extends DeusExProjectile;

var float	mpDamage;
var int		mpAccurateRange;
var int		mpMaxRange;
var ParticleGenerator smokeGen;

// set it's rotation correctly
simulated function Tick(float deltaTime)
{
	local Rotator rot;

	if (bStuck)
	{
	if (smokeGen != None)
	{
		smokeGen.DelayedDestroy();
	}
		return;
    }

    if (Velocity == vect(0,0,0))
    {
    if (smokeGen != None)
	{
		smokeGen.DelayedDestroy();
    }
    }

	Super.Tick(deltaTime);

	if (!IsInState('Ricocheted') && bBounce==False)
	{
		rot = Rotation;
		rot.Roll += 16384;
		rot.Pitch -= 16384;
		SetRotation(rot);
	}
}

simulated function Destroyed()
{
if (smokeGen != None)
		smokeGen.DelayedDestroy();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		Damage = mpDamage;
		AccurateRange = mpAccurateRange;
		MaxRange = mpMaxRange;
	}
}

simulated function PostBeginPlay()
{
    local DeusExPlayer player;

   if (Owner != None)
   {
     if (Owner.IsA('ScriptedPawn'))
     {
     speed=1300.000000;
     MaxSpeed=1300.000000;
     }
     /*else if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).SkillSystem.GetSkillLevel(class'SkillWeaponLowTech') >= 2)
     {
     Velocity*=3;
     speed=3000.000000;
     MaxSpeed=3000.000000;
     }
     else
     {
     Velocity*=1.5;
     speed=1800.000000;
     MaxSpeed=1800.000000;
     }*/
   }
Super.PostBeginPlay();

    player = DeusExPlayer(Owner);

    PlaySound(sound'CombatKnifeFire',SLOT_None,,,,1.5);

    if (player != None && player.PerkNamesArray[4]==1)
    {
     smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
	  smokeGen.RemoteRole = ROLE_None;
		smokeGen.particleTexture = Texture'DeusExItems.Skins.FlatFXTex46';
		smokeGen.particleDrawScale = 0.08;
		smokeGen.checkTime = 0.05;
		smokeGen.riseRate = 0.0;
		smokeGen.ejectSpeed = 0.0;
		smokeGen.particleLifeSpan = 0.5;
		smokeGen.bRandomEject = False;
		smokeGen.SetBase(Self);
	}
	}
}

defaultproperties
{
     mpDamage=17.000000
     mpAccurateRange=840
     mpMaxRange=640
     bBlood=True
     bStickToWall=True
     blastRadius=32.000000
     DamageType=shot
     AccurateRange=840
     maxRange=1480
     spawnWeaponClass=Class'DeusEx.WeaponShuriken'
     bIgnoresNanoDefense=True
     ItemName="Throwing Knife"
     ItemArticle="a"
     gravMult=0.500000
     speed=1400.000000
     MaxSpeed=1400.000000
     Damage=16.000000
     MomentumTransfer=1000
     ImpactSound=Sound'DeusExSounds.Generic.BulletHitFlesh'
     LifeSpan=560.000000
     Mesh=LodMesh'HDTPItems.HDTPShurikenPickup'
     CollisionRadius=3.500000
     CollisionHeight=0.300000
}
