//=============================================================================
// SkilledTool.
//=============================================================================
class SkilledTool extends DeusExPickup
	abstract;

var() sound			useSound;
var bool			bBeingUsed;
var float           p; //CyberP: combatspeedaug

function GetAugSpeed()
	{
	local DeusExPlayer player;

     player = DeusExPlayer(Owner);

     if (player != none && player.AugmentationSystem != none)
     {
     p = player.AugmentationSystem.GetAugLevelValue(class'AugCombat'); //CyberP: we get augcombat, but it is known in-game as combat speed.
     if (p < 1.0)
        p = 1.0;
     }
	}

//Shorthand for accessing hands tex
function texture GetWeaponHandTex()
{
	local deusexplayer p;
	p = deusexplayer(owner);
	if(p != none)
        return p.GetWeaponHandTex();
	return None;
}

// ----------------------------------------------------------------------
// PlayUseAnim()
// ----------------------------------------------------------------------

function PlayUseAnim()
{
	if (!IsInState('UseIt'))
		GotoState('UseIt');
}

// ----------------------------------------------------------------------
// StopUseAnim()
// ----------------------------------------------------------------------

function StopUseAnim()
{
	if (IsInState('UseIt'))
		GotoState('StopIt');
}

// ----------------------------------------------------------------------
// PlayIdleAnim()
// ----------------------------------------------------------------------

function PlayIdleAnim()
{
	local float rnd;

	rnd = FRand();

	if (rnd < 0.1)
		PlayAnim('Idle1');
	else if (rnd < 0.2)
		PlayAnim('Idle2');
	else if (rnd < 0.3)
		PlayAnim('Idle3');
}

// ----------------------------------------------------------------------
// PickupFunction()
//
// called when the object is picked up off the ground
// ----------------------------------------------------------------------

function PickupFunction(Pawn Other)
{
	GotoState('Idle2');
}

// ----------------------------------------------------------------------
// BringUp()
//
// called when the object is put in hand
// ----------------------------------------------------------------------

function BringUp()
{
    OnEquipped();
	if (!IsInState('Idle'))
		GotoState('Idle');
}

function OnEquipped()
{
}

// ----------------------------------------------------------------------
// PutDown()
//
// called to put the object away
// ----------------------------------------------------------------------

function PutDown()
{
    OnUnEquipped();
	if (IsInState('Idle'))
		GotoState('DownItem');
}

function OnUnEquipped()
{
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state Idle
{
	function Timer()
	{
		PlayIdleAnim();
	}

Begin:
	//bHidden = False;
	bOnlyOwnerSee = True;
	GetAugSpeed();
	PlayAnim('Select',p, 0.1);
DontPlaySelect:
	FinishAnim();
	PlayAnim('Idle1',, 0.1);
	SetTimer(3.0, True);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state UseIt
{
	function PutDown()
	{

	}

Begin:
	if (( Level.NetMode != NM_Standalone ) && ( Owner != None ))
		SetLocation( Owner.Location );
	AmbientSound = useSound;
	PlayAnim('UseBegin',, 0.1);
	FinishAnim();
	LoopAnim('UseLoop',, 0.1);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state StopIt
{
	function PutDown()
	{

	}

Begin:
	AmbientSound = None;
	PlayAnim('UseEnd',, 0.1);
	FinishAnim();
	GotoState('Idle', 'DontPlaySelect');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state DownItem
{
	function PutDown()
	{

	}

Begin:
	AmbientSound = None;
	GetAugSpeed();
	bHidden = False;		// make sure we can see the animation
	PlayAnim('Down',p, 0.1);
	FinishAnim();
	bHidden = True;	// hide it correctly
	GotoState('Idle2');
}

//
//
//
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// Decrease the volume and radius for mp
	if ( Level.NetMode != NM_Standalone )
	{
		SoundVolume = 96;
		SoundRadius = 16;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     CountLabel="Uses:"
}
