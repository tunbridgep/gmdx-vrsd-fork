//=============================================================================
// DeusExMover.
//=============================================================================
class DeusExMover extends Mover;

var() bool 				bOneWay;				// this door can only be opened from one side
var() bool 				bLocked;				// this door is locked
var() bool 				bPickable;				// this lock can be picked
var() float 			lockStrength;			// "toughness" of the lock on this door - 0.0 is easy, 1.0 is hard
var() float          initiallockStrength; // for resetting lock, initial lock strength of door.
var() bool           bInitialLocked;      // for resetting lock
var() bool 				bBreakable;				// this door can be destroyed
var() float				doorStrength;			// "toughness" of this door - 0.0 is weak, 1.0 is strong
var() name				KeyIDNeeded;			// key ID code to open the door
var() bool				bHighlight;				// should this door highlight when focused?
var() bool				bFrobbable;				// this door can be frobbed

var bool				bPicking;				// a lockpick is currently being used
var float				pickValue;				// how much this lockpick is currently picking
var float				pickTime;				// how much time it takes to use a single lockpick
var int					numPicks;				// how many times to reduce hack strength
var float            TicksSinceLastPick; //num ticks done since last pickstrength update(includes partials)
var float            TicksPerPick;       // num ticks needed for a hackstrength update (includes partials)
var float			 LastTickTime;		 // Time at which last tick occurred.

var DeusExPlayer		pickPlayer;				// the player that is picking
var Lockpick			curPick;				// the lockpick that is being used

var() int 				minDamageThreshold;		// damage below this amount doesn't count
var bool				bDestroyed;				// has this mover already been destroyed?

var() int				NumFragments;			// number of fragments to spew on destroy
var() float				FragmentScale;			// scale of fragments
var() int				FragmentSpread;			// distance fragments will be thrown
var() class<Fragment>	FragmentClass;			// which fragment
var() texture			FragmentTexture;		// what texture to use on fragments
var() bool				bFragmentTranslucent;	// are these fragments translucent?
var() bool				bFragmentUnlit;			// are these fragments unlit?
var() sound				ExplodeSound1;			// small explosion sound
var() sound				ExplodeSound2;			// large explosion sound
var() bool				bDrawExplosion;			// should we draw an explosion?
var() bool				bIsDoor;				// is this mover an actual door?

var() float          TimeSinceReset;   // how long since we relocked it
var() float          TimeToReset;      // how long between relocks

var localized string	msgKeyLocked;			// message when key locked door
var localized string	msgKeyUnlocked;			// message when key unlocked door
var localized string	msgKeyLockedKey;		// message when key locked door with key
var localized string	msgKeyUnlockedKey;		// message when key unlocked door with key
var localized string	msgLockpickSuccess;		// message when lock is picked
var localized string	msgOneWayFail;			// message when one-way door can't be opened
var localized string	msgLocked;				// message when the door is locked
var localized string	msgPicking;				// message when the door is being picked
var localized string	msgAlreadyUnlocked;		// message when the door is already unlocked
var localized string	msgNoNanoKey;			// message when the player doesn't have the right nanokey

var() bool				bOpenSendEvent;				//CyberP/totalitarian: send an event when triggered
var() bool              bSpecialExclusion;          //CyberP: don't break when NPCs bump us. Foe footlockers primarily.
var() bool              bNoDestroyEvent;            //CyberP: don't send an event when destroyed
var bool                bPerkApplied;
var float               frobGate;                    //CyberP: to prevent NPCs constantly closing doors that have just been opened
var ScriptedPawn        ChosenPawn;                 //CyberP: used by AI to determine wether they should open doors in the newly elaborated post-combat seeking sub-state

var bool                bPlayerLocked;           // Sarge: Flag for when the door was re-locked by the player. Prevents NPC's from opening it.
var float               previousStrength;        //Sarge: What was the strength before we started picking?

var float               leftFrobTimer;           //Sarge: Ticks down from 3 seconds after we do a left frob, so that we can use right-click to select different options
const             leftFrobTimerMax = 6.0;


//SARGE: Check to see if we can re-lock a door
//Either we have the key for it in our keyring, or we previously picked it open and have the Locksport perk
function bool CanToggleLock(DeusExPlayer Player, NanoKeyRing keyring)
{
    return (keyring.HasKey(KeyIDNeeded) && KeyIDNeeded != '') || ((!bLocked || bPlayerLocked) && pickPlayer == Player && Player.PerkManager.GetPerkWithClass(class'DeusEx.PerkLocksport').bPerkObtained == true);
}

