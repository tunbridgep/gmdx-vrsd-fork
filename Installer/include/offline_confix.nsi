Section "ConFix"

SectionIn RO

SetOutPath $INSTDIR\System
SetOverwrite on
File game\System\ConSys.u
;File game\System\DeusExConAudioAIBarks.u
;File game\System\DeusExConAudioEndGame.u
;File game\System\DeusExConAudioHK_Shared.u
;File game\System\DeusExConAudioIntro.u
;File game\System\DeusExConAudioMission*.u
;File game\System\DeusExConAudioNYShared.u
;File game\System\DeusExConText.u
;File game\System\DeusExConversations.u
File game\System\DeusExText.u
File /x DeusExConAudioFemJC* /x DeusExConAudioLDDP* game\System\DeusExCon*.u
SetOverwrite off
SetOutPath $INSTDIR

SectionEnd
