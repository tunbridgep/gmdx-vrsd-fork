//=============================================================================
// Barrel1.
//=============================================================================
class Barrel1 extends Containers;

#exec OBJ LOAD FILE=Ambient

enum ESkinColor
{
	SC_Biohazard,
	SC_Blue,
	SC_Brown,
	SC_Rusty,
	SC_Explosive,
	SC_FlammableLiquid,
	SC_FlammableSolid,
	SC_Poison,
	SC_RadioActive,
	SC_Wood,
	SC_Yellow
};

var() travel ESkinColor SkinColor;
var() bool bPreDamage;
var bool bLeaking;
var float radTimer;

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
    SetSkin();
}

function SetSkin()
{
    local string oldSkin;
    local string newSkin;
	switch (SkinColor)
    {
        case SC_Biohazard:			oldSkin = "DeusExDeco.Skins.Barrel1Tex1";
                                    newSkin = "HDTPDecos.Skins.HDTPBarrel1Tex1";
                                    break;
		case SC_Blue:				oldSkin = "DeusExDeco.Skins.Barrel1Tex2";
                                    newSkin = "HDTPDecos.Skins.HDTPBarrel1Tex2";
                                    break;
		case SC_Brown:				oldSkin = "DeusExDeco.Skins.Barrel1Tex3";
                                    newSkin = "HDTPDecos.Skins.HDTPBarrel1Tex3";
                                    break;
		case SC_Rusty:				oldSkin = "DeusExDeco.Skins.Barrel1Tex4";
                                    newSkin = "HDTPDecos.Skins.HDTPBarrel1Tex4";
                                    break;
		case SC_Explosive:			oldSkin = "DeusExDeco.Skins.Barrel1Tex5";
                                    newSkin = "HDTPDecos.Skins.HDTPBarrel1Tex5";
                                    break;
		case SC_FlammableLiquid:	oldSkin = "DeusExDeco.Skins.Barrel1Tex6";
                                    newSkin = "HDTPDecos.Skins.HDTPBarrel1Tex6";
                                    break;
        case SC_FlammableSolid:     oldSkin = "DeusExDeco.Skins.Barrel1Tex7";
                                    newSkin = "HDTPDecos.Skins.HDTPBarrel1Tex7";
                                    break;
		case SC_Poison:				oldSkin = "DeusExDeco.Skins.Barrel1Tex8";
                                    newSkin = "HDTPDecos.Skins.HDTPBarrel1Tex8";
									break;
		case SC_RadioActive:		oldSkin = "DeusExDeco.Skins.Barrel1Tex9";
                                    newSkin = "HDTPDecos.Skins.HDTPBarrel1Tex9";
									break;
		case SC_Wood:				oldSkin = "DeusExDeco.Skins.Barrel1Tex10";
                                    newSkin = "HDTPDecos.Skins.HDTPBarrel1Tex10";
									break;
		case SC_Yellow:				oldSkin = "DeusExDeco.Skins.Barrel1Tex11";
                                    newSkin = "HDTPDecos.Skins.HDTPBarrel1Tex11";
    }

    Skin = class'HDTPLoader'.static.GetTexture2(newSkin,oldSkin,IsHDTP());
}

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Biohazard:			
									HitPoints = 25;
									break;
		case SC_Blue:				
                                    minDamageThreshold=20;
                                    HitPoints = 50;
                                    break;
		case SC_Brown:				
		                            minDamageThreshold=20;
		                            HitPoints = 50;
		                            break;
		case SC_Rusty:				
		                            minDamageThreshold=16;
		                            HitPoints = 50;
		                            break;
		case SC_Explosive:			
									bExplosive = True;
									explosionDamage = 400;
									explosionRadius = 608;
									HitPoints = 5;
									minDamageThreshold=4;
									break;
		case SC_FlammableLiquid:	
									bExplosive = True;
									explosionRadius = 320;
									HitPoints = 5;
									minDamageThreshold=3;
									break;
		case SC_FlammableSolid:		
									bExplosive = True;
									explosionDamage = 200;
									explosionRadius = 416;
									minDamageThreshold=3;
									HitPoints = 20;
									break;
		case SC_Poison:				
									HitPoints = 25;
									break;
		case SC_RadioActive:		
									bInvincible = False;
									HitPoints = 60;
									minDamageThreshold=80;
									LightType = LT_Steady;
									LightRadius = 8;
									LightBrightness = 128;
									LightHue = 64;
									LightSaturation = 96;
									AmbientSound = sound'GeigerLoop';
									SoundRadius = 8;
									SoundVolume = 255;
									bUnlit = True;
									ScaleGlow = 0.4;
									break;
		case SC_Wood:				
                                    FragType = Class'DeusEx.WoodFragment'; //CyberP
                                    break;
		case SC_Yellow:				
                                    minDamageThreshold=20;
                                    HitPoints = 50;
		                            break;
	}
}

