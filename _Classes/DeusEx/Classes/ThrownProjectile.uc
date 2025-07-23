//=============================================================================
// ThrownProjectile.
//=============================================================================
class ThrownProjectile extends DeusExProjectile
	abstract;

var() float				Elasticity;
var() float				fuseLength;
var() class<Fragment>	FragmentClass;
var() bool				bProximityTriggered;
var() float				proxRadius;
var() bool				bArmed;
var bool				bFirstHit;
var float				proxCheckTime;
var float				beepTime;
var float				skillTime;
var float				skillAtSet;
var() bool				bDisabled;
var() bool				bHighlight;			// should this object not highlight when focused?
var() float				AISoundLevel;		// sound level at which to alert AI (0.0 to 1.0)
var() bool           bDamaged;         // was this blown up via damage?

var	bool				bDoExplode;		// Used for communication into a simulated chain
var	int				team;				// Keep track of team of owner

var() bool          bNoHardcoreFilter;
var bool            bRadiusSet;

var travel bool bEUASDetected;              //SARGE: Set to true when this explosive is detected on the EUAS augmentation.

var bool            bEMPDisabled;             //SARGE: When disabled by EMP, permanently prevent it from being re-armed

var int             rearmSkillRequired;      //SARGE: Demolitions Skill required to rearm this explosive after disarming it. Only used by Proximity Triggered Grenades.
var const localized string disabledText;
var const localized string msgCannotRearm;        //SARGE: When we try to frob a disarmed grenades but our skill is not enough

replication
{
	reliable if ( Role == ROLE_Authority )
		bDoExplode, team, bDisabled, skillAtSet;
}

//
// The player won't hear these unless their outisde the simulated function
//
function PlayBeepSound( float Range, float Pitch, float volume )
{
	if ( Level.NetMode != NM_Standalone )
		PlaySound( sound'Beep4',SLOT_None, volume,, Range, Pitch );
	else
		PlaySound( sound'Beep4',SLOT_None,,, Range, Pitch );
}

singular function SupportActor(Actor standingActor)
{
	// CyberP: no lam/grenade climbing exploit on hardcore
	if (standingActor != None && standingActor.Velocity.Z < -150 && bProximityTriggered)
		{
         if (standingActor.IsA('DeusExPlayer') && DeusExPlayer(standingActor).bHardCoreMode)
         {
           bDoExplode = True;
		   bArmed = False;
         }
		}
}

