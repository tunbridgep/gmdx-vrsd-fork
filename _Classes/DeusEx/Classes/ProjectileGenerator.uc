//=============================================================================
// RevisionProjectileGenerator.
//
//
// General Note:   FireExtinguisher should be a Weapon and spawn the shit itself,
//                 so don't worry that much about this class as it gets rewritten anyway.
//                 The current form sucks in network anyway.
//
// TODO
//  * Each part of code should have it's own ProjectileGenerator generator subclass
//    with the right settings in defaultprops, so these don't need to get replicated,
//    which often fails and also this step cleans up code.
//    (although I have to admit that igniting yourself with the fire extinguisher in
//     network play is pretty much the best bug ever).
//  * Make the same move as in HX to make an own native Effects baseclass which extends Actor,
//    so it can be native, and i can use GetOptimizedRepList() to replicate the rotation
//    even if DrawType==DT_Sprite.
//  * Use or add an Unreal Timer event like SpeechTimer() and let C++ handle check
//    when it is called or if it's visible or soon to be visible.
//  * Use RenderIterator when possible (e.g. when it's just an effect)
//  * Use bNetTemporary projectiles.
//=============================================================================
class ProjectileGenerator extends Effects;

var() float Frequency;               // what's the chance of spewing an actor every checkTime seconds
var() float EjectSpeed;              // how fast do the actors get ejected
var() class<Actor> ProjectileClass;  // class to project
var() float ProjectileLifeSpan;      // how long each projectile lives
var() bool bTriggered;               // start by triggering?
var() float SpewTime;                // how long do I spew after I am triggered?
var() bool bRandomEject;             // random eject velocity vector
var() float CheckTime;               // how often should I spit out particles?
var() Sound SpawnSound;              // sound to play when spawned
var() float SpawnSoundRadius;        // radius of sound
var() bool bAmbientSound;            // play the ambient sound?
var() int NumPerSpawn;               // number of particles to spawn per puff
var() Name AttachTag;                // attach us to this actor
var() bool bSpewUnseen;              // spew stuff when players can't see us
var() float WaitTime;                // amount of time between bursts
var() bool bOnlyOnce;                     // fire projectiles one time only
var() bool bInitiallyOn;                // if triggered, start on instead of off

var bool bSpewing;                        // am I spewing? REV HAN: Rep needed?
var bool bFrozen;                          // are we out of the player's sight?
var float Period;
var float Time;

// ----------------------------------------------------------------------------
// Replication.
// ----------------------------------------------------------------------------

replication
{
   // Server to client
   reliable if ( Role==ROLE_Authority )
      Frequency, EjectSpeed, ProjectileClass, ProjectileLifeSpan, bTriggered, SpewTime,
      bRandomEject, CheckTime, SpawnSound, SpawnSoundRadius, bAmbientSound, NumPerSpawn,
      AttachTag, bSpewUnseen, WaitTime, bOnlyOnce, bInitiallyOn;
}

// ----------------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------------

function PostBeginPlay() // Should probably be simulated.
{
   local Actor A;

   Super.PostBeginPlay();

   if ( bTriggered && !bInitiallyOn )
      bSpewing = False;

   // Attach us to the actor that was tagged
   if ( AttachTag != '' )
   {
      foreach AllActors( class'Actor', A, AttachTag )
      {
         if ( A!=None )
         {
            SetOwner(A);
            SetBase(A);
         }
      }
   }
}

// ----------------------------------------------------------------------------
// Trigger()
// ----------------------------------------------------------------------------

function Trigger(Actor Other, Pawn EventInstigator)
{
   Super.Trigger(Other, EventInstigator);

   // If we are spewing, turn us off.
   if ( bSpewing )
   {
      bSpewing = False;
      Period   = 0;
      Time     = 0;

      if ( bAmbientSound && AmbientSound!=None )
         SoundVolume = 0;
   }
   // Otherwise, turn us on.
   else if ( !bOnlyOnce )
   {
      bSpewing = True;
      Period   = 0;
      Time     = 0;

      if ( bAmbientSound && AmbientSound!=None )
         SoundVolume = 255;
   }
}

// ----------------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------------

