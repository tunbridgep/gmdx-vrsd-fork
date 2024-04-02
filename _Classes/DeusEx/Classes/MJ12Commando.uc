//=============================================================================
// MJ12Commando.
//=============================================================================
class MJ12Commando extends HumanMilitary;

/*function BeginPlay()
{
local DeusExPlayer player;
if (player !=none && player.bHardCoreMode)
{
   VisibilityThreshold=0.002000;
   Health=default.Health;
   HealthHead=default.HealthHead;
   HealthTorso=default.HealthTorso;
   HealthLegLeft=default.HealthLegLeft;
   HealthLegRight=default.HealthLegRight;
   HealthArmLeft=default.HealthArmLeft;
   HealthArmRight=default.HealthArmRight;
 }
 else
 {
 VisibilityThreshold=0.002000;
 default.Health=350;
 default.HealthHead=350;
 default.HealthTorso=350;
 default.HealthLegLeft=350;
 default.HealthLegRight=350;
 default.HealthArmLeft=350;
 default.HealthArmRight=350;
 Health=350;
 HealthHead=350;
 HealthTorso=350;
 HealthLegLeft=350;
 HealthLegRight=350;
 HealthArmLeft=350;
 HealthArmRight=350;
 }
   Super.BeginPlay();
}

function PostBeginPlay()
{
   local DeusExPlayer player;
if (player !=none && player.bHardCoreMode)
{
   VisibilityThreshold=0.002000;
   Health=default.Health;
   HealthHead=default.HealthHead;
   HealthTorso=default.HealthTorso;
   HealthLegLeft=default.HealthLegLeft;
   HealthLegRight=default.HealthLegRight;
   HealthArmLeft=default.HealthArmLeft;
   HealthArmRight=default.HealthArmRight;
 }
 else
 {
 VisibilityThreshold=0.002000;
 default.Health=350;
 default.HealthHead=350;
 default.HealthTorso=350;
 default.HealthLegLeft=350;
 default.HealthLegRight=350;
 default.HealthArmLeft=350;
 default.HealthArmRight=350;
 Health=350;
 HealthHead=350;
 HealthTorso=350;
 HealthLegLeft=350;
 HealthLegRight=350;
 HealthArmLeft=350;
 HealthArmRight=350;
 }
   Super.PostBeginPlay();
}*/

function Bool HasTwoHandedWeapon()
{
	return False;
}

function PlayReloadBegin()
{
	TweenAnimPivot('Shoot', 0.1);
}

function PlayReload()
{
}

function PlayReloadEnd()
{
}

function PlayIdle()
{
}

function TweenToShoot(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('TreadShoot', tweentime, GetSwimPivot());
	else if (!bCrouching)
		TweenAnimPivot('Shoot2', tweentime);
}

function PlayShoot()
{
	if (Region.Zone.bWaterZone)
		PlayAnimPivot('TreadShoot', , 0, GetSwimPivot());
	else
		PlayAnimPivot('Shoot2', , 0);
}

function bool IgnoreDamageType(Name damageType)
{
	if ((damageType == 'TearGas') || (damageType == 'PoisonGas'))
		return True;
	else
		return False;
}

function float ShieldDamage(Name damageType)
{
	if (IgnoreDamageType(damageType))
		return 0.0;
	else if ((damageType == 'Burned') || (damageType == 'Flamed'))
		return 0.5;
	else if ((damageType == 'Poison') || (damageType == 'PoisonEffect'))
		return 0.5;
	else
		return Super.ShieldDamage(damageType);
}


