//=============================================================================
// RSDCrap.
//=============================================================================
class All expands Object
	abstract;

// ===========================================================================================================
// DataVault
// ===========================================================================================================

#exec TEXTURE IMPORT FILE="Textures\RubberShellBox.pcx"			NAME="RubberShellBox"			GROUP="Items"
#exec TEXTURE IMPORT FILE="Textures\RubberShell.pcx"			NAME="RubberShell"			GROUP="Items"
#exec TEXTURE IMPORT FILE="Textures\SabotShellBox.pcx"			NAME="SabotShellBox"			GROUP="Items"
#exec TEXTURE IMPORT FILE="Textures\SabotShell.pcx"			NAME="SabotShell"			GROUP="Items"

#exec TEXTURE IMPORT FILE="Textures\CrossDot.pcx"			NAME="CrossDot"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\CrossDot2.pcx"			NAME="CrossDot2"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\CrossDot3.pcx"			NAME="CrossDot3"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\PowerIconActive.pcx"			NAME="PowerIconActive"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\PowerIconInactive.pcx"			NAME="PowerIconInactive"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\WhiteDot.pcx"			NAME="WhiteDot"			GROUP="UserInterface"

// Perks

// Heavy Weapons
#exec TEXTURE IMPORT FILE="Textures\PerkControlledBurn.pcx"			NAME="PerkControlledBurn"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\PerkBlastEnergy.pcx"			NAME="PerkBlastEnergy"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\PerkHERocket.pcx"			NAME="PerkHERocket"			GROUP="UserInterface"

// Pistols
#exec TEXTURE IMPORT FILE="Textures\PerkSidearm.pcx"			NAME="PerkSidearm"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\PerkAmbidextrous.pcx"			NAME="PerkAmbidextrous"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\PerkHumanCombustion.pcx"			NAME="PerkHumanCombustion"			GROUP="UserInterface"

// Low-Tech
#exec TEXTURE IMPORT FILE="Textures\PerkInventive.pcx"			NAME="PerkInventive"			GROUP="UserInterface"

// Medicine
#exec TEXTURE IMPORT FILE="Textures\PerkBiogenic.pcx"			NAME="PerkBiogenic"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\PerkToxicologist.pcx"			NAME="PerkToxicologist"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\PerkCombatMedicsBag.pcx"			NAME="PerkCombatMedicsBag"			GROUP="UserInterface"

// Environmental Training
#exec TEXTURE IMPORT FILE="Textures\PerkFieldRepair.pcx"			NAME="PerkFieldRepair"			GROUP="UserInterface"

// Stealth
#exec TEXTURE IMPORT FILE="Textures\PerkSecurityLoophole.pcx"			NAME="PerkSecurityLoophole"			GROUP="UserInterface"

//Secondary HUD
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HudAmmoDisplayBackgroundSecondary.pcx"			NAME="HudAmmoDisplayBackgroundSecondary"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HudAmmoDisplayBorderSecondary.pcx"			NAME="HudAmmoDisplayBorderSecondary"			GROUP="UserInterface"

//Big Belt
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HUDObjectBeltBorder_2_big.pcx"			NAME="HUDOBjectBeltBorder_2_big"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\InventoryBorder_4_big.pcx"			    NAME="InventoryBorder_4_big"	           	GROUP="UserInterface"

// Ammo
#exec TEXTURE IMPORT FILE="Textures\Ammo10mmAPTex.pcx"			NAME="Ammo10mmAPTex"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\AmmoDartTex1.pcx"			NAME="AmmoDartTex1"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\AmmoDartTex4.pcx"			NAME="AmmoDartTex4"			GROUP="Skins"

