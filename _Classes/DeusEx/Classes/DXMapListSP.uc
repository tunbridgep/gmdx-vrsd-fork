//=============================================================================
// DXMapList.
//
// contains a list of maps to cycle through
//
//=============================================================================
class DXMapListSP extends Maplist;

var(Maps) globalconfig string Maps[72];
var globalconfig string MapSizes[72];
var globalconfig int MapNum;
var localized string CycleNames[10];

// NumTypes is the number of total cycle types
// Not using an enum because it is hard for other classes to access

var globalconfig int CycleType;
const MCT_STATIC = 0;
const MCT_RANDOM = 1;
const MCT_CYCLE = 2;

var int NumTypes;

function string GetCurrentMap()
{
	return GetLevelInfo().MapName;
}

function string GetNextMap()
{
	local string CurrentMap;
    local int NumMaps;
	local int i;

	//CurrentMap = GetURLMap();
	CurrentMap = GetLevelInfo().MapName;
	if ( CurrentMap != "" )
	{
      //Strip off any .dx                                                       //RSD: No need, just get the damn mapName from level info jesus
		/*if ( Right(CurrentMap,3) ~= ".dx" )
			CurrentMap = Left(CurrentMap,Len(CurrentMap)-3);
		else
			CurrentMap = CurrentMap;*/

		for ( i=0; i<ArrayCount(Maps); i++ )
		{
			if ( CurrentMap ~= Maps[i] )
			{
				MapNum = i;
				break;
			}
		}
	}

   //Count number of maps
   for (i = 0; ( (i < ArrayCount(Maps)) && (Maps[i] != "") ); i++);
   NumMaps = i;

   if (CycleType == MCT_STATIC)
   {
      MapNum = MapNum;
   }
   else if (CycleType == MCT_RANDOM)
   {
      MapNum = FRand() * NumMaps;
      if (MapNum >= NumMaps)
         MapNum = 0;
   }
   else if (CycleType == MCT_CYCLE)
   {
      MapNum++;
      if (MapNum >= NumMaps)
         MapNum = 0;
   }

   //save out our current mapnum
   SaveConfig();

   return Maps[MapNum];
}

// ----------------------------------------------------------------------
// GetLevelInfo()
// ----------------------------------------------------------------------

function DeusExLevelInfo GetLevelInfo()
{
	local DeusExLevelInfo info;


	foreach AllActors(class'DeusExLevelInfo', info)
		break;

//   log("MYCHK:LevelInfo: ,"@info.Name);

	return info;
}

defaultproperties
{
     Maps(0)="01_NYC_UNATCOHQ"
     Maps(1)="01_NYC_UNATCOIsland"
     Maps(2)="02_NYC_Bar"
     Maps(3)="02_NYC_BatteryPark"
     Maps(4)="02_NYC_FreeClinic"
     Maps(5)="02_NYC_Hotel"
     Maps(6)="02_NYC_Smug"
     Maps(7)="02_NYC_Street"
     Maps(8)="02_NYC_Underground"
     Maps(9)="02_NYC_Warehouse"
     Maps(10)="03_NYC_747"
     Maps(11)="03_NYC_Airfield"
     Maps(12)="03_NYC_AirfieldHeliBase"
     Maps(13)="03_NYC_BatteryPark"
     Maps(14)="03_NYC_BrooklynBridgeStation"
     Maps(15)="03_NYC_Hangar"
     Maps(16)="03_NYC_MolePeople"
     Maps(17)="03_NYC_UNATCOHQ"
     Maps(18)="03_NYC_UNATCOIsland"
     Maps(19)="04_NYC_Bar"
     Maps(20)="04_NYC_BatteryPark"
     Maps(21)="04_NYC_Hotel"
     Maps(22)="04_NYC_NSFHQ"
     Maps(23)="04_NYC_Smug"
     Maps(24)="04_NYC_Street"
     Maps(25)="04_NYC_UNATCOHQ"
     Maps(26)="04_NYC_UNATCOIsland"
     Maps(27)="04_NYC_Underground"
     Maps(28)="05_NYC_UNATCOHQ"
     Maps(29)="05_NYC_UNATCOIsland"
     Maps(30)="05_NYC_UNATCOMJ12lab"
     Maps(31)="06_HongKong_Helibase"
     Maps(32)="06_HongKong_MJ12lab"
     Maps(33)="06_HongKong_Storage"
     Maps(34)="06_HongKong_TongBase"
     Maps(35)="06_HongKong_VersaLife"
     Maps(36)="06_HongKong_WanChai_Canal"
     Maps(37)="06_HongKong_WanChai_Garage"
     Maps(38)="06_HongKong_WanChai_Market"
     Maps(39)="06_HongKong_WanChai_Street"
     Maps(40)="06_HongKong_WanChai_Underworld"
     Maps(41)="08_NYC_Bar"
     Maps(42)="08_NYC_FreeClinic"
     Maps(43)="08_NYC_Hotel"
     Maps(44)="08_NYC_Smug"
     Maps(45)="08_NYC_Street"
     Maps(46)="08_NYC_Underground"
     Maps(47)="09_NYC_Dockyard"
     Maps(48)="09_NYC_Graveyard"
     Maps(49)="09_NYC_Ship"
     Maps(50)="09_NYC_ShipBelow"
     Maps(51)="09_NYC_ShipFan"
     Maps(52)="10_Paris_Catacombs"
     Maps(53)="10_Paris_Catacombs_Tunnels"
     Maps(54)="10_Paris_Chateau"
     Maps(55)="10_Paris_Club"
     Maps(56)="10_Paris_Metro"
     Maps(57)="11_Paris_Cathedral"
     Maps(58)="11_Paris_Everett"
     Maps(59)="11_Paris_Underground"
     Maps(60)="12_Vandenberg_Cmd"
     Maps(61)="12_Vandenberg_Computer"
     Maps(62)="12_Vandenberg_Gas"
     Maps(63)="12_Vandenberg_Tunnels"
     Maps(64)="14_OceanLab_Lab"
     Maps(65)="14_Oceanlab_Silo"
     Maps(66)="14_OceanLab_UC"
     Maps(67)="14_Vandenberg_Sub"
     Maps(68)="15_Area51_Bunker"
     Maps(69)="15_Area51_Entrance"
     Maps(70)="15_Area51_Final"
     Maps(71)="15_Area51_Page"
     CycleNames(0)="Repeat map"
     CycleNames(1)="Random map"
     CycleNames(2)="Loop maps"
     NumTypes=3
}
