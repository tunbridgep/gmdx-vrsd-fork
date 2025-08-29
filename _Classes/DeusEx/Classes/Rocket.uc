//=============================================================================
// Rocket.
//=============================================================================
class Rocket extends DeusExProjectile;

var float mpBlastRadius;

var ParticleGenerator fireGen;
var ParticleGenerator smokeGen;
var ParticleGenerator smokeGen2; //CyberP
var ParticleGenerator smokeGen3; //CyberP
var ParticleGenerator smokeGen4; //CyberP

var bool bRenderOverlay;
var bool bFlipFlopCanvas;
var vector PortalOffset;
var float PortalX,PortalY,PortalW,PortalH;
var bool bGEPInFlight;
var bool bGEPjit;
var texture GEPVid;
var float GEProll;
var rotator OldRotation;
var bool pState;
var float Throttle,FuelLeft;

function PostBeginPlay()
{
    local DeusExPlayer player;

	Super.PostBeginPlay();

	if (Level.NetMode == NM_DedicatedServer)
	  return;

    if (default.ItemName=="GEP Rocket")
        if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkHERocket').bPerkObtained == true)
            blastRadius=576.000000;

	OldRotation=Rotation;
	SpawnRocketEffects();

}

//GMDX: based on skill, laser = wire guided, scope=POV
//just incase its spawned and postbeginplay already completed before my inits are done!
function PostSpawnInit()
{
	local DeusExPlayer player;
	local float skillMod;

	if ((Owner!=none)&&(Owner.IsA('DeusExPlayer')))
	{
		player=DeusExPlayer(Owner);
		if ((player.SkillSystem!=none)&&(bTracking||player.bGEPprojectileInflight))
		{
			skillMod=player.SkillSystem.GetSkillLevel(class'SkillWeaponHeavy');
			skillMod+=1.5;
			RotationRate.Pitch=4096+(skillMod*4000.0); //CyberP: both were 5000
			RotationRate.Yaw=4096+(skillMod*4000.0); //2048
			// RotationRate=(Pitch=32768,Yaw=32768)
			bRenderOverlay=player.bGEPprojectileInflight;
			bGEPInFlight=true;
			//SetTimer(0.1,true);

			if (player.bGEPprojectileInflight)
			{
			speed=400.000000;
            MaxSpeed=400.000000;
            AmbientSound=Sound'GMDXSFX.Weapons.rocketcam';
            SoundRadius=255;
			}
		}
	}
}

function float SpeedMod()
{
   if (FuelLeft>0)
      return Throttle;
   return 0.95; //need to use dttime, how?
}

//function vector CalculateDrop(float dist)
//{
//   return (Region.Zone.ZoneGravity *0.05)- 0.0002*vector(Rotation)*vsize(Velocity)*vsize(Velocity); //CyberP: was 0.5
//}

function RenderPortal(canvas Canvas)
{
	local Actor actnul;
	local rotator rdif;
	if (bRenderOverlay&&!bFlipFlopCanvas)//stop self sustain
	{
		bFlipFlopCanvas=true;
		rdif=Rotation-OldRotation;

        if (MaxSpeed == 2100.000000)
		   rdif.Roll=rdif.Roll+(Frand()*2)-1;
		rdif.Roll=FMin(300,rdif.Roll);
		rdif.Roll=FMax(-300,rdif.Roll);

		OldRotation=Rotation;

	   Canvas.DrawPortal(Canvas.ClipX/4,Canvas.ClipY/4,Canvas.ClipX/2,Canvas.ClipY/2,self, Location+(PortalOffset>>(Rotation+rdif)), (Rotation+rdif), 100);
	   if(bGEPjit)
		 Canvas.SetPos(Canvas.ClipX/4,Canvas.ClipY/4+7);
			else
				Canvas.SetPos(Canvas.ClipX/4,Canvas.ClipY/4);
		bGEPjit=!bGEPjit;
		Canvas.Style=4;
		Canvas.DrawRect(GEPVid,Canvas.ClipX/2,Canvas.ClipY/2);
		Canvas.Style=1;
		ParticleGenState(fireGen,false);
		ParticleGenState(smokeGen,false);
                ParticleGenState(smokeGen2,false); //CyberP
		ParticleGenState(smokeGen3,false); //CyberP
		ParticleGenState(smokeGen4,false); //CyberP
		bFlipFlopCanvas=false;
	}
}

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();

	if (Role != ROLE_Authority)
	  SpawnRocketEffects();
}