simulated function Tick(float deltaTime)
{
	local ScriptedPawn P;
	local DeusExPlayer Player;
	local Vector dist, HitLocation, HitNormal;
	local float blinkRate, mult, skillDiff;
	local float proxRelevance;
	local Pawn curPawn;
	local bool pass;
	local Actor HitActor;
	local int itmp;
    local int itmp2;
    local DeusExPlayer playa;
    local float difficultyMod;
    local Perk lightFoot;
    local float proxRadiusModified;

	time += deltaTime;
	Player = DeusExPlayer(Owner);

    if (player != none)
    {
    itmp = Player.SkillSystem.GetSkillLevel(class'SkillDemolition');
		    if (itmp<=1)
		    blastRadius=384.000000;
		    else if (itmp<=2)
			blastRadius=512.000000;
			else if (itmp<=3)
			blastRadius=756.000000;
			else if (itmp<=4)
			blastRadius=1024.000000;
			else
			blastRadius=384.000000;

			if (DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkKnockoutGas').bPerkObtained == true && IsA('GasGrenade'))
		       Damage=260.000000;
    }

	if ( Role == ROLE_Authority )
	{
		Super.Tick(deltaTime);

		if (bDisabled)
			return;

		if ( (Owner == None) && ((Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer)) )
		{
			// Owner has logged out
			bDisabled = True;
			team = -1;
		}


		if (( Owner != None ) && (DeusExPlayer(Owner) != None ))
		{
			if ( TeamDMGame(DeusExPlayer(Owner).DXGame) != None )
			{
				// If they switched sides disable the grenade
				if ( DeusExPlayer(Owner).PlayerReplicationInfo.team != team )
				{
					bDisabled = True;
					team = -1;
				}
			}
		}


		// check for proximity
		if (bProximityTriggered)
		{
		playa = DeusExPlayer(GetPlayerPawn());
		if (!bDisabled && Owner == None)
		{
		if (playa != None && playa.PerkManager.GetPerkWithClass(class'DeusEx.PerkSonicTransducerSensor').bPerkObtained == true)
		{
		AmbientSound=sound'LAMAmbient';
		SoundRadius=26;
		SoundVolume=192;
		}
		}
			if (bArmed)
			{
				proxCheckTime += deltaTime;

				// beep based on skill
				if (skillTime != 0)
				{
					if (time > fuseLength)
					{
						if (skillTime % 0.3 > 0.25)
						{
							PlayBeepSound( 1280, 2.0, 3.0 );
							AmbientSound=None;
						}
					}
				}

				// if we have been triggered, count down based on skill
				if (skillTime > 0)
					skillTime -= deltaTime;

				// explode if time < 0
				if (skillTime < 0)
				{
					bDoExplode = True;
					bArmed = False;
				}
				// DC - new ugly way of doing it - old way was "if (proxCheckTime > 0.25)"
				// new way: weight the check frequency based on distance from player
				proxRelevance=DistanceFromPlayer/2000.0;  // at 500 units it behaves as it did before
				if (proxRelevance<0.25)
					proxRelevance=0.25;               // low bound 1/4
				else if (proxRelevance>10.0)
					proxRelevance=20.0;               // high bound 30
				else
					proxRelevance=proxRelevance*2;    // out past 1.0s, double the timing
				if (proxCheckTime>proxRelevance)
				{
					proxCheckTime = 0;

					// pre-placed explosives are only prox triggered by the player
					if (Owner == None)
					{
                        //Fix bug with pre-placed grenades not opening
                        if (HasAnim('Open'))
                            PlayAnim('Open');
						blastRadius=512.000000;
						foreach RadiusActors(class'DeusExPlayer', Player, proxRadius*4)
						{
							// the owner won't set it off, either
							if (Player != Owner)
							{
								dist = Player.Location - Location;
                                if (!player.bHardcoreMode)
								//if (playa.CombatDifficulty < 2)  //CyberP: mines are easy on easy & medium difficulty.
								    difficultyMod = 2.0;
								else
                                    difficultyMod = 1.0;

                                proxRadiusModified = proxRadius*1.0;
                                /*
                                //SARGE: Reduce detection distance based on Demolitions skill
                                itmp = Player.SkillSystem.GetSkillLevel(class'SkillDemolition');
                                switch (itmp) //GMDX now pick what u want
                                {
                                    case 0:proxRadiusModified=proxRadius*1.0;break;
                                    case 1:proxRadiusModified=proxRadius*0.85;break;
                                    case 2:proxRadiusModified=proxRadius*0.7;break;
                                    case 3:proxRadiusModified=proxRadius*0.65;break;
                                }
                                */
								if (VSize(dist) < proxRadiusModified)
									if (skillTime == 0)
									{
										//SARGE: No more variable timers. We will balance Demolitions in other ways instead.
										//skillTime=0.6*difficultyMod;
										itmp = Player.SkillSystem.GetSkillLevel(class'SkillDemolition');
									    switch (itmp) //GMDX now pick what u want
									    {
                                            //SARGE: Was 0.5, 1.0, 2.5, 7.0
											case 0:skillTime=0.5*difficultyMod;blastRadius=512.000000;break;
											case 1:skillTime=1.0*difficultyMod;blastRadius=512.000000;break;
											case 2:skillTime=1.75*difficultyMod;blastRadius=512.000000;break;
											case 3:skillTime=3.0*difficultyMod;blastRadius=512.000000;break;
										}
										//skillTime = FClamp(-20.0 * Player.SkillSystem.GetSkillLevelValue(class'SkillDemolition'), 1.0, 10.0);
									}
							}
						}
					}
					else
					{
						// If in multiplayer, check other players
						if (( Level.NetMode == NM_DedicatedServer) || ( Level.NetMode == NM_ListenServer))
						{
							curPawn = Level.PawnList;

							while ( curPawn != None )
							{
								pass = False;

								if ( curPawn.IsA('DeusExPlayer') )
								{
									Player = DeusExPlayer( curPawn );

									// Pass on owner
									if ( Player == Owner )
										pass = True;
									// Pass on team member
									else if ( (TeamDMGame(Player.DXGame) != None) && (team == player.PlayerReplicationInfo.team) )
										pass = True;
									// Pass if radar transparency on
									else if ( Player.AugmentationSystem.GetClassLevel( class'AugRadarTrans' ) == 3 )
										pass = True;

									// Finally, make sure we can see them (no exploding through thin walls)
									if ( !pass )
									{
										// Only players we can see : changed this to Trace from FastTrace so doors are included
										HitActor = Trace( HitLocation, HitNormal, Player.Location, Location, True );
										if (( HitActor == None ) || (DeusExPlayer(HitActor) == Player))
										{
										}
										else
											pass = True;
									}

									if ( !pass )
									{
										dist = Player.Location - Location;
										if ( VSize(dist) < proxRadius )
										{
											if (skillTime == 0)
											{
												skillDiff = -skillAtSet + Player.SkillSystem.GetSkillLevelValue(class'SkillDemolition');
												if ( skillDiff >= 0.0 ) // Scale goes 1.0, 1.6, 2.8, 4.0
													skillTime = FClamp( 1.0 + skillDiff * 6.0, 1.0, 2.5 );
												else	// Scale goes 1.0, 1.4, 2.2, 3.0
													skillTime = FClamp( 1.0	+ (-Player.SkillSystem.GetSkillLevelValue(class'SkillDemolition') * 4.0), 1.0, 3.0 );
											}
										}
									}
								}
								curPawn = curPawn.nextPawn;
							}
						}
						else	// Only have scripted pawns set off promixity grenades in single player
						{
							foreach RadiusActors(class'ScriptedPawn', P, proxRadius*4)
							{
								// only "heavy" pawns will set this off
								if ((P != None) && (P.Mass >= 40))
								{
									// the owner won't set it off, either
									if (P != Owner)
									{
										dist = P.Location - Location;
										if (VSize(dist) < proxRadius)
											if (skillTime == 0)
												skillTime = 1.0;
									}
								}
							}
						}
					}
				}
			}
		}

		// beep faster as the time expires
		beepTime += deltaTime;

		if (fuseLength - time <= 0.75)
			blinkRate = 0.1;
		else if (fuseLength - time <= fuseLength * 0.5)
			blinkRate = 0.3;
		else
			blinkRate = 0.5;

		if (time < fuseLength && !IsA('SpiderBotConstructorGrenade'))
		{
			if (beepTime > blinkRate)
			{
				beepTime = 0;
				PlayBeepSound( 1280, 1.0, 0.5 );
			}
		}
	}
	if ( bDoExplode )	// Keep the simulated chain going
		Explode(Location, Vector(Rotation));
}

function ReEnable()
{
	bDisabled = False;
}

function Frob(Actor Frobber, Inventory frobWith)
{
    local int skill;
    local DeusExPlayer Player;

    Player = DeusExPlayer(Frobber);

    //Can no longer re-use grenades damaged by EMP.
    if (bEMPDisabled)
    {
        player.ClientMessage(disabledText);
        return;
    }
        

    skill = Player.SkillSystem.GetSkillLevel(class'SkillDemolition');

	// if the player frobs it and it's disabled, the player can grab it
	if (bDisabled)
    {
        //SARGE: Cannot pick up grenades if we lack the skill
        if (skill < rearmSkillRequired && Owner != Player)
            Player.ClientMessage(sprintf(msgCannotRearm,itemName));
        else
            Super.Frob(Frobber, frobWith);
    }
	else if (bProximityTriggered && bArmed && (skillTime >= 0))
	{
        PlaySound(sound'Beep4',SLOT_None,,, 1280, 0.5);
        bDisabled = True;
        AmbientSound = None;

        //SARGE: If the player lacks the skills to properly disarm it, disable it completely.
        //if (skill < rearmSkillRequired && Owner != Player)
        //    bEMPDisabled = true;
	}
}

simulated function Timer()
{
	if ( Role == ROLE_Authority )
	{
		if (bProximityTriggered)
			bArmed = True;
		else
		{
			if ( !bDisabled )
				bDoExplode = True;
		}
	}
	if ( bDoExplode )
			Explode(Location, Vector(Rotation));
}

simulated function TakeDamage(int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name damageType)
{
	local ParticleGenerator gen;
	local Vector loc;

	if ((DamageType == 'TearGas') || (DamageType == 'PoisonGas') || (DamageType == 'Radiation'))
		return;

	if (DamageType == 'NanoVirus')
		return;

	if ( Role == ROLE_Authority )
	{
		// EMP damage disables explosives
		if (DamageType == 'EMP')
		{
			if (!bDisabled)
			{
				PlaySound(sound'EMPZap', SLOT_None,,, 1280);
				bDisabled = True;
                bEMPDisabled = True;
                loc = Location;
                loc.z += CollisionHeight/2;
				gen = Spawn(class'ParticleGenerator', Self,, loc, rot(16384,0,0));
				if (gen != None)
				{
					gen.checkTime = 0.25;
					gen.LifeSpan = 2;
					gen.particleDrawScale = 0.3;
					gen.bRandomEject = True;
					gen.ejectSpeed = 10.0;
					gen.bGravity = False;
					gen.bParticlesUnlit = True;
					gen.frequency = 0.5;
					gen.riseRate = 10.0;
					gen.spawnSound = Sound'Spark2';
					gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
					gen.SetBase(Self);
				}
			}
			return;
		}
		bDamaged = True;
	}
	Explode(Location, Vector(Rotation));
}

//
// SpawnTearGas needs to happen on the server so the clouds are insync and damage is dealt out of them
//
function SpawnTearGas()
{
	local Vector loc;
	local TearGas gas;
	local int i;

	if ( Role < ROLE_Authority )
		return;

	for (i=0; i<blastRadius/34; i++)
	{
		if (FRand() < 0.9)
		{
			loc = Location;
			loc.X += FRand() * blastRadius - blastRadius * 0.5;
			loc.Y += FRand() * blastRadius - blastRadius * 0.5;
			loc.Z += 32;
			gas = spawn(class'TearGas', None,, loc);
			if (gas != None)
			{
			    gas.SpawnSound = None;
				gas.Velocity = vect(0,0,0);
				gas.Acceleration = vect(0,0,0);
				gas.maxDrawScale=1.800000;
				gas.ScaleGlow=0.75;
				gas.DrawScale = FRand() * 0.5 + 2.0;
				gas.LifeSpan = FRand() * 10 + 30;
				if ( Level.NetMode != NM_Standalone )
					gas.bFloating = False;
				else
					gas.bFloating = True;
				gas.Instigator = Instigator;
			}
		}
	}
}

simulated function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other)
{
	local int i;
	local SmokeTrail puff;
	local TearGas gas;
	local Fragment frag;
	local ParticleGenerator gen;
	local ProjectileGenerator projgen;
	local vector loc;
	local rotator rot;
	local ExplosionLight light;
	local DeusExDecal mark;
	local AnimatedSprite expeffect;
	local int itmp;
	local DeusExPlayer Player;

	rot.Pitch = 16384 + FRand() * 16384 - 8192;
	rot.Yaw = FRand() * 65536;
	rot.Roll = 0;

	if ((damageType == 'Exploded') && bStuck)
	{
		gen = spawn(class'ParticleGenerator',,, HitLocation, rot);
		if (gen != None)
		{
		 //DEUS_EX AMSD Don't send this to clients unless really spawned server side.
		 if (bDamaged)
			gen.RemoteRole = ROLE_SimulatedProxy;
		 else
				gen.RemoteRole = ROLE_None;
			gen.LifeSpan = FRand() * 10 + 10;
			gen.CheckTime = 0.25;
			gen.particleDrawScale = 0.4;
			gen.RiseRate = 20.0;
			gen.bRandomEject = True;
			gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		}
	}

	// don't draw damage art on destroyed movers
	if (DeusExMover(Other) != None)
		if (DeusExMover(Other).bDestroyed)
			ExplosionDecal = None;

	if (ExplosionDecal != None)
	{
		mark = DeusExDecal(Spawn(ExplosionDecal, Self,, HitLocation, Rotator(HitNormal)));
		if (mark != None)
		{
			mark.DrawScaleMult = FClamp(damage/28, 0.1, 3.5);
			mark.UpdateHDTPSettings();
		 if (!bDamaged)
			mark.RemoteRole = ROLE_None;
		}
	}

	for (i=0; i<blastRadius/60; i++)
	{
		if (FRand() < 0.8)
		{
			if (bDebris && bStuck)
			{
				frag = spawn(FragmentClass,,, HitLocation);
				if (!bDamaged)
					frag.RemoteRole = ROLE_None;
				if (frag != None)
					frag.CalcVelocity(VRand(), blastRadius);
			}

			loc = Location;
			loc.X += FRand() * blastRadius - blastRadius * 0.5;
			loc.Y += FRand() * blastRadius - blastRadius * 0.5;

			if (damageType == 'Exploded')
			{
				puff = spawn(class'SmokeTrail',,, loc);
				if (puff != None)
				{
					if (!bDamaged)
						puff.RemoteRole = ROLE_None;
					else
						puff.RemoteRole = ROLE_SimulatedProxy;
					puff.RiseRate = FRand() + 1;
					puff.DrawScale = FRand() + 3.0;
					puff.OrigScale = puff.DrawScale;
					puff.LifeSpan = FRand() * 10 + 10;
					puff.OrigLifeSpan = puff.LifeSpan;
				}

				light = Spawn(class'ExplosionLight',,, HitLocation);
				if ((light != None) && (!bDamaged))
					light.RemoteRole = ROLE_None;

				if (itmp > 2)
				{
					expeffect = spawn(class'ExplosionMedium',,, loc);
					light.size = 8;
				}
				else
				{
					expeffect = spawn(class'ExplosionSmall',,, loc);
					light.size = 4;
				}
				if ((expeffect != None) && (!bDamaged))
					expeffect.RemoteRole = ROLE_None;
			}
			else if (damageType == 'EMP')
			{
				light = Spawn(class'ExplosionLight',,, HitLocation);
				if (light != None)
				{
					if (!bDamaged)
						light.RemoteRole = ROLE_None;
					light.size = 6;
					light.LightHue = 170;
					light.LightSaturation = 64;
				}
			}
		}
	}
}

