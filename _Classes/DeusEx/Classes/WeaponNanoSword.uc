//=============================================================================
// WeaponNanoSword.
//=============================================================================
class WeaponNanoSword extends DeusExWeapon;

//SARGE: Make DTS require Bioenergy to function
var travel ChargeManager chargeManager;
var int chargePerUse;                           //How much charge we use per hit
var int totalCharge;                           //How much charge we use per hit
var float drained;                              //Prevent draining within a short time, in case we hit multiple targets.

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		HitDamage = mpHitDamage;
		BaseAccuracy = mpBaseAccuracy;
		ReloadTime = mpReloadTime;
		AccurateRange = mpAccurateRange;
		MaxRange = mpMaxRange;
	}

    SetupChargeManager();
}

function DrainPower()
{
    local DeusExPlayer player;
    local int skillValue;

    if (owner == None || drained > 0)
        return;

    player = DeusExPlayer(owner);

    /*
    if (player != None)
		skillValue = player.SkillSystem.GetSkillLevel(governingSkill);

    //player.clientmessage("SkillValue: " $ skillValue);

    chargeManager.Drain(25 * (4.0 - skillValue));
    */
    //SARGE: No longer based on weapon skill
    chargeManager.Drain(chargePerUse);
    drained = 0.5;
}

function Tick(float deltaTime)
{
    drained = MAX(0,drained - deltaTime);
}

//Initialise charge manager and link the player to it
function SetupChargeManager()
{
    if (chargeManager == None)
    {
	    chargeManager = new(Self) class'ChargeManager';
        chargeManager.SetMaxCharge(totalCharge,true);
        chargeManager.chargeMult = 0.3;
    }
        
    if (owner.IsA('DeusExPlayer'))
        ChargeManager.Setup(DeusExPlayer(owner),self);
}

function string DoAmmoInfoWindow(Pawn P, PersonaInventoryInfoWindow winInfo)
{
	winInfo.SetText(sprintf(chargeManager.ChargeRemainingLabel,chargeManager.GetCurrentCharge()));
    winInfo.SetText(sprintf(chargeManager.BiocellRechargeAmountLabel,chargeManager.GetRechargeAmountDisplay()));
    winInfo.AddLine();
}

function bool CanUseWeapon(DeusExPlayer player, optional bool noMessage)
{
    if (ChargeManager != None && chargeManager.IsUsedUp())
    {
        if (!noMessage)
            player.ClientMessage("Dragon's Tooth Sword is not charged");
        return false;
    }

    return super.CanUseWeapon(player,noMessage);
}

//Stops the game crashing with a "Destroyed != 0" message when loading savegames or transitioning maps
event Destroyed()
{
    CriticalDelete(chargeManager);
}

simulated function renderoverlays(Canvas canvas)
{

	if (iHDTPModelToggle == 1)                                                  //RSD: Need this off for vanilla model
	{
    multiskins[5] = Getweaponhandtex();
    if (!bIsCloaked && !bIsRadar)                                               //RSD: Overhauled cloak/radar routines
    {
       multiskins[4] = Texture'Effects.Electricity.WavyBlade';                  //RSD: Added so we get the right blade texture when switching from HDTP -> vanilla
       multiskins[3] = Texture'Effects.Electricity.WavyBlade';                  //RSD
       multiskins[2] = none;
       multiskins[1] = none;
       multiskins[0] = none;
    }
    }
    else if (!bIsCloaked && !bIsRadar)                                          //RSD: Overhauled cloak/radar routines
    {
    	multiskins[0] = Getweaponhandtex();
    	multiskins[1] = none;
    	multiskins[2] = none;
    	multiskins[3] = none;
    	multiskins[4] = none;
    	multiskins[5] = none;
    	multiskins[6] = none;
    	multiskins[7] = none;
    }
	super.renderoverlays(canvas);

    if (iHDTPModelToggle == 1)                                                  //RSD: Need this off for vanilla model
		multiskins[5] = none;
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 1)
     {
          PlayerViewMesh=LodMesh'HDTPItems.HDTPDragonTooth';
          PickupViewMesh=LodMesh'HDTPItems.HDTPDragonToothPickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPDragonTooth3rd';
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.NanoSword';
          PickupViewMesh=LodMesh'DeusExItems.NanoSwordPickup';
          ThirdPersonMesh=LodMesh'DeusExItems.NanoSword3rd';
     }
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
}

