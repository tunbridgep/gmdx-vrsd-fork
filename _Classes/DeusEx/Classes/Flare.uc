//=============================================================================
// Flare.
//=============================================================================
class Flare extends SkilledTool;
//class Flare extends DeusExPickup;

#exec import file=Effects

var ParticleGenerator gen, gen2, flaregen;
var effects flamething; //trying very hard not to introduce extra classes
var effects flamething2;
var() float flaretime; //added DDL: because hardcoded numbers are TEH STUPID
var bool bFlameEffect;
var Beam attachedBeam;
var bool bLClicked;
var bool bBeginQuickThrow;
var float quickThrowCombo;
///HDTP
//ok for this one I've actually done a fair bit of coding
//it's basically the vastly nicer looking one I made for QE,
//but since that's still miles off release point, what the hell
////HDTP

//SARGE: Always allow as secondary
function bool CanAssignSecondary(DeusExPlayer player)
{
    return true;
}

function bool DoLeftFrob(DeusExPlayer frobber)
{
    blClicked=true;
    LightFlare();
    return false;
}

function FlareFlame()
{
      Multiskins[2]=class'HDTPLoader'.static.GetFireTexture("HDTPanim.HDTPFlrFlame");
      AmbientSound = Sound'Ambient.Ambient.WaterRushing2';
}

simulated function FlareWoosh()
{
local Flare flare;

        bFlameEffect = False;
        AmbientSound = None;
        LightType = LT_None;
        flareTime = default.flaretime;
        Multiskins[2]= Texture'BlackMaskTex';
		// Create a Flare and throw it
		flare = Spawn(class'Flare', Owner);
		flare.LightFlare();

		UseOnce();
}

simulated function FlareTabPull()
{
      Owner.PlaySound(Sound'GMDXSFX.Weapons.flareTabz', SLOT_None,,, 1024);
      SoundVolume=128;
      SoundPitch=80;
      LightType = LT_Steady;
      LightRadius=24;
      LightBrightness=255;
      bFlameEffect = True;
      if (Owner.IsA('DeusExPlayer'))
          DeusExPlayer(Owner).ClientFlash(0.1,vect(64,64,64));
}

function ExtinguishFlare()
{
	LightType = LT_None;
	AmbientSound = None;
	if (gen != None)
		gen.DelayedDestroy();
	if (gen2 != None)
		gen2.DelayedDestroy();
	if (flaregen != None)
		flaregen.DelayedDestroy();
	if(flamething != none)
		flamething.Destroy();
	if(flamething2 != none)
		flamething2.Destroy();
}

function tick(float DT)
{
    if (quickThrowCombo > 0)
        quickThrowCombo -= DT;

    if(gen != none)
		UpdateGens();

	if (bFlameEffect)
    {
        if (SoundVolume > 8)
            SoundVolume -= DT*150;
        flareTime += DT;
        //BroadcastMessage(flareTime);
        if (flareTime < 80.4 && FRand() < 0.5)
        {
           LightType = LT_None;
        }
        else
           LightType = LT_Steady;
    }

	super.Tick(dt);
}


