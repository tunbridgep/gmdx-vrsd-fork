Section "Visual C++ Redistributable"

SetOutPath $INSTDIR
File extras\VC_redist.x86.exe
ExecWait '"$INSTDIR\VC_redist.x86.exe" /install /passive /norestart'
Delete $INSTDIR\VC_redist.x86.exe

SectionEnd
