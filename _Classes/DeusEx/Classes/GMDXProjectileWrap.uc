//-----------------------------------------------------------
//GMDX:by dasraiser, throwing wrapper for decoration, deco will follow projectile collision
//W.I.P.
// fixed fragments
// need to fix detect tracking destroyed! (fixed)
//-----------------------------------------------------------
class GMDXProjectileWrap extends DeusExProjectile;

var Decoration TrackingDeco;
var bool bTackedOn;
var bool bFirstHit;
var float Elasticity;
var DeusExPlayer DxPlayer;
var bool bStartDelay;
var bool bStartDelayCount;
var float DelayThrow;
var float DelayTime; //adjust for corpse;
var float ZgravDiv;
var float AugDamMod;
var float ArmTimer;

//var FireSmoke smoke[5]; just for testing
//var int NoSmokeEffects;


var sound CollideSound;

function bool WrapWithDecoration()
{
	local vector lookDir, upDir;
	local float velscale, size, mult;
	local Augmentation muscleAug;


   //log("GMDX PROJECTILE OWNER "@Owner);

   if ((TrackingDeco!=None)&&(DxPlayer!=None))
   {
      if (TrackingDeco.CollisionHeight == TrackingDeco.default.CollisionHeight && TrackingDeco.CollisionRadius == TrackingDeco.default.CollisionRadius)
         TrackingDeco.SetCollisionSize(TrackingDeco.default.CollisionRadius*0.9,TrackingDeco.default.CollisionHeight*0.9);
	  bTackedOn=true;
   } else
   {
		Destroy();
		return false;
   }


   // throw velocity is based on augmentation Level, not level value!
   if (DxPlayer.AugmentationSystem != None)
   {
        muscleAug = DxPlayer.AugmentationSystem.GetAug(class'AugMuscle');
   
	  mult = 2.5+muscleAug.CurrentLevel; //CyberP: increased 1+

	  if (mult == 0.0)
		 mult = 1.0; //passive but incase it hasn't engaged
//         else
//            mult*=1.5;
	  
      //log("AUG LEVEL "@mult);
      //SARGE: Changed from 3/2/0 to 20/10/5
	  if (trackingDeco.Mass > 100)
	        DxPlayer.Energy -= muscleAug.GetAdjustedEnergy(20.0);
	  else if (trackingDeco.Mass > 60)
	        DxPlayer.Energy -= muscleAug.GetAdjustedEnergy(10.0);
	  else if (trackingDeco.Mass > 30)
      //else
            DxPlayer.Energy -= muscleAug.GetAdjustedEnergy(5.0);

	  if (DxPlayer.Energy < 0)
	     DxPlayer.Energy = 0;

      muscleAug.displayAsActiveTime = dxPlayer.saveTime + 0.5;
   }

   if (mult==4) AugDamMod=2; else AugDamMod=1.2;
   if (FRand()<0.33)
	  PlaySound(Sound'DeusExSounds.Player.MaleLand', SLOT_None, 0.9, false, 800, 0.75*(1.0+10.0/FClamp(Mass,20.0,150.0-20.0*mult)));
   DxPlayer.AISendEvent('Futz', EAITYPE_Visual);
//log("CARRIED DECO, found valid");
//set mass etc to deco
   if (TrackingDeco.IsA('Carcass'))
   {
	  SetCollisionSize(10,16); //SetCollisionSize(1,TrackingDeco.default.CollisionHeight);
	  Mass=TrackingDeco.Mass/2; //CyberP: divide by 3.5, was 4
	  mult += 2;
   } else
   {
	  Mass=TrackingDeco.Mass;
	  SetCollisionSize(TrackingDeco.CollisionRadius,TrackingDeco.CollisionHeight);
   }

   Velocity = Vector(DxPlayer.ViewRotation) * mult * 400;// + vect(0,0,220)+ 40 * VRand();
   Velocity.Z += 100;

    // scale it based on the mass
	velscale = FClamp(Sqrt(Mass)/6.0, 1.0, 60.0);
	Velocity /= velscale;
	Velocity +=DxPlayer.Velocity;

	Speed = VSize(Velocity);
	MaxSpeed=Speed*2;

   Damage=Sqrt(Mass*mult)*mult;

   if (mult>2) Damage*=1.25;

   MomentumTransfer=Mass/2;

   SetLocation(TrackingDeco.Location);
   SetRotation(DxPlayer.ViewRotation);

   TrackingDeco.SetPhysics(PHYS_none);
   TrackingDeco.SetBase(self);
   Attach(TrackingDeco);
   SetPhysics(PHYS_Projectile);

    SetCollision(True,True,True);
	bCollideWorld = True;

	if (Mass <= 80 && !TrackingDeco.IsA('Plant1') && !TrackingDeco.IsA('Plant2'))
	{
	   TrackingDeco.bFixedRotationDir = True;
	   bFixedRotationDir = True;
	   if (Mass > 40)
	   {
	   RotationRate.Pitch = (32768 - Rand(31000));
       RotationRate.Yaw = (32768 - Rand(31000));
	   }
	   else
	   {
	   RotationRate.Pitch = (32768 - Rand(31000)) * 2.0;
       RotationRate.Yaw = (32768 - Rand(31000)) * 2.0;
       }
    }
    bStartDelay=false;
}

