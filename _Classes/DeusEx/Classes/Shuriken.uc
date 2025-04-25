//=============================================================================
// Shuriken.
//=============================================================================
class Shuriken extends DeusExProjectile;

var float	mpDamage;
var int		mpAccurateRange;
var int		mpMaxRange;
var ParticleGenerator smokeGen;

// set it's rotation correctly
simulated function Tick(float deltaTime)
{
	local Rotator rot;

	if (bStuck)
	{
	if (smokeGen != None)
	{
		smokeGen.DelayedDestroy();
	}
		return;
    }

    if (Velocity == vect(0,0,0))
    {
    if (smokeGen != None)
	{
		smokeGen.DelayedDestroy();
    }
    }

	Super.Tick(deltaTime);

	if (!IsInState('Ricocheted') && bBounce==False)
	{
		rot = Rotation;
		rot.Roll += 16384;
		rot.Pitch -= 16384;
		SetRotation(rot);
	}
}

simulated function Destroyed()
{
if (smokeGen != None)
		smokeGen.DelayedDestroy();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		Damage = mpDamage;
		AccurateRange = mpAccurateRange;
		MaxRange = mpMaxRange;
	}
}

simulated function PostBeginPlay()
{
    local DeusExPlayer player;
    local int skillLevel;

    player = DeusExPlayer(Owner);

    if (Owner != None)
    {
        if (Owner.IsA('ScriptedPawn'))
        {
        speed=1300.000000;
        MaxSpeed=1300.000000;
        }
        //Sarge: If we are a player, throw the knives faster as our skill increases
        else if (player != None)
        {
            skillLevel = player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech');
            if (skillLevel > 0)
            {
                Velocity*=skillLevel;
                speed += 300 * skillLevel;
                MaxSpeed += 300 * skillLevel;
            }
        }
    }

    Super.PostBeginPlay();
    SetTimer(0.08, False);
    PlaySound(sound'CombatKnifeFire',SLOT_None,,,,1.5);
}

function Timer()
{
local DeusExPlayer player;

    player = DeusExPlayer(GetPlayerPawn());

    if (player != none)
    {
	if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkSharpEyed').bPerkObtained == true)
    {
     smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
	  smokeGen.RemoteRole = ROLE_None;
		smokeGen.particleTexture = Texture'DeusExItems.Skins.FlatFXTex46';
		smokeGen.particleDrawScale = 0.07;
		smokeGen.checkTime = 0.03;
		smokeGen.riseRate = 0.0;
		smokeGen.ejectSpeed = 0.0;
		smokeGen.ScaleGlow=0.5;
		smokeGen.particleLifeSpan = 0.5;
		smokeGen.bRandomEject = False;
		smokeGen.SetBase(Self);
	}
	}
   }
}

defaultproperties
{
     mpDamage=17.000000
     mpAccurateRange=840
     mpMaxRange=640
     bBlood=True
     bStickToWall=True
     blastRadius=32.000000
     DamageType=shot
     AccurateRange=1024
     maxRange=1480
     spawnWeaponClass=Class'DeusEx.WeaponShuriken'
     bIgnoresNanoDefense=True
     ItemName="Throwing Knife"
     ItemArticle="a"
     gravMult=0.500000
     HDTPMesh="HDTPItems.HDTPShurikenPickup"
     hdtpReference=Class'DeusEx.WeaponShuriken'
     speed=1400.000000
     MaxSpeed=1400.000000
     Damage=14.000000
     MomentumTransfer=1000
     ImpactSound=Sound'DeusExSounds.Generic.BulletHitFlesh'
     LifeSpan=560.000000
     Mesh=LodMesh'DeusExItems.ShurikenPickup'
     CollisionRadius=3.500000
     CollisionHeight=0.300000
}