// Misc Textures
//Cloaking Texture
#exec TEXTURE IMPORT FILE="Textures\CloakingTex.pcx"			NAME="CloakingTex"			GROUP="Skins"
//Was used by water fountains in HDTP, but used by some effects, is a big blow "ring" of water.
#exec TEXTURE IMPORT FILE="Textures\Kawoosh.pcx"			NAME="Kawoosh"			GROUP="Skins"
//HDTP Medium Box, ported so we can use it without HDTP
#exec TEXTURE IMPORT FILE="Textures\boxmedtex1.pcx"			NAME="BoxMedTex1"			GROUP="Skins"
//#exec TEXTURE IMPORT FILE="Textures\boxmedtex2.pcx"			NAME="BoxMedTex2"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\HDTPFlatFXTex29.pcx"	NAME="HDTPFlatFXTex29"			GROUP="Skins"
//Burned out vanilla flare
#exec TEXTURE IMPORT FILE="Textures\Skins\FlareTex2.pcx"			NAME="FlareTex2"			GROUP="Skins"

// Sodacans with closed lids
#exec TEXTURE IMPORT FILE="Textures\Skins\sodacantex1.pcx"		    NAME="SodaCanTex1"	    GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\sodacantex2.pcx"		    NAME="SodaCanTex2"	    GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\sodacantex3.pcx"		    NAME="SodaCanTex3"	    GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\sodacantex4.pcx"		    NAME="SodaCanTex4"	    GROUP="Skins"

// Extra Cigarette Skins
#exec TEXTURE IMPORT FILE="Textures\Skins\CigarettesTex2.pcx"		NAME="CigarettesTex2"	GROUP="Skins"
//Reimport of HDTP texture with some minor touch-ups
#exec TEXTURE IMPORT FILE="Textures\Skins\HDTPCigarettesTex2.pcx"	NAME="HDTPCigarettesTex2"	GROUP="Skins"
//Holy Smokes
#exec TEXTURE IMPORT FILE="Textures\Skins\CigarettesTex3.pcx"		NAME="CigarettesTex3"	GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\HDTPCigarettesTex3.pcx"	NAME="HDTPCigarettesTex3"	GROUP="Skins"
//Super 45
#exec TEXTURE IMPORT FILE="Textures\Skins\CigarettesTex4.pcx"		NAME="CigarettesTex4"	GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\HDTPCigarettesTex4.pcx"	NAME="HDTPCigarettesTex4"	GROUP="Skins"

// Minidisks
#exec TEXTURE IMPORT FILE="Textures\Skins\MiniDiskTex0.pcx"		    NAME="MiniDiskTex0"	    GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\MiniDiskTex1.pcx"		    NAME="MiniDiskTex1"	    GROUP="Skins"

// Alternate Security Comp texture that doesn't show blue through it's own model
#exec TEXTURE IMPORT FILE="Textures\Skins\ComputerSecurityTex1Blank.pcx"		    NAME="ComputerSecurityTex1Blank"	    GROUP="Skins"

// Alternate Dart colours for vanilla xbow
#exec TEXTURE IMPORT FILE="Textures\Skins\MiniCrossbowTex2dart0.pcx"		    NAME="MiniCrossbowTex2dart0"	    GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\MiniCrossbowTex2dart1.pcx"		    NAME="MiniCrossbowTex2dart1"	    GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\MiniCrossbowTex2dart2.pcx"		    NAME="MiniCrossbowTex2dart2"	    GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\MiniCrossbowTex2dart3.pcx"		    NAME="MiniCrossbowTex2dart3"	    GROUP="Skins"

// Lower Res versions of HDTP and GameMedia assets, to look better vanilla
#exec TEXTURE IMPORT FILE="Textures\Leaves\LeafTex.pcx"			    NAME="LeafTex"			GROUP="Environment"
#exec TEXTURE IMPORT FILE="Textures\Leaves\LeafTex0.pcx"			NAME="LeafTex0"			GROUP="Environment"
#exec TEXTURE IMPORT FILE="Textures\Leaves\LeafTex1.pcx"			NAME="LeafTex1"			GROUP="Environment"
#exec TEXTURE IMPORT FILE="Textures\Leaves\LeafTex2.pcx"			NAME="LeafTex2"			GROUP="Environment"
#exec TEXTURE IMPORT FILE="Textures\Leaves\LeafTex3.pcx"			NAME="LeafTex3"			GROUP="Environment"
#exec TEXTURE IMPORT FILE="Textures\Skins\trashtex1.pcx"		    NAME="TrashTex1"	    GROUP="Skins"