function InitWrapDecoration(Decoration CarriedDecoration,DeusExPlayer DxP)//,bool DropFromPlayer)
{
   //log(self);
	if (CarriedDecoration != None)
	{
	  if (CarriedDecoration.IsA('Carcass'))
	     DelayTime=0.04; //CyberP: was 0.125 //das 0.1
	  DxPlayer=DxP;
	  TrackingDeco=CarriedDecoration;
	  SetOwner(DxPlayer);
	  bStartDelayCount=true;
   }
}

function DelayedWrapDecoration()
{
	local Vector X, Y, Z, dropVect, origLoc, HitLocation, HitNormal, extent;
	local float velscale, size, mult;
	local bool bSuccess;
	local Actor hitActor;
    local class<Fragment> fragType;
	bSuccess = False;

	if (TrackingDeco != None)
	{
     if (TrackingDeco.IsA('DeusExDecoration'))
         fragType = DeusExDecoration(TrackingDeco).fragType;
	if (TrackingDeco.IsA('DeusExDecoration'))
   {
	  if(TrackingDeco.IsA('Basketball'))
	  {
		 CollideSound=None;//sound'GasGrenadeExplode';
		 Elasticity=0.85;
	  }
	  else
	  if(TrackingDeco.IsA('Poolball'))
	  {
		 CollideSound=sound'PoolballClack';
		 Elasticity=0.6;
	  }
	  else
	  if(TrackingDeco.IsA('CrateUnbreakableSmall') || TrackingDeco.IsA('CrateUnbreakableMed')  || TrackingDeco.IsA('CrateUnbreakableLarge'))
	  {
		 CollideSound=sound'MetalHit2';
	  }
	  else
		if (fragType == class'WoodFragment')
		{
			if (TrackingDeco.Mass <= 10)
				CollideSound = sound'WoodHit1';
			else
				CollideSound = sound'WoodBreakLarge';
		}
		else if (fragType == class'MetalFragment')
		{
			if ((TrackingDeco.Mass <= 40)||FRand()<0.2)
				CollideSound = sound'bouncemetal';
			else
				CollideSound = sound'MetalHit2';
		}
		else if (fragType == class'PlasticFragment')
		{
			//if ((TrackingDeco.Mass <= 20)||FRand()<0.5)
				//CollideSound = sound'PlasticHit1';
			//else
				CollideSound = sound'woodhvydrop_wood';
		}
		else if (fragType == class'GlassFragment')
		{
			if ((TrackingDeco.Mass <= 20)||FRand()<0.5)
				CollideSound = sound'GlassHit1';
			else
				CollideSound = sound'GlassHit2';
		}
		else	// paper sound
		{
			if (TrackingDeco.Mass <= 15)
				CollideSound = sound'PaperHit2';
			else
				CollideSound = sound'woodhvydrop_wood';
		}
   }
   else
	  if (fRand()<0.5) CollideSound=Sound'DeusExSounds.Generic.FleshHit1';
		 else
			CollideSound=Sound'DeusExSounds.Generic.FleshHit2';

   TrackingDeco.SetCollision(False, False, False);
   TrackingDeco.bCollideWorld = False;
   WrapWithDecoration();
	} else Destroy();
}