function UpdateGens()
{
	local vector loc, loc2;
	local rotator rota;

	if(gen != none)
	{
		loc2.Y += collisionradius*1.05;
		loc = loc2 >> rotation;
		loc += location;
		gen.SetLocation(loc);
		gen.SetRotation(rotator(loc - location));
	}

    if(gen2 != none)
	{
		loc2.Y += collisionradius*1.05;
		loc = loc2 >> rotation;
		loc += location;
		gen2.SetLocation(loc);
		gen2.SetRotation(rotator(loc - location));
	}

	if(flaregen != none)
	{
		loc2.Y += collisionradius*0.8;
		loc = loc2 >> rotation;
		loc += location;
		//rota = rotation;
		//rota.Roll = 0;
		//rota.Yaw += 16384;
		flaregen.SetLocation(loc);
		//flaregen.SetRotation(rota);
		flaregen.SetRotation(rotator(loc - location));

//		if(FF != none)
//		{
//			FF.SetLocation(locac);
//			FF.SetRotation(rotator(loc - location));
//		}
	}
	if(flamething2 != none)
	{
		if(flamething2.location != Location+vect(0,0,10))
			flamething2.setlocation(Location+vect(0,0,10)); //bah!

		if(lifespan > 2)
		{
        }
		else
		{
			flamething2.Destroy();
		}
	}
	if(flamething != none)
	{
		if(flamething.location != Location)
			flamething.setlocation(Location); //bah!

		rota = rotation;
		rota.pitch += 4096*(frand()-0.5);
		flamething.setrotation(rota);
		if(lifespan > 2)
			flamething.DrawScale = 0.1 + 0.3*lifespan/flaretime;
		else
		{
			flamething.Destroy();
			Spawn(class'FlareShell',,,Location,Rotation);
			Destroy();
		}
	}
	if (attachedBeam != none)
	{
	    attachedBeam.setlocation(Location + vect(0,0,3));
        if (lifespan < 3)
             attachedBeam.Destroy();
    }
}

function PlayIdleAnim()
{
	if (FRand() < 0.1)
		PlayAnim('Idle1');
}

function DropFrom(vector StartLocation)
{
    if (AnimSequence != 'Attack')
	    super.DropFrom(StartLocation);
}

auto state Pickup
{
	function ZoneChange(ZoneInfo NewZone)
	{
		//if (NewZone.bWaterZone)
		//if (gen != None)
		//gen.DelayedDestroy(); //CyberP: flares work in water.
			//ExtinguishFlare();

		Super.ZoneChange(NewZone);
	}

    function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{

		if ((DamageType == 'Shot') || (DamageType == 'Exploded'))
		{
		    bLClicked = true;
            LightFlare();
        }
        super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
    }

	function Frob(Actor Frobber, Inventory frobWith)
	{
		// we can't pick it up again if we've already activated it
		if (gen == None)
			Super.Frob(Frobber, frobWith);
		else if (Frobber.IsA('Pawn'))
			Pawn(Frobber).ClientMessage(ExpireMessage);
	}
}

state Activated
{
	function ZoneChange(ZoneInfo NewZone)
	{
		//if (NewZone.bWaterZone)
		//	ExtinguishFlare();

		Super.ZoneChange(NewZone);
	}

	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
        local Flare flare;
    
        if (!IsHDTP())
        {
            Super.BeginState();
            flare = Spawn(class'Flare', Owner);
            flare.LightFlare();

            UseOnce();
        }
	}
	function PutDown()
	{

	}
	function DropFrom(vector StartLocation)
    {
    }
Begin:
    if (IsHDTP())
    {
        PlayAnim('Attack',2,0.1);                                                    //RSD: Was 0.1
        FinishAnim();
    }
    Finish();                                                                   //RSD
}

/*state UseIt
{
	function PutDown()
	{

	}

Begin:
	PlayAnim('Attack',,0.1);
	FinishAnim();
} */