//SARGE: Added "Left Click Frob" and "Right Click Frob" support
//Return true to use the default frobbing mechanism (right click), or false for custom behaviour
function bool DoLeftFrob(DeusExPlayer frobber)
{
    local Inventory item;
    
    //Give us 3 seconds to use the right-click options after left-frobbing
    //This is so we don't accudentally change weapons in the middle of gameplay, by
    //right clicking on a mover
    leftFrobTimer = leftFrobTimerMax;

    //If not highlightable, not locked, and having a threshold, just select melee
    //This is a fallback for glass panes that aren't actually defined as BreakableGlass
    if (!bLocked && minDamageThreshold > 0 && !bHighlight)
    {
        frobber.SelectMeleePriority(minDamageThreshold);
        return false;
    }

    //When not on hardcore, always select the keyring if we have the key
    if (!frobber.bHardcoreMode && CanToggleLock(frobber,frobber.KeyRing))
    {
        frobber.PutInHand(frobber.KeyRing,true);
        return false;
    }
    else if (bLocked && frobber.bHardcoreMode) //Hardcore Mode: Always select picks. If we don't have one, always select keyring
    {
        if (bPickable && frobber.SelectInventoryItem('Lockpick',true))
            return false;
        //else if (bBreakable && frobber.SelectMeleePriority(minDamageThreshold))
        //    return false;
        else
            frobber.PutInHand(frobber.KeyRing,true);
        return false;
    }
    else if (bLocked) //Non-Hardcore. See if we have a melee weapon to bust the mover. Otherwise, select picks
    {
        if (bBreakable && frobber.SelectMeleePriority(minDamageThreshold))
			return false;
        else if (!bPickable || !frobber.SelectInventoryItem('Lockpick',true))
            frobber.PutInHand(frobber.KeyRing,true);
        return false;
    }
    else if (CanToggleLock(frobber,frobber.KeyRing)) //Keyring check for Hardcore mode
    {
        frobber.PutInHand(frobber.KeyRing,true);
        return false;
    }
    
    leftFrobTimer = 0.0;
    return true;
}
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{

    //Nofmal interaction if 
    if (!bLocked || frobber.inHand == None)
        return true;

    //Swap between lockpicks and nanokeyring
    if (leftFrobTimer > 0.0)
    {
        if (frobber.inHand.isA('NanoKeyRing'))
        {
            if (!frobber.SelectMeleePriority(minDamageThreshold))
                if (!frobber.SelectInventoryItem('Lockpick',true))
                    return true;
            leftFrobTimer = leftFrobTimerMax;
        }
        else if (frobber.inHand.isA('Lockpick'))
        {
            frobber.PutInHand(frobber.KeyRing,true);
            leftFrobTimer = leftFrobTimerMax;
        }
        else if (frobber.inHand.isA('DeusExWeapon') && DeusExWeapon(frobber.inHand).bHandToHand)
        {
            if (!frobber.SelectInventoryItem('Lockpick',true))
                frobber.PutInHand(frobber.KeyRing,true);
            leftFrobTimer = leftFrobTimerMax;
        }
    }
    else
    {
        frobber.DoAutoHolster();
        return true;
    }
    
    return false;
}



function PostBeginPlay()
{
	Super.PostBeginPlay();

	// keep these within limits
	lockStrength = FClamp(lockStrength, 0.0, 1.0);
	doorStrength = FClamp(doorStrength, 0.0, 1.0);

	if (!bPickable)
		lockStrength = 1.0;
	if (!bBreakable)
		doorStrength = 1.0;

   initiallockStrength = lockStrength;
   TimeSinceReset = 0.0;
   bInitialLocked = bLocked;

   /*if (lockStrength == 0.150000)                                              //RSD: This disgusting dirty hack has to go. You could have two movers associated together so that unlocking one unlocks the other, but with different strengths. NO
	{
	    if (FRand() < 0.3)
	       lockStrength = 0.200000;
	}*/
}


// -------------------------------------------------------------------------------
// Network Replication
// -------------------------------------------------------------------------------

replication
{
   //Variables server to client
   reliable if (Role == ROLE_Authority)
      bLocked, pickValue, lockStrength, doorStrength;
}

