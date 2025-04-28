# Base Info
Name "GMDX: AE Installer" "GMDX: Augmented Edition 1.0"
ShowInstDetails show

#Set a sensical dir, but read it from the Registry if we can
InstallDir ./
InstallDirRegKey HKLM "SOFTWARE\Unreal Technology\Installed Apps\Deus Ex" "Folder"

#include other plugins
!include LogicLib.nsh


#Now create the actual installer

Page license

licenseText "derp" "derp2"

Page directory

Page components

Page instfiles

# Install the main mod.
Section "GMDX Augmented Edition"

SectionIn RO

SetOutPath $INSTDIR

;File test.txt

SectionEnd