function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if (!IgnoreDamageType(damageType) && CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

function float ModifyDamage(int Damage, Pawn instigatedBy, Vector hitLocation,  //RSD: Overruled ModifyDamage just for additional damage with Sabot/AP rounds
							Vector offset, Name damageType)
{
	local int   actualDamage;
	local float headOffsetZ, headOffsetY, armOffset;

	actualDamage = Damage;

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.7;
	headOffsetY = CollisionRadius * 0.3;
	armOffset   = CollisionRadius * 0.35;

	// if the pawn is stunned, damage is 4X
	if (bStunned)
		actualDamage *= 8; //CyberP: now *8, hacky fix

	// if the pawn is hit from behind at point-blank range, he is killed instantly
	else if (offset.x < 0)
		if ((instigatedBy != None) && (VSize(instigatedBy.Location - Location) < 96)) //CyberP: was 64
			actualDamage  *= 12; //CyberP: was 10

	actualDamage = Level.Game.ReduceDamage(actualDamage, DamageType, self, instigatedBy);

	if (ReducedDamageType == 'All') //God mode
		actualDamage = 0;
	else if (Inventory != None) //then check if carrying armor
		actualDamage = Inventory.ReduceDamage(actualDamage, DamageType, HitLocation);

	// gas, EMP and nanovirus do no damage
	if (damageType == 'TearGas' || damageType == 'EMP' || damageType == 'NanoVirus')
		actualDamage = 0;
    else if (damageType == 'Sabot')
        actualDamage *= 1.5;                                                    //RSD: Extra +50% damage with Sabot and AP ammo
	//if (damageType == 'EMP')
    //{bHasCloak = False; CloakThreshold = 0;}//CyberP: EMP just outright disables cloaking.

	return actualDamage;

}

function DifficultyMod(float CombatDifficulty, bool bHardCoreMode, bool bExtraHardcore, bool bFirstLevelLoad) //RSD: New function to streamline NPC stat difficulty modulation
{
        Super.DifficultyMod(CombatDifficulty, bHardCoreMode, bExtraHardcore, bFirstLevelLoad);

        if (bHardCoreMode)
        {
        if (bFirstLevelLoad || !bNotFirstDiffMod)                       //RSD: Only alter health if it's the first time loading the map
        {
        default.Health=450;
        default.HealthHead=450;
        default.HealthTorso=400;
        default.HealthLegLeft=350;
        default.HealthLegRight=350;
        default.HealthArmLeft=350;
        default.HealthArmRight=350;
        Health=450;
        HealthHead=450;
        HealthTorso=400;
        HealthLegLeft=350;
        HealthLegRight=350;
        HealthArmLeft=350;
        HealthArmRight=350;
        }
        VisibilityThreshold=0.005000;
        if (bExtraHardcore)
            VisibilityThreshold=0.002000;
        }
        else
        {
        if (bFirstLevelLoad || !bNotFirstDiffMod)                       //RSD: Only alter health if it's the first time loading the map
        {
        default.Health=250;
        default.HealthHead=250;
        default.HealthTorso=250;
        default.HealthLegLeft=200;
        default.HealthLegRight=200;
        default.HealthArmLeft=200;
        default.HealthArmRight=200;
        Health=250;
        HealthHead=250;
        HealthTorso=250;
        HealthLegLeft=200;
        HealthLegRight=200;
        HealthArmLeft=200;
        HealthArmRight=200;
        }
        VisibilityThreshold=0.007000;
        }
        bNotFirstDiffMod = true;
}

defaultproperties
{
     bDontRandomizeWeapons=True
     MinHealth=0.000000
     CarcassType=Class'DeusEx.MJ12CommandoCarcass'
     WalkingSpeed=0.296000
     bCanCrouch=False
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponMJ12Commando')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=24)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponMJ12Rocket')
     InitialInventory(3)=(Inventory=Class'DeusEx.AmmoRocketMini',Count=10)
     BurnPeriod=0.000000
     smartStrafeRate=0.350000
     GroundSpeed=240.000000
     Health=450
     HitSound1=None
     HitSound2=None
     Die=Sound'DeusExSounds.Augmentation.CloakDown'
     HealthHead=450
     HealthTorso=450
     HealthLegLeft=450
     HealthLegRight=450
     HealthArmLeft=450
     HealthArmRight=450
     Mesh=LodMesh'DeusExCharacters.GM_ScaryTroop'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.MJ12CommandoTex1'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.MJ12CommandoTex1'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MJ12CommandoTex0'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.MJ12CommandoTex1'
     CollisionRadius=28.000000
     CollisionHeight=49.880001
     BindName="MJ12Commando"
     FamiliarName="MJ12 Commando"
     UnfamiliarName="MJ12 Commando"
}
