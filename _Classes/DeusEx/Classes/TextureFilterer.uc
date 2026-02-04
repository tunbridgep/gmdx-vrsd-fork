//SARGE: A module designed to implement Texture Filtering
class TextureFilterer extends DXGameInfoModule;

var globalconfig bool bSmartTextureFiltering;            //Enable or disable texture filtering

var private transient bool bOldValue;                    //Store the old value - if it changes, we need to refresh.

function Init(DeusExGameInfo info)
{
    RefreshTextureFiltering();
    super.Init(info);
}

function PlayerLogin(PlayerPawn P)
{
    bOldValue = bSmartTextureFiltering;
    RefreshTextureFiltering();
    super.PlayerLogin(P);
}

function Tick(float deltaTime)
{
    if (bOldValue != bSmartTextureFiltering)
    {
        RefreshTextureFiltering();
        bOldValue = bSmartTextureFiltering;
        SaveConfig();
    }
}

// ----------------------------------------------------------------------
// SARGE: RefreshTextureFiltering()
// Removes texture filtering, without removing it from everything.
// Thanks to TheAstropath on the DXR discord for this one!
// ----------------------------------------------------------------------

function RefreshTextureFiltering()
{
    local Texture T;
    local Actor A;
    local bool bFilterActor;

    Log("Refreshing Textures");

    foreach AllObjects(class'Texture',T)
    {
        if (!T.IsA('FireTexture') && !T.bWaterWavy)
        {
            T.default.bNoSmooth = !bSmartTextureFiltering;
            T.bNoSmooth = !bSmartTextureFiltering;
        }
    }
    
    foreach AllObjects(class'Actor',A)
    {
        bFilterActor = false;
        if (!bSmartTextureFiltering)
        {
            if (A.IsA('Decoration'))
                bFilterActor = !A.IsA('PlaceableDecal') || PlaceableDecal(A).ShouldBeUnfiltered();
            else if (A.IsA('Pawn') || A.IsA('Carcass') || A.IsA('Inventory') || /*A.IsA('Decal') ||*/ A.IsA('Fragment'))
                bFilterActor = true;
        }
            
        A.bNoSmooth = bFilterActor;
    }

    //We need to do the classes manually otherwise they won't be loaded.
    //This fucking sucks on ice!
    /*
    */
    
    //Some things get picked up by the generic classes, but not all
    class'Actor'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Effects'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Pawn'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Inventory'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Carcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Decoration'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Ammo'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Pickup'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Projectile'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Weapon'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'Decal'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Fragment'.default.bNoSmooth = !bSmartTextureFiltering;
    class'DeusExPickup'.default.bNoSmooth = !bSmartTextureFiltering;
    class'DeusExWeapon'.default.bNoSmooth = !bSmartTextureFiltering;
    class'DeusExCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'DeusExAmmo'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'DeusExDecal'.default.bNoSmooth = !bSmartTextureFiltering;
    class'DeusExDecoration'.default.bNoSmooth = !bSmartTextureFiltering;
    class'DeusExFragment'.default.bNoSmooth = !bSmartTextureFiltering;
    class'DeusExProjectile'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ThrownProjectile'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Containers'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ScriptedPawn'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Robot'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Human'.default.bNoSmooth = !bSmartTextureFiltering;
    class'HumanMilitary'.default.bNoSmooth = !bSmartTextureFiltering;
    class'HumanThug'.default.bNoSmooth = !bSmartTextureFiltering;
    class'HumanCivilian'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Animal'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AnimatedSprite'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Vehicles'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ElectronicDevices'.default.bNoSmooth = !bSmartTextureFiltering;
    class'HackableDevices'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ConsumableItem'.default.bNoSmooth = !bSmartTextureFiltering;
    class'RSDEdible'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Vice'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Furniture'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Seat'.default.bNoSmooth = !bSmartTextureFiltering;
    class'InformationDevices'.default.bNoSmooth = !bSmartTextureFiltering;
    class'OutdoorThings'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Tree'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ScaledDecal'.default.bNoSmooth = !bSmartTextureFiltering;

    //So lets also add everything that can be HDTP-ified, which don't work for some reason...
    //This fucking sucks on ice!
    
    //Characters and Carcasses
    class'JCDentonMale'.default.bNoSmooth = !bSmartTextureFiltering;
    class'JCDentonMaleCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'JCDouble'.default.bNoSmooth = !bSmartTextureFiltering;
    class'PaulDenton'.default.bNoSmooth = !bSmartTextureFiltering;
    class'PaulDentonCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'GuntherHermann'.default.bNoSmooth = !bSmartTextureFiltering;
    class'GuntherHermannCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AnnaNavarre'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AnnaNavarreCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'NicoletteDuClare'.default.bNoSmooth = !bSmartTextureFiltering;
    class'NicoletteDuClareCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Terrorist'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TerroristCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TerroristCarcass2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TerroristCarcass3'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TerroristCarcass4'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TerroristCarcassBeheaded'.default.bNoSmooth = !bSmartTextureFiltering;
    class'RiotCop'.default.bNoSmooth = !bSmartTextureFiltering;
    class'RiotCopCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WaltonSimons'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WaltonSimonsCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'UNATCOTroop'.default.bNoSmooth = !bSmartTextureFiltering;
    class'UNATCOTroopCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'UNATCOTroopCarcassBeheaded'.default.bNoSmooth = !bSmartTextureFiltering;
    class'UNATCOTroopCarcassCop'.default.bNoSmooth = !bSmartTextureFiltering;
    class'UNATCOTroopCarcassDehelm'.default.bNoSmooth = !bSmartTextureFiltering;
    class'UNATCOTroopCarcassMale'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CleanerBot'.default.bNoSmooth = !bSmartTextureFiltering;
    class'MilitaryBot'.default.bNoSmooth = !bSmartTextureFiltering;
    class'MedicalBot'.default.bNoSmooth = !bSmartTextureFiltering;
    class'RepairBot'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SecurityBot2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SecurityBot3'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SpiderBot'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SpiderBot2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SpiderBot3'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SpiderBot4'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SpiderBotConstructorGrenade'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SpiderBotFake'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Gray'.default.bNoSmooth = !bSmartTextureFiltering;
    class'GrayCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Greasel'.default.bNoSmooth = !bSmartTextureFiltering;
    class'GreaselCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Karkian'.default.bNoSmooth = !bSmartTextureFiltering;
    class'KarkianCarcass'.default.bNoSmooth = !bSmartTextureFiltering;

    //Turrets et al
    class'AutoTurret'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AutoTurretGun'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AutoTurretSmall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AutoTurretGunSmall'.default.bNoSmooth = !bSmartTextureFiltering;

    //Weapons
    class'WeaponAssaultGun'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponAssaultShotgun'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponBaton'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponCrowbar'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponEMPGrenade'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponFlamethrower'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponGasGrenade'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponGEPGun'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponLAM'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponLAW'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponMiniCrossbow'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponNanoSword'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponNanoVirusGrenade'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponPepperGun'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponPistol'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponPlasmaRifle'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponProd'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponRifle'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponSawedOffShotgun'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponStealthPistol'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponSword'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponShuriken'.default.bNoSmooth = !bSmartTextureFiltering;

    //Deco
    class'AIPrototype'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AlarmUnit'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AlarmLight'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BarrelAmbrosia'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Barrel1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BarrelFire'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Basket'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BasketBall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WHBenchEast'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WHBenchLibrary'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoneFemur'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoneFemurBloody'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Binoculars'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BookOpen'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BookClosed'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Newspaper'.default.bNoSmooth = !bSmartTextureFiltering;
    class'NewspaperOpen'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Button1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Candybar'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Cagelight'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoxLarge'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoxMedium'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoxSmall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Cat'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CatCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Dog'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Doberman'.default.bNoSmooth = !bSmartTextureFiltering;
    class'DobermanCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Chair1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ChairLeather'.default.bNoSmooth = !bSmartTextureFiltering;
    class'OfficeChair'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WHChairDining'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WHChairOvalOffice'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Cigarettes'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CigaretteMachine'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ComputerPersonal'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ComputerSecurity'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ATM'.default.bNoSmooth = !bSmartTextureFiltering;
    class'RoadBlock'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ControlPanel'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CouchLeather'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WHRedCouch'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Cushion'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Datacube'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Earth'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Fan1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Fan2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Fan1Vertical'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CeilingFan'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Faucet'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FirePlug'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FlagPole'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Flowers'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Keypad1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Keypad2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Keypad3'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Flask'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Lamp1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Lamp2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Lamp3'.default.bNoSmooth = !bSmartTextureFiltering;
    class'LightBulb'.default.bNoSmooth = !bSmartTextureFiltering;
    class'LightSwitch'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Mailbox'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Microscope'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BarrelVirus'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Pan1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Pan2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Pan3'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Pan4'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Pillow'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Pinball'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Plant1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Plant2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Plant3'.default.bNoSmooth = !bSmartTextureFiltering;
    class'NYPoliceBoat'.default.bNoSmooth = !bSmartTextureFiltering;
    class'PoolBall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Pot1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Pot2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Rat'.default.bNoSmooth = !bSmartTextureFiltering;
    class'RatCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'RetinalScanner'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SatelliteDish'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ShipsWheel'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ShopLight'.default.bNoSmooth = !bSmartTextureFiltering;
    class'HangingShopLight'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ShowerFaucet'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ShowerHead'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SubwayControlPanel'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CrateBreakableMedGeneral'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CrateBreakableMedCombat'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CrateBreakableMedMedical'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Switch1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CrateExplosiveSmall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Phone'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TAD'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Toilet'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Toilet2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TrashCan1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TrashCan2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TrashCan3'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TrashCan4'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TrashBag'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TrashBag2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TrashPaper'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Tree1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Tree2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Tree3'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Tree4'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TreeEvergreen'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Trophy'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Tumbleweed'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CrateUnbreakableLarge'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CrateUnbreakableMed'.default.bNoSmooth = !bSmartTextureFiltering;
    class'CrateUnbreakableSmall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Cart'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Valve'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Vase1'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Vase2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'VendingMachine'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WaterCooler'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WaterFountain'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SignFloor'.default.bNoSmooth = !bSmartTextureFiltering;
    class'LaserTrigger'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BeamTrigger'.default.bNoSmooth = !bSmartTextureFiltering;

    //Pickups
    class'AugmentationCannister'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AugmentationUpgradeCannister'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AugmentationUpgradeCannisterOverdrive'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Credits'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Flare'.default.bNoSmooth = !bSmartTextureFiltering;
    class'LiquorBottle'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Liquor40oz'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WineBottle'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Medkit'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Lockpick'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Multitool'.default.bNoSmooth = !bSmartTextureFiltering;
    class'NanoKeyRing'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BioelectricCell'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModAccuracy'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModAuto'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModClip'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModDamage'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModFullAuto'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModLaser'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModRange'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModRecoil'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModReload'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModRepair'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModScope'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WeaponModSilencer'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SodaCan'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SoyFood'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SoftwareNuke'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SoftwareStop'.default.bNoSmooth = !bSmartTextureFiltering;
    class'VialCrack'.default.bNoSmooth = !bSmartTextureFiltering;
    
    class'AdaptiveArmor'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BallisticArmor'.default.bNoSmooth = !bSmartTextureFiltering;
    class'HazMatSuit'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Rebreather'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TechGoggles'.default.bNoSmooth = !bSmartTextureFiltering;
    
    //Gore
    class'GMDXEffect'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragment'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragmentNub'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragmentSmall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragmentArm'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragmentGuts'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragmentLeg'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragmentAnimal'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragmentSmoking'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragmentBurned'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragmentWall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BloodDrop'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BloodDropFlying'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BloodDropWall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BloodExplodeHit'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BloodMeleeHit'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BloodPool'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BloodSplat'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BloodSpurt'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoneFemur'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoneFemurBloody'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoneFemurBloodyFragment'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoneFemurLessBloody'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoneFemurLessBloodyFragment'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoneSkull'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BoneSkullBloody'.default.bNoSmooth = !bSmartTextureFiltering;

    //Misc
    class'SpyDrone'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SavePoint'.default.bNoSmooth = !bSmartTextureFiltering;
    class'POVCorpse'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Fireball'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FireballRocket'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FlameEffect'.default.bNoSmooth = !bSmartTextureFiltering;
    class'MuzzleFlash'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FireSmoke'.default.bNoSmooth = !bSmartTextureFiltering;
    class'PlasmaParticleSpoof'.default.bNoSmooth = !bSmartTextureFiltering;
    class'GMDXFireSmokeFade'.default.bNoSmooth = !bSmartTextureFiltering;
    class'GMDXSparkFade'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SFXExp'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SFXExplosionLarge'.default.bNoSmooth = !bSmartTextureFiltering;
    class'GMDXImpactSpark'.default.bNoSmooth = !bSmartTextureFiltering;
    class'GMDXImpactSpark2'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TraceHitSpawner'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TraceHitHandSpawner'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TraceHitHandNonPenSpawner'.default.bNoSmooth = !bSmartTextureFiltering;
    class'TraceHitNonPenSpawner'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Tracer'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SniperTracer'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ExplosionLight'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ExplosionLarge'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ExplosionSmall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ExplosionMedium'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ExplosionExtra'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ShockRing'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SphereEffect'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FireballSpoof'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ShockRingProjectile'.default.bNoSmooth = !bSmartTextureFiltering;
    class'RubberBullet'.default.bNoSmooth = !bSmartTextureFiltering;
    class'PoolBall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'PoolTableLight'.default.bNoSmooth = !bSmartTextureFiltering;

    //Decals
    //Don't make these unfiltered, because it's inconsistent, and looks bad.
    class'PlaceableDecal'.default.bNoSmooth = false;
    /*
    class'BloodExplodeHit'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BloodMeleeHit'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BloodPool'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BloodSplat'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BulletHole'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BulletHoleGlass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BurnMark'.default.bNoSmooth = !bSmartTextureFiltering;
    class'GMDXEffect'.default.bNoSmooth = !bSmartTextureFiltering;
    class'PlaceableDecal'.default.bNoSmooth = !bSmartTextureFiltering;
    class'PlasmaParticleSpoof'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ScorchMark'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SpoofedCorona'.default.bNoSmooth = !bSmartTextureFiltering;
    class'SpoofedCoronaSmall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'LightCoronaFlicker'.default.bNoSmooth = !bSmartTextureFiltering;
    */

    //Fragments
    class'PlasticFragment'.default.bNoSmooth = !bSmartTextureFiltering;
    class'MetalFragment'.default.bNoSmooth = !bSmartTextureFiltering;
    class'WoodFragment'.default.bNoSmooth = !bSmartTextureFiltering;
    class'PaperFragment'.default.bNoSmooth = !bSmartTextureFiltering;
    class'GlassFragment'.default.bNoSmooth = !bSmartTextureFiltering;
    class'RockChip'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragment'.default.bNoSmooth = !bSmartTextureFiltering;
    class'FleshFragmentAnimal'.default.bNoSmooth = !bSmartTextureFiltering;

    //Ammo
    class'Ammo10mm'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Ammo10mmAP'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Ammo20mm'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Ammo20mmEMP'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Ammo762mm'.default.bNoSmooth = !bSmartTextureFiltering;
    class'Ammo3006'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoBattery'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoCrate'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoDart'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoDartFlare'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoDartPoison'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoDartTaser'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'AmmoEMPGrenade'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'AmmoGasGrenade'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'AmmoGraySpit'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'AmmoGreaselSpit'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'AmmoHideAGun'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'AmmoLAM'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'AmmoLAW'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'AmmoNanoVirusGrenade'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoNapalm'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'AmmoNone'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoPepper'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoPlasma'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoPlasmaSuperheated'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoRocket'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'AmmoRocketMini'.default.bNoSmooth = !bSmartTextureFiltering;
    //class'AmmoRocketRobot'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoRocketWP'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoRubber'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoSabot'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoShell'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmmoShuriken'.default.bNoSmooth = !bSmartTextureFiltering;

    /*
    //Characters and Carcasses
    class'AlexJacobson'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AlexJacobsonCarcass'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AnnaNavarre'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AnnaNavarreCarcass'.default.bNoSmooth = !bSmartTextureFiltering;

    class'TerroristCarcass'.default.bNoSmooth = !bSmartTextureFiltering;

    //Pickups
    class'AdaptiveArmor'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AugmentationCannister'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AugmentationUpgradeCannister'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AugmentationUpgradeCannisterOverdrive'.default.bNoSmooth = !bSmartTextureFiltering;
    class'BallisticArmor'.default.bNoSmooth = !bSmartTextureFiltering;


    //Decorations and Misc
    class'AcousticSensor'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AIPrototype'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AirBubble'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AlarmUnit'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AlarmLight'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AmbrosiaPool'.default.bNoSmooth = !bSmartTextureFiltering;
    class'ATM'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AttackHelicopter'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AutoTurret'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AutoTurretGun'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AutoTurretSmall'.default.bNoSmooth = !bSmartTextureFiltering;
    class'AutoTurretGunSmall'.default.bNoSmooth = !bSmartTextureFiltering;
    */
}

defaultproperties
{
    bSmartTextureFiltering=true
}
