SectionGroup "Renderers"
Section "Direct3D9 Renderer (Recommended)"

    SetOutPath $INSTDIR\System
    File game\System\D3D9Drv.*
    SetOutPath $INSTDIR

SectionEnd
Section "Direct3D10 Renderer"
    
    SetOutPath $INSTDIR\System
    File game\System\D3D10Drv.*
    SetOutPath $INSTDIR\System\d3d10drv
    File game\System\d3d10drv\*.*
    SetOutPath $INSTDIR

SectionEnd
SectionGroupEnd

