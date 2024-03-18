//=============================================================================
// DeusExAmmo.
//=============================================================================
class DeusExAmmo extends Ammo
	abstract;

var localized String msgInfoRounds;

// True if this ammo can be displayed in the Inventory screen
// by clicking on the "Ammo" button.

var bool bShowInfo;
var int MPMaxAmmo; //Max Ammo in multiplayer.
var int altDamage; //CyberP:
var() class<Skill> ammoSkill;                                                   //RSD: Denotes associated weapon skill
var travel bool bLooted;                                                        //RSD: If we've already looted this and partially emptied it (for ammo spillover in world)

// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------
function PostBeginPlay()                                                        //RSD: Halve Ammo shenanigans here
{
/*local DeusExPlayer player;                                                    //RSD: Removed for new GetAdjustedMaxAmmo() function in DeusExPlayer

	player = DeusExPlayer(GetPlayerPawn());
	if (player != none && player.bHalveAmmo)
	{
	   MaxAmmo = default.MaxAmmo * 0.5;
	   if (AmmoAmount >= MaxAmmo)
       {
          AmmoAmount = MaxAmmo;
       }
    }
    else
       MaxAmmo = default.MaxAmmo;*/
    Super.PostBeginPlay();
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.SetTitle(itemName);
	winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());

	// number of rounds left
	winInfo.AppendText(Sprintf(msgInfoRounds, AmmoAmount));

	return True;
}

singular function BaseChange()
{
	Super.BaseChange();

	// Make sure we fall if we don't have a base
	if ((base == None) && (Owner == None))
		{
        SetPhysics(PHYS_Falling);
        }
}

// ----------------------------------------------------------------------
// PlayLandingSound()
// ----------------------------------------------------------------------

function PlayLandingSound()
{
	if (LandSound != None)
	{
		if (Velocity.Z <= -140)
		{
			PlaySound(LandSound, SLOT_None, TransientSoundVolume,, 768);
			AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 512);
		}
	}
}

event Bump( Actor Other )
{
local float speed2, mult;
local DeusExPlayer player;

player = DeusExPlayer(GetPlayerPawn());

mult = player.AugmentationSystem.GetAugLevelValue(class'AugMuscle');
if (mult == -1.0)
mult = 1.0;

speed2 = VSize(Velocity);

if (speed2 > 1100)
if (Other.IsA('Pawn') || Other.IsA('DeusExDecoration') || Other.IsA('DeusExPickup'))
Other.TakeDamage((15+Mass)*mult,player,Other.Location,0.5*Velocity,'KnockedOut');
}

function Landed(Vector HitNormal)
{
	local Rotator rot;

	//Super.Landed(HitNormal);
    PlayLandingSound();
	bFixedRotationDir = False;
    rot = Rotation;
    rot.Pitch = 0;
    rot.Roll = 0;
    SetRotation(rot);
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
        local float dammult, massmult;

		if ((DamageType == 'TearGas') || (DamageType == 'PoisonGas') || (DamageType == 'Radiation'))
			return;

		if ((DamageType == 'EMP') || (DamageType == 'NanoVirus') || (DamageType == 'Shocked'))
			return;

		if (DamageType == 'HalonGas')
			return;

		if (DamageType == 'KnockedOut' && Damage < 11)
            return;

    if (Owner == None)
    {
    dammult = damage*0.1;
    if (dammult < 1.1)
    dammult = 1.1;
    else if (dammult > 2.5)                                                     //RSD: Was 15
    dammult = 2.5;  //capped so objects do not fly about at light speed.        //RSD: Was 15


    if (mass < 10)
    massmult = 1.2;
    else if (mass < 20)
    massmult = 1.1;
    else if (mass < 30)
    massmult = 1;
    else if (mass < 50)
    massmult = 0.7;
    else if (mass < 80)
    massmult = 0.4;
    else
    massmult = 0.2;

    SetPhysics(PHYS_Falling);
    Velocity = (Momentum*0.25)*dammult*massmult;
    if (VSize(Momentum) > 1000)                                                 //RSD: Damp out super high momentum
      Velocity *= 1000/VSize(Momentum);
    if (Velocity.Z < 0)
    Velocity.Z = 120;
    bFixedRotationDir = True;
	RotationRate.Pitch = (32768 - Rand(65536)) * 4.0;
	RotationRate.Yaw = (32768 - Rand(65536)) * 4.0;
	}
    }
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