function ParticleGenState(ParticleGenerator pGen,bool bShow)
{
	if(bShow!=pState&&pGen!=none)
	{
	   pState=true;
	   if (!pGen.bSpewing)
	   {
		pGen.bSpewing = true;
	   pGen.proxy.bHidden = false;
	   pGen.LifeSpan = pGen.spewTime;
	   if (pGen.bAmbientSound && (pGen.AmbientSound != None))
		   pGen.SoundVolume = 255;
		}
	} else
	{
	   pState=false;
	   if (pGen!=none&&pGen.bSpewing)
	   {
		pGen.bSpewing = False;
		pGen.proxy.bHidden = True;
		if (pGen.bAmbientSound && (pGen.AmbientSound != None))
			pGen.SoundVolume = 0;
		}
	}
}

simulated function SpawnRocketEffects()
{
	fireGen = Spawn(class'ParticleGenerator', Self);
	if (fireGen != None)
	{
	  fireGen.RemoteRole = ROLE_None;
		fireGen.particleTexture = Texture'Effects.Fire.Fireball1';
		fireGen.particleDrawScale = 0.1;
		fireGen.checkTime = 0.01;
		fireGen.riseRate = 0; //was 0
		fireGen.ejectSpeed = 0; //Was 0
		fireGen.particleLifeSpan = 0.1;
		fireGen.bRandomEject = True;
		fireGen.SetBase(Self);
	}
	smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
	  smokeGen.RemoteRole = ROLE_None;
		smokeGen.particleTexture = Texture'GMDXSFX.Effects.ef_ExpSmoke001';//Texture'Effects.Smoke.SmokePuff1';
		smokeGen.particleDrawScale = 0.12;  //0.3
		smokeGen.checkTime = 0.02; //CyberP: 0.02
		smokeGen.riseRate = 8.0;
		smokeGen.ejectSpeed = 0.0;
		smokeGen.particleLifeSpan = 1.5; //was 2.0
		smokeGen.bRandomEject = True;
		smokeGen.SetBase(Self);
	}
	smokeGen2 = Spawn(class'ParticleGenerator', Self); //CyberP Start
	if (smokeGen2 != None)
	{
	  smokeGen2.RemoteRole = ROLE_None;
		smokeGen2.particleTexture = Texture'GMDXSFX.Effects.ef_ExpSmoke002';//Texture'Effects.Smoke.SmokePuff1';
		smokeGen2.particleDrawScale = 0.135; //0.35
		smokeGen2.checkTime = 0.01; //CyberP: 0.02
		smokeGen2.riseRate = 8.0;
		smokeGen2.ejectSpeed = 20.0; //0
		smokeGen2.particleLifeSpan = 1.5;
		smokeGen2.bRandomEject = True;
		smokeGen2.SetBase(Self);
	}                                                 //cyberP End
	smokeGen3 = Spawn(class'ParticleGenerator', Self); //CyberP Start
	if (smokeGen3 != None)
	{
	  smokeGen3.RemoteRole = ROLE_None;
		smokeGen3.particleTexture = Texture'GMDXSFX.Effects.ef_ExpSmoke003';//Texture'Effects.Smoke.SmokePuff1';
		smokeGen3.particleDrawScale = 0.15; //0.3
		smokeGen3.checkTime = 0.02; //CyberP: 0.02
		smokeGen3.riseRate = 8.0;
		smokeGen3.ejectSpeed = 40.0; //0
		smokeGen3.particleLifeSpan = 1.5;
		smokeGen3.bRandomEject = True;
		smokeGen3.SetBase(Self);
	}                                                 //cyberP End
        smokeGen4 = Spawn(class'ParticleGenerator', Self); //CyberP Start
	if (smokeGen4 != None)
	{
	  smokeGen4.RemoteRole = ROLE_None;
		smokeGen4.particleTexture = Texture'GMDXSFX.Effects.ef_ExpSmoke004';//Texture'Effects.Smoke.SmokePuff1';
		smokeGen4.particleDrawScale = 0.16; //0.3
		smokeGen4.checkTime = 0.01; //CyberP: 0.02
		smokeGen4.riseRate = 8.0;
		smokeGen4.ejectSpeed = 60.0; //0
		smokeGen4.particleLifeSpan = 1.6;
		smokeGen4.bRandomEject = True;
		smokeGen4.SetBase(Self);
	}                                                 //cyberP End
}