function LightFlare()
{
	local Vector X, Y, Z, dropVect, loc, loc2, offset;
	local Pawn P;
	local rotator rota;
    local DeusExPlayer playa;
    local bool bHDTPInstalled;

    bHDTPInstalled = DeusExPlayer(GetPlayerPawn()).bHDTPInstalled;

	if (gen == None)
	{
		Multiskins[1]=texture'pinkmasktex';
		LifeSpan = flaretime;
		bUnlit = True;
		LightType = LT_None;
		//LightType = LT_Steady;
		AmbientSound = Sound'Flare';

        if (bLClicked)
		{
		   LightBrightness=224;
           LightHue=22;
           LightSaturation=96;
           LightRadius=16;
           LightType = LT_Steady;
		}
		P = Pawn(Owner);
		if (P != None)
		{
		    attachedBeam = spawn(class'Beam',self.Owner,,Location + vect(0,0,8));
		    if (attachedBeam != none)
		    {
		        attachedBeam.LightBrightness = 224;
		        attachedBeam.LightHue=22;
                attachedBeam.LightSaturation=96;
                attachedBeam.LightRadius=18;
                attachedBeam.bFlareBeam = True;
                LightType = LT_Steady;
                LightEffect=LE_TorchWaver;
		    }
			GetAxes(P.ViewRotation, X, Y, Z);
			dropVect = P.Location + 0.8 * P.CollisionRadius * X;
			dropVect.Z += P.BaseEyeHeight;
			if (P.IsA('ScriptedPawn'))
			{
			    //Velocity = Vector(P.ViewRotation) * 800 + vect(0,0,220);
			}
			else
			    Velocity = Vector(P.ViewRotation) * 500 + vect(0,0,220);
			bFixedRotationDir = True;
			RotationRate = RotRand(False);
			if (!P.IsA('ScriptedPawn'))
			    DropFrom(dropVect);

			// increase our collision height so we light up the ground better
			SetCollisionSize(CollisionRadius, CollisionHeight*2);
		}

		loc2.Y += collisionradius*1.05;
		loc = loc2 >> rotation;
		loc += location;
		gen = Spawn(class'ParticleGenerator', Self,, Loc, rot(16384,0,0));
		if (gen != None)
		{
			//gen.attachTag = Name;
			//gen.SetBase(Self);
			gen.LifeSpan = flaretime;
			gen.bRandomEject = True;
			gen.bParticlesUnlit = false;
			gen.ejectSpeed = 30;
			gen.riseRate = 10;
			gen.checkTime = 0.075;
			gen.particleLifeSpan = 5;
			gen.particleDrawScale = 0.075;
			gen.particleTexture = Texture'GMDXSFX.Effects.ef_ExpSmoke001';//Texture'Effects.Smoke.SmokePuff1';
		}
		gen2 = Spawn(class'ParticleGenerator', Self,, Loc, rot(16384,0,0));
		if (gen2 != None)
		{
			//gen.attachTag = Name;
			//gen.SetBase(Self);
			gen2.LifeSpan = flaretime;
			gen2.bRandomEject = True;
			gen2.bParticlesUnlit = false;
			gen2.ejectSpeed = 30;
			gen2.riseRate = 10;
			gen2.checkTime = 0.075;
			gen2.particleLifeSpan = 5;
			gen2.particleDrawScale = 0.1;
			gen2.particleTexture = Texture'GMDXSFX.Effects.ef_ExpSmoke002';//Texture'Effects.Smoke.SmokePuff1';
		}
		loc2.Y = collisionradius*0.8;    //I hate coordinate shifting
		loc = loc2 >> rotation;
		loc += location;
		rota = rotation;
		rota.Roll = 0;
		rota.Yaw += 16384;
        //if (IsHDTP())
        if (bHDTPInstalled)
        {
            flaregen = Spawn(class'ParticleGenerator',Self,, Loc, rota);
            if (flaregen != None)
            {
                flaregen.LifeSpan = flaretime;
                flaregen.attachTag = Name;
                flaregen.SetBase(Self);
                flaregen.bRandomEject=true;
                flaregen.RandomEjectAmt=0.1;
                flaregen.bParticlesUnlit=true;
                flaregen.frequency=0.5 + 0.5*frand();
                flaregen.numPerSpawn=2;
                flaregen.bGravity=false;
                flaregen.ejectSpeed = 100;
                flaregen.riseRate = -1;
                flaregen.checkTime = 0.02;
                flaregen.particleLifeSpan = 0.6*(1 + frand());
                flaregen.particleDrawScale = 0.05 + 0.05*frand();
                flaregen.particleTexture = class'HDTPLoader'.static.GetFireTexture("HDTPAnim.effects.HDTPFlarespark");
            }
        }
        //if (IsHDTP())
        if (bHDTPInstalled)
        {
            flamething = Spawn(class'Effects', Self,, Location, rotation);
            if(flamething != none)
            {
                flamething.setbase(self);
                flamething.DrawType=DT_mesh;
                flamething.mesh=class'HDTPLoader'.static.GetMesh("HDTPItems.HDTPflareflame");
                flamething.multiskins[1]=class'HDTPLoader'.static.GetFireTexture("HDTPAnim.effects.HDTPflrflame");
                flamething.Style=STY_Translucent;
                flamething.bUnlit=true;
                flamething.DrawScale=0.4;
                flamething.Scaleglow=5;
                flamething.lifespan=0;
                flamething.bHidden=false;
            }
        }
        //if (IsHDTP())
        if (bHDTPInstalled)
        {
            flamething2 = Spawn(class'Effects', Self,, Location, rotation);
            if(flamething2 != none)
            {
                flamething2.setbase(self);
                flamething2.DrawType=DT_mesh;
                flamething2.mesh=class'HDTPLoader'.static.GetMesh("HDTPItems.HDTPflareflame");
                flamething2.multiskins[1]=class'HDTPLoader'.static.GetFireTexture("HDTPAnim.effects.HDTPflrflame");
                flamething2.DrawScale=0.00001;
                flamething2.lifespan=0;
                flamething2.bHidden=false;
                flamething2.LightType=LT_None;
                //flamething2.LightType=LT_Steady;
                //flamething2.LightBrightness=96;
                //flamething2.LightHue=16;
                //flamething2.LightSaturation=96;
                //flamething2.LightRadius=22;
            }
        }
	}
}