/*function ChangeMaxAmmo(float mult)                                              //RSD: Changes MaxAmmo by a multiplier (not used)
{
    if (mult < 0.5) mult = 0.5;
    MaxAmmo = default.MaxAmmo*mult;
    if (AmmoAmount >= MaxAmmo)
        AmmoAmount = MaxAmmo;
}*/

function bool AddAmmo(int AmmoToAdd)                                            //RSD: Function to override Ammo in Engine classes for adjusted ammo counts
{
	local int tempMaxAmmo;
	local DeusExPlayer player;

	player = DeusExPlayer(GetPlayerPawn());
	tempMaxAmmo = player.GetAdjustedMaxAmmo(self);

    If (AmmoAmount >= tempMaxAmmo) return false;
	AmmoAmount += AmmoToAdd;
	if (AmmoAmount > tempMaxAmmo) AmmoAmount = tempMaxAmmo;
	return true;
}

function bool HandlePickupQuery( inventory Item )                               //RSD: Function to override Ammo.uc in Engine classes for adjusted ammo counts
{
	local int tempMaxAmmo, intj;
	local DeusExPlayer player;

    player = DeusExPlayer(GetPlayerPawn());
	tempMaxAmmo = player.GetAdjustedMaxAmmo(self);

    if ( (class == item.class) ||
		(ClassIsChildOf(item.class, class'Ammo') && (class == Ammo(item).parentammo)) )
	{
        if (AmmoAmount>=tempMaxAmmo) return true;                               //RSD: Made >= in case of errors
		else if (AmmoAmount + Ammo(item).AmmoAmount > tempMaxAmmo)              //RSD: New branch to leave spillover ammo in the world
		{
			intj = tempMaxAmmo - AmmoAmount;
			AddAmmo(intj);
			Ammo(item).AmmoAmount -= intj;
			if (item.IsA('DeusExAmmo'))
            	DeusExAmmo(item).bLooted = true;                                //RSD: so we don't add free ammo to containers we've partially looted
            if (ammoSkill != Class'DeusEx.SkillDemolition' && !IsA('AmmoHideAGun')) //RSD: Don't display ammo message for grenades or the PS20
		    {
			Pawn(Owner).ClientMessage( Item.PickupMessage @ Item.itemArticle @ Item.ItemName $ " (" $ intj $ ")", 'Pickup' );
			}
			item.PlaySound( item.PickupSound );
			if (Ammo(item).AmmoAmount <= 0)                                     //RSD: If the box is emptied, destroy it
				item.SetRespawn();
			return true;
		}
		else
		{
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogPickup(Item, Pawn(Owner));
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogPickup(Item, Pawn(Owner));
		if (ammoSkill != Class'DeusEx.SkillDemolition' && !IsA('AmmoHideAGun'))  //RSD: Don't display ammo message for grenades or the PS20
		{
		if (Item.PickupMessageClass == None)
			// DEUS_EX CNN - use the itemArticle and itemName
//			Pawn(Owner).ClientMessage( Item.PickupMessage, 'Pickup' );
			//Pawn(Owner).ClientMessage( Item.PickupMessage @ Item.itemArticle @ Item.ItemName, 'Pickup' );
			Pawn(Owner).ClientMessage( Item.PickupMessage @ Item.itemArticle @ Item.ItemName $ " (" $ Ammo(item).AmmoAmount $ ")", 'Pickup' ); //RSD
		else
			Pawn(Owner).ReceiveLocalizedMessage( Item.PickupMessageClass, 0, None, None, item.Class );
		}
		item.PlaySound( item.PickupSound );
		AddAmmo(Ammo(item).AmmoAmount);
		item.SetRespawn();
		return true;
		}
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}



auto state Pickup                                                               //RSD: State to override Inventory.uc in Engine classes for proper ammo count numbers. Holy fuck this is bad
{
	// When touched by an actor.
	// Now, when frobbed by an actor - DEUS_EX CNN
	function Frob(Actor Other, Inventory frobWith)
//	function Touch( actor Other )
	{
		// If touched by a player pawn, let him pick this up.
		if( ValidTouch(Other) )
		{
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
			SpawnCopy(Pawn(Other));
			if ( PickupMessageClass == None )
				// DEUS_EX CNN - use the itemArticle and itemName
//				Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
				Pawn(Owner).ClientMessage(PickupMessage @ itemArticle @ ItemName $ " (" $ AmmoAmount $ ")", 'Pickup' ); //RSD: Literally copied this entire code block just to add ammo amount
			else
				Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
			PlaySound (PickupSound);
			if ( Level.Game.Difficulty > 1 )
				Other.MakeNoise(0.1 * Level.Game.Difficulty);
			if ( Pawn(Other).MoveTarget == self )
				Pawn(Other).MoveTimer = -1.0;
		}
		else if ( bTossedOut && (Other.Class == Class)
				&& Inventory(Other).bTossedOut )
				Destroy();
	}

	// Landed on ground.
	function Landed(Vector HitNormal)
	{
		local rotator newRot;
		newRot = Rotation;
		newRot.pitch = 0;
		SetRotation(newRot);
		PlayLandingSound();  // DEUS_EX STM - added
//		SetTimer(2.0, false);	// DEUS_EX CNN - removed
	}

	// Make sure no pawn already touching (while touch was disabled in sleep).
	function CheckTouching()
	{
		local int i;

		bSleepTouch = false;
		for ( i=0; i<4; i++ )
			if ( (Touching[i] != None) && Touching[i].IsA('Pawn') )
				Touch(Touching[i]);
	}
	// DEUS_EX CNN - removed this crap - we want items to stick around forever
/*
	function Timer()
	{
		if ( RemoteRole != ROLE_SimulatedProxy )
		{
			NetPriority = 1.4;
			RemoteRole = ROLE_SimulatedProxy;

			// DEUS_EX STM - ick
//			if ( bHeldItem )
//				SetTimer(40.0, false);

			if ( bHeldItem )
			{
				if ( bTossedOut )
					SetTimer(15.0, false);
				else
					SetTimer(40.0, false);
			}
			return;
		}

		// DEUS_EX CNN
//		if ( bHeldItem )
//			Destroy();

		if ( bHeldItem )
		{
			if (  (FRand() < 0.1) || !PlayerCanSeeMe() )
				Destroy();
			else
				SetTimer(3.0, true);
		}
	}
*/
	function BeginState()
	{
		BecomePickup();
		bCollideWorld = true;
		// DEUS_EX CNN - removed
//		if ( bHeldItem )
//			SetTimer(30, false);
//		else if ( Level.bStartup )
		if ( Level.bStartup )
			bAlwaysRelevant = true;

		// Don't destroy it!  What were they thinking? - DEUS_EX CNN
//		if ( bHeldItem )
//			SetTimer(45, false);
	}

	function EndState()
	{
		bCollideWorld = false;
		bSleepTouch = false;
	}

Begin:
	BecomePickup();
	if ( bRotatingPickup && (Physics != PHYS_Falling) )
		SetPhysics(PHYS_Rotating);

Dropped:
	if( bAmbientGlow )
		AmbientGlow=255;
	if( bSleepTouch )
		CheckTouching();
}

defaultproperties
{
     msgInfoRounds="%d Rounds remaining"
     bDisplayableInv=False
     PickupMessage="You found"
     ItemName="DEFAULT AMMO NAME - REPORT THIS AS A BUG"
     ItemArticle=""
     LandSound=Sound'DeusExSounds.Generic.PaperHit1'
     bCollideWorld=True
     bProjTarget=True
     Mass=30.000000
}
