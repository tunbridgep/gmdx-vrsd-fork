Section "GMDX Profile and Settings"

SetOutPath $INSTDIR\System
File extras\GMDX_AE.exe
SetOutPath $INSTDIR\GMDX_AE\System
File extras\DeusEx.ini
File extras\User.ini
SetOutPath $INSTDIR

#CreateShortCut "$SMPROGRAMS\Deus Ex - GMDX.lnk" "$INSTDIR\System\GMDX_AE.cmd"

SectionEnd

/*
Section "Modernised Settings"

SetOverwrite on
SetOutPath $INSTDIR\GMDX_AE\System
File extras\Modern.ini /oname=User.ini
SetOverwrite off

SectionEnd
*/
