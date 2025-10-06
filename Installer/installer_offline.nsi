# THIS INSTALLER IS FUCKING HUGE!
# As a result, you need to use NSISBI, from here:
# https://sourceforge.net/projects/nsisbi/

!define INSTALLER_NAME "GMDX: Augmented Edition"
!define INSTALLER_EXE_NAME "GMDX-AE"
!define INSTALLER_VERSION "1.1"
!define INSTALLER_SUFFIX "Full"

#include the common parts of the installer
!include .\include\common.nsi
!include .\include\offline_confix.nsi

# create a popup box, with an OK button and the text "Hello world!"
# MessageBox MB_OK "Hello world 2!"

# Install DX9 and DX10 renderers
!include .\include\renderers.nsi


SectionGroup "Extras"

#Install GMDX Settings
!include .\include\gmdx_settings.nsi

#Create Shortcut
!include .\include\gmdx_shortcut.nsi

#Install VCRedist
!include .\include\offline_vcredist.nsi

#Install Kenties
!include .\include\kenties.nsi

#Install LDDP
!include .\include\offline_lddp.nsi

#Install HDTP
!include .\include\offline_HDTP.nsi

#Install New Vision
!include .\include\offline_NV.nsi

#Install Augmentique
!include .\include\offline_jcoutfits.nsi

#Install Visible Attachments
!include .\include\offline_visible_attachments.nsi

SectionGroupEnd