//
// ComputeMovementArea() - Computes a bounding box for the area
//                         in which this mover will move
//
function ComputeMovementArea(out vector center, out vector area)
{
	local int     i, j;
	local float   mult;
	local int     count;
	local vector  box1, box2;
	local vector  minVect;
	local vector  maxVect;
	local vector  newLocation;
	local rotator newRotation;

	if (NumKeys > 0)  // better safe than silly
	{
		// Initialize our bounding box
		GetBoundingBox(box1, box2, false, KeyPos[0]+BasePos, KeyRot[0]+BaseRot);

		// Compute the total area of our bounding box
		for (i=1; i<NumKeys; i++)
		{
			if (KeyRot[i] == KeyRot[i-1])
				count = 1;
			else
				count = 3;
			for (j=0; j<count; j++)
			{
				mult = float(j+1)/count;
				newLocation = BasePos + (KeyPos[i]-KeyPos[i-1])*mult + KeyPos[i-1];
				newRotation = BaseRot + (KeyRot[i]-KeyRot[i-1])*mult + KeyRot[i-1];
				if (GetBoundingBox(minVect, maxVect, false, newLocation, newRotation))
				{
					// Expand the bounding box
					box1.X = FMin(FMin(box1.X, maxVect.X), minVect.X);
					box1.Y = FMin(FMin(box1.Y, maxVect.Y), minVect.Y);
					box1.Z = FMin(FMin(box1.Z, maxVect.Z), minVect.Z);
					box2.X = FMax(FMax(box2.X, maxVect.X), minVect.X);
					box2.Y = FMax(FMax(box2.Y, maxVect.Y), minVect.Y);
					box2.Z = FMax(FMax(box2.Z, maxVect.Z), minVect.Z);
				}
			}
		}
	}

	// Fallback
	else
	{
		box1 = vect(0,0,0);
		box2 = vect(0,0,0);
	}

	// Compute center/area of the bounding box and return
	center = (box1+box2)/2;
	area = box2 - center;

}

//
// FinishNotify() - overridden from Mover; called when mover has finished moving
//
function FinishNotify()
{
	local Pawn   curPawn;
	local vector box1, box2;
	local vector center, area;
	local float  distX, distY, distZ;
	local float  maxX, maxY, maxZ;
	local float  dist;
	local float  maxDist;
	local vector tempVect;
	local bool   bNotify;

	Super.FinishNotify();

    frobGate = 2.0;

	if ((NumKeys > 0) && (MoverEncroachType == ME_IgnoreWhenEncroach))
	{
		GetBoundingBox(box1, box2, false, KeyPos[KeyNum]+BasePos, KeyRot[KeyNum]+BaseRot);
		center  = (box1+box2)/2;
		area    = box2 - center;
		maxDist = VSize(area)+200;
      // XXXDEUS_EX AMSD Slow Pawn Iterator
		//foreach RadiusActors(Class'Pawn', curPawn, maxDist)
      for (CurPawn = Level.PawnList; CurPawn != None; CurPawn = CurPawn.NextPawn)
		{
         if ((CurPawn != None) && (VSize(CurPawn.Location - Location) < (MaxDist + CurPawn.CollisionRadius)))
         {
            bNotify = false;
            distZ = Abs(center.Z - curPawn.Location.Z);
            maxZ  = area.Z + curPawn.CollisionHeight;
            if (distZ < maxZ)
            {
               distX = Abs(center.X - curPawn.Location.X);
               distY = Abs(center.Y - curPawn.Location.Y);
               maxX  = area.X + curPawn.CollisionRadius;
               maxY  = area.Y + curPawn.CollisionRadius;
               if ((distX < maxX) && (distY < maxY))
               {
                  if ((distX >= area.X) && (distY >= area.Y))
                  {
                     tempVect.X = distX-area.X;
                     tempVect.Y = distY-area.Y;
                     tempVect.Z = 0;
                     if (VSize(tempVect) < CollisionRadius)
                        bNotify = true;
                  }
                  else
                     bNotify = true;
               }
            }
            if (bNotify)
               curPawn.EncroachedByMover(self);
         }
		}
	}
}

//
// DropThings() - drops everything that is based on this mover
//
function DropThings()
{
	local actor A;

	// drop everything that is on us
	foreach BasedActors(class'Actor', A)
		A.SetPhysics(PHYS_Falling);
}

