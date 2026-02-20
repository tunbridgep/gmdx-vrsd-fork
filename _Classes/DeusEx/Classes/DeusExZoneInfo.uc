//=============================================================================
// DXZoneInfo
// SARGE: Defines the property of zones, extended for GMDX
// This will be populated on the player whenever they change zone.
//=============================================================================
class DeusExZoneInfo extends Info;

var() bool bSilentWeaponZone;             //SARGE: If set, weapons fired in this zone by the player will not alert enemies in other zones.

defaultproperties
{
    bStatic=True
    bNoDelete=True
    Texture=Texture'Engine.S_ZoneInfo'
    bAlwaysRelevant=True
}
