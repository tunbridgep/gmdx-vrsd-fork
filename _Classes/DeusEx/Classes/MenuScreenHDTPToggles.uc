//=============================================================================
// MenuScreenHDTPToggles                                                        //RSD: Adapted from MenuScreenCustomizeKeys.uc so I can steal the scrolling window
//=============================================================================

class MenuScreenHDTPToggles expands MenuScreenListWindow;

//Update Models
function SaveSettings()
{
    Super.SaveSettings();
    player.HDTP();
}

event bool ListRowActivated(window list, int rowId)
{
    Super.ListRowActivated(list,rowId);
    player.HDTP();
}

//We can't use console commands anymore, now we have to use player variables instead, because
//Deus Ex doesn't actually load classes unless they are instantiated in the world, so using 'get'
//will return "unknown class" even if the class name is correct.
//So instead, we're going to store everything on the player like chumps.
//We have to use DynamicLoadObject here, which abslutely fucking sucks...
//I hate Unreal....
function int GetConsoleValue(int index)
{
    local string strClassName;
    local class<Actor> A;
    
    strClassName = items[index].consoleTarget;

    //DISGUSTING!
    A = class<Actor>(DynamicLoadObject(strClassName, class'Class', true));

    //If we aren't a scriptedpawn, just do the default thing
    if (A == None || class<ScriptedPawn>(A) == None)
        return super.GetConsoleValue(index);
        
    return class<ScriptedPawn>(A).default.iHDTPModelToggle;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     strHeaderActionLabel="Object"
     strHeaderAssignedLabel="Model"
     HelpText="Select the model you wish to change and then press [Enter] or Double-Click to cycle through available models"
     Items(0)=(actionText="HDTP Enabled",variable="bHDTPEnabled",consoleTarget="DeusEx.DeusExPlayer",HelpText="Global toggle for HDTP models and textures.",defaultValue=1,valueText0="Off",valueText1="On")
     Items(1)=(actionText="Force HDTP Muzzle Flashes",helpText="Use HDTP muzzle flashes on Vanilla Weapons",valueText0="Disabled",valueText1="Enabled",consoleTarget="DeusEx.DeusExWeapon",variable="bHDTPMuzzleFlashes")
     Items(2)=(actionText="JC Denton",consoleTarget="DeusEx.DeusExPlayer")
     Items(3)=(actionText="Paul Denton",consoleTarget="DeusEx.PaulDenton")
     Items(4)=(actionText="Gunther Hermann",consoleTarget="DeusEx.GuntherHermann")
     Items(5)=(actionText="Anna Navarre",consoleTarget="DeusEx.AnnaNavarre")
     Items(6)=(actionText="Nicolette DuClare",consoleTarget="DeusEx.NicoletteDuclare")
     Items(7)=(actionText="NSF Terrorist",consoleTarget="DeusEx.Terrorist")
     Items(8)=(actionText="Riot Cop",consoleTarget="DeusEx.RiotCop")
     Items(9)=(actionText="Walton Simons",consoleTarget="DeusEx.WaltonSimons")
     Items(10)=(actionText="UNATCO Trooper",consoleTarget="DeusEx.UnatcoTroop")
     //items(11)=(actionText="MJ12 Trooper",consoleTarget="DeusEx.MJ12Troop");
     Items(11)=(actionText="Cleaner Bot",defaultValue=1,consoleTarget="DeusEx.CleanerBot")
     Items(12)=(actionText="Military Bot",defaultValue=1,consoleTarget="DeusEx.MilitaryBot")
     Items(13)=(actionText="Medical Bot",defaultValue=1,consoleTarget="DeusEx.MedicalBot")
     Items(14)=(actionText="Repair Bot",defaultValue=1,consoleTarget="DeusEx.RepairBot")
     Items(15)=(actionText="Security Bot (Large)",defaultValue=1,consoleTarget="DeusEx.SecurityBot2")
     Items(16)=(actionText="Security Bot (Small)",defaultValue=1,consoleTarget="DeusEx.SecurityBot3")
     Items(17)=(actionText="Spider Bot 1",defaultValue=1,consoleTarget="DeusEx.SpiderBot")
     Items(18)=(actionText="Spider Bot (Mini)",defaultValue=1,consoleTarget="DeusEx.SpiderBot2")
     Items(19)=(actionText="Spider Bot (Mini #2)",defaultValue=1,consoleTarget="DeusEx.SpiderBot3")
     Items(20)=(actionText="Spider Bot (Mini #3)",defaultValue=1,consoleTarget="DeusEx.SpiderBot4")
     Items(21)=(actionText="Gray",defaultValue=1,consoleTarget="DeusEx.Gray")
     Items(22)=(actionText="Greasel",defaultValue=1,consoleTarget="DeusEx.Greasel")
     Items(23)=(actionText="Karkian",defaultValue=1,consoleTarget="DeusEx.Karkian")
     Items(24)=(actionText="Auto Turret",defaultValue=1,consoleTarget="DeusEx.AutoTurret")
     Items(25)=(actionText="Assault Gun",defaultValue=1,consoleTarget="DeusEx.WeaponAssaultGun")
     Items(26)=(actionText="Assault Shotgun",defaultValue=1,consoleTarget="DeusEx.WeaponAssaultShotgun")
     Items(27)=(actionText="Baton",consoleTarget="DeusEx.WeaponBaton")
     Items(28)=(actionText="Combat Knife",defaultValue=1,consoleTarget="DeusEx.WeaponCombatKnife")
     Items(29)=(actionText="Crowbar",defaultValue=1,consoleTarget="DeusEx.WeaponCrowbar")
     Items(30)=(actionText="EMP Grenade",consoleTarget="DeusEx.WeaponEMPGrenade")
     Items(31)=(actionText="Flamethrower",defaultValue=1,consoleTarget="DeusEx.WeaponFlamethrower")
     Items(32)=(actionText="Gas Grenade",consoleTarget="DeusEx.WeaponGasGrenade")
     Items(33)=(actionText="GEP Gun",defaultValue=1,consoleTarget="DeusEx.WeaponGEPGun")
     Items(34)=(actionText="LAM",consoleTarget="DeusEx.WeaponLAM")
     Items(35)=(actionText="LAW",defaultValue=1,consoleTarget="DeusEx.WeaponLAW")
     Items(36)=(actionText="Mini-Crossbow",defaultValue=1,consoleTarget="DeusEx.WeaponMiniCrossbow")
     Items(37)=(actionText="Dragons Tooth Sword",defaultValue=1,consoleTarget="DeusEx.WeaponNanoSword")
     Items(38)=(actionText="Scramble Grenade",consoleTarget="DeusEx.WeaponNanoVirusGrenade")
     Items(39)=(actionText="Pepper Spray",defaultValue=1,consoleTarget="DeusEx.WeaponPepperGun")
     Items(40)=(actionText="Pistol",defaultValue=1,consoleTarget="DeusEx.WeaponPistol")
     Items(41)=(actionText="Plasma Rifle",defaultValue=1,consoleTarget="DeusEx.WeaponPlasmaRifle")
     Items(42)=(actionText="Riot Prod",consoleTarget="DeusEx.WeaponProd")
     Items(43)=(actionText="Sniper Rifle",valueText2="FOMOD Beta",defaultValue=1,consoleTarget="DeusEx.WeaponRifle")
     Items(44)=(actionText="Sawed-Off Shotgun",valueText2="FOMOD Beta",defaultValue=2,consoleTarget="DeusEx.WeaponSawedOffShotgun")
     Items(45)=(actionText="Stealth Pistol",valueText2="FOMOD Beta",defaultValue=1,consoleTarget="DeusEx.WeaponStealthPistol")
     Items(46)=(actionText="Sword",defaultValue=1,consoleTarget="DeusEx.WeaponSword")
     Items(47)=(actionText="Throwing Knives",defaultValue=1,consoleTarget="DeusEx.WeaponShuriken")
     Items(48)=(actionText="AI Prototype",defaultValue=1,consoleTarget="DeusEx.AIPrototype")
     Items(49)=(actionText="Alarm Unit",defaultValue=1,consoleTarget="DeusEx.AlarmUnit")
     Items(50)=(actionText="Alarm Light",defaultValue=1,consoleTarget="DeusEx.AlarmLight")
     Items(51)=(actionText="Ambrosia Container",defaultValue=1,consoleTarget="DeusEx.BarrelAmbrosia")
     Items(52)=(actionText="Augmentation Canister",defaultValue=1,consoleTarget="DeusEx.AugmentationCannister")
     Items(53)=(actionText="Augmentation Upgrade",defaultValue=1,consoleTarget="DeusEx.AugmentationUpgradeCannister")
     //Items(54)=(actionText="Augmentation Override",defaultValue=1,consoleTarget="DeusEx.AugmentationUpgradeCannisterOverdrive")
     Items(54)=(actionText="Barrel",defaultValue=1,consoleTarget="DeusEx.Barrel1")
     Items(55)=(actionText="Barrel (Flaming)",defaultValue=1,consoleTarget="DeusEx.BarrelFire")
     Items(56)=(actionText="Basket",defaultValue=1,consoleTarget="DeusEx.Basket")
     Items(57)=(actionText="Basketball",defaultValue=1,consoleTarget="DeusEx.Basketball")
     Items(58)=(actionText="Bench 1",defaultValue=1,consoleTarget="DeusEx.WHBenchEast")
     Items(59)=(actionText="Bench 2",defaultValue=1,consoleTarget="DeusEx.WHBenchLibrary")
     Items(60)=(actionText="Bone (Femur)",defaultValue=1,consoleTarget="DeusEx.BoneFemur")
     Items(61)=(actionText="Bone (Femur 2)",defaultValue=1,consoleTarget="DeusEx.BoneFemurBloody")
     Items(62)=(actionText="Binoculars",defaultValue=1,consoleTarget="DeusEx.Binoculars")
     Items(63)=(actionText="Book (Open)",defaultValue=1,consoleTarget="DeusEx.BookOpen")
     Items(64)=(actionText="Book (Closed)",valueText2="HDTP (Extended Covers)",defaultValue=2,consoleTarget="DeusEx.BookClosed")
     Items(65)=(actionText="Book (Newspaper)",defaultValue=1,consoleTarget="DeusEx.Newspaper")
     Items(66)=(actionText="Button",defaultValue=1,consoleTarget="DeusEx.Button1")
     Items(67)=(actionText="Candy Bar",defaultValue=1,consoleTarget="DeusEx.Candybar")
     Items(68)=(actionText="Cage Light",defaultValue=1,consoleTarget="DeusEx.CageLight")
     Items(69)=(actionText="Cardboard Box (Large)",defaultValue=1,consoleTarget="DeusEx.BoxLarge")
     Items(70)=(actionText="Cardboard Box (Medium)",defaultValue=1,consoleTarget="DeusEx.BoxMedium")
     Items(71)=(actionText="Cardboard Box (Small)",defaultValue=1,consoleTarget="DeusEx.BoxSmall")
     Items(72)=(actionText="Cat",defaultValue=1,consoleTarget="DeusEx.Cat")
     Items(73)=(actionText="Chair",defaultValue=1,consoleTarget="DeusEx.Chair1")
     Items(74)=(actionText="Chair (Leather)",defaultValue=1,consoleTarget="DeusEx.ChairLeather")
     Items(75)=(actionText="Chair (Swivel Chair)",defaultValue=1,consoleTarget="DeusEx.OfficeChair")
     Items(76)=(actionText="Chair (Dining Chair)",defaultValue=1,consoleTarget="DeusEx.WHChairDining")
     Items(77)=(actionText="Chair (Fancy)",defaultValue=1,consoleTarget="DeusEx.WHChairOvalOffice")
     Items(78)=(actionText="Cigarettes",defaultValue=1,consoleTarget="DeusEx.Cigarettes")
     Items(79)=(actionText="Cigarette Machine",defaultValue=1,consoleTarget="DeusEx.CigaretteMachine")
     Items(80)=(actionText="Computer (Personal)",defaultValue=1,consoleTarget="DeusEx.ComputerPersonal")
     Items(81)=(actionText="Computer (Security)",defaultValue=1,consoleTarget="DeusEx.ComputerSecurity")
     Items(82)=(actionText="Computer (ATM)",defaultValue=1,consoleTarget="DeusEx.ATM")
     Items(83)=(actionText="Concrete Barricade",defaultValue=1,consoleTarget="DeusEx.RoadBlock")
     Items(84)=(actionText="Control Panel",defaultValue=1,consoleTarget="DeusEx.ControlPanel")
     Items(85)=(actionText="Couch (Leather)",defaultValue=1,consoleTarget="DeusEx.CouchLeather")
     Items(86)=(actionText="Couch (Red)",defaultValue=1,consoleTarget="DeusEx.WHRedCouch")
     Items(87)=(actionText="Credit Chit",defaultValue=1,consoleTarget="DeusEx.Credits")
     Items(88)=(actionText="Cushion",defaultValue=1,consoleTarget="DeusEx.Cushion")
     Items(89)=(actionText="Data Cube",defaultValue=1,consoleTarget="DeusEx.DataCube")
     Items(90)=(actionText="Earth",defaultValue=1,consoleTarget="DeusEx.Earth")
     Items(91)=(actionText="Fan 1",defaultValue=1,consoleTarget="DeusEx.Fan1")
     Items(92)=(actionText="Fan 2",defaultValue=1,consoleTarget="DeusEx.Fan2")
     Items(93)=(actionText="Fan 3",defaultValue=1,consoleTarget="DeusEx.Fan1Vertical")
     Items(94)=(actionText="Fan (Ceiling Fan)",defaultValue=1,consoleTarget="DeusEx.CeilingFan")
     Items(95)=(actionText="Faucet",defaultValue=1,consoleTarget="DeusEx.Faucet")
     Items(96)=(actionText="Fire Plug",defaultValue=1,consoleTarget="DeusEx.FirePlug")
     Items(97)=(actionText="Flag Pole",defaultValue=1,consoleTarget="DeusEx.FlagPole")
     Items(98)=(actionText="Flare",defaultValue=1,consoleTarget="DeusEx.Flare")
     Items(99)=(actionText="Flower Pot",defaultValue=1,consoleTarget="DeusEx.Flowers")
     Items(100)=(actionText="Keypad 1",defaultValue=1,consoleTarget="DeusEx.Keypad1")
     Items(101)=(actionText="Keypad 2",defaultValue=1,consoleTarget="DeusEx.Keypad2")
     Items(102)=(actionText="Keypad 3",defaultValue=1,consoleTarget="DeusEx.Keypad3")
     Items(103)=(actionText="Lab Flask",defaultValue=1,consoleTarget="DeusEx.Flask")
     Items(104)=(actionText="Lamp 1",defaultValue=1,consoleTarget="DeusEx.Lamp1")
     Items(105)=(actionText="Lamp 2",defaultValue=1,consoleTarget="DeusEx.Lamp2")
     Items(106)=(actionText="Lamp 3",defaultValue=1,consoleTarget="DeusEx.Lamp3")
     Items(107)=(actionText="Light Bulb",defaultValue=1,consoleTarget="DeusEx.LightBulb")
     Items(108)=(actionText="Light Switch",defaultValue=1,consoleTarget="DeusEx.LightSwitch")
     Items(109)=(actionText="Liquor",defaultValue=1,consoleTarget="DeusEx.LiquorBottle")
     Items(110)=(actionText="Liquor (Forty)",defaultValue=1,consoleTarget="DeusEx.Liquor40oz")
     Items(111)=(actionText="Liquor (Wine)",defaultValue=1,consoleTarget="DeusEx.WineBottle")
     Items(112)=(actionText="Mailbox",defaultValue=1,consoleTarget="DeusEx.Mailbox")
     Items(113)=(actionText="Medical Kit",defaultValue=1,consoleTarget="DeusEx.MedKit")
     Items(114)=(actionText="Microscope",defaultValue=1,consoleTarget="DeusEx.Microscope")
     Items(115)=(actionText="Nanovirus Container",defaultValue=1,consoleTarget="DeusEx.BarrelVirus")
     Items(116)=(actionText="Pan 1",defaultValue=1,consoleTarget="DeusEx.Pan1")
     Items(117)=(actionText="Pan 2",defaultValue=1,consoleTarget="DeusEx.Pan2")
     Items(118)=(actionText="Pan 3",defaultValue=1,consoleTarget="DeusEx.Pan3")
     Items(119)=(actionText="Pan 4",defaultValue=1,consoleTarget="DeusEx.Pan4")
     Items(120)=(actionText="Pillow",defaultValue=1,consoleTarget="DeusEx.Pillow")
     Items(121)=(actionText="Pinball Machine",defaultValue=1,consoleTarget="DeusEx.Pinball")
     Items(122)=(actionText="Plant 1",defaultValue=1,consoleTarget="DeusEx.Plant1")
     Items(123)=(actionText="Plant 2",defaultValue=1,consoleTarget="DeusEx.Plant2")
     Items(124)=(actionText="Plant 3",defaultValue=1,consoleTarget="DeusEx.Plant3")
     Items(125)=(actionText="Police Boat",defaultValue=1,consoleTarget="DeusEx.NYPoliceBoat")
     Items(126)=(actionText="Pool Ball",defaultValue=1,consoleTarget="DeusEx.PoolBall")
     Items(127)=(actionText="Pot 1",defaultValue=1,consoleTarget="DeusEx.Pot1")
     Items(128)=(actionText="Pot 2",defaultValue=1,consoleTarget="DeusEx.Pot2")
     Items(129)=(actionText="Rat",defaultValue=1,consoleTarget="DeusEx.Rat")
     Items(130)=(actionText="Retinal Scanner",defaultValue=1,consoleTarget="DeusEx.RetinalScanner")
     Items(131)=(actionText="Satellite Dish",defaultValue=1,consoleTarget="DeusEx.SatelliteDish")
     Items(132)=(actionText="Ships Wheel",defaultValue=1,consoleTarget="DeusEx.ShipsWheel")
     Items(133)=(actionText="Shop Light",defaultValue=1,consoleTarget="DeusEx.Shoplight")
     Items(134)=(actionText="Shop Light (Hanging)",defaultValue=1,consoleTarget="DeusEx.HangingShopLight")
     Items(135)=(actionText="Shower Faucet",defaultValue=1,consoleTarget="DeusEx.ShowerFaucet")
     Items(136)=(actionText="Shower Head",defaultValue=1,consoleTarget="DeusEx.ShowerHead")
     Items(137)=(actionText="Soda Can",defaultValue=1,consoleTarget="DeusEx.SodaCan")
     Items(138)=(actionText="Software (Nuke)",defaultValue=1,consoleTarget="DeusEx.SoftwareNuke")
     Items(139)=(actionText="Software (Worm)",defaultValue=1,consoleTarget="DeusEx.SoftwareStop")
     Items(140)=(actionText="Soy Food",defaultValue=1,consoleTarget="DeusEx.SoyFood")
     Items(141)=(actionText="Subway Control Panel",defaultValue=1,consoleTarget="DeusEx.SubwayControlPanel")
     Items(142)=(actionText="Supply Crate (General)",defaultValue=1,consoleTarget="DeusEx.CrateBreakableMedGeneral")
     Items(143)=(actionText="Supply Crate (Combat)",defaultValue=1,consoleTarget="DeusEx.CrateBreakableMedCombat")
     Items(144)=(actionText="Supply Crate (Medical)",defaultValue=1,consoleTarget="DeusEx.CrateBreakableMedMedical")
     Items(145)=(actionText="Switch",defaultValue=1,consoleTarget="DeusEx.Switch1")
     Items(146)=(actionText="TNT Crate",defaultValue=1,consoleTarget="DeusEx.CrateExplosiveSmall")
     Items(147)=(actionText="Telephone",defaultValue=1,consoleTarget="DeusEx.Phone")
     Items(148)=(actionText="Telephone Answering Machine",defaultValue=1,consoleTarget="DeusEx.TAD")
     Items(149)=(actionText="Toilet",defaultValue=1,consoleTarget="DeusEx.Toilet")
     Items(150)=(actionText="Toilet (Urinal)",defaultValue=1,consoleTarget="DeusEx.Toilet2")
     Items(151)=(actionText="Trashcan 1",defaultValue=1,consoleTarget="DeusEx.TrashCan1")
     Items(152)=(actionText="Trashcan 2",defaultValue=1,consoleTarget="DeusEx.TrashCan2")
     Items(153)=(actionText="Trashcan 3",defaultValue=1,consoleTarget="DeusEx.TrashCan3")
     Items(154)=(actionText="Trashcan 4",defaultValue=1,consoleTarget="DeusEx.TrashCan4")
     Items(155)=(actionText="Trashbag 1",defaultValue=1,consoleTarget="DeusEx.Trashbag")
     Items(156)=(actionText="Trashbag 2",defaultValue=1,consoleTarget="DeusEx.Trashbag2")
     //Items(157)=(actionText="Trash (Paper)",defaultValue=1,consoleTarget="DeusEx.TrashPaper")
     Items(157)=(actionText="Tree 1",defaultValue=1,consoleTarget="DeusEx.Tree1",valueText1="HDTP (Optimised)",valueText2="HDTP")
     Items(158)=(actionText="Tree 2",defaultValue=1,consoleTarget="DeusEx.Tree2",valueText1="HDTP (Optimised)",valueText2="HDTP")
     Items(159)=(actionText="Tree 3",defaultValue=1,consoleTarget="DeusEx.Tree3",valueText1="HDTP (Optimised)",valueText2="HDTP")
     Items(160)=(actionText="Tree 4",defaultValue=1,consoleTarget="DeusEx.Tree4",valueText1="HDTP (Optimised)",valueText2="HDTP")
     Items(161)=(actionText="Tree (Evergreen)",defaultValue=1,consoleTarget="DeusEx.TreeEvergreen",valueText1="HDTP (Optimised)",valueText2="HDTP")
     Items(162)=(actionText="Trophy",defaultValue=1,consoleTarget="DeusEx.Trophy")
     Items(163)=(actionText="Tumbleweed",defaultValue=1,consoleTarget="DeusEx.Tumbleweed")
     Items(164)=(actionText="Unbreakable Crate (Large)",defaultValue=1,consoleTarget="DeusEx.CrateUnbreakableLarge")
     Items(165)=(actionText="Unbreakable Crate (Medium)",defaultValue=1,consoleTarget="DeusEx.CrateUnbreakableMed")
     Items(166)=(actionText="Unbreakable Crate (Small)",defaultValue=1,consoleTarget="DeusEx.CrateUnbreakableSmall")
     Items(167)=(actionText="Utility Push-Cart",defaultValue=1,consoleTarget="DeusEx.Cart")
     Items(168)=(actionText="Valve",defaultValue=1,consoleTarget="DeusEx.Valve")
     Items(169)=(actionText="Vase 1",defaultValue=1,consoleTarget="DeusEx.Vase1")
     Items(170)=(actionText="Vase 2",defaultValue=1,consoleTarget="DeusEx.Vase2")
     Items(171)=(actionText="Vending Machine",defaultValue=1,consoleTarget="DeusEx.VendingMachine")
     Items(172)=(actionText="Water Cooler",defaultValue=1,consoleTarget="DeusEx.WaterCooler")
     Items(173)=(actionText="Water Fountain",defaultValue=1,consoleTarget="DeusEx.WaterFountain")
     Items(174)=(actionText="Wet Floor Sign",defaultValue=1,consoleTarget="DeusEx.SignFloor")
     Items(175)=(actionText="10mm Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo10mm")
     Items(176)=(actionText="10mm AP Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo10mmAP")
     Items(177)=(actionText="20mm Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo20mm")
     Items(178)=(actionText="20mm EMP Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo20mmEMP")
     Items(179)=(actionText="762mm Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo762mm")
     Items(180)=(actionText="3006 Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo3006")
     Items(181)=(actionText="Darts",defaultValue=1,consoleTarget="DeusEx.AmmoDart")
     Items(182)=(actionText="Darts (Flare)",defaultValue=1,consoleTarget="DeusEx.AmmoDartFlare")
     Items(183)=(actionText="Darts (Poison)",defaultValue=1,consoleTarget="DeusEx.AmmoDartPoison")
     Items(184)=(actionText="Darts (Taser)",defaultValue=1,consoleTarget="DeusEx.AmmoDartTaser")
     Items(185)=(actionText="Napalm",defaultValue=1,consoleTarget="DeusEx.AmmoNapalm")
     Items(186)=(actionText="Plasma Ammo",defaultValue=1,consoleTarget="DeusEx.AmmoPlasma")
     Items(187)=(actionText="Prod Charger",defaultValue=1,consoleTarget="DeusEx.AmmoBattery")
     Items(188)=(actionText="Rockets",defaultValue=1,consoleTarget="DeusEx.AmmoRocket")
     Items(189)=(actionText="WP Rockets",defaultValue=1,consoleTarget="DeusEx.AmmoRocketWP")
     Items(190)=(actionText="Shells",defaultValue=1,consoleTarget="DeusEx.AmmoShell")
     Items(191)=(actionText="Shells (Sabot)",defaultValue=1,consoleTarget="DeusEx.AmmoSabot")
     Items(192)=(actionText="Shells (Rubber)",defaultValue=1,consoleTarget="DeusEx.AmmoRubber")
     Items(193)=(actionText="Blood and Decals",defaultValue=1,consoleTarget="DeusEx.DeusExDecal")
     Items(194)=(actionText="Fragments",defaultValue=1,consoleTarget="DeusEx.DeusExFragment")
     Title="HDTP Model Options"
     disabledText="Vanilla"
     enabledText="HDTP"
     variable="iHDTPModelToggle"
}
