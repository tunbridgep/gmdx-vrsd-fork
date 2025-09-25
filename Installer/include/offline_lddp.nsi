Section "Lay-D Denton Project"

SetOutPath $INSTDIR\Mods\LDDP\System
File game\System\FemJC.u
File game\System\DeusEx.u
;Install con-fix femJC audio files
SetOutPath $INSTDIR\System
File game\System\DeusExConAudioFemJC*.u
File game\System\DeusExConAudioLDDP*.u
SetOutPath $INSTDIR

SectionEnd
