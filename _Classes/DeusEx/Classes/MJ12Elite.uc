//=============================================================================
// MJ12Elite.
//=============================================================================
class MJ12Elite extends HumanMilitary;

var float burnAmount;

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (MultiSkins[6]==Texture'DeusExCharacters.Skins.MJ12TroopTex4'
        || MultiSkins[6]==Texture'DeusExCharacters.Skins.MJ12TroopTex3'
        || MultiSkins[6]==Texture'GMDXSFX.Skins.hMJ12TroopTex3')
    {
        bHasHelmet = True;
    }

    if (BaseAccuracy == 0.000000) //Shotgunners and xbow dudes look different.
    {
        //MultiSkins[5]=Texture'DeusExItems.Skins.GrayMaskTex';
        //MultiSkins[6]=Texture'GMDXSFX.Skins.MJ12TroopTex9';
        //CarcassType=Class'DeusEx.MJ12TroopCarcassElite2';
    }
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
    super.TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, true);

	if (damageType == 'Flamed') //CyberP: can be set on fire after continual flamed damage.
	{
        burnAmount+=Damage;
        if (burnAmount > 12)
        {
            BurnPeriod = 120.000000;
            super.TakeDamageBase(2, instigatedBy, hitlocation, momentum, 'Flamed', true);
        }
	}
}

//CyberP: fairly rarely, upon entering combat an enemy cloaks immediately.
State Attacking
{
   function BeginState()
	{
      if (bHasCloak && FRand() < 0.2 && !bCloakOn)
      {
      bCloakOn = False;
      CloakThreshold = 260;
      EnableCloak(True);
      }
      super.BeginState();
	}
   function EndState()
   {
	if (bHasCloak && bCloakOn && Orders != 'Attacking')
	{
      EnableCloak(false);
      CloakThreshold = 80;
    }
      super.EndState();
   }
}

function PlayIdleSound()
{
	if (FRand() < 0.2)
	    super.PlayIdleSound();
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
local DeusExPlayer player;

	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if (damageType == 'TearGas' || damageType == 'HalonGas')
    {
         player = DeusExPlayer(GetPlayerPawn());
         if (player != None && player.bHardCoreMode)
             GotoNextState();
         else
             GotoState('RubbingEyes');
	}
	else if (damageType == 'Stunned')
		GotoState('Stunned');
	else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

function DifficultyMod(float CombatDifficulty, bool bHardCoreMode, bool bExtraHardcore, bool bFirstLevelLoad) //RSD: New function to streamline NPC stat difficulty modulation
{
    Super.DifficultyMod(CombatDifficulty, bHardCoreMode, bExtraHardcore, bFirstLevelLoad);

    if (!bHardCoreMode)
    {
        if (bFirstLevelLoad || !bNotFirstDiffMod)                       //RSD: Only alter health if it's the first time loading the map
        {
            default.Health=200;
            default.HealthHead=200;
            default.HealthTorso=150;
            default.HealthLegLeft=150;
            default.HealthLegRight=150;
            default.HealthArmLeft=150;
            default.HealthArmRight=150;
            Health=200;
            HealthHead=200;
            HealthTorso=150;
            HealthLegLeft=150;
            HealthLegRight=150;
            HealthArmLeft=150;
            HealthArmRight=150;
        }
        CloakThreshold=100;
        GroundSpeed=220.000000;
        //SurprisePeriod=1.000000;
    }
    else
    {
        if (bFirstLevelLoad || !bNotFirstDiffMod)                       //RSD: Only alter health if it's the first time loading the map
        {
            default.Health=300;
            default.HealthHead=300;
            default.HealthTorso=250;
            default.HealthLegLeft=250;
            default.HealthLegRight=250;
            default.HealthArmLeft=250;
            default.HealthArmRight=250;
            Health=300;
            HealthHead=300;
            HealthTorso=250;
            HealthLegLeft=250;
            HealthLegRight=250;
            HealthArmLeft=250;
            HealthArmRight=250;
        }
        CloakThreshold=140;
        //GroundSpeed=220.000000;
    }
    bNotFirstDiffMod = true;
}

defaultproperties
{
     FovAngle=120.000000
     maxRange=4096.000000
     MinHealth=0.000000
     CarcassType=Class'DeusEx.MJ12TroopCarcassElite'
     WalkingSpeed=0.296000
     bHateWeapon=True
     bHateDistress=True
     bReactLoudNoise=True
     bReactShot=True
     bReactDistress=True
     bReactCarcass=True
     SurprisePeriod=0.400000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=24)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     BurnPeriod=0.000000
     bHasCloak=True
     walkAnimMult=0.780000
     runAnimMult=1.100000
     bGrenadier=True
     disturbanceCount=1
     bCanPop=True
     smartStrafeRate=0.500000
     GroundSpeed=230.000000
     Health=300
     HealthHead=300
     HealthTorso=300
     HealthLegLeft=300
     HealthLegRight=300
     HealthArmLeft=300
     HealthArmRight=300
     VisibilityThreshold=0.002000
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.MJ12TroopTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.MJ12TroopTex1'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MJ12TroopTex2'
     MultiSkins(3)=Texture'GMDXSFX.Skins.MJ12EliteTex0'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.MJ12TroopTex3'
     MultiSkins(6)=Texture'GMDXSFX.Skins.hMJ12TroopTex3'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.MJ12TroopTex3'
     CollisionRadius=20.000000
     CollisionHeight=49.000000
     RotationRate=(Yaw=90000)
     BarkBindName="MJ12Elite"
     BindName="MJ12Troop"
     FamiliarName="MJ12 Elite"
     UnfamiliarName="MJ12 Elite"
     fireReactTime=0.25
     BaseAccuracy=0.200000
     maxRange=9000.000000
}
