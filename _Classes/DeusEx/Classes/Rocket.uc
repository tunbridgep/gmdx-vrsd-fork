//=============================================================================
// Rocket.
//=============================================================================
class Rocket extends DeusExProjectile;

var float mpBlastRadius;
var ParticleGenerator fireGen;
var ParticleGenerator smokeGen;
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
var DeusExPlayer player;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Level.NetMode == NM_DedicatedServer)
		return;

	if (default.ItemName == "GEP Rocket" && if (player != None && player.PerkManager.GetPerkWithClass(class'DeusEx.PerkHERocket').bPerkObtained)
		blastRadius=576.000000;

	OldRotation = Rotation;
	SpawnRocketEffects();

}

//GMDX: based on skill, laser = wire guided, scope=POV
//just incase its spawned and postbeginplay already completed before my inits are done!
function PostSpawnInit()
{
	local float skillMod;

	if(player != None)
	{
		if ((player.SkillSystem != None) && ( bTracking || player.bGEPprojectileInflight))
		{
			skillMod = player.SkillSystem.GetSkillLevel(class'SkillWeaponHeavy');
			skillMod += 1.5;
			RotationRate.Pitch = 4096+(skillMod*4000.0); //CyberP: both were 5000
			RotationRate.Yaw = 4096+(skillMod*4000.0); //2048
			bRenderOverlay = player.bGEPprojectileInflight;
			bGEPInFlight=true;

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
   if (FuelLeft > 0)
      return Throttle;
  
   return 0.95; //need to use dttime, how?
}

function RenderPortal(canvas Canvas)
{
	local Actor actnul;
	local rotator rdif;
	
	if (bRenderOverlay && !bFlipFlopCanvas)//stop self sustain
	{
		bFlipFlopCanvas = true;
		rdif = Rotation-OldRotation;

		if (MaxSpeed == 2100.000000)
			rdif.Roll=rdif.Roll+(Frand()*2)-1;

		rdif.Roll=FMin(300,rdif.Roll);
		rdif.Roll=FMax(-300,rdif.Roll);
		OldRotation = Rotation;

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
		bFlipFlopCanvas = false;
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
	if(bShow != pState && pGen != None)
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
	} 
	else
	{
	   pState=false;
	   if (pGen != None && pGen.bSpewing)
	   {
			pGen.bSpewing = false;
			pGen.proxy.bHidden = true;
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
		fireGen.particleDrawScale = 0.09;
		fireGen.checkTime = 0.009;
		fireGen.riseRate = 0; //was 0
		fireGen.ejectSpeed = 0; //Was 0
		fireGen.particleLifeSpan = 0.1;
		fireGen.bRandomEject = true;
		fireGen.SetBase(Self);
	}

	smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
		smokeGen.RemoteRole = ROLE_None;
		smokeGen.particleTexture = Texture'GMDXSFX.Effects.ef_ExpSmoke002';
		smokeGen.particleDrawScale = 0.16;  //0.3
		smokeGen.checkTime = 0.01; //CyberP: 0.02
		smokeGen.riseRate = 8.0;
		smokeGen.ejectSpeed = 20.0;
		smokeGen.particleLifeSpan = 2.0; //was 2.0
		smokeGen.bRandomEject = true;
		smokeGen.SetBase(Self);
	}
}

simulated function Destroyed()
{
    local SmokeTrail puff;
    local rotator rot;

    rot.Pitch = 16384 + FRand() * 16384 - 8192;
	rot.Yaw = FRand() * 65536;
	rot.Roll = 0;

	if (fireGen != None)
		fireGen.DelayedDestroy();

	if (smokeGen != None)
		smokeGen.DelayedDestroy();

	Spawn(class'RockchipLarge');
	puff = Spawn(class'SmokeTrail');
	if (puff != None)
	{
		  //CyberP: smoke effects for rockets too
		puff.RiseRate = FRand() + 1;
		puff.DrawScale = FRand() + 2.0;
		puff.OrigScale = puff.DrawScale-0.5;
		puff.LifeSpan = FRand() * 3 + 1;
		puff.OrigLifeSpan = puff.LifeSpan;
	}

	if ( player != None && (bGEPInFlight))
	{
		player.bGEPprojectileInflight = false;
		player.aGEPProjectile = None;
		if (player.InHand.IsA('WeaponGEPGun') && DeusExWeapon(player.InHand).bZoomed && player.bAutoReload)
		{
			DeusExWeapon(player.InHand).ScopeOff();
			DeusExWeapon(player.InHand).ReloadAmmo();
		}
	}
	
	Super.Destroyed();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if (Owner != None && Owner.IsA('DeusExPlayer'))
		player = DeusExPlayer(Owner);

	if ( ( Level.NetMode != NM_Standalone ) && (class == class'Rocket') )
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
	  Explode(Location, vect(0,0,1));
}

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