function UnWrap()
{
//   log("TRACKING Defaults UNWRAP|n"@
//   TrackingDeco.default.bCollideActors@"|n "@
//   TrackingDeco.default.bBlockActors@"|n "@
//   TrackingDeco.default.bBlockPlayers@"|n "@
//   TrackingDeco.default.bCollideWorld@"|n "@
//   TrackingDeco.default.CollisionRadius@"|n "@
//   TrackingDeco.default.CollisionHeight@"|n "@
//   TrackingDeco.default.Physics);
   if (TrackingDeco != none)
   {
   if (TrackingDeco.IsA('Basketball'))
      PlaySound(sound'GasGrenadeExplode',SLOT_None,,,1536,1.5);
   Detach(TrackingDeco);

   TrackingDeco.SetCollision(TrackingDeco.default.bCollideActors,
   TrackingDeco.default.bBlockActors,
   TrackingDeco.default.bBlockPlayers);
   TrackingDeco.bCollideWorld=TrackingDeco.default.bCollideWorld;

//   TrackingDeco.SetCollisionSize(TrackingDeco.default.CollisionRadius,
//   TrackingDeco.default.CollisionHeight);

   TrackingDeco.SetPhysics(PHYS_Falling);
   TrackingDeco.SetBase(TrackingDeco);
   AIEndEvent('WeaponDrawn', EAITYPE_Visual);


   if (TrackingDeco.IsA('Carcass'))
   {
	  TrackingDeco.bCollideWorld=true; //GMDX need to figure why this is set in PostBeginPlay()
//      TrackingDeco.GotoState( 'Auto' );
   }
//   log("TRACKING UNWRAP|ln"@TrackingDeco@" "@
//   TrackingDeco.bCollideActors@"|n "@
//   TrackingDeco.bBlockActors@"|n "@
//   TrackingDeco.bBlockPlayers@"|n "@
//   TrackingDeco.bCollideWorld@"|n "@
//   TrackingDeco.CollisionRadius@"|n "@
//   TrackingDeco.CollisionHeight@"|n "@
//   TrackingDeco.Physics);

//   if (TrackingDeco.IsA('POVcorpse')) DropPOVcorpse();
   TrackingDeco.BaseChange();
   if (bStuck) Destroy();
   }
}

simulated function Tick(float deltaTime)
{
//	local float dist, size;
//	local Rotator dir;

//   super.Tick(deltaTime);

   if (bStartDelay)
   {
	  if (bStartDelayCount)
	  {
		 if (DelayThrow<DelayTime) DelayThrow+=deltaTime;
			else
			{
			   bStartDelayCount=false;
			   DelayedWrapDecoration();
			}
	  }
   } else
   {
         if (trackingDeco != None && Mass <= 80 && !TrackingDeco.IsA('Plant1') && !TrackingDeco.IsA('Plant2'))
	      trackingDeco.SetRotation(Rotation);
	  Acceleration = Region.Zone.ZoneGravity / (ZgravDiv*0.65);
	  ZgravDiv-=0.005*deltaTime;
	  ZgravDiv=fMax(1,ZgravDiv);
	  if (ArmTimer>0) ArmTimer-=deltaTime;
	}

   if (bTackedOn&&((TrackingDeco==none)||((DeusExDecoration(TrackingDeco)!=none)&&(DeusExDecoration(TrackingDeco).HitPoints<=0))))
   {
      if (TrackingDeco!=none && !TrackingDeco.IsInState('Exploding'))   //v9 added
          TrackingDeco.Destroy();
      if (TrackingDeco == None || (TrackingDeco!= None && !TrackingDeco.IsInState('Exploding')))
	      Destroy();
   }
}


// just in case
function Destroyed()
{
//   local int i;
//   for (i=0;i<5;i++)
//	if ( smoke[i] != None )
//		smoke[i].Destroy();
//   log(self@" has been destroyed"@bStuck);
   if (!bStuck) UnWrap();
	Super.Destroyed();
}


