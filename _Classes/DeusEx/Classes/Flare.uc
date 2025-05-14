//=============================================================================
// Flare.
//=============================================================================
class Flare extends SkilledTool;
//class Flare extends DeusExPickup;

#exec import file=Effects

var ParticleGenerator gen, flaregen;
var effects flamething; //trying very hard not to introduce extra classes
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

static function bool IsHDTP()
{
    return class'DeusExPlayer'.static.IsHDTPInstalled();
}

//SARGE: Always allow as secondary
function bool CanAssignSecondary(DeusExPlayer player)
{
    return true;
}

function bool DoLeftFrob(DeusExPlayer frobber)
{
    blClicked = true;
    LightFlare();
    return false;
}

function FlareFlame()
{
	AmbientSound = Sound'Ambient.Ambient.WaterRushing2';
	
	if (IsHDTP() && iHDTPModelToggle > 0)
		Multiskins[2] = class'HDTPLoader'.static.GetFireTexture("HDTPanim.HDTPFlrFlame");
}

simulated function FlareWoosh()
{
		local Flare flare;

        bFlameEffect = false;
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
	if(Owner != None)	
	{
		Owner.PlaySound(Sound'GMDXSFX.Weapons.flareTabz', SLOT_None,,, 1024);
		if (Owner.IsA('DeusExPlayer'))
			DeusExPlayer(Owner).ClientFlash(0.1,vect(64,64,64));
	}

	SoundVolume = 128;
	SoundPitch = 80;
	LightType = LT_Steady;
	LightRadius = 24;
	LightBrightness = 255;
	bFlameEffect = true;      
}

function ExtinguishFlare()
{
	LightType = LT_None;
	AmbientSound = None;
	if (gen != None)
		gen.DelayedDestroy();
	if (flaregen != None)
		flaregen.DelayedDestroy();
	if(flamething != None)
		flamething.Destroy();
}

simulated function Tick(float deltaTime)
{
    if (quickThrowCombo > 0)
        quickThrowCombo -= deltaTime;

    if(gen != None)
		UpdateGens();

	if (bFlameEffect)
    {
        if (SoundVolume > 8)
            SoundVolume -= deltaTime*150;
        flareTime += deltaTime;
        //BroadcastMessage(flareTime);
        if (flareTime < 80.4 && FRand() < 0.5)
        {
           LightType = LT_None;
        }
        else
           LightType = LT_Steady;
    }

	super.Tick(deltaTime);
}

function UpdateGens()
{
	local vector loc, loc2;
	local rotator rota;
    local FlareShell shell;

	if(gen != None)
	{		
		loc2.Y += collisionradius*1.05;
		loc = loc2 >> Rotation;
		loc += Location;
		if(gen.Location != loc)
			gen.setlocation(loc); //bah!

		gen.SetRotation(rotator(loc - Location));
	}
	
	if(flaregen != None)
	{
		loc2.Y += collisionradius*0.8;
		loc = loc2 >> Rotation;
		loc += Location;
		if(flaregen.Location != loc)
			flaregen.setlocation(loc); //bah!

		flaregen.SetRotation(rotator(loc - Location));
	}
	
	if(flamething != None)
	{
		if(flamething.Location != Location)
			flamething.setlocation(Location); //bah!

		rota = Rotation;
		rota.pitch += 4096*(FRand()-0.5);
		flamething.setrotation(rota);
		if(lifespan > 1)
			flamething.DrawScale = 0.1 + 0.3*lifespan/flaretime;
		else
			flamething.Destroy();
	}
	
	if (attachedBeam != None)
	{
		if(attachedBeam.Location != Location)
			attachedBeam.setlocation(Location + vect(0,0,3)); //bah!
		
        if (lifespan < 2)
             attachedBeam.Destroy();
    }
    
    if(lifespan < 2)
    {
		Destroy();
        shell = Spawn(class'FlareShell',,,Location,Rotation);
        if (shell != None && class'DeusExPlayer'.default.iPersistentDebris < 2)
            shell.LifeSpan = 30;
    }
}

function PlayIdleAnim()
{
	if (FRand() < 0.1)
		PlayAnim('Idle');
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

		Super.ZoneChange(NewZone);
	}

	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
        local Flare flare;
    
        if (!IsHDTP() || iHDTPModelToggle == 0)
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
    if (IsHDTP() && iHDTPModelToggle > 0)
    {
        PlayAnim('Attack',2,0.1);                                                    //RSD: Was 0.1
        FinishAnim();
    }
    Finish();                                                                   //RSD
}

