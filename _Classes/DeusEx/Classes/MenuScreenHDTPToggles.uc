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

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     items(0)=(actionText="JC Denton",consoleTarget="DeusExPlayer",variable="bHDTP_JC");
     items(1)=(actionText="Paul Denton",consoleTarget="DeusExPlayer",variable="bHDTP_Paul");
     items(2)=(actionText="Gunther Hermann",consoleTarget="DeusExPlayer",variable="bHDTP_Gunther");
     items(3)=(actionText="Anna Navarre",consoleTarget="DeusExPlayer",variable="bHDTP_Anna");
     items(4)=(actionText="Nicolette DuClare",consoleTarget="DeusExPlayer",variable="bHDTP_Nico");
     items(5)=(actionText="NSF Terrorist",consoleTarget="DeusExPlayer",variable="bHDTP_NSF");
     items(6)=(actionText="Riot Cop",consoleTarget="DeusExPlayer",variable="bHDTP_RiotCop");
     items(7)=(actionText="Walton Simons",consoleTarget="DeusExPlayer",variable="bHDTP_Walton");
     items(8)=(actionText="UNATCO Trooper",consoleTarget="DeusExPlayer",variable="bHDTP_Unatco");
     //items(9)=(actionText="MJ12 Trooper",consoleTarget="DeusExPlayer",variable="bHDTP_MJ12");
     items(9)=(actionText="Cleaner Bot",consoleTarget="DeusEx.CleanerBot",defaultValue=1);
     items(10)=(actionText="Military Bot",consoleTarget="DeusEx.MilitaryBot",defaultValue=1);
     items(11)=(actionText="Medical Bot",consoleTarget="DeusEx.MedicalBot",defaultValue=1);
     items(12)=(actionText="Repair Bot",consoleTarget="DeusEx.RepairBot",defaultValue=1);
     items(13)=(actionText="Security Bot (Large)",consoleTarget="DeusEx.SecurityBot2",defaultValue=1);
     items(14)=(actionText="Security Bot (Small)",consoleTarget="DeusEx.SecurityBot3",defaultValue=1);
     items(15)=(actionText="Assault Gun",consoleTarget="DeusEx.WeaponAssaultGun",defaultValue=1);
     items(16)=(actionText="Assault Shotgun",consoleTarget="DeusEx.WeaponAssaultShotgun",defaultValue=1);
     items(17)=(actionText="Baton",consoleTarget="DeusEx.WeaponBaton");
     items(18)=(actionText="Combat Knife",consoleTarget="DeusEx.WeaponCombatKnife",defaultValue=1);
     items(19)=(actionText="Crowbar",consoleTarget="DeusEx.WeaponCrowbar",defaultValue=1);
     items(20)=(actionText="EMP Grenade",consoleTarget="DeusEx.WeaponEMPGrenade");
     items(21)=(actionText="Flamethrower",consoleTarget="DeusEx.WeaponFlamethrower",defaultValue=1);
     items(22)=(actionText="Gas Grenade",consoleTarget="DeusEx.WeaponGasGrenade");
     items(23)=(actionText="GEP Gun",consoleTarget="DeusEx.WeaponGEPGun",defaultValue=1);
     items(24)=(actionText="LAM",consoleTarget="DeusEx.WeaponLAM");
     items(25)=(actionText="LAW",consoleTarget="DeusEx.WeaponLAW",defaultValue=1);
     items(26)=(actionText="Mini-Crossbow",consoleTarget="DeusEx.WeaponMiniCrossbow",defaultValue=1);
     items(27)=(actionText="Dragons Tooth Sword",consoleTarget="DeusEx.WeaponNanoSword",defaultValue=1);
     items(28)=(actionText="Scramble Grenade",consoleTarget="DeusEx.WeaponNanoVirusGrenade");
     items(29)=(actionText="Pepper Spray",consoleTarget="DeusEx.WeaponPepperGun",defaultValue=1);
     items(30)=(actionText="Pistol",consoleTarget="DeusEx.WeaponPistol",defaultValue=1);
     items(31)=(actionText="Plasma Rifle",consoleTarget="DeusEx.WeaponPlasmaRifle",defaultValue=1);
     items(32)=(actionText="Riot Prod",consoleTarget="DeusEx.WeaponProd");
     items(33)=(actionText="Sniper Rifle",consoleTarget="DeusEx.WeaponRifle",defaultValue=1,valueText2="FOMOD Beta");
     items(34)=(actionText="Sawed-Off Shotgun",consoleTarget="DeusEx.WeaponSawedOffShotgun",defaultValue=2,valueText2="FOMOD Beta");
     items(35)=(actionText="Stealth Pistol",consoleTarget="DeusEx.WeaponStealthPistol",defaultValue=1,valueText2="FOMOD Beta");
     items(36)=(actionText="Sword",consoleTarget="DeusEx.WeaponSword",defaultValue=1);
     items(37)=(actionText="AI Prototype",consoleTarget="DeusEx.AIPrototype",defaultValue=1);
     items(38)=(actionText="Alarm Unit",consoleTarget="DeusEx.AlarmUnit",defaultValue=1);
     items(39)=(actionText="Alarm Light",consoleTarget="DeusEx.AlarmLight",defaultValue=1);
     items(40)=(actionText="Ambrosia Container",consoleTarget="DeusEx.BarrelAmbrosia",defaultValue=1);
     items(41)=(actionText="Barrel",consoleTarget="DeusEx.Barrel1",defaultValue=1);
     items(42)=(actionText="Barrel (Flaming)",consoleTarget="DeusEx.BarrelFire",defaultValue=1);
     items(43)=(actionText="Book (Open)",consoleTarget="DeusEx.BookOpen",defaultValue=1);
     items(44)=(actionText="Book (Closed)",consoleTarget="DeusEx.BookClosed",defaultValue=2,valueText2="HDTP (Extended Covers)");
     items(45)=(actionText="Book (Newspaper)",consoleTarget="DeusEx.Newspaper",defaultValue=1);
     items(46)=(actionText="Button",consoleTarget="DeusEx.Button1",defaultValue=1);
     items(47)=(actionText="Candy Bar",consoleTarget="DeusEx.Candybar",defaultValue=1);
     items(48)=(actionText="Cage Light",consoleTarget="DeusEx.CageLight",defaultValue=1);
     items(49)=(actionText="Chair",consoleTarget="DeusEx.Chair1",defaultValue=1);
     items(50)=(actionText="Chair (Leather)",consoleTarget="DeusEx.ChairLeather",defaultValue=1);
     items(51)=(actionText="Chair (Swivel Chair)",consoleTarget="DeusEx.OfficeChair",defaultValue=1);
     items(52)=(actionText="Cigarettes",consoleTarget="DeusEx.Cigarettes",defaultValue=1);
     items(53)=(actionText="Computer (Personal)",consoleTarget="DeusEx.ComputerPersonal",defaultValue=1);
     items(54)=(actionText="Computer (Security)",consoleTarget="DeusEx.ComputerSecurity",defaultValue=1);
     items(55)=(actionText="Computer (ATM)",consoleTarget="DeusEx.ATM",defaultValue=1);
     items(56)=(actionText="Concrete Barricade",consoleTarget="DeusEx.RoadBlock",defaultValue=1);
     items(57)=(actionText="Data Cube",consoleTarget="DeusEx.DataCube",defaultValue=1);
     items(58)=(actionText="Fan 1",consoleTarget="DeusEx.Fan1",defaultValue=1);
     items(59)=(actionText="Fan 2",consoleTarget="DeusEx.Fan2",defaultValue=1);
     items(60)=(actionText="Fan 3",consoleTarget="DeusEx.Fan1Vertical",defaultValue=1);
     items(61)=(actionText="Fan (Ceiling Fan)",consoleTarget="DeusEx.CeilingFan",defaultValue=1);
     items(62)=(actionText="Fan (Ceiling Fan Motor)",consoleTarget="DeusEx.CeilingFanMotor",defaultValue=1);
     items(63)=(actionText="Flare",consoleTarget="DeusEx.Flare",defaultValue=1);
     items(64)=(actionText="Faucet",consoleTarget="DeusEx.Faucet",defaultValue=1);
     items(65)=(actionText="Flag Pole",consoleTarget="DeusEx.FlagPole",defaultValue=1);
     items(66)=(actionText="Flower Pot",consoleTarget="DeusEx.Flowers",defaultValue=1);
     items(67)=(actionText="Keypad 1",consoleTarget="DeusEx.Keypad1",defaultValue=1);
     items(68)=(actionText="Keypad 2",consoleTarget="DeusEx.Keypad2",defaultValue=1);
     items(69)=(actionText="Keypad 3",consoleTarget="DeusEx.Keypad3",defaultValue=1);
     items(70)=(actionText="Lab Flask",consoleTarget="DeusEx.Flask",defaultValue=1);
     items(71)=(actionText="Lamp 1",consoleTarget="DeusEx.Lamp1",defaultValue=1);
     items(72)=(actionText="Lamp 2",consoleTarget="DeusEx.Lamp2",defaultValue=1);
     items(73)=(actionText="Lamp 3",consoleTarget="DeusEx.Lamp3",defaultValue=1);
     items(74)=(actionText="Light Switch",consoleTarget="DeusEx.LightSwitch",defaultValue=1);
     items(75)=(actionText="Liquor",consoleTarget="DeusEx.LiquorBottle",defaultValue=1);
     items(76)=(actionText="Liquor (Forty)",consoleTarget="DeusEx.Liquor40oz",defaultValue=1);
     items(77)=(actionText="Liquor (Wine)",consoleTarget="DeusEx.WineBottle",defaultValue=1);
     items(78)=(actionText="Leather Couch",consoleTarget="DeusEx.CouchLeather",defaultValue=1);
     items(79)=(actionText="Medical Kit",consoleTarget="DeusEx.MedKit",defaultValue=1);
     items(80)=(actionText="Microscope",consoleTarget="DeusEx.Microscope",defaultValue=1);
     items(81)=(actionText="Nanovirus Container",consoleTarget="DeusEx.BarrelVirus",defaultValue=1);
     items(82)=(actionText="Pillow",consoleTarget="DeusEx.Pillow",defaultValue=1);
     items(83)=(actionText="Pinball Machine",consoleTarget="DeusEx.Pinball",defaultValue=1);
     items(84)=(actionText="Plant 1",consoleTarget="DeusEx.Plant1",defaultValue=1);
     items(85)=(actionText="Plant 2",consoleTarget="DeusEx.Plant2",defaultValue=1);
     items(86)=(actionText="Plant 3",consoleTarget="DeusEx.Plant3",defaultValue=1);
     items(87)=(actionText="Pot 1",consoleTarget="DeusEx.Pot1",defaultValue=1);
     items(88)=(actionText="Pot 2",consoleTarget="DeusEx.Pot2",defaultValue=1);
     items(89)=(actionText="Retinal Scanner",consoleTarget="DeusEx.RetinalScanner",defaultValue=1);
     items(90)=(actionText="Soda Can",consoleTarget="DeusEx.SodaCan",defaultValue=1);
     items(91)=(actionText="Supply Crate (General)",consoleTarget="DeusEx.CrateBreakableMedGeneral",defaultValue=1);
     items(92)=(actionText="Supply Crate (Combat)",consoleTarget="DeusEx.CrateBreakableMedCombat",defaultValue=1);
     items(93)=(actionText="Supply Crate (Medical)",consoleTarget="DeusEx.CrateBreakableMedMedical",defaultValue=1);
     items(94)=(actionText="TNT Crate",consoleTarget="DeusEx.CrateExplosiveSmall",defaultValue=1);
     items(95)=(actionText="Telephone",consoleTarget="DeusEx.Phone",defaultValue=1);
     items(96)=(actionText="Telephone Answering Machine",consoleTarget="DeusEx.TAD",defaultValue=1);
     items(97)=(actionText="Toilet",consoleTarget="DeusEx.Toilet",defaultValue=1);
     items(98)=(actionText="Toilet (Urinal)",consoleTarget="DeusEx.Toilet2",defaultValue=1);
     items(99)=(actionText="Trashcan 1",consoleTarget="DeusEx.TrashCan1",defaultValue=1);
     items(100)=(actionText="Trashcan 2",consoleTarget="DeusEx.TrashCan2",defaultValue=1);
     items(101)=(actionText="Trashcan 3",consoleTarget="DeusEx.TrashCan3",defaultValue=1);
     items(102)=(actionText="Trashcan 4",consoleTarget="DeusEx.TrashCan4",defaultValue=1);
     items(103)=(actionText="Trashbag 1",consoleTarget="DeusEx.Trashbag",defaultValue=1);
     items(104)=(actionText="Trashbag 2",consoleTarget="DeusEx.Trashbag2",defaultValue=1);
     items(105)=(actionText="Trash (Paper)",consoleTarget="DeusEx.TrashPaper",defaultValue=1);
     items(106)=(actionText="Tree 1",consoleTarget="DeusEx.Tree1",defaultValue=1);
     items(107)=(actionText="Tree 2",consoleTarget="DeusEx.Tree2",defaultValue=1);
     items(108)=(actionText="Tree 3",consoleTarget="DeusEx.Tree3",defaultValue=1);
     items(109)=(actionText="Tree 4",consoleTarget="DeusEx.Tree4",defaultValue=1);
     items(110)=(actionText="Trophy",consoleTarget="DeusEx.Trophy",defaultValue=1);
     items(111)=(actionText="Unbreakable Crate (Large)",consoleTarget="DeusEx.CrateUnbreakableLarge",defaultValue=1);
     items(112)=(actionText="Unbreakable Crate (Medium)",consoleTarget="DeusEx.CrateUnbreakableMed",defaultValue=1);
     items(113)=(actionText="Unbreakable Crate (Small)",consoleTarget="DeusEx.CrateUnbreakableSmall",defaultValue=1);
     items(114)=(actionText="Utility Push-Cart",consoleTarget="DeusEx.Cart",defaultValue=1);
     items(115)=(actionText="Vase 1",consoleTarget="DeusEx.Vase1",defaultValue=1);
     items(116)=(actionText="Vase 2",consoleTarget="DeusEx.Vase2",defaultValue=1);
     items(117)=(actionText="Water Cooler",consoleTarget="DeusEx.WaterCooler",defaultValue=1);
     items(118)=(actionText="Water Fountain",consoleTarget="DeusEx.WaterFountain",defaultValue=1);
     items(119)=(actionText="10mm Ammo",consoleTarget="DeusEx.Ammo10mm",defaultValue=1);
     items(120)=(actionText="10mm AP Ammo",consoleTarget="DeusEx.Ammo10mmAP",defaultValue=1);
     items(121)=(actionText="20mm Ammo",consoleTarget="DeusEx.Ammo20mm",defaultValue=1);
     items(122)=(actionText="20mm EMP Ammo",consoleTarget="DeusEx.Ammo20mmEMP",defaultValue=1); //TODO: Add 20mm EMP skin
     items(123)=(actionText="762mm Ammo",consoleTarget="DeusEx.Ammo762mm",defaultValue=1);
     items(124)=(actionText="3006 Ammo",consoleTarget="DeusEx.Ammo3006",defaultValue=1);
     items(125)=(actionText="Darts",consoleTarget="DeusEx.AmmoDart",defaultValue=1);
     items(126)=(actionText="Darts (Flare)",consoleTarget="DeusEx.AmmoDartFlare",defaultValue=1);
     items(127)=(actionText="Darts (Poison)",consoleTarget="DeusEx.AmmoDartPoison",defaultValue=1);
     items(128)=(actionText="Darts (Taser)",consoleTarget="DeusEx.AmmoDartTaser",defaultValue=1);
     items(129)=(actionText="Napalm",consoleTarget="DeusEx.AmmoNapalm",defaultValue=1);
     items(130)=(actionText="Plasma Ammo",consoleTarget="DeusEx.AmmoPlasma",defaultValue=1); //TODO: Add superheated plasma
     items(131)=(actionText="Prod Charger",consoleTarget="DeusEx.AmmoBattery",defaultValue=1);
     items(132)=(actionText="Rockets",consoleTarget="DeusEx.AmmoRocket",defaultValue=1);
     items(133)=(actionText="WP Rockets",consoleTarget="DeusEx.AmmoRocketWP",defaultValue=1);
     items(134)=(actionText="Shells",consoleTarget="DeusEx.AmmoShell",defaultValue=1);
     items(135)=(actionText="Shells (Sabot)",consoleTarget="DeusEx.AmmoSabot",defaultValue=1);
     items(136)=(actionText="Shells (Rubber)",consoleTarget="DeusEx.AmmoRubber",defaultValue=1);
     strHeaderActionLabel="Object"
     strHeaderAssignedLabel="Model"
     HelpText="Select the model you wish to change and then press [Enter] or Double-Click to cycle through available models"
     Title="HDTP Model Options"
     disabledText="Vanilla"
     enabledText="HDTP"
     variable="iHDTPModelToggle"
}
