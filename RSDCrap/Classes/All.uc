//=============================================================================
// AllUI.
//=============================================================================
class All expands Object
	abstract;

// ===========================================================================================================
// DataVault Images
// ===========================================================================================================

#exec TEXTURE IMPORT FILE="Textures\RubberShellBox.pcx"			NAME="RubberShellBox"			GROUP="Items" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\RubberShell.pcx"			NAME="RubberShell"			GROUP="Items" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\SabotShellBox.pcx"			NAME="SabotShellBox"			GROUP="Items" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\SabotShell.pcx"			NAME="SabotShell"			GROUP="Items" MIPS=Off

#exec TEXTURE IMPORT FILE="Textures\CrossDot.pcx"			NAME="CrossDot"			GROUP="UserInterface" MIPS=Off

#exec AUDIO IMPORT FILE="Sounds\PistolCaseSound.wav.pcx"			NAME="PistolCaseSound"			GROUP="Weapons" MIPS=Off
#exec AUDIO IMPORT FILE="Sounds\ShellCaseSound.wav.pcx"			NAME="ShellCaseSound"			GROUP="Weapons" MIPS=Off

defaultproperties
{
}