// Random textures imported from HDTP, so that certain maps will actually work
//#exec TEXTURE IMPORT FILE="Textures\Environment\DrainTex.pcx"			    NAME="DrainTex"			    GROUP="Environment"
#exec TEXTURE IMPORT FILE="Textures\Environment\DirtyToiletWaterTex.pcx"	NAME="DirtyToiletWaterTex"	GROUP="Environment"
//#exec TEXTURE IMPORT FILE="Textures\Environment\InfoSign.pcx"	            NAME="InfoSign"         	GROUP="Environment"
#exec TEXTURE IMPORT FILE="Textures\Environment\WaterPuddle.pcx"	        NAME="WaterPuddle"         	GROUP="Environment"

//Fix visible purple on vanilla fence texture, only used on Warehouse map
//Original is in CoreTexMetal
#exec TEXTURE IMPORT FILE="Textures\Environment\OldeIronFence_B_fixed.pcx"	        NAME="OldeIronFence_B_Fixed"         	GROUP="Environment" MIPS=ON FLAGS=2

//Icons etc
#exec TEXTURE IMPORT FILE="Textures\LargeIconCrowbarRot.pcx"	    NAME="LargeIconCrowbarRot"	    GROUP="Icons"
#exec TEXTURE IMPORT FILE="Textures\LargeIconCrowbarHDTP.pcx"		NAME="LargeIconCrowbarHDTP"		GROUP="Icons"
#exec TEXTURE IMPORT FILE="Textures\LargeIconRifle.pcx"			    NAME="LargeIconRifle"			GROUP="Icons"
#exec TEXTURE IMPORT FILE="Textures\LargeIconPistol.pcx"			NAME="LargeIconPistol"			GROUP="Icons"
#exec TEXTURE IMPORT FILE="Textures\BeltIconRifle.pcx"			    NAME="BeltIconRifle"			GROUP="Icons"
#exec TEXTURE IMPORT FILE="Textures\LargeIconAmmoDartsTaser.pcx"	NAME="LargeIconAmmoDartsTaser"  GROUP="Icons"
#exec TEXTURE IMPORT FILE="Textures\BeltIconAmmoDartsTaser.pcx"	    NAME="BeltIconAmmoDartsTaser"   GROUP="Icons"
#exec TEXTURE IMPORT FILE="Textures\ChargedIconArmorAdaptive.pcx"	NAME="ChargedIconArmorAdaptive" GROUP="Icons"

//Bloody Shuriken
#exec TEXTURE IMPORT FILE="Textures\BeltIconShurikenBloody.pcx"	    NAME="BeltIconShurikenBloody"   GROUP="Icons"   FLAGS=2

//Crap
#exec TEXTURE IMPORT FILE="Textures\Skins\SpartaSign.pcx"	        NAME="SpartaSign" GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\HDTPSpartaSign.pcx"	    NAME="HDTPSpartaSign" GROUP="Skins"