function PostPostBeginPlay()
{
	Super.PostPostBeginPlay();

	if (bPreDamage)
		TakeDamage(1, None, Location, vect(0,0,0), 'shot');
}

function StupidBugfix()
{
	switch (SkinColor)
	{
		case SC_Biohazard:			
									HitPoints = 25;
									break;
		case SC_Blue:				
                                    minDamageThreshold=20;
                                    HitPoints = 50;
                                    break;
		case SC_Brown:				
		                            minDamageThreshold=20;
		                            HitPoints = 50;
		                            break;
		case SC_Rusty:				
		                            minDamageThreshold=16;
		                            HitPoints = 50;
		                            break;
		case SC_Explosive:			
									bExplosive = True;
									explosionDamage = 400;
									explosionRadius = 608;
									HitPoints = 5;
									minDamageThreshold=4;
									break;
		case SC_FlammableLiquid:	
									bExplosive = True;
									explosionRadius = 320;
									HitPoints = 5;
									minDamageThreshold=3;
									break;
		case SC_FlammableSolid:		
									bExplosive = True;
									explosionDamage = 200;
									explosionRadius = 416;
									minDamageThreshold=3;
									HitPoints = 20;
									break;
		case SC_Poison:				
									HitPoints = 25;
									break;
		case SC_RadioActive:		
									bInvincible = True;
									LightType = LT_Steady;
									LightRadius = 8;
									LightBrightness = 128;
									LightHue = 64;
									LightSaturation = 96;
									AmbientSound = sound'GeigerLoop';
									SoundRadius = 8;
									SoundVolume = 255;
									bUnlit = True;
									ScaleGlow = 0.4;
									break;
		case SC_Wood:				
                                    FragType = Class'DeusEx.WoodFragment'; //CyberP
                                    break;
		case SC_Yellow:				
                                    minDamageThreshold=20;
                                    HitPoints = 50;
		                            break;
	}

    UpdateHDTPsettings();
}


