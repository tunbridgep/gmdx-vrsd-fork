//=============================================================================
// FireExtinguisher.
//=============================================================================
class FireExtinguisher extends DeusExPickup;

#exec OBJ LOAD FILE=Ambient
var bool bAltActivate;  //CyberP: for being triggered by left click

function bool DoLeftFrob(DeusExPlayer frobber)
{
    bAltActivate=true;
    Activate();
    return false;
}
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    bAltActivate=false;
    return true;
}

function Timer()
{
local FireExtinguisherEmpty empt;
local Pawn P;
local Vector offset, X, Y, Z;

    P = Pawn(Owner);
    if (P != None)
    {
      GetAxes(P.ViewRotation,X,Y,Z);
      offset = P.Location;
		offset += X * P.CollisionRadius;
      empt = spawn(class'FireExtinguisherEmpty',,,offset,Rotation);
     if (empt != none)
       {
         empt.Velocity = Vector(Pawn(Owner).ViewRotation) * 600 + vect(0,0,220);
         empt.RotationRate = RotRand();
       }
    }
    else
    {
    empt = spawn(class'FireExtinguisherEmpty');
    if (empt != none)
     empt.SetPhysics(self.Physics);
    }

	Destroy();
}

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local ProjectileGenerator gen;
		local Vector loc;
		local Rotator rot;
        local DeusExPlayer player;
        local bool bFirefighter;
        local int burnTime, ejectSpeed;
        local float projLife;

		Super.BeginState();

        player = DeusExPlayer(GetPlayerPawn());
		
        bFirefighter = player != None && player.PerkManager.GetPerkWithClass(class'DeusEx.PerkFirefighter').bPerkObtained;

        if (bFirefighter)
        {
            burnTime = 5;
            projLife = 1.8;
            ejectSpeed = 380;
        }
        else
        {
            burnTime = 4;
            projLife = 1.5;
            ejectSpeed = 320;
        }

		// force-extinguish the player
		if (Owner == player && player.bOnFire)
				player.ExtinguishFire();

		// spew halon gas
		if (bAltActivate)
		{
            gen = Spawn(class'ProjectileGenerator', None,, Location);
        }
        else
        {
            rot = Pawn(Owner).ViewRotation;
            loc = Vector(rot) * Owner.CollisionRadius;
            loc.Z += Owner.CollisionHeight * 0.9;
            loc += Owner.Location;
            gen = Spawn(class'ProjectileGenerator', None,, loc, rot);
        }

		if (gen != None)
        {
			gen.ProjectileClass = class'HalonGas';
			gen.SetBase(Owner);//(Owner);
			gen.LifeSpan = burnTime;
			gen.ejectSpeed = ejectSpeed;
			gen.projectileLifeSpan = projLife;
			gen.frequency = 0.3; //0.13;   //CyberP: modded values
			gen.checkTime = 0.03; //0.06;
			gen.bAmbientSound = True;
			gen.DrawScale = 2.0;
			gen.AmbientSound = sound'SteamVent'; //CyberP: better sound
			gen.SoundVolume = 192;
			gen.SoundPitch = 32;
        }
		// blast for 3 seconds, then destroy //SARGE: Actually 4
        // or, for 8 seconds, if the player has the Firefighter perk
        SetTimer(burnTime, False);
	}
Begin:
}

state DeActivated
{
}

defaultproperties
{
     bBreakable=True
     bAutoActivate=True
     FragType=Class'DeusEx.MetalFragment'
     bActivatable=True
     ItemName="Fire Extinguisher"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.FireExtinguisher'
     PickupViewMesh=LodMesh'DeusExItems.FireExtinguisher'
     ThirdPersonMesh=LodMesh'DeusExItems.FireExtinguisher'
     LandSound=Sound'DeusExSounds.Generic.GlassDrop'
     Icon=Texture'DeusExUI.Icons.BeltIconFireExtinguisher'
     largeIcon=Texture'DeusExUI.Icons.LargeIconFireExtinguisher'
     largeIconWidth=25
     largeIconHeight=49
     Description="A chemical fire extinguisher."
     beltDescription="FIRE EXT"
     Mesh=LodMesh'DeusExItems.FireExtinguisher'
     CollisionRadius=8.000000
     CollisionHeight=10.270000
     bCollideWorld=True
     bBlockPlayers=True
     Mass=30.000000
     Buoyancy=20.000000
}