//Import the Minidisk Mesh from GameMedia.u, since otherwise we have to pollute all of our maps with references to minidisk.
//This dependency likely won't be removed anytime soon, but it's nice to know we can get rid of it easier if we decide to.
//TOTALLY BORKED FOR SOME REASON!!!
/*
#exec MESH IMPORT MESH=Minidisk ANIVFILE=MODELS\Minidisk_a.3d DATAFILE=MODELS\Minidisk_d.3d
#exec MESH ORIGIN MESH=Minidisk X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Minidisk SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Minidisk MESH=Minidisk
#exec MESHMAP SCALE MESHMAP=Minidisk X=0.04 Y=0.04 Z=0.04

//Import high quality versions of minidisk textures
#exec TEXTURE IMPORT FILE="Textures\MiniDiskTexh0.pcx"			NAME="MiniDiskTexh0"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\MiniDiskTexh1.pcx"			NAME="MiniDiskTexh1"			GROUP="Skins"

#exec MESHMAP SETTEXTURE MESHMAP=Minidisk NUM=1 TEXTURE=MinidiskTexh0
*/

//Menu Backgrounds
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HDTPMenuOptionsBackground_1.pcx"			NAME="HDTPMenuOptionsBackground_1"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HDTPMenuOptionsBackground_2.pcx"			NAME="HDTPMenuOptionsBackground_2"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HDTPMenuOptionsBackground_3.pcx"			NAME="HDTPMenuOptionsBackground_3"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HDTPMenuOptionsBackground_4.pcx"			NAME="HDTPMenuOptionsBackground_4"			GROUP="UserInterface"

#exec TEXTURE IMPORT FILE="Textures\UserInterface\HDTPOptionsScreen_1.pcx"			NAME="HDTPOptionsScreen_1"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HDTPOptionsScreen_2.pcx"			NAME="HDTPOptionsScreen_2"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HDTPOptionsScreen_3.pcx"			NAME="HDTPOptionsScreen_3"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HDTPOptionsScreen_4.pcx"			NAME="HDTPOptionsScreen_4"			GROUP="UserInterface"

// QoL Menu
#exec TEXTURE IMPORT FILE="Textures\UserInterface\MenuQolBackground_1.pcx"			NAME="MenuQoLBackground_1"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\MenuQolBackground_2.pcx"			NAME="MenuQoLBackground_2"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\MenuQolBackground_3.pcx"			NAME="MenuQoLBackground_3"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\MenuQolBackground_4.pcx"			NAME="MenuQoLBackground_4"			GROUP="UserInterface"

//Flipped HUD Elements
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HUDAmmoDisplayBorder_1F.pcx"			NAME="HUDAmmoDisplayBorder_1F"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HUDAmmoDisplayBorderSecondaryF.pcx"	NAME="HudAmmoDisplayBorderSecondaryF"	GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\UserInterface\HUDObjectBeltBorder_3F.pcx"			NAME="HUDObjectBeltBorder_3F"			GROUP="UserInterface"

// Hands Textures

#exec TEXTURE IMPORT FILE="Textures\MiniCrossbowTex0Male.bmp"   	NAME="CrossbowHandstex0"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\MiniCrossbowTex1Male.bmp"   	NAME="CrossbowHandstex1"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\MiniCrossbowTex2Male.bmp"   	NAME="CrossbowHandstex2"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\MiniCrossbowTex3Male.bmp"   	NAME="CrossbowHandstex3"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\MiniCrossbowTex4Male.bmp"	    NAME="CrossbowHandstex4"			GROUP="Skins"

#exec TEXTURE IMPORT FILE="Textures\MiniCrossbowTex0MaleAugs.bmp"	NAME="CrossbowHandstex0A"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\MiniCrossbowTex1MaleAugs.bmp"	NAME="CrossbowHandstex1A"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\MiniCrossbowTex2MaleAugs.bmp"	NAME="CrossbowHandstex2A"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\MiniCrossbowTex3MaleAugs.bmp"	NAME="CrossbowHandstex3A"			GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\MiniCrossbowTex4MaleAugs.bmp"	NAME="CrossbowHandstex4A"			GROUP="Skins"

#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex0.bmp"        	NAME="WeaponHandstex0"	    		GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex1.bmp"        	NAME="WeaponHandstex1"	    		GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex2.bmp"        	NAME="WeaponHandstex2"	    		GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex3.bmp"        	NAME="WeaponHandstex3"	    		GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex4.bmp"        	NAME="WeaponHandstex4"	    		GROUP="Skins"