auto state Active
{
	function Tick(float deltaTime)
	{
		local Actor A;
		local Vector offset;

		Super.Tick(deltaTime);

		if (SkinColor == SC_RadioActive)
		{
			radTimer += deltaTime;

			if (radTimer > 1.0)
			{
				radTimer = 0;

				// check to see if anything has entered our effect radius
				foreach VisibleActors(class'Actor', A, 128.0)
					if (A != None)
					{
						// be sure to damage the torso
						offset = A.Location;
						A.TakeDamage(5, None, offset, vect(0,0,0), 'Radiation');
					}
			}
		}
	}

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
	{
		local ParticleGenerator gen;
		local ProjectileGenerator projgen;
		local float size;
		local Vector loc;
		local Actor A;
		local SmokeTrail puff;
		local PoisonGas gas;
		local int i;

		if (bStatic || bInvincible)
			return;

		if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'HalonGas'))
			return;

		if ((damageType == 'EMP') || (damageType == 'NanoVirus') || (damageType == 'Radiation'))
			return;

		if (Damage >= minDamageThreshold)
		{
			if (HitPoints-Damage <= 0)
			{
				foreach BasedActors(class'Actor', A)
				{
					if (A.IsA('ParticleGenerator'))
						ParticleGenerator(A).DelayedDestroy();
					else if (A.IsA('ProjectileGenerator'))
						A.Destroy();
				}

				// spread out a gas cloud
				for (i=0; i<explosionRadius/36; i++)
				{
					loc = Location;
					loc.X += FRand() * explosionRadius - explosionRadius * 0.5;
					loc.Y += FRand() * explosionRadius - explosionRadius * 0.5;

					if ((SkinColor == SC_Explosive) || (SkinColor == SC_FlammableLiquid) ||
						(SkinColor == SC_FlammableSolid))
					{
						puff = spawn(class'SmokeTrail',,, loc);
						if (puff != None)
						{
							puff.RiseRate = FRand() + 1;
							puff.DrawScale = FRand() + 3.0;
							puff.OrigScale = puff.DrawScale;
							puff.LifeSpan = FRand() * 10 + 10;
							puff.OrigLifeSpan = puff.LifeSpan;
						}
					}
					else if ((SkinColor == SC_Biohazard) || (SkinColor == SC_Poison))
					{
						loc.Z += 32;
						gas = spawn(class'PoisonGas', None,, loc);
						if (gas != None)
						{
							gas.Velocity = vect(0,0,0);
							gas.Acceleration = vect(0,0,0);
							gas.DrawScale = FRand() * 0.5 + 2.0;
							gas.LifeSpan = FRand() * 10 + 30;
							gas.bFloating = True;
							gas.Instigator = Instigator;
						}
					}
				}
			}

			if (!bLeaking)
			{
				// spawn a projectile generator for toxic gas leaks
				if (((SkinColor == SC_Biohazard) || (SkinColor == SC_Poison)) &&
					(HitPoints-Damage > 0))
				{
					size = CollisionRadius / 54.0;
					size = FClamp(size, 0.1, 4.0);

					loc.X = 0;
					loc.Y = 0;
					loc.Z = CollisionHeight;
					loc += Location;

					projgen = Spawn(class'ProjectileGenerator', Self,, loc, rot(16384,0,0));
					if (projgen != None)
					{
						bLeaking = True;
						projgen.ProjectileClass = class'PoisonGas';
						projgen.ProjectileLifeSpan = 3.0;
						projgen.frequency = 0.9;
						projgen.checkTime = 0.5;
						projgen.ejectSpeed = 50.0;
						projgen.bRandomEject = True;
						projgen.SetBase(Self);
					}

					// play a hissing sound
					if (AmbientSound == None)
					{
						AmbientSound = Sound'SteamVent2';
						SoundRadius = 64 * size;
						SoundVolume = 192;
					}
				}

				// spawn a smoke generator if a flammable solid barrel is damaged
				if (((SkinColor == SC_Explosive) || (SkinColor == SC_FlammableLiquid) ||
					 (SkinColor == SC_FlammableSolid)) && (HitPoints-Damage > 0))
				{
					size = CollisionRadius / 54.0;
					size = FClamp(size, 0.1, 4.0);

					loc.X = 0;
					loc.Y = 0;
					loc.Z = CollisionHeight;
					loc += Location;

					gen = Spawn(class'ParticleGenerator', Self,, loc, rot(16384,0,0));
					if (gen != None)
					{
						bLeaking = True;
						gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
						gen.particleDrawScale = size * 4.0;
						gen.frequency = 0.9;
						gen.checkTime = 0.1;
						gen.riseRate = 90.0;
						gen.ejectSpeed = 40.0;
						gen.bRandomEject = True;
						gen.SetBase(Self);
					}

					// play a hissing sound
					if (AmbientSound == None)
					{
						AmbientSound = Sound'SteamVent2';
						SoundRadius = 64 * size;
						SoundVolume = 192;
					}
				}
			}
		}

		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}
}

defaultproperties
{
     SkinColor=SC_Rusty
     HitPoints=31
     ItemName="Barrel"
     bBlockSight=True
     Mesh=LodMesh'DeusExDeco.Barrel1'
     HDTPMesh="HDTPDecos.HDTPbarrel1"
     CollisionRadius=20.000000
     CollisionHeight=29.000000
     Mass=80.000000
     Buoyancy=90.000000
	 bHDTPFailsafe=False
}
