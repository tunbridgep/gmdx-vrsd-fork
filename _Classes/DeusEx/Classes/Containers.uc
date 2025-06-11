//=============================================================================
// Containers.
//=============================================================================
class Containers extends DeusExDecoration
	abstract;

var() int numThings;
var() bool bGenerateTrash;
var   bool bSelectMeleeWeapon; //Select a melee weapon when we left-frob this container

function bool DoLeftFrob(DeusExPlayer frobber)
{
    if (minDamageThreshold > 0 && bSelectMeleeWeapon)
    {
        frobber.SelectMeleePriority(minDamageThreshold);
        return false;
    }
    return true;
}

function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    if (frobber.bRightClickToolSelection && objectInHand && bSelectMeleeWeapon && (frobber.inHand == frobber.primaryWeapon || !frobber.InHand.IsA('DeusExWeapon')))
        return DoLeftFrob(frobber);

    return Super.DoRightFrob(frobber,objectInHand);
}

//
// copied from Engine.Decoration
//
function Destroyed()
{
	local actor dropped;
	local class<actor> tempClass;
	local int i, j;
	local Rotator rot;
	local Vector loc;
	local TrashPaper trash;
	local Rat vermin;

	// trace down to see if we are sitting on the ground
	loc = vect(0,0,0);
	loc.Z -= CollisionHeight + 8.0;
	loc += Location;

    if (IsA('BoxMedium') && FRand() < 0.1)
    {
    loc = Location;
    loc.Z -= CollisionHeight * 0.7;
     for(j=0;j<30;j++)
     {
       Spawn(class'Polystyrene',,,loc);
       Spawn(class'Polystyrene',,,loc);
       Spawn(class'Polystyrene',,,loc);
       Spawn(class'Polystyrene',,,loc);
     }
    }

	// only generate trash if we are on the ground
	if (!FastTrace(loc) && bGenerateTrash)
	{
		// maybe spawn some paper

		if (FRand() > 0.99)
		Spawn(class'Flask');

		if (FRand() < 0.01)
		Spawn(class'BoxSmall');

        /*
		if (FRand() < 0.001)
		Spawn(class'VialCrack');  //CyberP: rare chances to spawn more useless stuff
        */

		for (i=0; i<8; i++)        //CyberP: increased chance to spawn trash.
		{
			if (FRand() < 0.75)
			{
				loc = Location;
				loc.X += (CollisionRadius / 2) - FRand() * CollisionRadius;
				loc.Y += (CollisionRadius / 2) - FRand() * CollisionRadius;
				loc.Z += (CollisionHeight / 2) - FRand() * CollisionHeight;
				trash = Spawn(class'TrashPaper',,, loc);
				if (trash != None)
				{
					trash.SetPhysics(PHYS_Rolling);
					trash.rot = RotRand(True);
					trash.rot.Yaw = 0;
					trash.dir = VRand() * 20 + vect(20,20,0);
					trash.dir.Z = 0;
				}
			}
		}

		// maybe spawn a rat
		if (FRand() < 0.3) //CyberP: less chance to spawn a rat
		{
			loc = Location;
			loc.Z -= CollisionHeight;
			vermin = Spawn(class'Rat',,, loc);
			if (vermin != None)
				vermin.bTransient = true;
		}
	}

	if( (Pawn(Base) != None) && (Pawn(Base).CarriedDecoration == self) )
		Pawn(Base).DropDecoration();
	if( (Contents!=None) && !Level.bStartup )
	{
		tempClass = Contents;
		if (Content2!=None && FRand()<0.3) tempClass = Content2;
		if (Content3!=None && FRand()<0.3) tempClass = Content3;

		for (i=0; i<numThings; i++)
		{
			loc = Location+0.7*VRand()*CollisionRadius;                         //RSD: randomness seemed to be causing problems with clipping through walls -- added 0.7?
			//loc = Location;
			loc.Z = Location.Z;
			rot = rot(0,0,0);
			rot.Yaw = FRand() * 65535;
			dropped = Spawn(tempClass,,, loc, rot);
			if (dropped != None)
			{
				dropped.RemoteRole = ROLE_DumbProxy;
				dropped.SetPhysics(PHYS_Falling);
				dropped.bCollideWorld = true;
				//dropped.Velocity = VRand() * 50;                              //RSD: randomness seemed to be causing problems with clipping through walls?
				if ( inventory(dropped) != None )
					inventory(dropped).GotoState('Pickup', 'Dropped');
			}
		}
	}

	Super.Destroyed();
}

/*Function Bump(actor other)                                                      //RSD: Test for TT's Unreal Evolution code
{
    local DeusExPlayer NewPlayer;
    if (Other.IsA('DeusExPlayer'))
    {
        NewPlayer = DeusExPlayer(Other);

        SetPhysics(PHYS_Rotating);
        bRotatetoDesired=True;
        bFixedRotationDir=True;
        DesiredRotation = Rotator(NewPlayer.Location - Location);
        DesiredRotation.Yaw = DesiredRotation.Yaw;
        DesiredRotation.Pitch=0;
        DesiredRotation.roll=0;
        NewPlayer.BroadcastMessage("DR:" @ DesiredRotation.Yaw);
        NewPlayer.BroadcastMessage("RO:" @ Rotation.Yaw);
        RotationRate = DesiredRotation;
        RotationRate.Yaw = modulo(RotationRate.Yaw+32768-Rotation.Yaw,65536)-32768; //RSD: this corrects for our worldspace orientation so we go in the right direction
        NewPlayer.BroadcastMessage("RR:" @ RotationRate.Yaw);
    }
}

function int modulo(int A, int B)                                               //RSD: Correct arithmetic on negative numbers
{
  if( A % B >= 0 )
    return A % B ;
  else
    return ( A % B ) + B ;
}*/

defaultproperties
{
     numThings=1
     minDamageThreshold=2
     bFlammable=True
     bCanBeBase=True
     bSelectMeleeWeapon=True
}
