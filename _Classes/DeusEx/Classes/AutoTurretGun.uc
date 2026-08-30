//=============================================================================
// AutoTurretGun.
//=============================================================================
class AutoTurretGun extends HackableDevices;

var int		team;
var String	titleString;
var float	updateTime;

replication
{
	reliable if (Role==ROLE_Authority)
		team, titleString;
}

//Sarge: All turrets are at 20% strength
//(one multitool at Advanced on all difficulties)
//Was previously 75%, which was fucking stupid.
//Can now increase up to 75% with additional NG+ cycles.
function SetupDifficultyMod(DeusExPlayer P)
{
    super.SetupDifficultyMod(P);
    hackStrength = FMIN(0.75,0.2 + (0.15 * P.iNewGamePlusCycle));
}
    
//For cameras and turrets which can be turned off at a computer, we want to display them
//as BYPASSED if they are disabled at a computer
function bool DisplayHackText()
{
	local AutoTurret turret;
	turret = AutoTurret(Owner);

    return super.DisplayHackText() && (!turret.bDisabled || turret.bRebooting);
}

function Destroyed()
{
	local AutoTurret turret;

	turret = AutoTurret(Owner);
	if (turret != None)
	{
		turret.gun = None;
		turret.Destroy();
		SetOwner(None);
	}
	Super.Destroyed();
}

//Change style based on the parent AutoTurret
static function bool IsHDTP()
{
	return class'DeusExPlayer'.static.IsHDTPInstalled() && class'AutoTurret'.default.iHDTPModelToggle > 0;
}

function ResetComputerAlignment()
{
	local AutoTurret turret;
	local ComputerSecurity TempComp;
	local int ViewIndex;

	turret = AutoTurret(Owner);

	if (( Level.NetMode != NM_Standalone ) && ( turret != None ))
	{
		//Find the associated computer
		foreach AllActors(class'ComputerSecurity',TempComp)
		{
			for (ViewIndex = 0; ViewIndex < ArrayCount(TempComp.Views); ViewIndex++)
			{
				if (TempComp.Views[ViewIndex].turretTag == turret.Tag)
				{
					TempComp.Team = -1;
				}
			}
		}
	}
}

function HackAction(Actor Hacker, bool bHacked)
{
	local ComputerSecurity CompOwner;
	local ComputerSecurity TempComp;
	local AutoTurret turret;
	local SecurityCamera Camera;
	local name CameraTag;
	local int ViewIndex;

	Super.HackAction(Hacker, bHacked);

	turret = AutoTurret(Owner);
	if (bHacked && (turret != None))
	{
		if (Level.NetMode == NM_Standalone)
		{
			if (!turret.bDisabled || turret.bRebooting)
			{
				turret.UnTrigger(Hacker, Pawn(Hacker));
				turret.bDisabled = True;
			}
			else
			{
				turret.bDisabled = False;
				turret.Trigger(Hacker, Pawn(Hacker));
			}
		}
		else
		{
			//DEUS_EX AMSD Reset the hackstrength afterwards
			if (hackStrength == 0.0)
				hackStrength = 0.6;
			turret.bDisabled = True;
			turret.Trigger(Hacker,Pawn(Hacker));
			//Find the associated computer.
			foreach AllActors(class'ComputerSecurity',TempComp)
			{
				for (ViewIndex = 0; ViewIndex < ArrayCount(TempComp.Views); ViewIndex++)
				{
					if (TempComp.Views[ViewIndex].turretTag == Turret.Tag)
					{
						CompOwner = TempComp;
						//find associated turret
						cameratag = TempComp.Views[ViewIndex].cameratag;
						if (cameratag != '')
						{
							foreach AllActors(class'Securitycamera', camera, cameraTag)
							{
								break;
							}
						}
					}
				}
			}

			if (CompOwner != None)
			{
				if ( (Hacker.IsA('DeusExPlayer')) && (Camera.bActive))
				{
					Camera.HackStrength = 0.6;
					if (Camera.bActive)
						Camera.UnTrigger(Hacker, Pawn(Hacker));
				}
			}
		}
	}
}

function Tick(float deltaTime)
{
	local AutoTurret turret;

	Super.Tick(deltaTime);

	// As a client, it was possible for the turret to become irrelevant to you while the gun remained relevant
	if  ((Level.NetMode != NM_Standalone) && (updateTime < Level.Timeseconds))
	{
		updateTime = Level.Timeseconds + 2.0;
		turret = AutoTurret(Owner);
		if ( turret != None )
		{
			if ( team != turret.team )
				team = turret.team;
			if (!( titleString ~= turret.titleString ))
				titleString = turret.titleString;
		}
	}
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
local AutoTurret turret;

	if (( Level.NetMode != NM_Standalone ) && (EventInstigator.IsA('DeusExPlayer')))
		DeusExPlayer(EventInstigator).ServerConditionalNotifyMsg( DeusExPlayer(EventInstigator).MPMSG_TurretInv );

    turret = AutoTurret(Owner);

    //SARGE: Modify damage by the Piercing perk
    Damage *= class'PerkPiercing'.static.GetPiercingPerkMult(DeusExPlayer(eventInstigator));

    Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);

    if ( turret != None )
		turret.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

function PostBeginPlay()
{
	local AutoTurret turret;

    super.PostBeginPlay();

	turret = AutoTurret(Owner);
	if (turret.bUnlit)
	{
	 bUnlit=True;
	 ScaleGlow=0.5;
	}
}

defaultproperties
{
     Team=-1
     hackStrength=0.750000
     HitPoints=60
     minDamageThreshold=60
     bEMPHitMarkers=True
     bInvincible=False
     FragType=Class'DeusEx.MetalFragment'
     ItemName="Autonomous Defense Turret"
     Physics=PHYS_Rotating
     HDTPMesh="HDTPDecos.HDTPAutogun"
     Mesh=LodMesh'DeusExDeco.AutoTurretGun'
     PrePivot=(Z=-8.770000)
     SoundRadius=24
     CollisionRadius=22.500000
     CollisionHeight=9.100000
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=28
     LightSaturation=160
     LightRadius=2
     bRotateToDesired=True
     Mass=50.000000
     Buoyancy=10.000000
     RotationRate=(Pitch=21384,Yaw=21384)
     bVisionImportant=True
}
