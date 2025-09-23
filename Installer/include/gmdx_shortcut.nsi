Section "Create GMDX Shortcut"

SetOutPath "$INSTDIR\System"
CreateShortCut "$SMPROGRAMS\GMDX Augmented Edition.lnk" "$INSTDIR\System\GMDX_AE.exe" "" "$INSTDIR\GMDX_AE\gmdxicon.ico" 0
CreateShortCut "$DESKTOP\GMDX Augmented Edition.lnk" "$INSTDIR\System\GMDX_AE.exe" "" "$INSTDIR\GMDX_AE\gmdxicon.ico" 0
SetOutPath "$INSTDIR"

SectionEnd
