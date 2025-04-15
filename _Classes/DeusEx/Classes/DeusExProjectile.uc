//=============================================================================
// DeusExProjectile.
//=============================================================================
class DeusExProjectile extends Projectile
	abstract;

var bool bExplodes;				// does this projectile explode?
var bool bBlood;				// does this projectile cause blood?
var bool bDebris;				// does this projectile cause debris?
var bool bStickToWall;			// does this projectile stick to walls?
var bool bStuck;				// is this projectile stuck to the wall?
var vector initDir;				// initial direction of travel
var float blastRadius;			// radius to explode
var Actor damagee;				// who is being damaged
var name damageType;			// type of damage that this projectile does
var int AccurateRange;			// maximum accurate range in world units (feet * 16)
var int MaxRange;				// maximum range in world units (feet * 16)
var vector initLoc;				// initial location for range tracking
var bool bTracking;				// should this projectile track a target?
var Actor Target;				// what target we are tracking
var float time;					// misc. timer
var float MinDrawScale;
var float MaxDrawScale;

var vector LastSeenLoc;    // Last known location of target
var vector NetworkTargetLoc; // For network propagation (non relevant targets)
var bool bHasNetworkTarget;
var bool bHadLocalTarget;

var int gradualHurtSteps;		// how many separate explosions for the staggered HurtRadius
var int gradualHurtCounter;		// which one are we currently doing

var bool bEmitDanger;
var class<DeusExWeapon>	spawnWeaponClass;	// weapon to give the player if this projectile is disarmed and frobbed
var class<Ammo>			spawnAmmoClass;		// weapon to give the player if this projectile is disarmed and frobbed

var bool bIgnoresNanoDefense; //True if the aggressive defense aug does not blow this up.

var bool bAggressiveExploded; //True if exploded by Aggressive Defense
var DeusExPlayer aggressiveExploder;        //SARGE: Who triggered the aggressive defense aug explosion (used to reduce damage)

var localized string itemName;		// human readable name
var localized string	itemArticle;	// article much like those for weapons

var float WarningTimer;              //GMDX: send projectile warning again
var bool bContactDetonation;            //CyberP: explode upon contact
var ScriptedPawn pawnAlreadyHit;                                                //RSD: So the the Controlled Burn perk doesn't multihit enemies as it passes through them
var float gravMult;                                                             //RSD: Multiplier for zone gravity. 0.5 in vanilla, now 0 for non-dropping projectiles, ~0.45 for dropping
var bool bPlusOneDamage;                                                        //RSD: did our damage get boosted by 1 from decimal damage variation? So we can turn it off for movers

//SARGE: HDTP Model toggles
var string HDTPSkin;
var string HDTPTexture;
var string HDTPMesh;
var class<DeusExWeapon> hdtpReference;                                          //SARGE: Used when we want to tell a projectile to use the HDTP settings of a particular weapon

//SARGE: Explode on destroy
var bool bExplodeOnDestroy;

// network replication
replication
{
	//server to client
	reliable if (Role == ROLE_Authority)
	  bTracking, Target, bAggressiveExploded, bHasNetworkTarget, NetworkTargetLoc;
}

function PreBeginPlay()
{
    Super.PreBeginPlay();
    UpdateHDTPSettings();
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (bEmitDanger)
		AIStartEvent('Projectile', EAITYPE_Visual);
}

static function bool IsHDTP()
{
	if (!class'DeusExPlayer'.static.IsHDTPInstalled())
		return false;
    else if (default.hdtpReference != None)
        return default.hdtpReference.default.iHDTPModelToggle > 0;
    else if (default.spawnWeaponClass != None)
        return default.spawnWeaponClass.default.iHDTPModelToggle > 0;

    return false;
}

//SARGE: Setup the HDTP settings for this projectile
function UpdateHDTPSettings()
{
    if (HDTPMesh != "")
        Mesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),IsHDTP());
    if (HDTPSkin != "")
        Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),IsHDTP());
    if (HDTPTexture != "")
        Texture = class'HDTPLoader'.static.GetTexture2(HDTPTexture,string(default.Texture),IsHDTP());
}

//SARGE: Let the object explode on destroy
function Destroyed()
{
    if (bExplodeOnDestroy)
        Explode(Location, vect(0,0,1));
	else
		Super.Destroyed();
}

//Ygll: interface function used in each dart classe to create visual effect
function DoProjectileHitEffects(bool bWallHit)
{
}

//Ygll: new utility function to generate base wall hit effect for darts item
function CreateDartHitBaseEffect(bool bWallHit)
{
	DoProjectileHitEffects(bWallHit);
}