simulated function Destroyed()
{
    local SmokeTrail puff;
    local rotator rot;
    //local ParticleGenerator gen;            //CyberP: I need to check for a wall or decal

    rot.Pitch = 16384 + FRand() * 16384 - 8192;
	rot.Yaw = FRand() * 65536;
	rot.Roll = 0;

   /* gen = spawn(class'ParticleGenerator',,,, rot);
		if (gen != None)
		{
			gen.LifeSpan = FRand() * 10 + 10;
			gen.CheckTime = 0.25;
			gen.particleDrawScale = 0.4;                        //CyberP: I need to check for a wall or decal
			gen.RiseRate = 20.0;
			gen.bRandomEject = True;
			gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		}
     */
	if (smokeGen != None)
		smokeGen.DelayedDestroy();
        if (smokeGen2 != None)
		smokeGen2.DelayedDestroy(); //CyberP
	if (smokeGen3 != None)
		smokeGen3.DelayedDestroy(); //CyberP
	if (smokeGen4 != None)
		smokeGen4.DelayedDestroy(); //CyberP
	if (fireGen != None)
		fireGen.DelayedDestroy();

        spawn(class'RockchipLarge');
        spawn(class'RockchipLarge');

		puff = spawn(class'SmokeTrail');
				if (puff != None)
				{
					  //CyberP: smoke effects for rockets too
					puff.RiseRate = FRand() + 1;
					puff.DrawScale = FRand() + 2.2;
					puff.OrigScale = puff.DrawScale;
					puff.LifeSpan = FRand() * 3 + 1;
					puff.OrigLifeSpan = puff.LifeSpan;
				}

	if ((Owner.IsA('DeusExPlayer'))&&(bGEPInFlight))
	{
		DeusExPlayer(Owner).bGEPprojectileInflight=false;
		DeusExPlayer(Owner).aGEPProjectile=none;
		if (DeusExPlayer(Owner).InHand.IsA('WeaponGEPGun'))
		{
            if (DeusExPlayer(Owner).bAutoReload && DeusExWeapon(DeusExPlayer(Owner).InHand).ClipCount == 0) //SARGE: Added clipcount check
            {
                DeusExWeapon(DeusExPlayer(Owner).InHand).ReloadAmmo();
                if (DeusExWeapon(DeusExPlayer(Owner).InHand).bZoomed)
                    DeusExWeapon(DeusExPlayer(Owner).InHand).ScopeOff();
            }
        }
	}
	Super.Destroyed();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( ( Level.NetMode != NM_Standalone ) && (Class == Class'Rocket') )
	{
		blastRadius = mpBlastRadius;
	  speed = 2000.0000;
	  SetTimer(5,false);
		SoundRadius = 64;
	}

}

simulated function Timer()
{
	if (Level.NetMode != NM_Standalone)
	{
	  Explode(Location, vect(0,0,1));
	}
	//FuelLeft=Fmax(0,FuelLeft-0.1);

}
//RotationRate=(Pitch=32768,Yaw=32768)

//speed=1000.000000
//MaxSpeed=1500.000000

defaultproperties
{
     mpBlastRadius=192.000000
     PortalOffset=(X=-1.650000,Z=-2.950000)
     GEPvid=Texture'GMDXUI.Skins.GEPOverlayDiamond'
     throttle=1.010000
     FuelLeft=240.000000
     bExplodes=True
     bBlood=True
     bDebris=True
     blastRadius=288.000000
     DamageType=exploded
     AccurateRange=14400
     maxRange=24000
     bTracking=True
     ItemName="GEP Rocket"
     ItemArticle="a"
     HDTPMesh="HDTPItems.HDTPRocket"
     Mesh=LodMesh'DeusExItems.Rocket'
     hdtpReference=Class'DeusEx.WeaponGEPGun'
     speed=1300.000000
     Damage=200.000000
     MomentumTransfer=10000
     SpawnSound=Sound'DeusExSounds.Weapons.GEPGunFire'
     ImpactSound=Sound'DeusExSounds.Generic.MediumExplosion2'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     DrawScale=0.250000
     SoundRadius=224
     SoundVolume=192
     AmbientSound=Sound'DeusExSounds.Special.RocketLoop'
     CollisionRadius=0.200000
     CollisionHeight=0.200000
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=128
     LightHue=40
     LightSaturation=192
     LightRadius=24
     RotationRate=(Pitch=1024,Yaw=1024)
}