simulated function Tick( float DeltaTime )
{
   local int    i, j;
   local int    Count;
   local Actor  Spawnee;
   local float  Speed;
   local float  TimeVal;
   local Vector Dir;

   Super.Tick(DeltaTime);

   // If the owner that I'm attached to is dead, kill me. - REV_HAN: Sucks.
   if ( AttachTag!='' && Owner==None )
      Destroy();

   // Update timers
   Time   += DeltaTime;
   Period += DeltaTime;

   // REV HAN: Both should be merged. (And i would really like to have a tenary operator).
   // If we're spewing and it's time to stop, stop.
   if ( bSpewing )
   {
      if ( SpewTime>0 )
      {
         if ( Period>=SpewTime )
         {
            Period   = 0;
            Time     = 0;
            bSpewing = False;
         }
      }
      else
         Period = 0;
   }
   // If we're not spewing and it's time to start, start.
   else if ( !bOnlyOnce )
   {
      if ( WaitTime>0 )
      {
         if ( Period>=WaitTime )
         {
            Period   = 0;
            Time     = 0;
            bSpewing = True;
         }
      }
      else
         Period = 0;
   }

   // CNN - remove optimizaions to fix strange behavior of PlayerCanSeeMe()
/*
   // Should we freeze the spewage?
   if ( bSpewUnseen )
      bFrozen = False;
   else if (PlayerCanSeeMe())
      bFrozen = False;
   else
      bFrozen = True;
*/

   // Are we spewing? Is it not time to start spewing?
   if ( !bSpewing || bFrozen || Time<CheckTime )
      return;

   // How many projectiles must we spew?
   if (CheckTime > 0)
   {
      Count = int(Time/CheckTime);
      Time -= Count*CheckTime;
   }
   else
   {
      Count = 1;
      Time  = 0;
   }
   TimeVal = time;

   // Sanity check
   if (Count > 5)
      Count = 5;

   // If frequency < 1, make spewage random
   if ( FRand()<=Frequency )
   {
      // REV_HAN: This should probably be in projectiles startup code,
      //          although this seems to be problematic in network play.
      //          (see: http://www.oldunreal.com/cgi-bin/yabb2/YaBB.pl?num=1421911644)
      if ( SpawnSound!=None )
         PlaySound( SpawnSound, SLOT_Misc,,, SpawnSoundRadius );

   // Spawn an appropriate number of projectiles
   for ( i=0; i<Count*NumPerSpawn; i++ )  // (Number of spews for this tick)*(Number of spawns per spew)
   {
      // Wayyy down upon the Spawnee river...
      // REV_HAN: Basic problem for FireExinguishers:
      //  * Having player as base probably accounts for the magic rotation update.
      //    However, this seem to just updates the Rotation, and *NOT* the ViewRotation.
      //    Probably in previous versions of the game the PlayerPawn.Rotation.Pitch was changed
      //    (there were some lines hinting this, and player was Pitched for NM_ListenServer in convos too).
      Spawnee = Spawn( ProjectileClass, Owner );

      if (Spawnee != None)
      {
         if ( bRandomEject )
            Dir = VRand();
         // REV_HAN: Account for ViewRotation on pawns.
         else if ( Base!= None && Base.bIsPawn )
            Dir = Vector(Pawn(Base).ViewRotation);
         else
            Dir = Vector(Rotation);

         Speed = EjectSpeed;
         if ( bRandomEject )
            Speed *= FRand();

         Spawnee.SetRotation( Rotator(Dir) );
         Spawnee.Velocity     = Speed*Dir;
         Spawnee.Acceleration = Dir;
         Spawnee.SetLocation( Location + Spawnee.Velocity*TimeVal );

         if ( ProjectileLifeSpan>0 )
            Spawnee.LifeSpan = ProjectileLifeSpan;
         }
      }
   }
   TimeVal += CheckTime*Count*NumPerSpawn;
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------

defaultproperties
{
     Frequency=1.000000
     ejectSpeed=300.000000
     ProjectileClass=Class'DeusEx.Fireball'
     checkTime=0.250000
     SpawnSoundRadius=1024.000000
     numPerSpawn=1
     bInitiallyOn=True
     bSpewing=True
     bHidden=True
     bDirectional=True
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Inventory'
     CollisionRadius=40.000000
     CollisionHeight=40.000000
}
