DetailPrint "Downloading..."
NScurl::http get "https://www.moddb.com/downloads/start/288895" "$EXEDIR\LDDP_Confix.zip" /INSIST /CANCEL /Zone.Identifier /END
Pop $0
${If} $0 == "OK"
	DetailPrint "Download successful"
${Else}
	DetailPrint "Download failed with error $0"
	NScurl::http get "https://sarge945.xyz/files/deusex/testfile2.txt" "$EXEDIR\testfile.txt" /INSIST /CANCEL /Zone.Identifier /END
	Pop $1
	${If} $1 == "OK"
		DetailPrint "Download 2 successful"
	${Else}
		DetailPrint "Download 2 failed with error $0"
	${EndIf}
${EndIf}