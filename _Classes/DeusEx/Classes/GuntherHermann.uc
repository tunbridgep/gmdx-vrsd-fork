//=============================================================================
// GuntherHermann.
//=============================================================================
class GuntherHermann extends HumanMilitary;

//
// Damage type table for Gunther Hermann:
//
// Shot			- 100%
// Sabot		- 100%
// Exploded		- 100%
// TearGas		- 10%
// PoisonGas	- 10%
// Poison		- 10%
// HalonGas		- 10%
// Radiation	- 10%
// Shocked		- 10%
// Stunned		- 0%
// KnockedOut   - 0%
// Flamed		- 0%
// Burned		- 0%
// NanoVirus	- 0%
// EMP			- 0%
//

function float ShieldDamage(name damageType)
{
	// handle special damage types
	if ((damageType == 'Flamed') || (damageType == 'Burned') || (damageType == 'Stunned') ||
	    (damageType == 'KnockedOut'))
		return 0.0;
	else if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'HalonGas') ||
			(damageType == 'Radiation') || (damageType == 'Shocked') || (damageType == 'Poison') ||
	        (damageType == 'PoisonEffect'))
		return 0.1;
	else if (damageType == 'EMP')
	{
        GotoState('Stunned');
        return Super.ShieldDamage(damageType);
	}
	else
		return Super.ShieldDamage(damageType);
}

// ----------------------------------------------------------------------
// SpawnCarcass()
//
// Blow up instead of spawning a carcass
// ----------------------------------------------------------------------

function Carcass SpawnCarcass()
{
	if (bStunned)
		return Super.SpawnCarcass();

	Explode();

	return None;
}

function Explode()
{
	local SphereEffect sphere;
	local ScorchMark s;
	local ExplosionLight light;
	local int i;
	local float explosionDamage;
	local float explosionRadius;
	local vector loc;
    local FleshFragment chunk;

	explosionDamage = 110;
	explosionRadius = 320;

	// alert NPCs that I'm exploding
	AISendEvent('LoudNoise', EAITYPE_Audio, , explosionRadius*16);
	PlaySound(Sound'LargeExplosion1', SLOT_None,,, explosionRadius*16);

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, Location);
	if (light != None)
		light.size = 4;

	Spawn(class'ExplosionSmall',,, Location + 2*VRand()*CollisionRadius);
	Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);
	Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);


	sphere = Spawn(class'SphereEffect',,, Location);
	if (sphere != None)
		sphere.size = explosionRadius / 32.0;

	// spawn a mark
	s = spawn(class'ScorchMark', Base,, Location-vect(0,0,1)*CollisionHeight, Rotation+rot(16384,0,0));
	if (s != None)
	{
		s.DrawScaleMult = FClamp(explosionDamage/28, 0.1, 3.0);
		s.UpdateHDTPSettings();
	}

	//CyberP: messy gore
	for (i=0; i<22; i++)
			{
				loc.X = (1-2*FRand()) * CollisionRadius;
				loc.Y = (1-2*FRand()) * CollisionRadius;
				loc.Z = (1-2*FRand()) * CollisionHeight;
				loc += Location;
				spawn(class'BloodDropFlying');
				chunk = spawn(class'FleshFragment', None,, loc);
                if (chunk != None)
				{
                    chunk.Velocity.Z = FRand() * 410 + 410;
					chunk.bFixedRotationDir = False;
					chunk.RotationRate = RotRand();
				}
             }

	HurtRadius(explosionDamage, explosionRadius, 'Exploded', explosionDamage*100, Location);
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

//
// special Gunther killswitch animation state
//
state KillswitchActivated
{
    function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
						Vector momentum, name damageType)
	{
         if (damageType == 'KnockedOut' || damageType == 'Poison' || damageType == 'PoisonEffect')
             return;
         else
		     super.TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
	}

	function BeginState()
	{
		StandUp();
		LastPainTime = Level.TimeSeconds;
		LastPainAnim = AnimSequence;
		bInterruptState = false;
		BlockReactions();
		bCanConverse = False;
		bStasis = False;
		SetDistress(true);
		TakeHitTimer = 2.0;
		EnemyReadiness = 1.0;
		ReactionLevel  = 1.0;
		bInTransientState = true;
	}

Begin:
	FinishAnim();
	PlayAnim('HitTorso', 2.0, 0.1);
	FinishAnim();
	PlayAnim('HitHead', 2.0, 0.1);
	FinishAnim();
	PlayAnim('HitTorsoBack', 2.0, 0.1);
	FinishAnim();
	PlayAnim('HitHeadBack', 2.0, 0.1);
	FinishAnim();
	PlayAnim('HitHead', 3.0, 0.1);
	FinishAnim();
	PlayAnim('HitHeadBack', 3.0, 0.1);
	FinishAnim();
	PlayAnim('HitHead', 5.0, 0.1);
	FinishAnim();
	PlayAnim('HitHeadBack', 5.0, 0.1);
	FinishAnim();
	Explode();
	Destroy();
}

defaultproperties
{
     CarcassType=Class'DeusEx.GuntherHermannCarcass'
     WalkingSpeed=0.150000
     bImportant=True
     bInvincible=True
     bAvoidHarm=False
     CloseCombatMult=0.500000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     InitialInventory(3)=(Inventory=Class'DeusEx.WeaponFlamethrower')
     InitialInventory(4)=(Inventory=Class'DeusEx.AmmoNapalm',Count=2)
     WalkSound=Sound'DeusExSounds.Robot.SecurityBot2Walk'
     BurnPeriod=0.000000
     walkAnimMult=0.750000
     runAnimMult=1.100000
     HDTPMesh="HDTPCharacters.HDTPGunther"
     HDTPMeshTex(0)="HDTPCharacters.skins.HDTPGuntherTex1"
     HDTPMeshTex(1)="HDTPCharacters.skins.HDTPGuntherTex1"
     HDTPMeshTex(2)="HDTPCharacters.skins.HDTPGuntherTex2"
     HDTPMeshTex(3)="HDTPCharacters.skins.HDTPGuntherTex3"
     HDTPMeshTex(4)="HDTPCharacters.skins.HDTPGuntherTex4"
     HDTPMeshTex(5)="HDTPCharacters.skins.HDTPGuntherTex5"
     HDTPMeshTex(6)="HDTPCharacters.skins.HDTPGuntherTex6"
     HDTPMeshTex(7)="HDTPCharacters.skins.HDTPGuntherTex7"
     bTank=True
     GroundSpeed=360.000000
     BaseEyeHeight=44.000000
     Health=800
     HitSound1=Sound'DeusExSounds.Generic.ArmorRicochet'
     HitSound2=Sound'DeusExSounds.Generic.ArmorRicochet'
     HealthHead=800
     HealthTorso=800
     HealthLegLeft=500
     HealthLegRight=500
     HealthArmLeft=500
     HealthArmRight=500
     Texture=Texture'DeusExItems.Skins.BlackMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_DressShirt_B'
     DrawScale=1.100000
     MultiSkins(0)=Texture'DeusExCharacters.Skins.GuntherHermannTex1'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.PantsTex9'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.GuntherHermannTex0'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.GuntherHermannTex0'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(6)=Texture'DeusExItems.Skins.BlackMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=24.200001
     CollisionHeight=54.259998
     BindName="GuntherHermann"
     FamiliarName="Gunther Hermann"
     UnfamiliarName="Gunther Hermann"
}