function PlayImpactSound()
{
	PlaySound(ImpactSound, SLOT_None, 2.0,, blastRadius*16);
}

auto simulated state Flying
{
	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local ShockRing ring;
		local DeusExPlayer player;
		local float dist;

		// flash the screen white based on how far away the explosion is
		//		player = DeusExPlayer(GetPlayerPawn());
		//		MBCODE: Reference projectile owner to get player
		//		because sever fails to get it the old way
		player = DeusExPlayer(Owner);
      if (player!=none) //GMDX: fix log error
      {
   		dist = Abs(VSize(player.Location - Location));
        if ((FastTrace(player.Location) && dist < 2048) || dist < 512)
        {
   		// if you are at the same location, blind the player
   		if (dist ~= 0)
   			dist = 10.0;
   		else
   			dist = 2.0 * FClamp(blastRadius/dist, 0.0, 4.0);

   		if (damageType == 'EMP')
   			player.ClientFlash(dist, vect(0,200,1000));
   		else if (damageType == 'TearGas')
   			player.ClientFlash(dist, vect(0,1000,100));
   		else
   			player.ClientFlash(dist, vect(1000,1000,900));
   		}
      }
	  //DEUS_EX AMSD Only do visual effects if client or if destroyed via damage (since the client can't detect that)
	  if ((Level.NetMode != NM_DedicatedServer) || (Role < ROLE_Authority) || bDamaged)
	  {
		 SpawnEffects(HitLocation, HitNormal, None);
		 DrawExplosionEffects(HitLocation, HitNormal);
	  }

		if ((damageType=='KnockedOut') && (Role==ROLE_Authority)) //CyberP: DamageType=='TearGas'
			SpawnTearGas();

		PlayImpactSound();

		if ( AISoundLevel > 0.0 )
        {
            //SARGE: Fix the broken sound propagation
            class'PawnUtils'.static.WakeUpAI(self,blastRadius*10);
			AISendEvent('LoudNoise', EAITYPE_Audio, 2.0, AISoundLevel*blastRadius*10);
        }

		GotoState('Exploding');
	}
	simulated function HitWall (vector HitNormal, actor HitWall)
	{
		local Rotator rot;
		local float   volume;

        if (bContactDetonation && Speed != 0 && !bProximityTriggered)
        Explode(Location,Vector(Rotation));

		Velocity = Elasticity*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		speed = VSize(Velocity);
		if (bFirstHit && speed<400)
			bFirstHit=False;
		RotationRate = RotRand(True);
		if ( (speed < 60) && (HitNormal.Z > 0.7) )
		{
			volume = 0.5+FRand()*0.5;
			PlaySound(MiscSound, SLOT_None, volume,, 512, 0.85+FRand()*0.3);

			// I know this is a little cheesy, but certain grenade types should
			// not alert AIs unless they are really really close - CNN
			if (AISoundLevel > 0.0)
            {
                class'PawnUtils'.static.WakeUpAI(self, AISoundLevel*256);
				AISendEvent('LoudNoise', EAITYPE_Audio, volume, AISoundLevel*256);
            }
			SetPhysics(PHYS_None, HitWall);
			if (Physics == PHYS_None)
			{
				rot = Rotator(HitNormal);
				rot.Yaw = Rand(65536);
				SetRotation(rot);
				bBounce = False;
				bStuck = True;
			}
		}
		else If (speed > 50)
		{
			PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		}
	}
}