/*Function CheckWeaponSkins()
{=
}*/

state DownWeapon
{
	function BeginState()
	{
		Super.BeginState();
		LightType = LT_None;
	}
}

state Idle
{
	function BeginState()
	{
		Super.BeginState();
		LightType = LT_Steady;
       AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 416);  //CyberP: drawing the sword makes noise
	}

    //Put away weapon when it runs out of juice
    function Tick(float deltaTime)
    {
        Super.Tick(deltaTime);
        if (owner.IsA('DeusExPlayer') && ChargeManager != None)
        {
            if (ChargeManager.IsUsedUp())
                DeusExPlayer(Owner).PutInHand(none);
        }
    }
}

auto state Pickup
{
	function EndState()
	{
		Super.EndState();
		LightType = LT_None;
        SetupChargeManager();
	}
}

defaultproperties
{
     weaponOffsets=(X=13.000000,Y=-16.000000,Z=-27.000000)
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     reloadTime=0.000000
     HitDamage=25
     maxRange=100
     AccurateRange=100
     BaseAccuracy=1.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     SwingOffset=(X=24.000000,Z=2.000000)
     mpHitDamage=10
     mpBaseAccuracy=1.000000
     mpAccurateRange=150
     mpMaxRange=150
     RecoilShaker=(X=4.000000,Y=0.000000,Z=4.000000)
     bCanHaveModDamage=True
     msgSpec="Emits Light"
     meleeStaminaDrain=1.750000
     NPCMaxRange=100
     NPCAccurateRange=100
     iHDTPModelToggle=1
     largeIconRot=Texture'GMDXSFX.Icons.LargeIconRotDragonTooth'
     invSlotsXtravel=4
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
     bInstantHit=True
     FireOffset=(X=-21.000000,Y=16.000000,Z=27.000000)
     shakemag=20.000000
     FireSound=Sound'DeusExSounds.Weapons.NanoSwordFire'
     SelectSound=Sound'DeusExSounds.Weapons.NanoSwordSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.NanoSwordHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.NanoSwordHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.NanoSwordHitSoft'
     InventoryGroup=14
     ItemName="Dragon's Tooth Sword"
     ItemArticle="the"
     PlayerViewOffset=(X=21.000000,Y=-16.000000,Z=-27.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPDragonTooth'
     PickupViewMesh=LodMesh'HDTPItems.HDTPDragonToothPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPDragonTooth3rd'
     LandSound=Sound'DeusExSounds.Weapons.NanoSwordHitHard'
     Icon=Texture'DeusExUI.Icons.BeltIconDragonTooth'
     largeIcon=Texture'DeusExUI.Icons.LargeIconDragonTooth'
     largeIconWidth=205
     largeIconHeight=46
     invSlotsX=4
     Description="The true weapon of a modern warrior, the Dragon's Tooth is not a sword in the traditional sense, but a nanotechnologically constructed blade that is dynamically 'forged' on command into a non-eutactic solid. Nanoscale whetting devices insure that the blade is both unbreakable and lethally sharp. Due to it's molecular nature, it requires a constant energy supply to function."
     beltDescription="DRAGON"
     Mesh=LodMesh'HDTPItems.HDTPDragonToothPickup'
     MultiSkins(2)=WetTexture'Effects.Electricity.WavyBlade'
     MultiSkins(3)=WetTexture'Effects.Electricity.WavyBlade'
     MultiSkins(4)=WetTexture'Effects.Electricity.WavyBlade'
     MultiSkins(5)=WetTexture'Effects.Electricity.WavyBlade'
     MultiSkins(6)=WetTexture'Effects.Electricity.WavyBlade'
     MultiSkins(7)=WetTexture'Effects.Electricity.WavyBlade'
     CollisionRadius=32.000000
     CollisionHeight=2.400000
     LightType=LT_Steady
     LightEffect=LE_WateryShimmer
     LightBrightness=192
     LightHue=160
     LightSaturation=64
     LightRadius=4
     Mass=20.000000
     minSkillRequirement=3;
     chargePerUse=4
     totalCharge=100
}