//
// "Destroy" the mover
//
function BlowItUp(Pawn instigatedBy)
{
	local int i;
	local Fragment frag;
	local Actor A;
	local DeusExDecal D;
	local Vector spawnLoc;
	local ExplosionLight light;

	// force the mover to stop
	if (Leader != None)
		Leader.MakeGroupStop();

	Instigator = instigatedBy;

	// trigger our event
	if (Event != ''&& !bNoDestroyEvent)
		foreach AllActors(class'Actor', A, Event)
			if (A != None)
				A.Trigger(Self, instigatedBy);

	// destroy all effects that are on us
	foreach BasedActors(class'DeusExDecal', D)
		D.Destroy();

	DropThings();

	// get the origin of the mover
	spawnLoc = Location - (PrePivot >> Rotation);

	// spawn some fragments and make a sound
	for (i=0; i<NumFragments; i++)
	{
		frag = Spawn(FragmentClass,,, spawnLoc + FragmentSpread * VRand());
		if (frag != None)
		{
			frag.Instigator = instigatedBy;

			// make the last fragment just drop down so we have something to attach the sound to
			if (i == NumFragments - 1)
				frag.Velocity = vect(0,0,0);
			else
				frag.CalcVelocity(VRand(), FragmentSpread);

			frag.DrawScale = FragmentScale;
			if (FragmentTexture != None)
				frag.Skin = FragmentTexture;
			if (bFragmentTranslucent)
				frag.Style = STY_Translucent;
			if (bFragmentUnlit)
				frag.bUnlit = True;
		}
	}

	// should we draw explosion effects?
	if (bDrawExplosion)
	{
		light = Spawn(class'ExplosionLight',,, spawnLoc);
		if (FragmentSpread < 64)
		{
			Spawn(class'ExplosionSmall',,, spawnLoc);
			if (light != None)
				light.size = 2;
		}
		else if (FragmentSpread < 128)
		{
			Spawn(class'ExplosionMedium',,, spawnLoc);
			if (light != None)
				light.size = 4;
		}
		else
		{
			Spawn(class'ExplosionLarge',,, spawnLoc);
			if (light != None)
				light.size = 8;
		}
		AISendEvent('LoudNoise', EAITYPE_Audio, 2.0, FragmentSpread * 24);
	}
    else
	AISendEvent('LoudNoise', EAITYPE_Audio, 2.0, FragmentSpread * 16);

	MakeNoise(2.0);
	if (frag != None)
	{
		if (NumFragments <= 5)
			frag.PlaySound(ExplodeSound1, SLOT_None, 2.0,, FragmentSpread*256);
		else
			frag.PlaySound(ExplodeSound2, SLOT_None, 2.0,, FragmentSpread*256);
	}

   //DEUS_EX AMSD Mover is dead, make it a dumb proxy so location updates
   RemoteRole = ROLE_DumbProxy;
	SetLocation(Location+vect(0,0,20000));		// move it out of the way
	SetCollision(False, False, False);			// and make it non-colliding
	bDestroyed = True;
}

//
// SupportActor()
//
// Called when somebody lands on us (copied from DeusExDecoration)
//

singular function SupportActor(Actor standingActor)
{
	local float  zVelocity;
	local float  baseMass;
	local float  standingMass;

	zVelocity = standingActor.Velocity.Z;
	// We've been stomped!
	if (zVelocity < -500 && standingActor.Mass > 30)
	{
		standingMass = FMax(1, standingActor.Mass);
		baseMass     = FMax(1, Mass);
		TakeDamage((1 - standingMass/baseMass * zVelocity/30),
		           standingActor.Instigator, standingActor.Location, 0.2*standingActor.Velocity, 'stomped');
	}
    //if (FragmentSpread == 41 && FragmentScale == 2.000000 && minDamageThreshold == 70 && MoveTime == 0.900000)
    //standingActor.TakeDamage(10000,None,standingActor.Location,vect(0,0,0),'Exploded'); //CyberP: terrible but safe hack to get pawns to gib to fan blades. //RSD: fuck you this ain't safe, this causes instagibs when you simply jump on a static fan blade

	if (!bDestroyed)
		standingActor.SetBase(self);
	else
		standingActor.SetPhysics(PHYS_Falling);
}

//
// Copied from Engine.Mover
//
function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
	if (bDestroyed)
		return;

	if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'HalonGas'))
		return;

	if ((damageType == 'Stunned') || (damageType == 'Radiation'))
		return;

    if ((damageType == 'KnockedOut') && Damage > 90 && DamageThreshold > 30)
		return;    //CyberP: prevent pressurized gas nades destroying movers.

	if ((DamageType == 'EMP') || (DamageType == 'NanoVirus') || (DamageType == 'Shocked'))
		return;

    if (InstigatedBy != none && InstigatedBy.Weapon != none && InstigatedBy.Weapon.IsA('WeaponCrowbar')) //RSD: New special effect for the crowbar: additional 5 damage vs inanimate objects //SARGE: Now 2x
       damage *= 2;

   //log("TakeDamage "@Damage@" "@instigatedBy@" "@bBreakable);
	if (bBreakable)
	{
        /*
        if (InstigatedBy.IsA('DeusExPlayer'))
            DeusExPlayer(InstigatedBy).clientMessage("Damage:" @ Damage @ ", Threshold:" @ minDamageThreshold);
        */
		//log("dooStrength "@doorStrength); //CyberP: we don't need to log this
      // add up the damage
		if (Damage >= minDamageThreshold)
        {
            //SARGE: If we aren't highlighting but are breakable, destroy in 1 hit.
            //This essentially means that when you can't see the door strength, a valid hit will always
            //blow it up, no guessing-games. Having to memorize certain door strengths and knowing that you can
            //whack them a certain number of times is extremely degenerate.
            if (!bHighlight)
                doorStrength = 0.0;
            else
                doorStrength -= Damage * 0.01;


            //Sarge: Add Hit Markers
            if (instigatedBy != None && instigatedBy.IsA('DeusExPlayer'))
            {
                if (DeusExPlayer(instigatedBy).bHitmarkerOn)
                    DeusExPlayer(instigatedBy).hitmarkerTime = 0.2;
            }
        }

		//log("doorStrength1 "@doorStrength);

//		else
//			doorStrength -= Damage * 0.001;		// damage below the threshold does 1/10th the damage

		doorStrength = FClamp(doorStrength, 0.0, 1.0);

		//log("doorStrength2 "@doorStrength@" "@(doorStrength ~= 0.0));
		if (doorStrength ~= 0.0)
			BlowItUp(instigatedBy);
	}
}