//
// Let the player pick up stuck projectiles
//
function Frob(Actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	// if the player frobs it and it's stuck, the player can grab it
	if( bStuck && !IsA('RubberBullet') )
	{
		GrabProjectile(DeusExPlayer(Frobber));
	}
}

function GrabProjectile(DeusExPlayer player)
{
	local Inventory item;

	if (player != None)
	{
		if (spawnWeaponClass != None)		// spawn the weapon
		{
			item = Spawn(spawnWeaponClass);
			if (item != None)
			{
				if ( (Level.NetMode != NM_Standalone ) && Self.IsA('Shuriken'))
					DeusExWeapon(item).PickupAmmoCount = DeusExWeapon(item).PickupAmmoCount * 3;
				else
					DeusExWeapon(item).PickupAmmoCount = 1;
			}
		}
		else if (spawnAmmoClass != None)	// or spawn the ammo
		{
			item = Spawn(spawnAmmoClass);
			if (item != None)
			{
				if ( (Level.NetMode != NM_Standalone ) && Self.IsA('Dart'))
					Ammo(item).AmmoAmount = Ammo(item).AmmoAmount * 3;
				else
					Ammo(item).AmmoAmount = 1;
			}
		}
		if (item != None)
		{
			player.FrobTarget = item;

			// check to see if we can pick up the new weapon/ammo
			if (player.HandleItemPickup(item))
			{
				Destroy();				// destroy the projectile on the wall
				if ( Level.NetMode != NM_Standalone )
				{
					if ( item != None )
						item.Destroy();
				}
			}
			else
				item.Destroy();			// destroy the weapon/ammo if it can't be picked up

			player.FrobTarget = None;
		}
	}
}

//GMDX scale velocity, eaiser implementation for rocket mod
function float SpeedMod()
{
   return 1;
}

//GMDX normal drop based on ranges
//function vector CalculateDrop(float dist)
//{
//   local vector acc;
//   if (dist > 20000)		// start descent due to "gravity"
//		acc = Region.Zone.ZoneGravity / 2; //cyberP: was 100
//	return acc;

function Timer()
{
	if (bStuck)
	  Destroy();
}

simulated function vector AcquireMPTargetLocation()
{
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor hit, retval;

	if (Target == None)
	{
	  if (bHasNetworkTarget)
		 return NetworkTargetLoc;
	  else
		 return LastSeenLoc;
	}

	StartTrace = Location;
	EndTrace = Target.Location;

	if (!Target.IsA('Pawn'))
	  return Target.Location;

	foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
	{
		if (hit == Target)
			return Target.Location;
	}

	// adjust for eye height
	EndTrace.Z += Pawn(Target).BaseEyeHeight;

	foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
	{
		if (hit == Target)
			return EndTrace;
	}

	return LastSeenLoc;
}

//Ygll: new utility function to generate blood drop on hit vector
function CreateDartBloodDropHit(Vector vec)
{
	local int i, maxBloodDrop;
	local float hitEffectDamage;
	local BloodDrop drop;

	hitEffectDamage = Damage/2;
	maxBloodDrop = 0;

	if(hitEffectDamage < 2.0)
		maxBloodDrop = 2;
	else if(hitEffectDamage > 6.0)
		maxBloodDrop = 6;
	else
		maxBloodDrop = hitEffectDamage;

	for(i=0; i<maxBloodDrop; i++)
	{
		drop = spawn(class'BloodDrop',,, vec);
		if (drop != None)
		{
			drop.Velocity *= 0.5;
			//drop.Velocity.Z *= 1.3;
		}
	}
}

function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
	local BloodSpurt spurt;

	if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
	  return;
	
	//for all projectile
	spurt = spawn(class'BloodSpurt',,, HitLocation+HitNormal);
		
	//Ygll: new for Taser Dart, they are now the same behaviour than poison dart
	//Ygll: adding the hit visual effect for flesh hit
	if (IsA('DartPoison') || IsA('DartTaser') )
	{
		spurt.LifeSpan *= 0.7;
		spurt.DrawScale *= 1.0;

		CreateDartHitBaseEffect(false);
	}
	else if( bBlood ) //Ygll: if the current projectile is set to generate blood
	{
		spurt.LifeSpan *= 0.8;
		spurt.DrawScale *= 1.1;

		CreateDartBloodDropHit(HitLocation+HitNormal);
	}
}

