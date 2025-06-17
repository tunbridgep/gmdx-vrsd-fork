//=============================================================================
// MJ12Troop.
//=============================================================================
class MJ12Troop extends HumanMilitary;

var float burnAmount;

//GMDX inline hack  //cyberp: it's a big hack, beware!
function PostBeginPlay()
{
    BurnPeriod=0.000000;

    if (MultiSkins[6]==Texture'DeusExCharacters.Skins.MJ12TroopTex4' || MultiSkins[6]==Texture'DeusExCharacters.Skins.MJ12TroopTex3' ||
     MultiSkins[6]==Texture'GMDXSFX.Skins.hMJ12TroopTex3')
         bHasHelmet = True;

    if (UnfamiliarName == "MJ12 Elite" || MultiSkins[3]==Texture'DeusExCharacters.Skins.MiscTex1' || MultiSkins[3]==Texture'DeusExCharacters.Skins.TerroristTex0' || MultiSkins[3]==Texture'GMDXSFX.Skins.MJ12EliteTex0')
    {
        bHasCloak=true;
        runAnimMult=1.100000;

            //BarkBindName="MJ12Elite";
            MultiSkins[1]=Texture'GMDXSFX.Skins.MJ12EliteTex2';
            MultiSkins[2]=Texture'GMDXSFX.Skins.MJ12EliteTex1';
            MultiSkins[3]=Texture'GMDXSFX.Skins.MJ12EliteTex0';
            if (BaseAccuracy == 0.000000)
            {
            MultiSkins[5]=Texture'DeusExItems.Skins.GrayMaskTex';
            MultiSkins[6]=Texture'GMDXSFX.Skins.MJ12TroopTex9';
            CarcassType=Class'DeusEx.MJ12TroopCarcassElite2';
            }
            else
            {
            MultiSkins[5]=Texture'DeusExCharacters.Skins.MJ12TroopTex3';
            MultiSkins[6]=Texture'GMDXSFX.Skins.hMJ12TroopTex3';
            CarcassType=Class'DeusEx.MJ12TroopCarcassElite';
            }
    }
    else if (CarcassType == Class'DeusEx.MJ12TroopCarcassElite' || CarcassType == Class'DeusEx.MJ12TroopCarcassElite') //RSD: Fix for reverted MJ12 troops becoming elites when killed
        CarcassType=Class'DeusEx.MJ12TroopCarcass';

    Super.PostBeginPlay();
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
    super.TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, true);

	if (damageType == 'Flamed') //CyberP: can be set on fire after continual flamed damage.
	{
	burnAmount+=Damage;
	if (burnAmount > 6)
	{
	if (MultiSkins[3]==Texture'GMDXSFX.Skins.MJ12EliteTex0' && burnAmount < 12)
	{
	}
	else
	{
	BurnPeriod = 120.000000;
	super.TakeDamageBase(1, instigatedBy, hitlocation, momentum, 'Flamed', true);
	}
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
      CloakThreshold = 400;
      EnableCloak(True);
      }
      super.BeginState();
	}
   function EndState()
   {
	if (bHasCloak && bCloakOn && Orders != 'Attacking')
	{
      CloakThreshold = Health*0.4;
      EnableCloak(false);
    }
      super.EndState();
   }
}

function PopHead()
{
MultiSkins[3] = Texture'GMDXSFX.Skins.DoctorTexBeheaded';
MultiSkins[5] = Texture'DeusExItems.Skins.PinkMaskTex';
MultiSkins[6] = Texture'DeusExItems.Skins.PinkMaskTex';
CarcassType = Class'DeusEx.MJ12TroopCarcassBeheaded';
}

function PlayIdleSound()
{
	if (!bHasCloak || FRand() < 0.2)
	    super.PlayIdleSound();
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
local DeusExPlayer player;

if (UnfamiliarName != "MJ12 Elite" || !bHasCloak)
{
 super.GotoDisabledState(damageType,hitPos);
}
else  //MJ12 Elite are immune to halon gas & tear gas on hardcore
{
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
}

function DifficultyMod(float CombatDifficulty, bool bHardCoreMode, bool bExtraHardcore, bool bFirstLevelLoad) //RSD: New function to streamline NPC stat difficulty modulation
{
    Super.DifficultyMod(CombatDifficulty, bHardCoreMode, bExtraHardcore, bFirstLevelLoad);

    if (MultiSkins[3]==Texture'DeusExCharacters.Skins.MiscTex1' || MultiSkins[3]==Texture'GMDXSFX.Skins.MJ12EliteTex0' || MultiSkins[3]==Texture'DeusExCharacters.Skins.TerroristTex0')
    {
        if (bHardCoreMode)
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
        GroundSpeed=220.000000;
        }
        else
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
    }
    bNotFirstDiffMod = true;
}

defaultproperties
{
     CarcassType=Class'DeusEx.MJ12TroopCarcass'
     WalkingSpeed=0.296000
     SurprisePeriod=0.700000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=24)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     BurnPeriod=0.000000
     walkAnimMult=0.780000
     bGrenadier=True
     disturbanceCount=1
     bCanPop=True
     GroundSpeed=220.000000
     Health=130
     HealthHead=130
     HealthTorso=130
     HealthLegLeft=130
     HealthLegRight=130
     HealthArmLeft=130
     HealthArmRight=130
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.SkinTex1'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.MJ12TroopTex1'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MJ12TroopTex2'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.SkinTex1'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.MJ12TroopTex3'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.MJ12TroopTex4'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=49.000000
     BindName="MJ12Troop"
     FamiliarName="MJ12 Troop"
     UnfamiliarName="MJ12 Troop"
     fireReactTime=0.35
     bHateWeapon=True
     bHateDistress=True
     bReactLoudNoise=True
     bReactShot=True
     bReactCarcass=True
     bReactDistress=True
}