//
// Called every 0.1 seconds while the pick is actually picking
//
function Timer()
{
	local DeusExMover M;
	if (bPicking)
	{
	  curPick.PlayUseAnim();

	  TicksSinceLastPick += (Level.TimeSeconds - LastTickTime) * 10;
	  LastTickTime = Level.TimeSeconds;
      //TicksSinceLastPick = TicksSinceLastPick + 1;
      while (TicksSinceLastPick > TicksPerPick)
      {
         numPicks--;
         lockStrength -= 0.01;
         TicksSinceLastPick = TicksSinceLastPick - TicksPerPick;
         lockStrength = FClamp(lockStrength, 0.0, 1.0);
      }

		// pick all like-tagged movers at once (for double doors and such)
		if ((Tag != '') && (Tag != 'DeusExMover'))
			foreach AllActors(class'DeusExMover', M, Tag)
				if (M != Self)
					M.lockStrength = lockStrength;

		// did we unlock it?
		if (lockStrength ~= 0.0)
		{
			lockStrength = 0.0;
			bLocked = False;
         TimeSinceReset = 0.0;

			// unlock all like-tagged movers at once (for double doors and such)
			if ((Tag != '') && (Tag != 'DeusExMover'))
				foreach AllActors(class'DeusExMover', M, Tag)
					if (M != Self)
					{
						M.bLocked = False;
						M.TimeSinceReset = 0;
						M.lockStrength = 0.0;
					}

			pickPlayer.ClientMessage(msgLockpickSuccess);
			StopPicking();
		}

		// are we done with this pick?
		else if (numPicks <= 0)
			StopPicking();

		// check to see if we've moved too far away from the door to continue
		else if (pickPlayer.frobTarget != Self)
			StopPicking(true);

		// check to see if we've put the lockpick away
		else if (pickPlayer.inHand != curPick)
			StopPicking(true);
	}
}

//
// Called to deal with resetting the device
//
function Tick(float deltaTime)
{

    //Reduce our left-frob timer
    leftFrobTimer = FMAX(0.0,leftFrobTimer - deltaTime);

   TimeSinceReset = TimeSinceReset + deltaTime;
   if (frobGate > 0)
       frobGate -= deltaTime;
   //only reset in multiplayer, if we aren't picking it, and if it has been completely unlocked
   if ((!bPicking) && (Level.NetMode != NM_Standalone) && (lockStrength == 0.0) && !(bLocked))
   {
      if (TimeSinceReset > TimeToReset)
      {
         lockStrength = initiallockStrength;
         TimeSinceReset = 0.0;
         if (lockStrength > 0)
		 {
			 //Force door closed and locked appropriately.
			 DoClose();
			 bLocked = bInitialLocked;
		 }
      }
   }
   // In multi, force it closed if locked.  Keep trying until it closes.
   if ((Level.NetMode != NM_Standalone) && (bLocked) && (KeyNum != 0))
	   DoClose();
   Super.Tick(deltaTime);
}

//
// Stops the current pick-in-progress
//
function StopPicking(optional bool aborted)
{
	local DeusExMover M;

	// alert NPCs that I'm not messing with stuff anymore
	AIEndEvent('MegaFutz', EAITYPE_Visual);
	bPicking = False;
	if (curPick != None)
	{
		curPick.StopUseAnim();
		curPick.bBeingUsed = False;

        //Sarge: Only take a pick if we didn't abort.
        if (!aborted)
    		curPick.UseOnce();
	}
	curPick = None;
	SetTimer(0.1, False);

    //Sarge: If we aborted, reset lock strength
    if (aborted)
    {
        LockStrength = previousStrength;
		if ((Tag != '') && (Tag != 'DeusExMover'))
			foreach AllActors(class'DeusExMover', M, Tag)
				if (M != Self)
					M.lockStrength = lockStrength;
        
    }
}