function BringUp()                                                              //RSD: For secondary item shenanigans
{
    if (!IsInState('Idle'))
		GotoState('Idle');

    if (bBeginQuickThrow)
    {
        GotoState('Activated');
    }
}

function PutDown()                                                              //RSD: For secondary item shenanigans
{
	if (IsInState('Idle'))
		GotoState('DownItem');

	bBeginQuickThrow = false;
}

function Finish()                                                               //RSD: For secondary item shenanigans
{
    if (bBeginQuickThrow)
    {
   		if (Owner != None && Owner.IsA('DeusExPlayer'))
        {
            DeusExPlayer(Owner).StopFiring();
    		if (quickThrowCombo > 0)
    		{
    			GotoState('Activated');
    			return;
   			}
            //if (DeusExPlayer(Owner).primaryWeapon != None)                    //RSD: Always quickdraw
            //{
              if (DeusExPlayer(Owner).CarriedDecoration == None)
                 DeusExPlayer(Owner).inHandPending = DeusExPlayer(Owner).primaryWeapon;
              GotoState('idle');
              return;
            //}
         }
    }
    else
		GoToState('Idle');
		return;
}

exec function UpdateHDTPsettings()
{
    Super.UpdateHDTPsettings();
    PlayerViewMesh=class'HDTPLoader'.static.GetMesh2("FOMOD.flare1st","DeusExItems.Flare",IsHDTP());
    if (bCarriedItem)
        Mesh = PlayerViewMesh;
}

defaultproperties
{
     flaretime=80.000000
     maxCopies=30
     bCanHaveMultipleCopies=True
     ExpireMessage="It's already been used"
     bActivatable=True
     ItemName="Flare"
     PlayerViewOffset=(X=22.000000,Y=-2.000000,Z=-17.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Flare'
     Mesh=LodMesh'DeusExItems.Flare'
     HDTPMesh="HDTPItems.HDTPflare"
     Icon=Texture'DeusExUI.Icons.BeltIconFlare'
     largeIcon=Texture'DeusExUI.Icons.LargeIconFlare'
     largeIconWidth=42
     largeIconHeight=43
     Description="A flare."
     beltDescription="FLARE"
     SoundRadius=16
     SoundVolume=96
     CollisionRadius=6.200000
     CollisionHeight=1.300000
     bCollideWorld=True
     bBlockPlayers=True
     LightBrightness=224
     LightHue=22
     LightSaturation=96
     LightRadius=16
     Mass=2.000000
     Buoyancy=1.000000
}
