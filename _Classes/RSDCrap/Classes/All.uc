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

#exec TEXTURE IMPORT FILE="Textures\HudAmmoDisplayBackgroundSecondary.pcx"			NAME="HudAmmoDisplayBackgroundSecondary"			GROUP="UserInterface"
#exec TEXTURE IMPORT FILE="Textures\HudAmmoDisplayBorderSecondary.pcx"			NAME="HudAmmoDisplayBorderSecondary"			GROUP="UserInterface"

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