//
// The main logic function for doors
//
function Frob(Actor Frobber, Inventory frobWith)
{
	local Pawn P;
	local DeusExPlayer Player;
	local bool bOpenIt, bDone;
	local string msg;
	local Vector X, Y, Z;
	local float dotp;
	local DeusExMover M;
    local Actor A;
    local string KeyName;
        

	// if we shouldn't be frobbed, get out
	if (!bFrobbable)
		return;

	// if we are destroyed, don't do anything
	if (bDestroyed)
		return;

	// make sure we frob our leader if we are a slave
	if (bSlave)
		if (Leader != None)
			Leader.Frob(Frobber, frobWith);

	P = Pawn(Frobber);
	Player = DeusExPlayer(P);
	bOpenIt = False;
	bDone = False;
	msg = msgLocked;

    //Get the name of our key if the player has it
    KeyName = Player.GetNanoKeyDesc(KeyIDNeeded);
    
	// make sure someone is trying to open the door
	if (P == None)
		return;

	// ugly hack, so animals can't open doors
	if (P.IsA('Animal'))
		return;

	// Let any non-player pawn open any door for now
    // SARGE: Unless we manually locked it
	if (Player == None && !bPlayerLocked)
	{
		bOpenIt = True;
		msg = "";
		bDone = True;
	}

	// If we are already trying to pick it, print a message
	if (bPicking)
	{
		msg = msgPicking;
		bDone = True;
	}

	// If the door is not closed, it can always be closed no matter what
	if (((KeyNum != 0) || (PrevKeyNum != 0)) && frobWith == None)
	{
		bOpenIt = True;
		msg = "";
		bDone = True;
	}

	// check to see if this is a one-way door
	if (!bDone && bOneWay)
	{
		GetAxes(Rotation, X, Y, Z);
		dotp = (Location - Frobber.Location) dot X;

		// if we're on the wrong side of the door, then don't open
		if (dotp > 0.0)
		{
			bOpenIt = False;
			msg = msgOneWayFail;
			bDone = True;
		}
	}

	//
	// If the door is locked, the player must do one of the following to open it
	// without triggers or explosions:
	// 1. Use the KeyIDNeeded
	// 2. Use the Lockpick and SkillLockpicking
	//
	if (!bDone)
	{
		// Get what's in the player's hand
		if (frobWith != None)
		{
			// check for the use of lockpicks
			if (bPickable && frobWith.IsA('Lockpick') && (Player.SkillSystem != None))
			{
				if (bLocked)
				{
					// alert NPCs that I'm messing with stuff
					if (Player.PerkManager.GetPerkWithClass(class'DeusEx.PerkSleightOfHand').bPerkObtained == false)                           //RSD: Unless you have the Sleight of Hand perk
						AIStartEvent('MegaFutz', EAITYPE_Visual);

                    previousStrength = LockStrength;

					pickValue = Player.SkillSystem.GetSkillLevelValue(class'SkillLockpicking');
					pickPlayer = Player;
					if (Player.PerkManager.GetPerkWithClass(class'DeusEx.PerkLocksport').bPerkObtained == true)
                        pickValue = 1;
					curPick = LockPick(frobWith);
					curPick.bBeingUsed = True;
					curPick.PlayUseAnim();
					bPicking = True;
               //DEUS_EX AMSD In multiplayer, slow it down further at low skill levels
               numPicks = PickValue * 100;
               if (Level.Netmode != NM_Standalone)
                  pickTime = default.pickTime / (pickValue * pickValue);
               TicksPerPick = (PickTime * 10.0) / numPicks;
			   LastTickTime = Level.TimeSeconds;
               TicksSinceLastPick = 0;
					SetTimer(0.1, True);
					msg = msgPicking;
				}
				else
				{
					msg = msgAlreadyUnlocked;
				}
			}
			else if (frobWith.IsA('NanoKeyRing'))
			{
				// check for the correct key use
				NanoKeyRing(frobWith).PlayUseAnim();
				if (CanToggleLock(Player,NanoKeyRing(frobWith))) //Sarge: Moved to function rather than having the check inline
				{
					bLocked = !bLocked;		// toggle the lock state
                    bPlayerLocked = bLocked;
					TimeSinceReset = 0;

                    //if re-locked, reset the lock strength
                    if (bLocked)
                        lockStrength = initialLockStrength;

					// toggle the lock state for all like-tagged movers at once (for double doors and such)
					if ((Tag != '') && (Tag != 'DeusExMover'))
						foreach AllActors(class'DeusExMover', M, Tag)
							if (M != Self)
							{
								M.bLocked = !M.bLocked;
								M.TimeSinceReset = 0;
                                if (M.bLocked)
                                    M.lockStrength = M.initialLockStrength;
							}

					bOpenIt = False;

                    //We need to check this, because we can now lock doors without a key
                    //if we use the Locksport perk
					if (bLocked)
                    {
                        if (KeyName != "")
    						msg = Sprintf(msgKeyLockedKey,KeyName);
                        else
    						msg = msgKeyLocked;
                    }
					else
                    {
                        if (KeyName != "")
    						msg = Sprintf(msgKeyUnlockedKey,KeyName);
                        else
    						msg = msgKeyUnlocked;
                    }
				}
				else if (bLocked)
				{
                    //Give us 3 seconds to use the right-click options after failing to use the key
                    //This is so we don't accudentally change weapons in the middle of gameplay, by
                    //right clicking on a mover
                    leftFrobTimer = leftFrobTimerMax;

					bOpenIt = False;
					msg = msgNoNanoKey;
				}
				else
				{
					msg = msgAlreadyUnlocked;
				}
			}
			else if (!bLocked)
			{
				bOpenIt = True;
				msg = "";
			}
		}
		else if (!bLocked)
		{
			bOpenIt = True;
			msg = "";
		}
	}

	// give the player a message //CyberP: also play locked door frob sound effects
	if ((Player != None) && (msg != ""))
	{
	    if ((FrobWith == None && !bPicking) || (FrobWith != None && !bPicking && (!FrobWith.IsA('LockPick') || !FrobWith.IsA('NanoKeyRing'))))
	    {
        if (bLocked && FragmentClass == Class'DeusEx.WoodFragment' && bIsDoor)
	        PlaySound(sound'lockeddoor',SLOT_None);
	    else if (msg == msgLocked && bBreakable && FragmentClass == Class'DeusEx.MetalFragment')
	        PlaySound(sound'DropSmallMetal',SLOT_None);
		}
        Player.ClientMessage(msg);
	}

	// open it!
	if (bOpenIt)
	{
		Super.Frob(Frobber, frobWith);
		Trigger(Frobber, P);

        ChosenPawn = None;
		// trigger all like-tagged movers at once (for double doors and such)
		if ((Tag != '') && (Tag != 'DeusExMover'))
			foreach AllActors(class'DeusExMover', M, Tag)
				if (M != Self)
					M.Trigger(Frobber, P);

	    //CyberP/|Totalitarian|: trigger our event if bOpenSendEvent
	    if (bOpenSendEvent == true)
        {
	    if (Event != '')
		   foreach AllActors(class'Actor', A, Event)
			       if (A != None)
			       	A.Trigger(Self, None);
        }
	}
}

