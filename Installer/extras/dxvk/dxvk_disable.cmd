@echo off

::disable the dlls
ren "d3d9.dll" "d3d9.dll_"
ren "d3d10core.dll" "d3d10core.dll_"
ren "d3d11.dll" "d3d11.dll_"
ren "dxgi.dll" "dxgi.dll_"
