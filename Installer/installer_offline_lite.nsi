!define INSTALLER_NAME "GMDX: Augmented Edition"
!define INSTALLER_EXE_NAME "GMDX-AE"
!define INSTALLER_VERSION "1.0"
!define INSTALLER_SUFFIX "Lite"

#include the common parts of the installer
!include .\include\common.nsi
!include .\include\offline_confix.nsi

# create a popup box, with an OK button and the text "Hello world!"
# MessageBox MB_OK "Hello world 2!"

# Install DX9 and DX10 renderers
!include .\include\renderers.nsi

SectionGroup "Extras"

#Install Kenties
!include .\include\kenties.nsi

#Install GMDX Settings
!include .\include\gmdx_settings.nsi

#Install LDDP
!include .\include\offline_lddp.nsi

#Install Augmentique
!include .\include\offline_jcoutfits.nsi

SectionGroupEnd