#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex0Augs.bmp"       	NAME="WeaponHandstex0A"	    		GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex1Augs.bmp"       	NAME="WeaponHandstex1A"	    		GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex2Augs.bmp"       	NAME="WeaponHandstex2A"	    		GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex3Augs.bmp"       	NAME="WeaponHandstex3A"	    		GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex4Augs.bmp"       	NAME="WeaponHandstex4A"	    		GROUP="Skins"

//New Wall Socket texture to replace GMDX's janky one
#exec TEXTURE IMPORT FILE="Textures\Skins\SocketTex1.pcx"		    NAME="SocketTex1"	        GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\SocketTex1_broken.pcx"    NAME="SocketTex1_broken"	GROUP="Skins"

//New Office Chair textures to match HDTP's style
#exec TEXTURE IMPORT FILE="Textures\Skins\OfficeChairTex5.pcx"		NAME="OfficeChairTex5"	    GROUP="Skins"
#exec TEXTURE IMPORT FILE="Textures\Skins\OfficeChairTex6.pcx"		NAME="OfficeChairTex6"	    GROUP="Skins"

// New Sounds
#exec AUDIO IMPORT FILE="Sounds\PistolCaseSound.wav"			NAME="PistolCaseSound"			GROUP="Weapons"
#exec AUDIO IMPORT FILE="Sounds\ShellCaseSound.wav"			NAME="ShellCaseSound"			GROUP="Weapons"

#exec AUDIO IMPORT FILE="Sounds\BallisticVestEquip.wav"			NAME="BallisticVestEquip"			GROUP="Pickup"
#exec AUDIO IMPORT FILE="Sounds\BallisticVestUnequip.wav"			NAME="BallisticVestUnequip"			GROUP="Pickup"
#exec AUDIO IMPORT FILE="Sounds\HazmatSuitEquip.wav"			NAME="HazmatSuitEquip"			GROUP="Pickup"
#exec AUDIO IMPORT FILE="Sounds\HazmatSuitUnequip.wav"			NAME="HazmatSuitUnequip"			GROUP="Pickup"
#exec AUDIO IMPORT FILE="Sounds\NightVisionEnable.wav"			NAME="NightVisionEnable"			GROUP="Pickup"
#exec AUDIO IMPORT FILE="Sounds\NightVisionDisable.wav"			NAME="NightVisionDisable"			GROUP="Pickup"
#exec AUDIO IMPORT FILE="Sounds\RebreatherEquip.wav"			NAME="RebreatherEquip"			GROUP="Pickup"
#exec AUDIO IMPORT FILE="Sounds\RebreatherUnequip.wav"			NAME="RebreatherUnequip"			GROUP="Pickup"

#exec AUDIO IMPORT FILE="Sounds\LockpickEquip.wav"			NAME="LockpickEquip"			GROUP="Misc"
#exec AUDIO IMPORT FILE="Sounds\LockpickUnequip.wav"		NAME="LockpickUnequip"			GROUP="Misc"
#exec AUDIO IMPORT FILE="Sounds\LockpickUse.wav"		    NAME="LockpickUse"	    		GROUP="Misc"

#exec AUDIO IMPORT FILE="Sounds\KeyringEquip.wav"			NAME="NanoKeyEquip"		    	GROUP="Misc"
#exec AUDIO IMPORT FILE="Sounds\KeyringUnequip.wav"		    NAME="NanoKeyUnequip"		    GROUP="Misc"

#exec AUDIO IMPORT FILE="Sounds\MultitoolEquip.wav"			NAME="MultitoolEquip"	    	GROUP="Misc"
#exec AUDIO IMPORT FILE="Sounds\MultitoolUnequip.wav"	    NAME="MultitoolUnequip"		    GROUP="Misc"

defaultproperties
{
}
