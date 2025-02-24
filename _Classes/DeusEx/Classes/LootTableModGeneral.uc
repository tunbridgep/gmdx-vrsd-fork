//=============================================================================
// LootTableModAmmo
//=============================================================================
class LootTableModGeneral extends LootTable;

defaultproperties
{
     entries(0)=(Item=Class'DeusEx.WeaponModAccuracy',weight=16)
     entries(1)=(Item=Class'DeusEx.WeaponModRecoil',weight=16)
     entries(2)=(Item=Class'DeusEx.WeaponModRange',weight=17)
     entries(3)=(Item=Class'DeusEx.WeaponModReload',weight=19)
     entries(4)=(Item=Class'DeusEx.WeaponModClip',weight=19)
     entries(5)=(Item=Class'DeusEx.WeaponModDamage',weight=19)
     entries(6)=(Item=Class'DeusEx.WeaponModAuto',weight=19)
     entries(7)=(Item=Class'DeusEx.WeaponModLaser',weight=6) //SARGE: Was 7, one is now hand placed (Smuggler's Safe, first visit)
     entries(8)=(Item=Class'DeusEx.WeaponModScope',weight=4)
     entries(9)=(Item=Class'DeusEx.WeaponModSilencer',weight=1) //SARGE: WAS 2, one is now hand placed (Paul's Closet, first visit)
     //entries(10)=(Item=Class'DeusEx.WeaponModFullAuto',weight=1) //SARGE: Now hand placed (Tong's Lab).
}