simulated singular function ZoneChange( ZoneInfo NewZone )
{
	local float splashsize;
	local actor splash;

	if ( NewZone.bWaterZone )
	{
		Velocity = 0.2 * Velocity;
		splashSize = 0.0005 * (250 - 0.5 * Velocity.Z);
		if ( Level.NetMode != NM_DedicatedServer )
		{
			if ( NewZone.EntrySound != None )
				PlaySound(NewZone.EntrySound, SLOT_None, splashSize);
			if ( NewZone.EntryActor != None )
			{
				splash = Spawn(NewZone.EntryActor);
				if ( splash != None )
					splash.DrawScale = 4 * splashSize;
			}
		}
		if (bFirstHit)
			bFirstHit=False;

		RotationRate = 0.2 * RotationRate;
	}
}

simulated function BeginPlay()
{
	local DeusExPlayer aplayer;


	Super.BeginPlay();

	Velocity = Speed * Vector(Rotation);
	RotationRate = RotRand(True);
	SetTimer(fuseLength, False);
	SetCollision(True, True, True);



	// What team is the owner if in team game
	if (( Level.NetMode != NM_Standalone ) && (Role == ROLE_Authority))
	{
		aplayer = DeusExPlayer(Owner);
		if ( aplayer != None )
		{
         if ( TeamDMGame(aplayer.DXGame) != None )
			   team = aplayer.PlayerReplicationInfo.team;
		    skillAtSet = aplayer.SkillSystem.GetSkillLevelValue(class'SkillDemolition');
		}
	}

	// don't beep at the start of a level if we've been preplaced
	if (Owner == None)
	{
		time = fuseLength;
		bStuck = True;
	}
}

defaultproperties
{
     elasticity=0.400000
     fuseLength=4.000000
     FragmentClass=Class'DeusEx.Rockchip'
     proxRadius=64.000000
     bFirstHit=True
     bHighlight=True
     AISoundLevel=1.000000
     bExplodes=True
     bBlood=True
     bDebris=True
     blastRadius=416.000000
     DamageType=exploded
     ItemName="ERROR ThrownProjectile Default-Report as bug!"
     ItemArticle="a"
     gravMult=0.500000
     ImpactSound=Sound'DeusExSounds.Generic.LargeExplosion1'
     MiscSound=Sound'DeusExSounds.Generic.MetalBounce1'
     Physics=PHYS_Falling
     CollisionRadius=2.000000
     CollisionHeight=2.000000
     bBounce=True
     bFixedRotationDir=True
     disabledText="The internal circuitry is damaged."
     msgCannotRearm="You lack the skill to rearm the %d"
}