function DoOpen()
{
	local DeusExMover M;
	if (Level.NetMode != NM_Standalone)
	{
		// In multiplayer, unlock doors that get opened.
		// toggle the lock state for all like-tagged movers at once (for double doors and such)
		bLocked = false;
		TimeSinceReset = 0;
		lockStrength = 0.0;
		if ((Tag != '') && (Tag != 'DeusExMover'))
			foreach AllActors(class'DeusExMover', M, Tag)
			if (M != Self)
			{
				M.bLocked = false;
				M.TimeSinceReset = 0;
				M.lockStrength = 0;
			}
	}
	Super.DoOpen();
}

function LowKeyDestroy(Pawn instigatedBy)                                       //RSD: An alternate version of BlowItUp() without any of the explosion effects
{
	local int i;
	local Actor A;
	local DeusExDecal D;

	// force the mover to stop
	if (Leader != None)
		Leader.MakeGroupStop();

	Instigator = instigatedBy;

	// trigger our event
	if (Event != ''&& !bNoDestroyEvent)
		foreach AllActors(class'Actor', A, Event)
			if (A != None)
				A.Trigger(Self, instigatedBy);

	// destroy all effects that are on us
	foreach BasedActors(class'DeusExDecal', D)
		D.Destroy();

	DropThings();

   //DEUS_EX AMSD Mover is dead, make it a dumb proxy so location updates
   RemoteRole = ROLE_DumbProxy;
	SetLocation(Location+vect(0,0,20000));		// move it out of the way
	SetCollision(False, False, False);			// and make it non-colliding
	bDestroyed = True;
}