function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other)
{
	local int i;
	local DeusExDecal mark;
	local Rockchip chip;

	// don't draw damage art on destroyed movers
	if ( DeusExMover(Other) != None && DeusExMover(Other).bDestroyed )
		ExplosionDecal = None;

	// draw the explosion decal here, not in Engine.Projectile
	if (ExplosionDecal != None)
	{
		mark = DeusExDecal(Spawn(ExplosionDecal, Self,, HitLocation, Rotator(HitNormal)));
		if (mark != None)
		{
			mark.DrawScaleMult = FClamp(Damage/24, 0.5, 4.0); //CyberP: was divided by 30, last param was 3
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
		{
			chip = spawn(class'Rockchip',,,HitLocation+HitNormal);

			//DEUS_EX AMSD In multiplayer, don't propagate these to
			//other players (or from the listen server to clients).
			if (chip != None)
			   chip.RemoteRole = ROLE_None;
		}
	}
}

function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ShockRing ring;
	local SphereEffect sphere;
	local ExplosionLight light;
	local AnimatedSprite expeffect;

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, HitLocation);
	if (light != None)
	  light.RemoteRole = ROLE_None;

	if (blastRadius < 128 || IsA('GasGrenade'))
	{
		expeffect = Spawn(class'ExplosionSmall',,, HitLocation);
		Spawn(class'ExplosionMedium',,, HitLocation);
		light.size = 6;
		//light2.size = 6;
	}
	else if (blastRadius < 352)
	{
		expeffect = Spawn(class'ExplosionMedium',,, HitLocation);
		if (IsHDTP())
			Spawn(class'ExplosionExtra',,, HitLocation);
		else
			Spawn(class'ExplosionMedium',,, HitLocation);
		light.size = 12;
		//light2.size = 12;
	}
	else if (blastRadius < 544)
	{
		expeffect = Spawn(class'ExplosionLarge',,, HitLocation);
		Spawn(class'ExplosionMedium',,, HitLocation);
		light.size = 24;
		//light2.size = 24;
	}
	else
	{
		expeffect = Spawn(class'SFXExplosionLarge',,, HitLocation);
		Spawn(class'ExplosionMedium',,, HitLocation);
		//Spawn(class'ExplosionSmall',,, HitLocation);
		light.size = 32;
		//light2.size = 32;
	}

    //if (BlastRadius >= 352 || ItemName == "GEP Rocket")
    //    Spawn(class'ExplosionLarge',,, HitLocation);
	if (expeffect != None)
	  expeffect.RemoteRole = ROLE_None;

	// draw a pretty shock ring
	// For nano defense we are doing something else.
	if ((!bAggressiveExploded) || (Level.NetMode == NM_Standalone))
	{
	  ring = Spawn(class'ShockRing',,, HitLocation, rot(16384,0,0));
	  if (ring != None)
	  {
		 ring.RemoteRole = ROLE_None;
		 ring.size = blastRadius / 32.0;
	  }
	  ring = Spawn(class'ShockRing',,, HitLocation, rot(0,0,0));
	  if (ring != None)
	  {
		 ring.RemoteRole = ROLE_None;
		 ring.size = blastRadius / 32.0;
	  }
	  ring = Spawn(class'ShockRing',,, HitLocation, rot(0,16384,0));
	  if (ring != None)
	  {
		 ring.RemoteRole = ROLE_None;
		 ring.size = blastRadius / 32.0;
	  }
	}
	else
	{
	  sphere = Spawn(class'SphereEffect',,, HitLocation, rot(16384,0,0));
	  if (sphere != None)
	  {
		 sphere.RemoteRole = ROLE_None;
		 sphere.size = blastRadius / 32.0;
	  }
	  sphere = Spawn(class'SphereEffect',,, HitLocation, rot(0,0,0));
	  if (sphere != None)
	  {
		 sphere.RemoteRole = ROLE_None;
		 sphere.size = blastRadius / 32.0;
	  }
	  sphere = Spawn(class'SphereEffect',,, HitLocation, rot(0,16384,0));
	  if (sphere != None)
	  {
		 sphere.RemoteRole = ROLE_None;
		 sphere.size = blastRadius / 32.0;
	  }
	}
}

