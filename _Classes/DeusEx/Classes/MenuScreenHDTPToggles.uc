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
     items(9)=(actionText="Assault Gun",consoleTarget="DeusEx.WeaponAssaultGun",defaultValue=1);
     items(10)=(actionText="Assault Shotgun",consoleTarget="DeusEx.WeaponAssaultShotgun",defaultValue=1);
     items(11)=(actionText="Baton",consoleTarget="DeusEx.WeaponBaton");
     items(12)=(actionText="Combat Knife",consoleTarget="DeusEx.WeaponCombatKnife",defaultValue=1);
     items(13)=(actionText="Crowbar",consoleTarget="DeusEx.WeaponCrowbar",defaultValue=1);
     items(14)=(actionText="EMP Grenade",consoleTarget="DeusEx.WeaponEMPGrenade");
     items(15)=(actionText="Flamethrower",consoleTarget="DeusEx.WeaponFlamethrower",defaultValue=1);
     items(16)=(actionText="Gas Grenade",consoleTarget="DeusEx.WeaponGasGrenade");
     items(17)=(actionText="GEP Gun",consoleTarget="DeusEx.WeaponGEPGun",defaultValue=1);
     items(18)=(actionText="LAM",consoleTarget="DeusEx.WeaponLAM");
     items(19)=(actionText="LAW",consoleTarget="DeusEx.WeaponLAW",defaultValue=1);
     items(20)=(actionText="Mini-Crossbow",consoleTarget="DeusEx.WeaponMiniCrossbow",defaultValue=1);
     items(21)=(actionText="Dragons Tooth Sword",consoleTarget="DeusEx.WeaponNanoSword",defaultValue=1);
     items(22)=(actionText="Scramble Grenade",consoleTarget="DeusEx.WeaponNanoVirusGrenade");
     items(23)=(actionText="Pepper Spray",consoleTarget="DeusEx.WeaponPepperGun",defaultValue=1);
     items(24)=(actionText="Pistol",consoleTarget="DeusEx.WeaponPistol",defaultValue=1);
     items(25)=(actionText="Plasma Rifle",consoleTarget="DeusEx.WeaponPlasmaRifle",defaultValue=1);
     items(26)=(actionText="Riot Prod",consoleTarget="DeusEx.WeaponProd");
     items(27)=(actionText="Sniper Rifle",consoleTarget="DeusEx.WeaponRifle",defaultValue=1,valueText2="FOMOD Beta");
     items(28)=(actionText="Sawed-Off Shotgun",consoleTarget="DeusEx.WeaponSawedOffShotgun",defaultValue=2,valueText2="FOMOD Beta");
     items(29)=(actionText="Stealth Pistol",consoleTarget="DeusEx.WeaponStealthPistol",defaultValue=1,valueText2="FOMOD Beta");
     items(30)=(actionText="Sword",consoleTarget="DeusEx.WeaponSword",defaultValue=1);
     items(31)=(actionText="Ambrosia Container",consoleTarget="DeusEx.BarrelAmbrosia",defaultValue=1);
     items(32)=(actionText="Barrel",consoleTarget="DeusEx.Barrel1",defaultValue=1);
     items(33)=(actionText="Barrel (Flaming)",consoleTarget="DeusEx.BarrelFire",defaultValue=1);
     items(34)=(actionText="Nanovirus Container",consoleTarget="DeusEx.BarrelVirus",defaultValue=1);
     items(35)=(actionText="Supply Crate (General)",consoleTarget="DeusEx.CrateBreakableMedGeneral",defaultValue=1);
     items(36)=(actionText="Supply Crate (Combat)",consoleTarget="DeusEx.CrateBreakableMedCombat",defaultValue=1);
     items(37)=(actionText="Supply Crate (Medical)",consoleTarget="DeusEx.CrateBreakableMedMedical",defaultValue=1);
     items(38)=(actionText="Unbreakable Crate (Large)",consoleTarget="DeusEx.CrateUnbreakableLarge",defaultValue=1);
     items(39)=(actionText="Unbreakable Crate (Medium)",consoleTarget="DeusEx.CrateUnbreakableLarge",defaultValue=1);
     items(40)=(actionText="Unbreakable Crate (Small)",consoleTarget="DeusEx.CrateUnbreakableSmall",defaultValue=1);
     strHeaderActionLabel="Weapon"
     strHeaderAssignedLabel="Model"
     HelpText="Select the model you wish to change and then press [Enter] or Double-Click to cycle through available models"
     Title="HDTP Model Options"
     disabledText="Vanilla"
     enabledText="HDTP"
     variable="iHDTPModelToggle"
}
