::Use BAT to EXE converter to make GMDX_AE.exe
::https://github.com/l-urk/Bat-To-Exe-Converter-64-Bit/releases

@echo off

::Replace deusex.int
if not exist DeusEx.int_vanilla (
    echo Backing up original DeusEx.int...
    copy DeusEx.int DeusEx.int_vanilla /v
)

del "DeusEx.int"
echo Swapping int file...
copy "..\GMDX_AE\System\DeusEx.int" "DeusEx.int"

DeusEx.exe INI="..\GMDX_AE\System\DeusEx.ini" USERINI="..\GMDX_AE\System\User.ini" %*

if exist DeusEx.int_vanilla (
    echo Restoring original DeusEx.int...
    del "DeusEx.int"
    copy "DeusEx.int_vanilla" "DeusEx.int"
)
