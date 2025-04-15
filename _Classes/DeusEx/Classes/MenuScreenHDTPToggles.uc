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
    player.HDTP(true);
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
     strHeaderSettingLabel="Object"
     strHeaderValueLabel="Model"
     HelpText="Select the model you wish to change and then press [Enter] or Double-Click to cycle through available models"
     Items(0)=(actionText="HDTP Enabled",variable="bHDTPEnabled",consoleTarget="DeusEx.DeusExPlayer",HelpText="Global toggle for HDTP models and textures.",defaultValue=1,valueText0="Off",valueText1="On",sortcategory="00TOP0")
     Items(1)=(actionText="Force HDTP Muzzle Flashes",helpText="Use HDTP muzzle flashes on Vanilla Weapons",valueText0="Disabled",valueText1="Enabled",consoleTarget="DeusEx.DeusExWeapon",variable="bHDTPMuzzleFlashes",sortcategory="00TOP1")
     Items(2)=(actionText="Blood and Decals",defaultValue=1,consoleTarget="DeusEx.DeusExDecal",sortcategory="00TOP2")
     Items(3)=(actionText="Fragments",defaultValue=1,consoleTarget="DeusEx.DeusExFragment",sortcategory="00TOP2")
     Items(4)=(actionText="JC Denton",consoleTarget="DeusEx.DeusExPlayer",sortcategory="0AAA")
     Items(5)=(actionText="Paul Denton",consoleTarget="DeusEx.PaulDenton",sortcategory="0AAA")
     Items(6)=(actionText="Gunther Hermann",consoleTarget="DeusEx.GuntherHermann",sortcategory="0AAA")
     Items(7)=(actionText="Anna Navarre",consoleTarget="DeusEx.AnnaNavarre",sortcategory="0AAA")
     Items(8)=(actionText="Nicolette DuClare",consoleTarget="DeusEx.NicoletteDuclare",sortcategory="0AAA")
     Items(9)=(actionText="NSF Terrorist",consoleTarget="DeusEx.Terrorist",sortcategory="0AAA")
     Items(10)=(actionText="Riot Cop",consoleTarget="DeusEx.RiotCop",sortcategory="0AAA")
     Items(11)=(actionText="Walton Simons",consoleTarget="DeusEx.WaltonSimons",sortcategory="0AAA")
     Items(12)=(actionText="UNATCO Trooper",consoleTarget="DeusEx.UnatcoTroop",sortcategory="0AAA")
     //items(13)=(actionText="MJ12 Trooper",consoleTarget="DeusEx.MJ12Troop",sortcategory="0AAA");
     Items(13)=(actionText="Cleaner Bot",defaultValue=1,consoleTarget="DeusEx.CleanerBot",sortcategory="0AAB")
     Items(14)=(actionText="Military Bot",defaultValue=1,consoleTarget="DeusEx.MilitaryBot",sortcategory="0AAB")
     Items(15)=(actionText="Medical Bot",defaultValue=1,consoleTarget="DeusEx.MedicalBot",sortcategory="0AAB")
     Items(16)=(actionText="Repair Bot",defaultValue=1,consoleTarget="DeusEx.RepairBot",sortcategory="0AAB")
     Items(17)=(actionText="Security Bot (Large)",defaultValue=1,consoleTarget="DeusEx.SecurityBot2",sortcategory="0AAB")
     Items(18)=(actionText="Security Bot (Small)",defaultValue=1,consoleTarget="DeusEx.SecurityBot3",sortcategory="0AAB")
     Items(19)=(actionText="Spider Bot 1",defaultValue=1,consoleTarget="DeusEx.SpiderBot",sortcategory="0AAB")
     Items(20)=(actionText="Spider Bot (Mini)",defaultValue=1,consoleTarget="DeusEx.SpiderBot2",sortcategory="0AAB")
     Items(21)=(actionText="Spider Bot (Mini #2)",defaultValue=1,consoleTarget="DeusEx.SpiderBot3",sortcategory="0AAB")
     Items(22)=(actionText="Spider Bot (Mini #3)",defaultValue=1,consoleTarget="DeusEx.SpiderBot4",sortcategory="0AAB")
     Items(23)=(actionText="Gray",defaultValue=1,consoleTarget="DeusEx.Gray",sortcategory="0AAB")
     Items(24)=(actionText="Greasel",defaultValue=1,consoleTarget="DeusEx.Greasel",sortcategory="0AAB")
     Items(25)=(actionText="Karkian",defaultValue=1,consoleTarget="DeusEx.Karkian",sortcategory="0AAB")
     Items(26)=(actionText="Auto Turret",defaultValue=1,consoleTarget="DeusEx.AutoTurret",sortcategory="0AAB")
     Items(27)=(actionText="Assault Gun",defaultValue=1,consoleTarget="DeusEx.WeaponAssaultGun",sortcategory="0BAA")
     Items(28)=(actionText="Assault Shotgun",defaultValue=1,consoleTarget="DeusEx.WeaponAssaultShotgun",sortcategory="0BAA")
     Items(29)=(actionText="Baton",consoleTarget="DeusEx.WeaponBaton",sortcategory="0BAA")
     Items(30)=(actionText="Combat Knife",defaultValue=1,consoleTarget="DeusEx.WeaponCombatKnife",sortcategory="0BAA")
     Items(31)=(actionText="Crowbar",defaultValue=1,consoleTarget="DeusEx.WeaponCrowbar",sortcategory="0BAA")
     Items(32)=(actionText="EMP Grenade",consoleTarget="DeusEx.WeaponEMPGrenade",sortcategory="0BAA")
     Items(33)=(actionText="Flamethrower",defaultValue=1,consoleTarget="DeusEx.WeaponFlamethrower",sortcategory="0BAA")
     Items(34)=(actionText="Gas Grenade",consoleTarget="DeusEx.WeaponGasGrenade",sortcategory="0BAA")
     Items(35)=(actionText="GEP Gun",defaultValue=1,consoleTarget="DeusEx.WeaponGEPGun",sortcategory="0BAA")
     Items(36)=(actionText="LAM",consoleTarget="DeusEx.WeaponLAM",sortcategory="0BAA")
     Items(37)=(actionText="LAW",defaultValue=1,consoleTarget="DeusEx.WeaponLAW",sortcategory="0BAA")
     Items(38)=(actionText="Mini-Crossbow",defaultValue=1,consoleTarget="DeusEx.WeaponMiniCrossbow",sortcategory="0BAA")
     Items(39)=(actionText="Dragons Tooth Sword",defaultValue=1,consoleTarget="DeusEx.WeaponNanoSword",sortcategory="0BAA")
     Items(40)=(actionText="Scramble Grenade",consoleTarget="DeusEx.WeaponNanoVirusGrenade",sortcategory="0BAA")
     Items(41)=(actionText="Pepper Spray",defaultValue=1,consoleTarget="DeusEx.WeaponPepperGun",sortcategory="0BAA")
     Items(42)=(actionText="Pistol",defaultValue=1,consoleTarget="DeusEx.WeaponPistol",sortcategory="0BAA")
     Items(43)=(actionText="Plasma Rifle",defaultValue=1,consoleTarget="DeusEx.WeaponPlasmaRifle",sortcategory="0BAA")
     Items(44)=(actionText="Riot Prod",consoleTarget="DeusEx.WeaponProd",sortcategory="0BAA")
     Items(45)=(actionText="Sniper Rifle",valueText2="FOMOD Beta",defaultValue=1,consoleTarget="DeusEx.WeaponRifle",sortcategory="0BAA")
     Items(46)=(actionText="Sawed-Off Shotgun",valueText2="FOMOD Beta",defaultValue=2,consoleTarget="DeusEx.WeaponSawedOffShotgun",sortcategory="0BAA")
     Items(47)=(actionText="Stealth Pistol",valueText2="FOMOD Beta",defaultValue=1,consoleTarget="DeusEx.WeaponStealthPistol",sortcategory="0BAA")
     Items(48)=(actionText="Sword",defaultValue=1,consoleTarget="DeusEx.WeaponSword",sortcategory="0BAA")
     Items(49)=(actionText="Throwing Knives",defaultValue=1,consoleTarget="DeusEx.WeaponShuriken",sortcategory="0BAA")
     Items(50)=(actionText="AI Prototype",defaultValue=1,consoleTarget="DeusEx.AIPrototype")
     Items(51)=(actionText="Alarm Unit",defaultValue=1,consoleTarget="DeusEx.AlarmUnit")
     Items(52)=(actionText="Alarm Light",defaultValue=1,consoleTarget="DeusEx.AlarmLight")
     Items(53)=(actionText="Ambrosia Container",defaultValue=1,consoleTarget="DeusEx.BarrelAmbrosia")
     Items(54)=(actionText="Augmentation Canister",defaultValue=1,consoleTarget="DeusEx.AugmentationCannister")
     Items(55)=(actionText="Augmentation Upgrade",defaultValue=1,consoleTarget="DeusEx.AugmentationUpgradeCannister")
     //Items(56)=(actionText="Augmentation Override",defaultValue=1,consoleTarget="DeusEx.AugmentationUpgradeCannisterOverdrive")
     Items(56)=(actionText="Barrel",defaultValue=1,consoleTarget="DeusEx.Barrel1")
     Items(57)=(actionText="Barrel (Flaming)",defaultValue=1,consoleTarget="DeusEx.BarrelFire")
     Items(58)=(actionText="Basket",defaultValue=1,consoleTarget="DeusEx.Basket")
     Items(59)=(actionText="Basketball",defaultValue=1,consoleTarget="DeusEx.Basketball")
     Items(60)=(actionText="Bench 1",defaultValue=1,consoleTarget="DeusEx.WHBenchEast")
     Items(61)=(actionText="Bench 2",defaultValue=1,consoleTarget="DeusEx.WHBenchLibrary")
     Items(62)=(actionText="Bone (Femur)",defaultValue=1,consoleTarget="DeusEx.BoneFemur")
     Items(63)=(actionText="Bone (Femur 2)",defaultValue=1,consoleTarget="DeusEx.BoneFemurBloody")
     Items(64)=(actionText="Binoculars",defaultValue=1,consoleTarget="DeusEx.Binoculars")
     Items(65)=(actionText="Book (Open)",defaultValue=1,consoleTarget="DeusEx.BookOpen")
     Items(66)=(actionText="Book (Closed)",valueText2="HDTP (Extended Covers)",defaultValue=2,consoleTarget="DeusEx.BookClosed")
     Items(67)=(actionText="Book (Newspaper)",defaultValue=1,consoleTarget="DeusEx.Newspaper")
     Items(68)=(actionText="Button",defaultValue=1,consoleTarget="DeusEx.Button1")
     Items(69)=(actionText="Candy Bar",defaultValue=1,consoleTarget="DeusEx.Candybar")
     Items(70)=(actionText="Cage Light",defaultValue=1,consoleTarget="DeusEx.CageLight")
     Items(71)=(actionText="Cardboard Box (Large)",defaultValue=1,consoleTarget="DeusEx.BoxLarge")
     Items(72)=(actionText="Cardboard Box (Medium)",defaultValue=1,consoleTarget="DeusEx.BoxMedium")
     Items(73)=(actionText="Cardboard Box (Small)",defaultValue=1,consoleTarget="DeusEx.BoxSmall")
     Items(74)=(actionText="Cat",defaultValue=1,consoleTarget="DeusEx.Cat")
     Items(75)=(actionText="Chair",defaultValue=1,consoleTarget="DeusEx.Chair1")
     Items(76)=(actionText="Chair (Leather)",defaultValue=1,consoleTarget="DeusEx.ChairLeather")
     Items(77)=(actionText="Chair (Swivel Chair)",defaultValue=1,consoleTarget="DeusEx.OfficeChair")
     Items(78)=(actionText="Chair (Dining Chair)",defaultValue=1,consoleTarget="DeusEx.WHChairDining")
     Items(79)=(actionText="Chair (Fancy)",defaultValue=1,consoleTarget="DeusEx.WHChairOvalOffice")
     Items(80)=(actionText="Cigarettes",defaultValue=1,consoleTarget="DeusEx.Cigarettes")
     Items(81)=(actionText="Cigarette Machine",defaultValue=1,consoleTarget="DeusEx.CigaretteMachine")
     Items(82)=(actionText="Computer (Personal)",defaultValue=1,consoleTarget="DeusEx.ComputerPersonal")
     Items(83)=(actionText="Computer (Security)",defaultValue=1,consoleTarget="DeusEx.ComputerSecurity")
     Items(84)=(actionText="Computer (ATM)",defaultValue=1,consoleTarget="DeusEx.ATM")
     Items(85)=(actionText="Concrete Barricade",defaultValue=1,consoleTarget="DeusEx.RoadBlock")
     Items(86)=(actionText="Control Panel",defaultValue=1,consoleTarget="DeusEx.ControlPanel")
     Items(87)=(actionText="Couch (Leather)",defaultValue=1,consoleTarget="DeusEx.CouchLeather")
     Items(88)=(actionText="Couch (Red)",defaultValue=1,consoleTarget="DeusEx.WHRedCouch")
     Items(89)=(actionText="Credit Chit",defaultValue=1,consoleTarget="DeusEx.Credits")
     Items(90)=(actionText="Cushion",defaultValue=1,consoleTarget="DeusEx.Cushion")
     Items(91)=(actionText="Data Cube",defaultValue=1,consoleTarget="DeusEx.DataCube")
     Items(92)=(actionText="Earth",defaultValue=1,consoleTarget="DeusEx.Earth")
     Items(93)=(actionText="Fan 1",defaultValue=1,consoleTarget="DeusEx.Fan1")
     Items(94)=(actionText="Fan 2",defaultValue=1,consoleTarget="DeusEx.Fan2")
     Items(95)=(actionText="Fan 3",defaultValue=1,consoleTarget="DeusEx.Fan1Vertical")
     Items(96)=(actionText="Fan (Ceiling Fan)",defaultValue=1,consoleTarget="DeusEx.CeilingFan")
     Items(97)=(actionText="Faucet",defaultValue=1,consoleTarget="DeusEx.Faucet")
     Items(98)=(actionText="Fire Plug",defaultValue=1,consoleTarget="DeusEx.FirePlug")
     Items(99)=(actionText="Flag Pole",defaultValue=1,consoleTarget="DeusEx.FlagPole")
     Items(100)=(actionText="Flare",defaultValue=1,consoleTarget="DeusEx.Flare")
     Items(101)=(actionText="Flower Pot",defaultValue=1,consoleTarget="DeusEx.Flowers")
     Items(102)=(actionText="Keypad 1",defaultValue=1,consoleTarget="DeusEx.Keypad1")
     Items(103)=(actionText="Keypad 2",defaultValue=1,consoleTarget="DeusEx.Keypad2")
     Items(104)=(actionText="Keypad 3",defaultValue=1,consoleTarget="DeusEx.Keypad3")
     Items(105)=(actionText="Lab Flask",defaultValue=1,consoleTarget="DeusEx.Flask")
     Items(106)=(actionText="Lamp 1",defaultValue=1,consoleTarget="DeusEx.Lamp1")
     Items(107)=(actionText="Lamp 2",defaultValue=1,consoleTarget="DeusEx.Lamp2")
     Items(108)=(actionText="Lamp 3",defaultValue=1,consoleTarget="DeusEx.Lamp3")
     Items(109)=(actionText="Light Bulb",defaultValue=1,consoleTarget="DeusEx.LightBulb")
     Items(110)=(actionText="Light Switch",defaultValue=1,consoleTarget="DeusEx.LightSwitch")
     Items(111)=(actionText="Liquor",defaultValue=1,consoleTarget="DeusEx.LiquorBottle")
     Items(112)=(actionText="Liquor (Forty)",defaultValue=1,consoleTarget="DeusEx.Liquor40oz")
     Items(113)=(actionText="Liquor (Wine)",defaultValue=1,consoleTarget="DeusEx.WineBottle")
     Items(114)=(actionText="Mailbox",defaultValue=1,consoleTarget="DeusEx.Mailbox")
     Items(115)=(actionText="Medical Kit",defaultValue=1,consoleTarget="DeusEx.MedKit")
     Items(116)=(actionText="Microscope",defaultValue=1,consoleTarget="DeusEx.Microscope")
     Items(117)=(actionText="Nanovirus Container",defaultValue=1,consoleTarget="DeusEx.BarrelVirus")
     Items(118)=(actionText="Pan 1",defaultValue=1,consoleTarget="DeusEx.Pan1")
     Items(119)=(actionText="Pan 2",defaultValue=1,consoleTarget="DeusEx.Pan2")
     Items(120)=(actionText="Pan 3",defaultValue=1,consoleTarget="DeusEx.Pan3")
     Items(121)=(actionText="Pan 4",defaultValue=1,consoleTarget="DeusEx.Pan4")
     Items(122)=(actionText="Pillow",defaultValue=1,consoleTarget="DeusEx.Pillow")
     Items(123)=(actionText="Pinball Machine",defaultValue=1,consoleTarget="DeusEx.Pinball")
     Items(124)=(actionText="Plant 1",defaultValue=1,consoleTarget="DeusEx.Plant1")
     Items(125)=(actionText="Plant 2",defaultValue=1,consoleTarget="DeusEx.Plant2")
     Items(126)=(actionText="Plant 3",defaultValue=1,consoleTarget="DeusEx.Plant3")
     Items(127)=(actionText="Police Boat",defaultValue=1,consoleTarget="DeusEx.NYPoliceBoat")
     Items(128)=(actionText="Pool Ball",defaultValue=1,consoleTarget="DeusEx.PoolBall")
     Items(129)=(actionText="Pot 1",defaultValue=1,consoleTarget="DeusEx.Pot1")
     Items(130)=(actionText="Pot 2",defaultValue=1,consoleTarget="DeusEx.Pot2")
     Items(131)=(actionText="Rat",defaultValue=1,consoleTarget="DeusEx.Rat")
     Items(132)=(actionText="Retinal Scanner",defaultValue=1,consoleTarget="DeusEx.RetinalScanner")
     Items(133)=(actionText="Satellite Dish",defaultValue=1,consoleTarget="DeusEx.SatelliteDish")
     Items(134)=(actionText="Ships Wheel",defaultValue=1,consoleTarget="DeusEx.ShipsWheel")
     Items(135)=(actionText="Shop Light",defaultValue=1,consoleTarget="DeusEx.Shoplight")
     Items(136)=(actionText="Shop Light (Hanging)",defaultValue=1,consoleTarget="DeusEx.HangingShopLight")
     Items(137)=(actionText="Shower Faucet",defaultValue=1,consoleTarget="DeusEx.ShowerFaucet")
     Items(138)=(actionText="Shower Head",defaultValue=1,consoleTarget="DeusEx.ShowerHead")
     Items(139)=(actionText="Soda Can",defaultValue=1,consoleTarget="DeusEx.SodaCan")
     Items(140)=(actionText="Software (Nuke)",defaultValue=1,consoleTarget="DeusEx.SoftwareNuke")
     Items(141)=(actionText="Software (Worm)",defaultValue=1,consoleTarget="DeusEx.SoftwareStop")
     Items(142)=(actionText="Soy Food",defaultValue=1,consoleTarget="DeusEx.SoyFood")
     Items(143)=(actionText="Subway Control Panel",defaultValue=1,consoleTarget="DeusEx.SubwayControlPanel")
     Items(144)=(actionText="Supply Crate (General)",defaultValue=1,consoleTarget="DeusEx.CrateBreakableMedGeneral")
     Items(145)=(actionText="Supply Crate (Combat)",defaultValue=1,consoleTarget="DeusEx.CrateBreakableMedCombat")
     Items(146)=(actionText="Supply Crate (Medical)",defaultValue=1,consoleTarget="DeusEx.CrateBreakableMedMedical")
     Items(147)=(actionText="Switch",defaultValue=1,consoleTarget="DeusEx.Switch1")
     Items(148)=(actionText="TNT Crate",defaultValue=1,consoleTarget="DeusEx.CrateExplosiveSmall")
     Items(149)=(actionText="Telephone",defaultValue=1,consoleTarget="DeusEx.Phone")
     Items(150)=(actionText="Telephone Answering Machine",defaultValue=1,consoleTarget="DeusEx.TAD")
     Items(151)=(actionText="Toilet",defaultValue=1,consoleTarget="DeusEx.Toilet")
     Items(152)=(actionText="Toilet (Urinal)",defaultValue=1,consoleTarget="DeusEx.Toilet2")
     Items(153)=(actionText="Trashcan 1",defaultValue=1,consoleTarget="DeusEx.TrashCan1")
     Items(154)=(actionText="Trashcan 2",defaultValue=1,consoleTarget="DeusEx.TrashCan2")
     Items(155)=(actionText="Trashcan 3",defaultValue=1,consoleTarget="DeusEx.TrashCan3")
     Items(156)=(actionText="Trashcan 4",defaultValue=1,consoleTarget="DeusEx.TrashCan4")
     Items(157)=(actionText="Trashbag 1",defaultValue=1,consoleTarget="DeusEx.Trashbag")
     Items(158)=(actionText="Trashbag 2",defaultValue=1,consoleTarget="DeusEx.Trashbag2")
     //Items(159)=(actionText="Trash (Paper)",defaultValue=1,consoleTarget="DeusEx.TrashPaper")
     Items(159)=(actionText="Tree 1",defaultValue=1,consoleTarget="DeusEx.Tree1",valueText1="HDTP (Optimised)",valueText2="HDTP")
     Items(160)=(actionText="Tree 2",defaultValue=1,consoleTarget="DeusEx.Tree2",valueText1="HDTP (Optimised)",valueText2="HDTP")
     Items(161)=(actionText="Tree 3",defaultValue=1,consoleTarget="DeusEx.Tree3",valueText1="HDTP (Optimised)",valueText2="HDTP")
     Items(162)=(actionText="Tree 4",defaultValue=1,consoleTarget="DeusEx.Tree4",valueText1="HDTP (Optimised)",valueText2="HDTP")
     Items(163)=(actionText="Tree (Evergreen)",defaultValue=1,consoleTarget="DeusEx.TreeEvergreen",valueText1="HDTP (Optimised)",valueText2="HDTP")
     Items(164)=(actionText="Trophy",defaultValue=1,consoleTarget="DeusEx.Trophy")
     Items(165)=(actionText="Tumbleweed",defaultValue=1,consoleTarget="DeusEx.Tumbleweed")
     Items(166)=(actionText="Unbreakable Crate (Large)",defaultValue=1,consoleTarget="DeusEx.CrateUnbreakableLarge")
     Items(167)=(actionText="Unbreakable Crate (Medium)",defaultValue=1,consoleTarget="DeusEx.CrateUnbreakableMed")
     Items(168)=(actionText="Unbreakable Crate (Small)",defaultValue=1,consoleTarget="DeusEx.CrateUnbreakableSmall")
     Items(169)=(actionText="Utility Push-Cart",defaultValue=1,consoleTarget="DeusEx.Cart")
     Items(170)=(actionText="Valve",defaultValue=1,consoleTarget="DeusEx.Valve")
     Items(171)=(actionText="Vase 1",defaultValue=1,consoleTarget="DeusEx.Vase1")
     Items(172)=(actionText="Vase 2",defaultValue=1,consoleTarget="DeusEx.Vase2")
     Items(173)=(actionText="Vending Machine",defaultValue=1,consoleTarget="DeusEx.VendingMachine")
     Items(174)=(actionText="Water Cooler",defaultValue=1,consoleTarget="DeusEx.WaterCooler")
     Items(175)=(actionText="Water Fountain",defaultValue=1,consoleTarget="DeusEx.WaterFountain")
     Items(176)=(actionText="Wet Floor Sign",defaultValue=1,consoleTarget="DeusEx.SignFloor")
     Items(177)=(actionText="10mm Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo10mm",sortcategory="1Ammo")
     Items(178)=(actionText="10mm AP Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo10mmAP",sortcategory="1Ammo")
     Items(179)=(actionText="20mm Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo20mm",sortcategory="1Ammo")
     Items(180)=(actionText="20mm EMP Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo20mmEMP",sortcategory="1Ammo")
     Items(181)=(actionText="762mm Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo762mm",sortcategory="1Ammo")
     Items(182)=(actionText="3006 Ammo",defaultValue=1,consoleTarget="DeusEx.Ammo3006",sortcategory="1Ammo")
     Items(183)=(actionText="Darts",defaultValue=1,consoleTarget="DeusEx.AmmoDart",sortcategory="1Ammo")
     Items(184)=(actionText="Darts (Flare)",defaultValue=1,consoleTarget="DeusEx.AmmoDartFlare",sortcategory="1Ammo")
     Items(185)=(actionText="Darts (Poison)",defaultValue=1,consoleTarget="DeusEx.AmmoDartPoison",sortcategory="1Ammo")
     Items(186)=(actionText="Darts (Taser)",defaultValue=1,consoleTarget="DeusEx.AmmoDartTaser",sortcategory="1Ammo")
     Items(187)=(actionText="Napalm",defaultValue=1,consoleTarget="DeusEx.AmmoNapalm",sortcategory="1Ammo")
     Items(188)=(actionText="Plasma Ammo",defaultValue=1,consoleTarget="DeusEx.AmmoPlasma",sortcategory="1Ammo")
     Items(189)=(actionText="Prod Charger",defaultValue=1,consoleTarget="DeusEx.AmmoBattery",sortcategory="1Ammo")
     Items(190)=(actionText="Rockets",defaultValue=1,consoleTarget="DeusEx.AmmoRocket",sortcategory="1Ammo")
     Items(191)=(actionText="WP Rockets",defaultValue=1,consoleTarget="DeusEx.AmmoRocketWP",sortcategory="1Ammo")
     Items(192)=(actionText="Shells",defaultValue=1,consoleTarget="DeusEx.AmmoShell",sortcategory="1Ammo")
     Items(193)=(actionText="Shells (Sabot)",defaultValue=1,consoleTarget="DeusEx.AmmoSabot",sortcategory="1Ammo")
     Items(194)=(actionText="Shells (Rubber)",defaultValue=1,consoleTarget="DeusEx.AmmoRubber",sortcategory="1Ammo")
     Title="HDTP Model Options"
     disabledText="Vanilla"
     enabledText="HDTP"
     variable="iHDTPModelToggle"
}
