// ===========================================================================================================
// Import Properly animated version of MP_Jumpsuit
// This should be superior to GM_Jumpsuit in every way!
// Credit: WCCC
// ===========================================================================================================

class Fixed_Jumpsuit expands Object abstract;

#exec MESH IMPORT MESH=Fixed_Jumpsuit ANIVFILE=Models\Fixed_Jumpsuit_a.3d DATAFILE=Models\Fixed_Jumpsuit_d.3d
#exec MESH ORIGIN MESH=Fixed_Jumpsuit X=0 Y=0 Z=12200 YAW=64
#exec MESH LODPARAMS MESH=Fixed_Jumpsuit STRENGTH=0.5

#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=All              STARTFRAME=0   NUMFRAMES=389
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=Still            STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=Base             STARTFRAME=0   NUMFRAMES=1   RATE=1
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=Walk             STARTFRAME=1   NUMFRAMES=10  RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=Run              STARTFRAME=11  NUMFRAMES=10  RATE=18
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=CrouchWalk       STARTFRAME=21  NUMFRAMES=17  RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=Crouch           STARTFRAME=38  NUMFRAMES=3   RATE=6
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=Stand            STARTFRAME=41  NUMFRAMES=3   RATE=6
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=crouchshoot      STARTFRAME=44  NUMFRAMES=5   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=breathelight     STARTFRAME=49  NUMFRAMES=5   RATE=2
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=deathfront       STARTFRAME=54  NUMFRAMES=13  RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=deathback        STARTFRAME=67  NUMFRAMES=8   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=hithead          STARTFRAME=75  NUMFRAMES=4   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=hittorso         STARTFRAME=79  NUMFRAMES=4   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=hitarmleft       STARTFRAME=83  NUMFRAMES=4   RATE=12
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=hitlegleft       STARTFRAME=87  NUMFRAMES=4   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=hitarmright      STARTFRAME=91  NUMFRAMES=4   RATE=12
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=hitlegright      STARTFRAME=95  NUMFRAMES=4   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=hitheadback      STARTFRAME=99  NUMFRAMES=4   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=hittorsoback     STARTFRAME=103 NUMFRAMES=4   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=mouthclosed      STARTFRAME=107 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=moutha           STARTFRAME=108 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=mouthe           STARTFRAME=109 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=mouthf           STARTFRAME=110 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=mouthm           STARTFRAME=111 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=moutho           STARTFRAME=112 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=moutht           STARTFRAME=113 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=mouthu           STARTFRAME=114 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=Blink            STARTFRAME=115 NUMFRAMES=2   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=shoot            STARTFRAME=117 NUMFRAMES=6   RATE=15
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=attack           STARTFRAME=123 NUMFRAMES=7   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=headup           STARTFRAME=130 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=headdown         STARTFRAME=131 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=headleft         STARTFRAME=132 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=headright        STARTFRAME=133 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=runshoot         STARTFRAME=134 NUMFRAMES=10  RATE=18
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=gestureleft      STARTFRAME=144 NUMFRAMES=9   RATE=20
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=gestureright     STARTFRAME=153 NUMFRAMES=9   RATE=20
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=gestureboth      STARTFRAME=162 NUMFRAMES=9   RATE=20
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=RubEyesStart     STARTFRAME=171 NUMFRAMES=4   RATE=20
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=RubEyes          STARTFRAME=175 NUMFRAMES=4   RATE=7.5
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=RubEyesStop      STARTFRAME=179 NUMFRAMES=4   RATE=15
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=sitbegin         STARTFRAME=183 NUMFRAMES=5   RATE=3
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=Sitstill         STARTFRAME=188 NUMFRAMES=1   RATE=15
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=sitstand         STARTFRAME=189 NUMFRAMES=5   RATE=3
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=pickup           STARTFRAME=194 NUMFRAMES=7   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=jump             STARTFRAME=201 NUMFRAMES=3   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=land             STARTFRAME=204 NUMFRAMES=3   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=panic            STARTFRAME=207 NUMFRAMES=10  RATE=18
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=pushbutton       STARTFRAME=217 NUMFRAMES=6   RATE=5
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=reloadbegin      STARTFRAME=223 NUMFRAMES=4   RATE=8
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=reload           STARTFRAME=227 NUMFRAMES=4   RATE=8
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=reloadend        STARTFRAME=231 NUMFRAMES=7   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=tread            STARTFRAME=238 NUMFRAMES=12  RATE=15
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=treadshoot       STARTFRAME=250 NUMFRAMES=12  RATE=15
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=waterhittorso    STARTFRAME=262 NUMFRAMES=3   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=waterhittorsoback  STARTFRAME=265 NUMFRAMES=3   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=waterdeath       STARTFRAME=268 NUMFRAMES=8   RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=cowerbegin       STARTFRAME=276 NUMFRAMES=4   RATE=20
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=cowerstill       STARTFRAME=280 NUMFRAMES=1  
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=cowerend         STARTFRAME=281 NUMFRAMES=4   RATE=20
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=attackside       STARTFRAME=285 NUMFRAMES=13  RATE=20
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=strafe           STARTFRAME=298 NUMFRAMES=10  RATE=18
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=walk2h           STARTFRAME=308 NUMFRAMES=10  RATE=10
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=strafe2h         STARTFRAME=318 NUMFRAMES=10  RATE=18
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=runshoot2h       STARTFRAME=328 NUMFRAMES=10  RATE=18
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=shoot2h          STARTFRAME=338 NUMFRAMES=7   RATE=20
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=breathelight2h   STARTFRAME=345 NUMFRAMES=5   RATE=2
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=idle1            STARTFRAME=350 NUMFRAMES=15  RATE=6
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=idle12h          STARTFRAME=365 NUMFRAMES=15  RATE=6
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=shocked          STARTFRAME=380 NUMFRAMES=4   RATE=18
#exec MESH SEQUENCE MESH=Fixed_Jumpsuit      SEQ=sitbreathe       STARTFRAME=384 NUMFRAMES=5   RATE=2

#exec MESHMAP SCALE MESHMAP=Fixed_Jumpsuit X=0.00390625 Y=0.00390625 Z=0.00390625

#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Walk                     TIME=0.1        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Walk                     TIME=0.6        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Run                      TIME=0.1        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Run                      TIME=0.6        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=RunShoot         TIME=0.1        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=RunShoot         TIME=0.6        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Panic            TIME=0.1        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Panic            TIME=0.6        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Strafe           TIME=0.1        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Strafe           TIME=0.6        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Walk2H           TIME=0.1        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Walk2H           TIME=0.6        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Strafe2H         TIME=0.1        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Strafe2H         TIME=0.6        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=RunShoot2H       TIME=0.1        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=RunShoot2H       TIME=0.6        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=DeathFront       TIME=0.3        FUNCTION=PlayBodyThud
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=DeathBack        TIME=0.5        FUNCTION=PlayBodyThud
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=Tread            TIME=0.3        FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Fixed_Jumpsuit SEQ=TreadShoot       TIME=0.3        FUNCTION=PlayFootStep
