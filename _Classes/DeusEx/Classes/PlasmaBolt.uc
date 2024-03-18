//=============================================================================
// PlasmaBolt.
//=============================================================================
class PlasmaBolt extends DeusExProjectile;

var ParticleGenerator pGen1;
var ParticleGenerator pGen2;

var float mpDamage;
var float mpBlastRadius;

var DeusExWeapon weaponShotBy;                                                  //RSD: To ensure we only use the Blast Energy perk with the plasma rifle

#exec OBJ LOAD FILE=Effects

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ParticleGenerator gen;
	local ExplosionLight bright;

    PlaySound(Sound'DeusExSounds.Generic.MediumExplosion1',SLOT_None,1.5,,2048);
	// create a particle generator shooting out plasma spheres
	Spawn(class'SphereEffectPlasma');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	gen = Spawn(class'ParticleGenerator',,, HitLocation, Rotator(HitNormal));
	if (gen != None)
	{
		bright = Spawn(class'ExplosionLight',,,HitLocation+(Vector(Rotation)*4.5), Rotation);
		bright.size = 16;


     		bright.LightBrightness=255;
     		bright.LightHue=80;
     		bright.LightSaturation=96;

		gen.RemoteRole = ROLE_None;
		gen.particleDrawScale = 1.0;
		gen.checkTime = 0.10;
		gen.frequency = 1.0;
		gen.ejectSpeed = 200.0;
		gen.bGravity = True;
		gen.bRandomEject = True;
		gen.particleLifeSpan = 0.75;
		gen.particleTexture =Texture'Effects.Fire.Proj_PRifle';
		gen.LifeSpan = 1.3;

	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ((Level.NetMode == NM_Standalone) || (Level.NetMode == NM_ListenServer))
		SpawnPlasmaEffects();
}

simulated function PostNetBeginPlay()
{
	if (Role < ROLE_Authority)
		SpawnPlasmaEffects();
}

// DEUS_EX AMSD Should not be called as server propagating to clients.
simulated function SpawnPlasmaEffects()
{
	local Rotator rot;
	rot = Rotation;
	rot.Yaw -= 32768;

	pGen2 = Spawn(class'ParticleGenerator', Self,, Location, rot);
	if (pGen2 != None)
	{
		pGen2.RemoteRole = ROLE_None;
		pGen2.particleTexture = Texture'Effects.Fire.Proj_PRifle';
		pGen2.particleDrawScale = 0.1;
		pGen2.checkTime = 0.01; //Cyber: was 0.04
		pGen2.riseRate = 0.0;
		pGen2.ejectSpeed = 100.0;
		pGen2.particleLifeSpan = 0.6; //CyberP: was check
		pGen2.bRandomEject = True;
		pGen2.SetBase(Self);
	}
}

simulated function Destroyed()
{
	if (pGen1 != None)
		pGen1.DelayedDestroy();
	if (pGen2 != None)
		pGen2.DelayedDestroy();

	Super.Destroyed();
}

state Exploding                                                                 //RSD: overrides state Exploding in DeusExProjectile.uc so I can make a different HurtRadiusPlasma()
{
	ignores ProcessTouch, HitWall, Explode;

	function DamageRing()
	{
		local Pawn apawn;
		local float damageRadius;
		local Vector dist;

	  //DEUS_EX AMSD Ignore Line of Sight on the lowest radius check, only in multiplayer
		HurtRadiusPlasma
		(
			(2 * Damage) / gradualHurtSteps,
			(blastRadius / gradualHurtSteps) * gradualHurtCounter,
			damageType,
			MomentumTransfer / gradualHurtSteps,
			Location, gradualHurtCounter < 3);

	    if ( Level.NetMode != NM_Standalone )
		{
			damageRadius = (blastRadius / gradualHurtSteps) * gradualHurtCounter;

			for ( apawn = Level.PawnList; apawn != None; apawn = apawn.nextPawn )
			{
				if ( apawn.IsA('DeusExPlayer') )
				{
					dist = apawn.Location - Location;
					if ( VSize(dist) < damageRadius )
					{
						if ( gradualHurtCounter <= 2 )
						{
							if ( apawn.FastTrace( apawn.Location, Location ))
								DeusExPlayer(apawn).myProjKiller = Self;
						}
						else
							DeusExPlayer(apawn).myProjKiller = Self;
					}
				}
			}
		}
	}

	function Timer()
	{
	ImpactSound=None;

		gradualHurtCounter++;
	  DamageRing();
		if (gradualHurtCounter >= gradualHurtSteps)
		{
			if (Owner.IsA('DeusExPlayer') && WeaponPlasmaRifle(weaponShotBy) != none && DeusExPlayer(Owner).PerkNamesArray[13] == 1) //RSD: If we have the Blast Energy perk, do one more flat damage ring to adjust the curve up
            HurtRadiusPlasma
			(
				0.5*Damage,                                                     //RSD: evaluated at 0.25*gradualHurtSteps*[original damage=2*Damage] since the curve was cut by 25% in HurtRadiusPlasma()
				blastRadius,                                                    //RSD: use the whole blast radius this time
				damageType,
				MomentumTransfer / gradualHurtSteps,
				Location, false,                                                //RSD: definitely don't ignore line of sight
                true);                                                          //RSD: should be flat damage scaling this time
            Destroy();
		}
	}

Begin:
	// stagger the HurtRadius outward using Timer()
	// do five separate blast rings increasing in size
	gradualHurtCounter = 1;
	gradualHurtSteps = 4;                                                       //RSD: Normally 5, making it 4 since I added another one with the perk
	Velocity = vect(0,0,0);
	bHidden = True;
	LightType = LT_None;
	SetCollision(False, False, False);
	//if (damageType == 'Exploded')
	//    BlastDeadzone();
	DamageRing();
	SetTimer(0.25/float(gradualHurtSteps), True);
}