function bool EncroachingOn( actor Other )                                      // RSD: copied from Mover.uc to make fan blades gib the player PROPERLY
{
	local Pawn P;
	if ( Other.IsA('Carcass') || Other.IsA('Decoration') )
	{
		Other.TakeDamage(10000, None, Other.Location, vect(0,0,0), 'Crushed');
		return false;
	}
	// DEUS_EX CNN - Don't destroy inventory items when encroached!
//	if ( Other.IsA('Fragment') || (Other.IsA('Inventory') && (Other.Owner == None)) )
	if (Other.IsA('Fragment'))
	{
		Other.Destroy();
		return false;
	}

	// DEUS_EX CNN - make based actors not stop movers
	if (Other.Base == Self)
	{
		return False;
	}

	// Damage the encroached actor.
	if( EncroachDamage != 0 )
		Other.TakeDamage( EncroachDamage, Instigator, Other.Location, vect(0,0,0), 'Crushed' );

	// If we have a bump-player event, and Other is a pawn, do the bump thing.
	P = Pawn(Other);
	if( P!=None && P.bIsPlayer )
	{
		if ( PlayerBumpEvent!='' )
			Bump( Other );
		if ( (MyMarker != None) && (P.Base != self)
			&& (P.Location.Z < MyMarker.Location.Z - P.CollisionHeight - 0.7 * MyMarker.CollisionHeight) )
			// pawn is under lift - tell him to move
			P.UnderLift(self);
	}

	// Stop, return, or whatever.
	if( MoverEncroachType == ME_StopWhenEncroach )
	{
		Leader.MakeGroupStop();
		return true;
	}
	else if( MoverEncroachType == ME_ReturnWhenEncroach )
	{
		Leader.MakeGroupReturn();
		if ( Other.IsA('Pawn') )
		{
			if ( Pawn(Other).bIsPlayer )
				Pawn(Other).PlaySound(Pawn(Other).Land, SLOT_None);			// DEUS_EX CNN - Changed from SLOT_Talk
			else
				Pawn(Other).PlaySound(Pawn(Other).HitSound1, SLOT_None);	// DEUS_EX CNN - Changed from SLOT_Talk
		}
		return true;
	}
	else if( MoverEncroachType == ME_CrushWhenEncroach )
	{
		// Kill it.
        if (FragmentSpread == 41 && FragmentScale == 2.000000 && minDamageThreshold == 70 && MoveTime == 0.900000) //RSD: proper hack for fan gibbing
        	Other.TakeDamage(10000,Instigator,Other.Location,vect(0,0,0),'Exploded');
		else
        	Other.KilledBy( Instigator );
		return false;
	}
	else if( MoverEncroachType == ME_IgnoreWhenEncroach )
	{
		// Ignore it.
		return false;
	}
}


//
// make sure we can't be triggered after we've been destroyed
//
state() TriggerOpenTimed
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if (!bDestroyed)
			Super.Trigger(Other, EventInstigator);
	}
}

state() TriggerToggle
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if (!bDestroyed)
			Super.Trigger(Other, EventInstigator);
	}
}

state() TriggerControl
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if (!bDestroyed)
			Super.Trigger(Other, EventInstigator);
	}
}

state() TriggerPound
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if (!bDestroyed)
			Super.Trigger(Other, EventInstigator);
	}
}

defaultproperties
{
     bPickable=True
     lockStrength=0.200000
     doorStrength=0.250000
     bHighlight=True
     bFrobbable=True
     pickTime=3.000000
     minDamageThreshold=10
     NumFragments=16
     FragmentScale=2.000000
     FragmentSpread=32
     FragmentClass=Class'DeusEx.WoodFragment'
     ExplodeSound1=Sound'DeusExSounds.Generic.WoodBreakSmall'
     ExplodeSound2=Sound'DeusExSounds.Generic.WoodBreakLarge'
     TimeToReset=28.000000
     msgKeyLocked="Your NanoKey Ring locked it"
     msgKeyUnlocked="Your NanoKey Ring unlocked it"
     msgKeyLockedKey="Your NanoKey Ring locked it using %s"
     msgKeyUnlockedKey="Your NanoKey Ring unlocked it using %s"
     msgLockpickSuccess="You picked the lock"
     msgOneWayFail="It won't open from this side"
     msgLocked="It's locked"
     msgPicking="Picking the lock..."
     msgAlreadyUnlocked="It's already unlocked"
     msgNoNanoKey="Your NanoKey Ring doesn't have the right code"
     MoverEncroachType=ME_StopWhenEncroach
     BumpType=BT_PawnBump
     bBlockSight=True
     InitialState=TriggerToggle
     bDirectional=True
}
