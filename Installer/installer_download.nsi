OutFile "GMDX Augmented Edition 1.0 Downloader.exe"

#plugins etc
!AddPluginDir "NScurl\x86-unicode"

#include the common parts of the installer
!include .\include\common.nsi



#Install ConFix
Section "ConFix"

SectionIn RO

!include .\include\download_confix.nsi

# create a popup box, with an OK button and the text "Hello world!"
# MessageBox MB_OK "Hello world 2!"


SectionEnd

SectionGroup "Renderers"
Section "Direct3D9 Renderer (Recommended)"
SectionEnd
Section "Direct3D10 Renderer"
SectionEnd
SectionGroupEnd

SectionGroup "Extras"
#Install LDDP
Section "Lay-D Denton Project"
	
SectionEnd

#Install HDTP
Section "HDTP"

SectionEnd

#Install New Vision
Section "New Vision"

SectionEnd
SectionGroupEnd