//RSD: stolen from HurtRadius() in Actor.uc to enable new Blast Energy perkm, added bNoDamageFalloff for clever hackery
function HurtRadiusPlasma( float DamageAmount, float DamageRadius, name DamageName, float Momentum, vector HitLocation, optional bool bIgnoreLOS, optional bool bNoDamageFalloff)
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local float mult;                                                           //RSD: for Blast Energy perk

	// DEUS_EX CNN
	local Mover M;

    if (Owner.IsA('DeusExPlayer') && WeaponPlasmaRifle(weaponShotBy) != none && DeusExPlayer(Owner).PerkNamesArray[13] == 1) //RSD: Blast Energy perk
    	mult = 0.75;
   	else mult = 1.0;

	if( bHurtEntry )
		return;

	bHurtEntry = true;
   if (!bIgnoreLOS)
   {
      foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
      {
         if( Victims != self )
         {
            dir = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dir));
            dir = dir/dist;
            if (bNoDamageFalloff)
               damageScale = 1.0;
            else
               damageScale = mult*(1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius)); //RSD: 25% less decay with Blast Energy perk
            Victims.TakeDamage
               (
               damageScale * DamageAmount,
               Instigator,
               Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
               (damageScale * Momentum * dir),
               DamageName
               );
         }
      }
   }
   else
   {
      foreach RadiusActors(class 'Actor', Victims, DamageRadius, HitLocation )
      {
         if( Victims != self )
         {
            dir = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dir));
            dir = dir/dist;
            if (bNoDamageFalloff)
               damageScale = 1.0;
            else
               damageScale = mult*(1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius)); //RSD: 50% less decay with Blast Energy perk
            Victims.TakeDamage
               (
               damageScale * DamageAmount,
               Instigator,
               Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
               (damageScale * Momentum * dir),
               DamageName
               );
         }
      }
   }

	//
	// DEUS_EX - CNN - damage the movers, also
	//
	foreach RadiusActors(class 'Mover', M, DamageRadius, HitLocation)
	{
		if( M != self )
		{
			dir = M.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - M.CollisionRadius)/DamageRadius);
			M.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator,
				M.Location - 0.5 * (M.CollisionHeight + M.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageName
			);
		}
	}

	bHurtEntry = false;
}

defaultproperties
{
     mpDamage=20.000000
     mpBlastRadius=288.000000
     bExplodes=True
     blastRadius=192.000000
     DamageType=Burned
     AccurateRange=14400
     maxRange=24000
     bIgnoresNanoDefense=True
     ItemName="Plasma Bolt"
     ItemArticle="a"
     speed=1500.000000
     Damage=20.000000
     MomentumTransfer=5000
     SpawnSound=Sound'DeusExSounds.Weapons.PlasmaRifleFire'
     ImpactSound=Sound'DeusExSounds.Weapons.PlasmaRifleHit'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     Skin=Texture'HDTPDecos.Skins.HDTPAlarmLightTex4'
     Mesh=LodMesh'DeusExItems.PlasmaBolt'
     DrawScale=2.200000
     bUnlit=True
     CollisionRadius=0.100000
     CollisionHeight=0.100000
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=224
     LightHue=80
     LightSaturation=128
     LightRadius=8
     bFixedRotationDir=True
}
