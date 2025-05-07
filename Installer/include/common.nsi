# We need to define where our u files are located,
# because they are symlinks, and nsis doesn't like symlinks
!define SARGE_U_FILES "F:\Games\Deus Ex GOTY\System"

# Base Info
Name "${INSTALLER_NAME}"
OutFile "${INSTALLER_EXE_NAME}-${INSTALLER_VERSION}_${INSTALLER_SUFFIX}.exe"
ShowInstDetails show

#Set a sensical dir, but read it from the Registry if we can
InstallDir ./
InstallDirRegKey HKLM "SOFTWARE\Unreal Technology\Installed Apps\Deus Ex" "Folder"

#include other plugins
#!include LogicLib.nsh

#Now create the actual installer

;Page license

;licenseText "derp" "derp2"

Page directory

Page components

Page instfiles

# Always overwrite to allow updating in-place

SetOverwrite on

# Install the main mod.
Section "${INSTALLER_NAME} ${INSTALLER_VERSION}"

SectionIn RO

SetOutPath $INSTDIR

IfFileExists "$INSTDIR\System\DeusEx.exe" afterFileCheck
MessageBox MB_OK "GMDX must be installed to your Deus Ex Directory"
Quit
afterFileCheck:

SetOutPath $INSTDIR\GMDX_AE
File /r /x DeusEx.u /x RSDCrap.u /x DeusEx.int game\GMDXvSARGE\*
SetOutPath $INSTDIR\GMDX_AE\System
File "${SARGE_U_FILES}\DeusEx.u"
File "${SARGE_U_FILES}\RSDCrap.u"

;Copy int file
File "..\System\DeusEx.int"

;Install docs
SetOutPath $INSTDIR\GMDX_AE\Docs
File ..\Docs\*.txt
File "..\Docs\*.html"
SetOutPath $INSTDIR\GMDX_AE\vRSD_Docs
File ..\Docs\vRSD_Docs\*.txt

SectionEnd
