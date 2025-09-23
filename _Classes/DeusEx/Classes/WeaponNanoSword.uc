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


//SARGE: Recharges this nano sword based on another ones charge.
function RechargeFrom(WeaponNanoSword target)
{
    if (target == None || target.ChargeManager == None || chargeManager == None)
        return;

    chargeManager.RechargeFrom(target.ChargeManager);
}

function Tick(float deltaTime)
{
    super.Tick(deltaTime);
    drained = MAX(0,drained - deltaTime);
    RefreshLight();
}

function RefreshLight()
{
    if (!IsInState('DownWeapon') && !IsInState('Idle2') && !chargeManager.IsUsedUp())
        LightType = LT_Steady;
    else
        LightType = LT_None;
}

//Initialise charge manager and link the player to it
function SetupChargeManager()
{
    if (chargeManager == None)
    {
	    chargeManager = new(Self) class'ChargeManager';
        chargeManager.SetMaxCharge(totalCharge,true);
        chargeManager.chargeMult = 0.2;
    }
        
    if (owner.IsA('DeusExPlayer'))
        ChargeManager.Setup(DeusExPlayer(owner),self);
}

function string DoAmmoInfoWindow(Pawn P, PersonaInventoryInfoWindow winInfo)
{
    if (DeusExPlayer(P) != None && !DeusExPlayer(P).bNanoswordEnergyUse && !DeusExPlayer(P).bHardcoreMode)
        return "";

	winInfo.SetText(sprintf(chargeManager.ChargeRemainingLabel,chargeManager.GetCurrentCharge()));
    winInfo.SetText(sprintf(chargeManager.BiocellRechargeAmountLabel,chargeManager.GetRechargeAmountDisplay()));
    winInfo.AddLine();
}

//Stops the game crashing with a "Destroyed != 0" message when loading savegames or transitioning maps
event Destroyed()
{
    CriticalDelete(chargeManager);
}

//SARGE: Show DTS Charge on the frob string
function string GetFrobString(DeusExPlayer player)
{
    local string modStr, energyStr;

    //If it's modified, we want to show it in the brackets alongside the charge
    if (bModified && player != None && player.bBeltShowModified)
        modStr = strModified;

    if (ChargeManager != None && player != None && (player.bHardcoreMode || player.bNanoswordEnergyUse))
        energyStr = string(ChargeManager.GetCurrentCharge()) $ "%";

    if (modStr != "" && energyStr != "")
        return itemName @ "(" $ energyStr @ "-" @ modStr $ ")";
    else if (modStr != "" || energyStr != "")
        return itemName @ "(" $ modStr $ energyStr $ ")";
    else
        return itemName;
}

//SARGE: Restrict fire if we're using the Dragons Tooth with no charge
function Fire(float Value)
{
    if (chargeManager != None && chargeManager.IsUsedUp())
    {
        GotoState('Idle');  //SARGE: Needed to not break weapons
        return;
    }

    super.Fire(Value);
}

//SARGE: Sets and unsets textures based on our charge amount
function SetWeaponSkin(bool hdtp)
{
    if (hdtp)
    {
        if (chargeManager.IsUsedUp())
        {
            multiskins[2] = Texture'PinkMaskTex';
            multiskins[3] = Texture'PinkMaskTex';
            multiskins[4] = Texture'PinkMaskTex';
            multiskins[6] = Texture'PinkMaskTex';
            multiskins[7] = Texture'PinkMaskTex';
            Texture = Texture'PinkMaskTex';
            SelectSound = None;
        }
        else
        {
            multiskins[2] = Texture'Effects.Electricity.WavyBlade';
            multiskins[3] = Texture'Effects.Electricity.WavyBlade';
            multiskins[4] = Texture'Effects.Electricity.WavyBlade';
            multiskins[6] = Texture'Effects.Electricity.WavyBlade';
            multiskins[7] = Texture'Effects.Electricity.WavyBlade';
            SelectSound = default.SelectSound;
        }
    }
    else if (chargeManager.IsUsedUp())
    {
        multiskins[1] = Texture'PinkMaskTex';
        multiskins[2] = Texture'BlackMaskTex';
        //multiskins[3] = Texture'PinkMaskTex';
        multiskins[4] = Texture'PinkMaskTex';
        multiskins[5] = Texture'PinkMaskTex';
        multiskins[6] = Texture'PinkMaskTex';
        multiskins[7] = Texture'PinkMaskTex';
        SelectSound = None;
    }
    else
    {
        SelectSound = default.SelectSound;
    }
}

function DisplayWeapon(bool overlay)
{
	super.DisplayWeapon(overlay);
    if (IsHDTP())
    {
		if (overlay)
			multiskins[5] = handstex;
    }
    else if (overlay)
    {
    	multiskins[0] = handstex;
    }

    SetWeaponSkin(IsHDTP());
}

state Idle
{
	function BeginState()
	{
		Super.BeginState();
        if (chargeManager != None && !chargeManager.IsUsedUp())
        {
            AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 416);  //CyberP: drawing the sword makes noise
       }
	}
}

auto state Pickup
{
	function EndState()
	{
		Super.EndState();
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
     HDTPPlayerViewMesh="HDTPItems.HDTPDragonTooth"
     HDTPPickupViewMesh="HDTPItems.HDTPDragonToothPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPDragonTooth3rd"
     PlayerViewMesh=LodMesh'DeusExItems.NanoSword'
     PickupViewMesh=LodMesh'DeusExItems.NanoSwordPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.NanoSword3rd'
     LandSound=Sound'DeusExSounds.Weapons.NanoSwordHitHard'
     Icon=Texture'DeusExUI.Icons.BeltIconDragonTooth'
     largeIcon=Texture'DeusExUI.Icons.LargeIconDragonTooth'
     largeIconWidth=205
     largeIconHeight=46
     invSlotsX=4
     Description="The true weapon of a modern warrior, the Dragon's Tooth is not a sword in the traditional sense, but a nanotechnologically constructed blade that is dynamically 'forged' on command into a non-eutactic solid. Nanoscale whetting devices insure that the blade is both unbreakable and lethally sharp. Due to it's molecular nature, it requires a constant energy supply to function."
     beltDescription="DRAGON"
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
     chargePerUse=5
     totalCharge=100
}