//
// Exploding state
//
state Ricocheted
{
	ignores ProcessTouch, Explode;

	simulated function HitWall(vector HitNormal, actor Wall)
	{
		Velocity = 0.8*((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		//Acceleration = vect(0,0,0);
		SetPhysics(PHYS_Falling);
	}

    simulated function Landed( vector HitNormal)
	{
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		SetPhysics(PHYS_None);
		bStuck = true;
		PlaySound(sound'BulletHitFlesh',SLOT_None,,,2048,1.1);
	}

	Begin:
		SetCollision(true, false, false);
        Velocity.Z-= 600;
        bBounce=false;
        if (Velocity.Z > -600)
        Velocity.Z = -600;
		//SetPhysics(PHYS_Falling);
		bFixedRotationDir = true;
}

state Exploding
{
	ignores ProcessTouch, HitWall, Explode;

	function DamageRing()
	{
		local Pawn apawn;
		local float damageRadius;
		local Vector dist;

	  //DEUS_EX AMSD Ignore Line of Sight on the lowest radius check, only in multiplayer
		HurtRadiusGMDX                                                          //RSD: Now HurtRadiusGMDX
		(
			(2 * Damage) / gradualHurtSteps,
			(blastRadius / gradualHurtSteps) * gradualHurtCounter,
			damageType,
			MomentumTransfer / gradualHurtSteps,
			Location, gradualHurtCounter < 2,                                   //RSD: Was <3
			gradualHurtCounter < 3);                                            //RSD: Additional new bIgnoreLOSmover bool

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
			Destroy();
	}

	Begin:
		// stagger the HurtRadius outward using Timer()
		// do five separate blast rings increasing in size
		gradualHurtCounter = 1;
		gradualHurtSteps = 5;
		Velocity = vect(0,0,0);
		bHidden = true;
		LightType = LT_None;
		SetCollision(false, false, false);
		//if (damageType == 'Exploded')
		//    BlastDeadzone();
		DamageRing();
		SetTimer(0.25/float(gradualHurtSteps), true);
}

function PlayImpactSound()
{
	local float rad;

	rad = Max(blastRadius*28, 2048); //CyberP: was *4
	if (IsA('Dart'))
		PlaySound(ImpactSound, SLOT_None, 2.0,, rad,1.15);
	else if (IsA('RubberBullet')) //Special case for rubber bullets as they can be problematic
	{
	  if (FRand() < 0.6)
		  PlaySound(ImpactSound, SLOT_Interact, 1.5,, 512);
	}
	else
		PlaySound(ImpactSound, SLOT_None, 2.0,, rad);
}

function bool CheckHelmetCollision(int actualDamage, Vector hitLocation, name damageType, Pawn helmetPawn) //RSD: Adapted from HandleDamage() in ScriptedPawn.uc
{
	local float        headOffsetZ, headOffsetY, armOffset;
    local vector offset;

	// calculate our hit extents
	headOffsetZ = helmetPawn.CollisionHeight * 0.7;
	headOffsetY = helmetPawn.CollisionRadius * 0.3;
	armOffset   = helmetPawn.CollisionRadius * 0.35;

    offset = (hitLocation - helmetPawn.Location) << helmetPawn.Rotation;

	if (actualDamage > 0)
	{
		if (offset.z > headOffsetZ)		// head
		{
		    if (offset.z > HelmetPawn.CollisionHeight * 0.85 && !(abs(offset.y) < headOffsetY && offset.x > 0.0 && offset.z < CollisionHeight*0.93) //RSD: Was CollisionHeight*0.93, I'm making it *0.85, and NOT from the front
            	&& (damageType == 'Shot' || damageType == 'Poison' || damageType == 'Stunned'))
            {
				if (actualDamage >= 25)
					return false;
				else
					return true;
            }
		}
	}

	return false;
}

//RSD: stolen from HurtRadius() in Actor.uc to patch out mover damage through walls
//SARGE: make damage scale with ADS level, rather than always doing full damage
function HurtRadiusGMDX( float DamageAmount, float DamageRadius, name DamageName, float Momentum, vector HitLocation, optional bool bIgnoreLOS , optional bool bIgnoreLOSmover)
{
	local actor Victims;
	local float damageScale, dist, mult;
	local vector dir;
	// DEUS_EX CNN
	local Mover M;

	if( bHurtEntry )
		return;

	bHurtEntry = true;
	if (!bIgnoreLOS)
	{
		foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
		{
			if( Victims != self)
			{
				//SARGE: Reduce damage dealt when exploded by ADS
				if ( Victims == aggressiveExploder )
				{
					mult = 0.2 + (aggressiveExploder.AugmentationSystem.GetClassLevel(class'AugDefense') * 0.1);
					damageAmount = mult * damageAmount;
				}
				dir = Victims.Location - HitLocation;
				dist = FMax(1,VSize(dir));
				dir = dir/dist;
				damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
				Victims.TakeDamage (
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
				//SARGE: Reduce damage dealt when exploded by ADS
				if ( Victims == aggressiveExploder )
				{
					mult = 0.2 + (aggressiveExploder.AugmentationSystem.GetClassLevel(class'AugDefense') * 0.1);
					damageAmount = mult * damageAmount;
				}
				dir = Victims.Location - HitLocation;
				dist = FMax(1,VSize(dir));
				dir = dir/dist;
				damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
				Victims.TakeDamage (
					damageScale * DamageAmount,
					Instigator,
					Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
					(damageScale * Momentum * dir),
					DamageName
				);
			}
		}
	}

	// DEUS_EX - CNN - damage the movers, also
	if (!bIgnoreLOSmover)   //RSD: New mover LOS bool
	{
		foreach VisibleCollidingActors(class 'Mover', M, DamageRadius, HitLocation)
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
	}
	else
	{
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
	}

	bHurtEntry = false;
}


auto state Flying
{
	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if (bStuck)
			return;

        //G-Flex: let's try sticking projectiles in decorations
		//G-Flex: or not, collision cylinders make it look terrible and weird and ugly //CyberP: overruled! We'll have special cases
		if ( Other != None && ( ( bStickToWall && DeusExDecoration(Other) != None && DeusExDecoration(Other).bInvincible && !DeusExDecoration(Other).bPushable ) 
				|| ( IsA('Shuriken') && DeusExDecoration(Other) != None ) ) )
		{
			HitWall(normal(Velocity), Other);
		}
		else if(Other != None && DeusExDecoration(Other) != None && !Other.IsA('DeusExPlayer')) //Ygll: test to have some visual hit event with all object, add the player to the test to advert issue when moving
		{
			HitWall(normal(Velocity), Other);
		}

		if( Other != None && (Other != instigator) && (DeusExProjectile(Other) == None) && (Other != Owner) )
		{
			if (IsA('ThrownProjectile') && (Other.IsA('DeusExCarcass') || Other.IsA('Pickup')))
			{
		        return;    //CyberP: don't explode when hitting carci or pickups
			}

			damagee = Other;

			Explode(HitLocation, Normal(HitLocation-damagee.Location));

			// DEUS_EX AMSD Spawn blood server side only
			if (Role == ROLE_Authority)
			{
				//Ygll: change to add hit effect on all flesh target type
				if ((damagee.IsA('Pawn') || damagee.IsA('DeusExCarcass')) && !damagee.IsA('Robot'))
				{
				   SpawnBlood(HitLocation, Normal(HitLocation-damagee.Location));
				}
			}
		}
		else if( Other != None && ( Other.IsA('LAM') || Other.IsA('EMPGrenade') || Other.IsA('GasGrenade') || Other.IsA('NanoVirusGrenade') ) ) //RSD: special case for hitting wall mines since they get filtered by above
		{
            damagee = Other;
            Explode(HitLocation, Normal(HitLocation-damagee.Location));
		}
	}

	simulated function HitWall(vector HitNormal, actor Wall)
	{
		local float speed2;

		if (Wall != None && Wall.IsA('Mover')) //CyberP A.K.A Totalitarian: since movers seem to ignore plasma...
		{
			if (bPlusOneDamage)                                                     //RSD: remove random damage variation
			   Damage=Damage-1.0;
			if (IsA('PlasmaBolt') || IsA('PlasmaPS20'))
			   Wall.TakeDamage(Damage, Pawn(Owner), Wall.Location, MomentumTransfer*Normal(Velocity), damageType);
		}
	
	   if (IsA('RubberBullet'))
	   {
			Velocity = 0.8*((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
			speed2 = VSize(Velocity);
			bFixedRotationDir = true;
			RotationRate = RotRand(false);
			if ((speed2 > 0) && (speed2 < 50))
			{
				SetPhysics(PHYS_None);
				bStickToWall=true;
				bStuck = true;
				Velocity = vect(0,0,0);
				if (Physics == PHYS_None)
					bFixedRotationDir = false;
			}
			else if (speed2 < 800)
			{
				if (FRand() < 0.5)
					ImpactSound=None;
				else
					ImpactSound=Sound'DeusExSounds.Generic.BasketballBounce';
			}
		}
		
		if (bStickToWall)
		{
			if (IsA('Shuriken') && ( Wall != None && ( Wall.IsA('DeusExDecoration') || Wall.IsA('Pickup') ) ) )
		    {
		        SetCollisionSize(4.0,3.0);
		        bBounce = true;
			    Velocity = 0.8*((Velocity dot HitNormal) * HitNormal * (-2.0) + (Velocity*0.75));   // Reflect off Wall w/damping
			    bFixedRotationDir = true;
				RotationRate.Pitch = (32768 - Rand(65536)) * 4.0;
                RotationRate.Yaw = (32768 - Rand(65536)) * 4.0;
				
				if (DeusExDecoration(Wall) != None && DeusExDecoration(Wall).fragType == class'MetalFragment')
					PlaySound(sound'bouncemetal',SLOT_None,,,2048,1.3);
				else
					PlaySound(sound'BulletHitFlesh',SLOT_None,,,2048,1.1);

				if (bPlusOneDamage)                                              //RSD: remove random damage variation
					Damage=Damage-1.0;

				Wall.TakeDamage(Damage,Pawn(Owner),Location,MomentumTransfer*Normal(Velocity)*0.001,damageType);
				GoToState('Ricocheted');
	        }
			else
            {
				if (IsA('Dart') || IsA('Shuriken'))
				{
					SetCollisionSize(4.0,3.0);
				}
				Velocity = vect(0,0,0);
				Acceleration = vect(0,0,0);
				SetPhysics(PHYS_None);
				bStuck = true;
		    }

			if (!IsA('RubberBullet'))
			{
				ImpactSound = Sound'DeusExSounds.Weapons.CrowbarHitSoft';

				CreateDartHitBaseEffect(true);

				// MBCODE: Do this only on server side
				if ( Role == ROLE_Authority )
				{
					if (Level.NetMode != NM_Standalone)
						SetTimer(5.0,false);

					if ( Wall != None && Wall.IsA('Mover'))
					{
						SetBase(Wall);
						if (bPlusOneDamage)                                         //RSD: remove random damage variation
							Damage=Damage-1.0;
						Wall.TakeDamage(Damage, Pawn(Owner), Wall.Location, MomentumTransfer*Normal(Velocity), damageType);

						//Sarge: Don't allow knives to be retrieved if they damaged a locked object
						if (IsA('Shuriken') && DeusExMover(Wall).bLocked && Damage >= DeusExMover(Wall).minDamagethreshold)
							Destroy();
					}
				}
			}
		}
        else if( IsA('Dart') )                        //RSD: Still do hit effects for Darts on Hardcore or fragile dart enable (bSticktoWall=false)
        {
			// Ygll : Adding Taser dart to handle them with new the hardcore rule and 'Fragile Dart' gameplay option enable.
			ImpactSound = Sound'DeusExSounds.Weapons.BatonHitSoft';	//RSD: Weaker sound effect to help sell the illusion of dart breaking
			CreateDartHitBaseEffect(true);
        }
		
		// MBCODE: Do this only on server side
		if ( Role == ROLE_Authority )
		{
			if (Level.NetMode != NM_Standalone)
				SetTimer(5.0,false);

			if ( Wall != None && Wall.IsA('Mover'))
			{
				SetBase(Wall);
				if (bPlusOneDamage)                                         //RSD: remove random damage variation
					Damage=Damage-1.0;

				Wall.TakeDamage(Damage, Pawn(Owner), Wall.Location, MomentumTransfer*Normal(Velocity), damageType);
			}
		}

		if ( Wall != None && Wall.IsA('BreakableGlass'))
			bDebris = false;
		
		//Ygll: Doing a change to add hit sfx effect on all containers object classe except paper type
		if ( ( Wall != None && !Wall.IsA('Containers') ) || (Wall != None && Wall.IsA('Containers') && Containers(Wall).fragType != class'DeusEx.PaperFragment'))
        {
			SpawnEffects(Location, HitNormal, Wall);
        }
		
		Super.HitWall(HitNormal, Wall);
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local bool bDestroy;
		local float rad, mult;
        local FireballSpoof fSpoof;
        local SFXExp exp;

	    // Reduce damage on nano exploded projectiles
	    if (bAggressiveExploded)
        {
            if (Level.NetMode != NM_Standalone)
		        Damage = Damage/6;
        }

		bDestroy = false;

		if (bExplodes)
		{
			//DEUS_EX AMSD Don't draw effects on dedicated server
			if ((Level.NetMode != NM_DedicatedServer) || (Role < ROLE_Authority))
				DrawExplosionEffects(HitLocation, HitNormal);

			GotoState('Exploding');
		}
		else
		{
			// Server side only
			if ( Role == ROLE_Authority )
			{
				if ((damagee != None) && (Tracer(Self) == None)) // Don't even attempt damage with a tracer
				{
					if ( Level.NetMode != NM_Standalone )
					{
						if ( damagee.IsA('DeusExPlayer') )
							DeusExPlayer(damagee).myProjKiller = Self;
					}
					if (damagee.IsA('ScriptedPawn'))         //RSD: Putting headshot extraMult stuff here (see DeusExWeapon.uc for trace weapons)
					{
                    	if (IsA('Shuriken'))
                    	{
                        	ScriptedPawn(damagee).extraMult = 1;
                        	//if (FRand() < 0.7)                                  //RSD: This part is relocated too
               				//	ScriptedPawn(damagee).impaleCount++;
               				ScriptedPawn(damagee).impaleCount = 1;              //RSD: max of one TK return, but it's 100% chance
                    	}
                        else
                        	ScriptedPawn(damagee).extraMult = 0;                //RSD: pretty sure this was missing from original implementation! Agh!

                       	if (ScriptedPawn(damagee).extraMult != 0)               //RSD: Ensuring that no extraMult is added in edge cases
 			        		ScriptedPawn(damagee).bHeadshotAltered = true;
			        	else
                    		ScriptedPawn(damagee).bHeadshotAltered = false;

          		        if (IsA('DartTaser'))                                   //RSD: Altered stun timer stuff here (see DeusExWeapon.uc for trace weapons)
          		        {
          		        	//ScriptedPawn(damagee).stunSleepTime = 7.5;
          		        	ScriptedPawn(damagee).stunSleepTime = 0.5*Damage;   //RSD: Stun time is 1/3 of damage
          		        	ScriptedPawn(damagee).bStunTimeAltered = true;
          		        	Damage = 0;                                         //RSD: Taser dart does no actual damage
 		        	    }
 		        	    else
 		        	    {
 		        	    	ScriptedPawn(damagee).bStunTimeAltered = false;
      	    	        }
					}
					if (!damagee.IsA('ScriptedPawn') && bPlusOneDamage)         //RSD: remove random damage variation
						Damage=Damage-1.0;
					if (!(damagee.IsA('ScriptedPawn') && pawnAlreadyHit != None && ScriptedPawn(damagee) == pawnAlreadyHit)) //RSD: Don't multihit enemies with the Controlled Burn perk
						damagee.TakeDamage(Damage, Pawn(Owner), HitLocation, MomentumTransfer*Normal(Velocity), damageType);
					//log("Damage =" $Damage);
				}
			}

			//Ygll: just a comment, here we gonna to destroy all item classe with the parameter at false (from hardcore or gameplay option settings or item parameter)
			if (!bStuck)
				bDestroy = true;
		}

		rad = Max(blastRadius*24, 1024);

		// This needs to be outside the simulated call chain
		// RSD: Don't play impact sounds if we're hitting a helmet (alt sound handled in HandleDamage() in ScriptedPawn.uc)
		// Ygll: Now all projectile item type will have the deflect sound
		if( ( damagee != None && !damagee.IsA('ScriptedPawn') )
			|| ( damagee != None && damagee.IsA('ScriptedPawn') && ( !ScriptedPawn(damagee).bHasHelmet || ( ScriptedPawn(damagee).bHasHelmet && !CheckHelmetCollision(Damage, HitLocation, damageType, ScriptedPawn(damagee)) ) ) ) )
		{
			if (IsA('DartPoison') && damagee.IsA('Robot'))  //RSD: Play weak sound for dart deflecting
			{
				PlaySound(sound'BatonHitSoft', SLOT_None, 2.0,, 1536,1.15);
			}
			else
			{
				PlayImpactSound();
			}
		}
		else
			PlayImpactSound();

		//DEUS_EX AMSD Only do these server side
		if (Role == ROLE_Authority)
		{
			if (ImpactSound != None)
			{
				//log("EXPLODE:"@blastRadius);
				AISendEvent('LoudNoise', EAITYPE_Audio, 2.0, blastRadius*10);
				if (bExplodes)
				   AISendEvent('WeaponFire', EAITYPE_Audio, 2.0, blastRadius*2);
			}
		}
	  
		if (IsA('RubberBullet') || IsA('ShockRingProjectile'))
			bDestroy=false;

        if (IsA('Fireball') && damagee != None && damagee.IsA('ScriptedPawn') && Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkControlledBurn').bPerkObtained)
        {
            bDestroy=false;
            pawnAlreadyHit = ScriptedPawn(damagee);
        }

	    if (IsA('Fireball') && FRand() < 0.5)
	    {
	        if (damagee == None || !damagee.IsA('DeusExPlayer') )
			{
				fSpoof = spawn(class'FireballSpoof');
				if (fSpoof != None)
					fSpoof.drawscale += (drawscale*0.6);

				exp = Spawn(class'SFXExp');
				if (exp != None)
				{
					exp.Velocity.Z = 4;
					exp.scaleFactor = 1.25+DrawScale;
					exp.Velocity.Z = 2;
				}
	        }
        }

		if (bDestroy)
			Destroy();
	}

	simulated function BeginState()
	{
		local DeusExWeapon W;
		
        if (IsA('Dart') || IsA('Shuriken'))
           SetCollisionSize(0.5,0.5);
	   
		initLoc = Location;
		initDir = vector(Rotation);
		Velocity = speed*initDir;
		
		if (W != None && W.IsA('WeaponPlasmaRifle'))
			PlaySound(SpawnSound, SLOT_None,1.2,,8193);
		else
			PlaySound(SpawnSound, SLOT_None,,,2048);
	}
}

//
// update our flight path based on our ranges and tracking info
//
simulated function Tick(float deltaTime)
{
	local float dist, size;
	local Rotator dir;
	local vector TargetLocation;
	local vector vel;
	local vector NormalHeading;
	local vector NormalDesiredHeading;
	local float HeadingDiffDot;
	local vector zerovec;

	local DeusExPlayer dxPlayer;
	local vector rx,ry,rz;

	if (bStuck)
		return;

	Super.Tick(deltaTime);

	if ((bEmitDanger)&&(WarningTimer<=0.0))
	{
		AIStartEvent('Projectile', EAITYPE_Visual);
		WarningTimer=default.WarningTimer;
	} else WarningTimer-=deltaTime;

	if (VSize(LastSeenLoc) < 1)
	{
	  LastSeenLoc = Location + Normal(Vector(Rotation)) * 10000;
	}

	if (Role == ROLE_Authority)
	{
	  bHasNetworkTarget = (Target != None);
	}
	else
	{
	  bHadLocalTarget = (bHadLocalTarget || (Target != None));
	}

	dxPlayer=DeusExPlayer(Owner);

	if (bTracking && ((Target != None) || ((Level.NetMode != NM_Standalone) && (bHasNetworkTarget)) || ((Level.Netmode != NM_Standalone) && (bHadLocalTarget))))
	{
		// check it's range
		dist = Abs(VSize(Target.Location - Location));
		if ( (dist > MaxRange) && ( !(IsA('Rocket') && (dxPlayer != None) && (dxPlayer.RocketTarget != None)) ) ) 
		{
				// if we're out of range, lose the lock and quit tracking
			bTracking = false;
			Target = None;
			return;
		}
		else
		{
			// get the direction to the target
		 if (Level.NetMode == NM_Standalone)
			TargetLocation = Target.Location;
		 else
			TargetLocation = AcquireMPTargetLocation();
		 if (Role == ROLE_Authority)
			NetworkTargetLoc = TargetLocation;
		 LastSeenLoc = TargetLocation;
			dir = Rotator(TargetLocation - Location);
			dir.Roll = 0;

		 if (Level.Netmode != NM_Standalone)
		 {
			NormalHeading = Normal(Vector(Rotation));
			NormalDesiredHeading = Normal(TargetLocation - Location);
			HeadingDiffDot = NormalHeading Dot NormalDesiredHeading;
		 }

			// set our new rotation
			bRotateToDesired = true;
			DesiredRotation = dir;

			// move us in the new direction that we are facing
			size = VSize(Velocity);
			vel = Normal(Vector(Rotation));

		 if (Level.NetMode != NM_Standalone)
		 {
			size = FMax(HeadingDiffDot,0.4) * Speed;
		 }
			Velocity = vel * size;
		}
	}
	else
	{
		if ((IsA('Rocket')) && (dxPlayer != None) && (dxPlayer.bGEPprojectileInflight) && (Rocket(self).bGEPInFlight))
		{
			if (dxPlayer.bGEPzoomActive)
			{
				dxPlayer.UpdateTrackingSteering(DeltaTime);

				GetAxes(Rotator(Velocity),rx,ry,rz);
				dir=Rotator(rx*25.0+ry*dxPlayer.GEPSteeringX*0.8+rz*dxPlayer.GEPSteeringY*0.8);

				dir.Roll = 0;
				bRotateToDesired = true;
				DesiredRotation=dir;

				size = VSize(Velocity);
				vel = Normal(Vector(Rotation));
				Velocity = vel * size * SpeedMod();
			}
		}
		SetRotation(Rotator(Velocity));
	}

	dist = Abs(VSize(initLoc - Location));

    if (IsA('ThrownProjectile'))                                                //RSD: Retain old arc with grenades
    {
        if (dist > AccurateRange)
            Acceleration = gravMult*Region.Zone.ZoneGravity;
    }
    else if (Owner != None && Owner.IsA('ScriptedPawn'))                        //RSD: NPCs retain old drop formula
    {
		if (dist > AccurateRange/100 && IsA('SpiderConstructorLaunched'))
			Acceleration = Region.Zone.ZoneGravity / 2.2;
        else if (dist > AccurateRange)
			Acceleration = Region.Zone.ZoneGravity / 2;
    }
    else if (gravMult > 0) //RSD: New simple and effective formula for gravity, multiplier determined individually with MATH and SCIENCE
		Acceleration = gravMult*Region.Zone.ZoneGravity;

    if ((Role < ROLE_Authority) && (bAggressiveExploded))
	  Explode(Location, vect(0,0,1));
}

defaultproperties
{
     AccurateRange=800
     maxRange=1600
     MinDrawScale=0.050000
     maxDrawScale=2.500000
     bEmitDanger=true
     ItemName="DEFAULT PROJECTILE NAME - REPORT THIS AS A BUG"
     ItemArticle="Error"
     WarningTimer=1.000000
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=60.000000
     RotationRate=(Pitch=65536,Yaw=65536)
}