function LightFlare()
{
	local Vector X, Y, Z, dropVect, loc, loc2;
	local Pawn P;
	local rotator rota;

	if (gen == None)
	{
		Multiskins[1]=texture'pinkmasktex';
		LifeSpan = flaretime;
		bUnlit = true;
		LightType = LT_None;
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
		    attachedBeam = spawn(class'Beam',Self.Owner,,Location + vect(0,0,8));

			GetAxes(P.ViewRotation, X, Y, Z);
			dropVect = P.Location + 0.8 * P.CollisionRadius * X;
			dropVect.Z += P.BaseEyeHeight;
			bFixedRotationDir = true;
			RotationRate = RotRand(false);
			if (!P.IsA('ScriptedPawn'))
			{
			    DropFrom(dropVect);
				Velocity = Vector(P.ViewRotation) * 500 + vect(0,0,220);
			}
			// increase our collision height so we light up the ground better
			SetCollisionSize(CollisionRadius, CollisionHeight*2);
		}
		else
		{
			attachedBeam = spawn(class'Beam',Self,,Location + vect(0,0,8));
			SetCollisionSize(CollisionRadius, CollisionHeight*2);
		}
		
		if (attachedBeam != None)
		{
			attachedBeam.LightBrightness = 224;
			attachedBeam.LightHue=22;
			attachedBeam.LightSaturation=96;
			attachedBeam.LightRadius=18;
			attachedBeam.bFlareBeam = True;
			LightType = LT_Steady;
			LightEffect=LE_TorchWaver;
		}

		loc2.Y += collisionradius*1.05;
		loc = loc2 >> Rotation;
		loc += Location;
		gen = Spawn(class'ParticleGenerator', Self,, loc, rot(16384,0,0));
		if (gen != None)
		{
			gen.attachTag = Name;
			//gen.SetBase(Self);
			gen.LifeSpan = flaretime;
			gen.bRandomEject = true;
			gen.bParticlesUnlit = false;
			gen.ejectSpeed = 35;
			gen.riseRate = 15;
			gen.checkTime = 0.075;
			gen.particleLifeSpan = 4;
			gen.particleDrawScale = 0.25;
			gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		}	

        if (IsHDTP()) //no need to check the model for the effect only the mod installation so vanilla model can have this effect too
        {
			loc2.Y = collisionradius*0.8;    //I hate coordinate shifting
			loc = loc2 >> Rotation;
			loc += Location;
			rota = Rotation;
			rota.Roll = 0;
			rota.Yaw += 16384;
		
            flaregen = Spawn(class'ParticleGenerator',Self,, loc, rota);
            if (flaregen != None)
            {
				flaregen.particleTexture = class'HDTPLoader'.static.GetFireTexture("HDTPAnim.Effects.HDTPFlarespark");
				flaregen.LifeSpan = LifeSpan;
				flaregen.attachTag = Name;
				flaregen.SetBase(Self);
				flaregen.bRandomEject = true;
				flaregen.RandomEjectAmt = 0.1;
				flaregen.bParticlesUnlit = true;
				flaregen.frequency = 0.3 + 0.4*FRand();
				flaregen.numPerSpawn = 2;
				flaregen.bGravity = true;
				flaregen.ejectSpeed = 100;
				flaregen.riseRate = 1;
				flaregen.checkTime = 0.02;
				flaregen.particleLifeSpan = 0.2*(1 + FRand());
				flaregen.particleDrawScale = 0.02 + 0.04*FRand();   
            }
       
			rota.Yaw = 0;
            flamething = Spawn(class'Effects', Self,, Location, Rotation);
            if(flamething != None)
            {
				flamething.Mesh=class'HDTPLoader'.static.GetMesh("HDTPItems.HDTPflareflame");
                flamething.Multiskins[1]=class'HDTPLoader'.static.GetFireTexture("HDTPAnim.effects.HDTPflrflame");
                flamething.Setbase(Self);
                flamething.DrawType=DT_mesh;                
                flamething.Style=STY_Translucent;
                flamething.bUnlit=true;
                flamething.DrawScale=0.4;
                flamething.Scaleglow=5;
                flamething.Lifespan=0;
                flamething.bHidden=false;
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
			
            if (DeusExPlayer(Owner).CarriedDecoration == None)
				DeusExPlayer(Owner).SelectLastWeapon(true,false);
         }
    }
	
	GoToState('Idle');
	return;
}

exec function UpdateHDTPsettings()
{
    //Super.UpdateHDTPsettings();
	if (HDTPMesh != "")
        Mesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),(IsHDTP() && iHDTPModelToggle > 0));
    if (HDTPSkin != "")
        Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),(IsHDTP() && iHDTPModelToggle > 0));
    if (HDTPTexture != "")
        Texture = class'HDTPLoader'.static.GetTexture2(HDTPTexture,string(default.Texture),(IsHDTP() && iHDTPModelToggle > 0));
	
	PlayerViewMesh = class'HDTPLoader'.static.GetMesh2("FOMOD.flare1st",string(default.Mesh),(IsHDTP() && iHDTPModelToggle > 0));
	PickupViewMesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),(IsHDTP() && iHDTPModelToggle > 0));	
	
    if (bCarriedItem)
        Mesh = PlayerViewMesh;
	else
		Mesh = PickupViewMesh;
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	UpdateHDTPsettings();
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
	 UseSound=Sound'GMDXSFX.Weapons.flareTabz'
}
