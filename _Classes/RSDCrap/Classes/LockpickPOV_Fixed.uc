// ===========================================================================================================
// Import Fixed version of Lockpick POV model.
// Fixed the missing surface on the top of the model.
// Credit: cappucciNO
// ===========================================================================================================

class LockpickPOV_Fixed expands Object abstract;

#exec MESH IMPORT MESH=LockpickPOV_Fixed ANIVFILE=Models\LockpickPOV_a.3d DATAFILE=Models\LockpickPOV_d.3d
#exec MESH ORIGIN MESH=LockpickPOV_Fixed X=0 Y=0 Z=0 YAW=-64
#exec MESHMAP SCALE MESHMAP=LockpickPOV_Fixed X=0.00390625 Y=0.00390625 Z=0.00390625
#exec MESH SEQUENCE MESH=LockpickPOV_Fixed SEQ=All		STARTFRAME=0	NUMFRAMES=54
#exec MESH SEQUENCE MESH=LockpickPOV_Fixed SEQ=Still		STARTFRAME=0	NUMFRAMES=1
#exec MESH SEQUENCE MESH=LockpickPOV_Fixed SEQ=Select		STARTFRAME=1	NUMFRAMES=8		RATE=18
#exec MESH SEQUENCE MESH=LockpickPOV_Fixed SEQ=UseBegin	STARTFRAME=9	NUMFRAMES=5		RATE=17
#exec MESH SEQUENCE MESH=LockpickPOV_Fixed SEQ=UseLoop	STARTFRAME=14	NUMFRAMES=6		RATE=19
#exec MESH SEQUENCE MESH=LockpickPOV_Fixed SEQ=UseEnd		STARTFRAME=20	NUMFRAMES=5		RATE=17
#exec MESH SEQUENCE MESH=LockpickPOV_Fixed SEQ=Down		STARTFRAME=25	NUMFRAMES=5		RATE=17
#exec MESH SEQUENCE MESH=LockpickPOV_Fixed SEQ=Idle1		STARTFRAME=30	NUMFRAMES=8		RATE=2
#exec MESH SEQUENCE MESH=LockpickPOV_Fixed SEQ=Idle2		STARTFRAME=38	NUMFRAMES=8		RATE=2
#exec MESH SEQUENCE MESH=LockpickPOV_Fixed SEQ=Idle3		STARTFRAME=46	NUMFRAMES=8		RATE=2

#exec TEXTURE IMPORT NAME=LockpickPOVTex1_Fixed FILE=Textures\Skins\LockpickPOVTex1_Fixed.bmp GROUP="Skins"
#exec MESHMAP SETTEXTURE MESHMAP=LockpickPOV_Fixed NUM=0 TEXTURE=WeaponHandsTex
#exec MESHMAP SETTEXTURE MESHMAP=LockpickPOV_Fixed NUM=1 TEXTURE=LockpickPOVTex1_Fixed
