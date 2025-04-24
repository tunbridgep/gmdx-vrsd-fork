//=============================================================================
// AugAutoaim.
//=============================================================================
class AugAutoaim extends Augmentation;

var ScriptedPawn potentialTarget;               //Target needs to be valid for a time to register as a target.
var ScriptedPawn target;
var float targetCountdown;

const TRACK_TIME = 3.5;

// ----------------------------------------------------------------------------
// Network Replication
// ----------------------------------------------------------------------------

replication
{
   //Server to client function replication
   reliable if (Role == ROLE_Authority)
      SetAugStatus;
}

state Active
{
Begin:
   SetAugStatus(CurrentLevel,True,IsValidWeapon(),potentialTarget,target);
}

function Deactivate()
{
	Super.Deactivate();
    SetAugStatus(CurrentLevel,False,IsValidWeapon(),None,None);
}

function Setup()
{
    SetAugStatus(CurrentLevel,bIsActive,IsValidWeapon(),potentialTarget,target);
}

// ------------------------------------------------------------------------------
// IsValidWeapon()
// ------------------------------------------------------------------------------

function bool IsValidWeapon()
{
    local DeusExWeapon weapon;
    
    if (player == None)
        return false;

    weapon = DeusExWeapon(player.weapon);
    return weapon != None && !weapon.bHandToHand; //&& weapon.bTargetingAugCompatible;
}

// ------------------------------------------------------------------------------
// FindNearestTarget()
// ------------------------------------------------------------------------------

simulated function FindNearestTarget()
{
    local ScriptedPawn pawn, minpawn;
    local float dist, mindist;
    local bool bValidTarget;

    if (!bIsActive || !IsValidWeapon())
    {
        ClearTarget();
        return;
    }

    pawn = None;
    mindist = 999999;

    //if we already have a potential target, just use that instead
    if (potentialTarget != None && dist < mindist && dist < 2000 + (CurrentLevel * 1000))
    {
        if (player.LineOfSightTo(pawn))
            return;
    }

    foreach AllActors(class'ScriptedPawn', pawn)
    {
        bValidTarget = pawn.GetPawnAllianceType(player) == ALLIANCE_Hostile; //Only allow hostiles

        if (pawn.IsA('Robot'))
            bValidTarget = false;

        if (!player.LineOfSightTo(pawn))
            bValidTarget = false;

        if (bValidTarget)
        {
            dist = VSize(Player.Location - pawn.Location);
            if (dist < mindist && dist < 2000 + (CurrentLevel * 1000))
            {
                mindist = dist;
                minpawn = pawn;
            }
        }
    }

    potentialTarget = minpawn;
}

simulated function Tick(float DeltaTime)
{
    local ScriptedPawn previousPotential;

    Super.Tick(DeltaTime);

    previousPotential = potentialTarget;

    FindNearestTarget();

    if (previousPotential == potentialTarget && potentialTarget != None)
        targetCountdown -= DeltaTime;
    else
        targetCountdown = TRACK_TIME;

    if (targetCountdown <= 0)
    {
        targetCountdown = 0;
        target = potentialTarget;
    }


    SetAugStatus(CurrentLevel,bIsActive,IsValidWeapon(),potentialTarget,target);
}

function ClearTarget()
{
    potentialTarget = None;
    target = None;
    SetAugStatus(CurrentLevel,bIsActive,IsValidWeapon(),potentialTarget,target);
}

// ----------------------------------------------------------------------
// SetAugStatus()
// ----------------------------------------------------------------------

simulated function SetAugStatus(int Level, bool IsActive, bool validWeap, ScriptedPawn ppawn, ScriptedPawn tpawn)
{
	if (player == None || player.rootWindow == None)
		return;

	DeusExRootWindow(Player.rootWindow).hud.augDisplay.bAutoaimActive = bIsActive;
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.autoaimPotentialTarget = ppawn;
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.autoaimTarget = tpawn;
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.autoaimValidWeapon = validWeap;
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
        AugmentationLocation = LOC_Subdermal;
	}
}

defaultproperties
{
     EnergyRate=2.000000
     EnergyRateLabel="Energy Rate: %d Units/Shot"
     AugmentationType=Aug_Automatic
     Icon=Texture'DeusExUI.UserInterface.AugIconTarget'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconTarget_Small'
     AugmentationName="Aim Enhancer"
     Description="When active, controlled muscle movements are synchronised with ocular data to position an agents weapon directly, providing a significant accuracy increase as well as automatic target acquisition and aiming."
     MPInfo="When active, controlled muscle movements are synchronised with ocular data to position an agents weapon directly, providing a significant accuracy increase as well as automatic target acquisition and aiming."
     AugmentationLocation=LOC_Eye
     MPConflictSlot=4
}
