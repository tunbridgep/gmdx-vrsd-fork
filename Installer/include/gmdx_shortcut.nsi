Section "Create GMDX Shortcut"

SetOutPath "$INSTDIR\System"
CreateShortCut "$SMPROGRAMS\Deus Ex - GMDX.lnk" "$INSTDIR\System\GMDX_AE.exe"
CreateShortCut "$DESKTOP\Deus Ex - GMDX.lnk" "$INSTDIR\System\GMDX_AE.exe"
SetOutPath "$INSTDIR"

SectionEnd