auto simulated state Flying
{

/*   simulated function SpawnSomeSmoke()
   {
	  local int i;
	  local bool bfound;
	  for(i=0;i<5;i++)
	  {
		 if (smoke[i]==none) {bfound=true;break;}
	  }
	  if (bfound)
	  {
			smoke[i] = Spawn( class'FireSmoke',,,Location);
			smoke[i].DrawScale=CollisionHeight/12;
	  }
   }
*/
	simulated function Explode(vector HitLocation, vector HitNormal)
	{
	  //log("EXPLODE FLYING@");
	}

	singular function HitWall(vector HitNormal, actor HitWall)
	{
		local Rotator rot;
		local float   volume;

	  //log("HIT WALL "@HitWall);
//      if(HitWall.IsA('Pawn'))

        if (!Hitwall.IsA('BreakableGlass'))
		Velocity = Elasticity*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		speed = VSize(Velocity);

		if (bFirstHit && speed<400)
			bFirstHit=False;
		//RotationRate = RotRand(True);

		if ( (speed < 60) && (HitNormal.Z > 0.7) )
		{
			volume = 0.5+FRand()*0.5;

			if (CollideSound != None)
			   PlaySound(CollideSound, SLOT_None, volume*1.5,, 2048, 0.85+FRand()*0.5); //CyberP: increased radius by 100%
				//PlaySound(MiscSound, SLOT_None, volume,, 512, 0.85+FRand()*0.3);

			// I know this is a little cheesy, but certain grenade types should
			// not alert AIs unless they are really really close - CNN
//			if (AISoundLevel > 0.0)
//				AISendEvent('LoudNoise', EAITYPE_Audio, volume, AISoundLevel*256);

			SetPhysics(PHYS_None, HitWall);
			if (Physics == PHYS_None)
			{
//				rot = Rotator(HitNormal);
	//			rot.Yaw = Rand(65536);
	//			SetRotation(rot);
				bBounce = False;
				bStuck = True;
			//log("Deco is bStuck"@self@TrackingDeco@HitWall);
				UnWrap();
			}
		}
		else If (speed > 99)
		{
//		   SpawnSomeSmoke();
		   DamagePawn(HitWall);
//			PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		}
	}

   function DamagePawn (Actor Other)
	{
	  local actor HitActor;
	  local vector HitLocation, HitNormal, TestLocation;

		if (bStuck)
			return;
//log("DECO PROCESS TOUCH2 "@Other);

	  HitActor = Trace(HitLocation, HitNormal, Location, OldLocation, true);
	  //log("DECO HitActor "@HitActor);

		if((Other!=none)&&(Other.IsA('Pawn')))
		{
			if (Pawn(Other).AdjustHitLocation(HitLocation, Velocity))
			ProcessDamage(Other, Other.Location + Other.CollisionRadius * Normal(Location - Other.Location));
			else
			   ProcessDamage(none, Location + CollisionRadius * Normal(Location));
		}
		else
		 ProcessDamage(Other, Location + CollisionRadius * Normal(Location));
   }

   function ProcessDamage (Actor Other, Vector HitLocation)
   {
	  local float  baseMass;
	  local float  standingMass;
      local float  Dmg;
      local float  ClampInfluence; //CyberP
      local float  MassModifier; //CyberP

      clampInfluence = DxPlayer.AugmentationSystem.GetClassLevel(class'AugMuscle');
      MassModifier = 1;

      if (TrackingDeco != none)
      {
      if (TrackingDeco.Mass < 40)
      MassModifier = 0.25;
      else if  (TrackingDeco.Mass < 80) //less than barrel1
      MassModifier = 0.75;
      else if  (TrackingDeco.Mass < 200)
      MassModifier = 2.0;
      else if  (TrackingDeco.Mass >= 200)
      MassModifier = 2.5;
      }

	  if ((Other!=None)&&(!Other.IsA('LevelInfo')))
	  {
		 Dmg=Vsize(Other.Velocity*Other.Mass-Mass*Velocity);
	  } else
	  {
		 Dmg=Mass*Vsize(Velocity);
	  }
		Dmg/=1000.0;
		Dmg+=Damage;
		//Dmg*=AugDamMod;
	  //Log("Proccess Damage "@Dmg);

	  if (Other!=None)
	  {
		 if (DeusExPlayer(Other)!=None)
		 {
			if (ArmTimer<=0) Dmg*=0.3;
			   else Dmg=0;
		 }
		else if (Other.IsA('Pawn') && clampInfluence >= 4) Dmg=110*MassModifier;
		else if (Other.IsA('Pawn') && clampInfluence >= 3) Dmg=95*MassModifier; //CyberP: Meh, it will do.
        else if (Other.IsA('Pawn') && clampInfluence == 2) Dmg=80*MassModifier;
        else if (Other.IsA('Pawn') && clampInfluence < 2) Dmg=75*MassModifier;
		 //log("GMDX:Projectile "@Other@" "@Dmg@Damage@AugDamMod);

         if ((Other.IsA('DeusExMover'))&&(DeusExMover(Other).minDamageThreshold>=40)) //CyberP: no movers DT 40 or over
         {
         }
         else if ((Other.IsA('HackableDevices')) && (HackableDevices(Other).minDamageThreshold>=40)) //CyberP: hackable devices too
         {
         }
         else if ((Other.IsA('AutoTurret')) && (AutoTurret(Other).minDamageThreshold>=40)) //CyberP: base of turret is deco not hackable device
         {
         }
         else if (TrackingDeco.IsA('Pillow') || TrackingDeco.IsA('Cushion') || TrackingDeco.IsA('BoxSmall') || TrackingDeco.IsA('BoxMedium') || TrackingDeco.IsA('BoxLarge'))
         Other.TakeDamage(Dmg,DxPlayer,HitLocation, 0.2*Velocity, 'KnockedOut');   //CyberP: nonlethal
         else
		 Other.TakeDamage(Dmg,DxPlayer,HitLocation, 0.2*Velocity, 'Throw');
	  }

	  //if (((TrackingDeco.IsA('DeusExCarcass')&&DeusExCarcass(TrackingDeco).CumulativeDamage<DeusExCarcass(TrackingDeco).MaxDamage))
	//	 ||!TrackingDeco.IsA('DeusExCarcass'))     //stop potential double gib carcass..
	//	 {
			//log("Tracking "@Dmg);
			//if (TrackingDeco.Mass > 50)
			//TrackingDeco.TakeDamage(Dmg,DxPlayer,HitLocation, 0.6*Velocity, 'throw'); //CyberP: let's just amoalways destroy it
			//else
			TrackingDeco.TakeDamage(Dmg+1000,DxPlayer,HitLocation, 0.6*Velocity, 'throw'); //CyberP: let's just always destroy it
	//	 }
	  //if (Pawn(Other)==none)
	  //{
		 if (DeusExDecoration(TrackingDeco)!=none) Dmg*=DeusExDecoration(TrackingDeco).DamageScaler;//scale back for walls as deco ridiculously weak
			else
			   if (Carcass(TrackingDeco)!=none) Dmg*=AugDamMod;
	  //}

	if (CollideSound != None)
		PlaySound(CollideSound, SLOT_None, 2.0,, 2048, 0.85+FRand()*0.5); //CyberP: we can hear now

	// alert NPCs that I've landed
	AISendEvent('LoudNoise', EAITYPE_Audio,Dmg/4.0,Dmg*8.0);

    //log("GM_PROJ_PROC_DAM "@Dmg);

//		damagee = Other;
		 // DEUS_EX AMSD Spawn blood server side only
//		 if (Role == ROLE_Authority)
//			{
//			if (damagee.IsA('Pawn') && !damagee.IsA('Robot') && bBlood)
//			   SpawnBlood(HitLocation, Normal(HitLocation-damagee.Location));
//			}
	}

	singular function ZoneChange( ZoneInfo NewZone )
   {
	local float splashsize;
	local WaterRing splash;
	local int i;

   if ( NewZone.bWaterZone )
   {
		splashSize = 0.0015 * Abs(Velocity.Z); //0.0005
		spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
	 // splashSize = FClamp(0.0001 * Mass * (250 - 0.5 * FMax(-600,Velocity.Z)), 1.0, 3.0 );
	  if ( Level.NetMode != NM_DedicatedServer )
		{
   			if ( NewZone.EntrySound != None )
   				PlaySound(NewZone.EntrySound, SLOT_None, splashSize);
   			if ( NewZone.EntryActor != None )
   			{
   			   splash = Spawn(class'WaterRing',,,Location+ CollisionHeight * vect(0,0,1));//,Rotator(Vect(0,1,0)));
   				if ( splash != None )
   				{
   					splash.DrawScale = 4 * splashSize;
   				}
   			}
   		}
   		if (bFirstHit)
   			bFirstHit=False;

   		RotationRate = 0.2 * RotationRate;
	  }
   }
}

defaultproperties
{
     bFirstHit=True
     elasticity=0.300000
     bStartDelay=True
     DelayTime=0.030000
     ZgravDiv=2.000000
     ArmTimer=0.500000
     bBlood=True
     blastRadius=1.000000
     DamageType=shot
     spawnAmmoClass=Class'DeusEx.AmmoDart'
     bIgnoresNanoDefense=True
     ItemName="Deco"
     ItemArticle="a"
     speed=1000.000000
     Damage=25.000000
     MomentumTransfer=1000
     ImpactSound=Sound'DeusExSounds.Generic.BulletHitFlesh'
     bHidden=True
     Physics=PHYS_None
     Mesh=LodMesh'DeusExItems.Dart'
     CollisionRadius=3.000000
     CollisionHeight=2.000000
     bCollideActors=False
     bBounce=True
}
