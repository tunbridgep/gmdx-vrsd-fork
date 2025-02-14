//=============================================================================
// SARGE: This is a small smoke alarm,
// Was Thrown together from a modified fan base.
// Originally used by GMDX and created manually in the Paris bar map.
// Now it's a separate object.
//=============================================================================
class FireAlarm extends DeusExDecoration;

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
    if (IsHDTP())
        MultiSkins[1] = class'HDTPLoader'.static.GetTexture("CoreTexWallObj.Wall_Objects.graycncrtwall_a");
    else
        Skin = class'HDTPLoader'.static.GetTexture("CoreTexWallObj.Wall_Objects.graycncrtwall_a");
}

defaultproperties
{
     //bInvincible=True
     HitPoints=12
     FragType=Class'DeusEx.MetalFragment'
     ItemName="Smoke Alarm"
     bBlockSight=False
     HDTPMesh="HDTPDecos.HDTPCeilingFanMotor"
     Mesh=LodMesh'DeusExDeco.CeilingFanMotor'
     DrawScale=0.75
     ScaleGlow=0.1
     bUnlit=true
     MultiSkins(1)=Texture'CoreTexWallObj.Wall_Objects.graycncrtwall_a'
     Skin=Texture'CoreTexWallObj.Wall_Objects.graycncrtwall_a'
     CollisionRadius=11.000000
     CollisionHeight=4.42
     Physics=PHYS_None
     bBlockActors=False
     bBlockPlayers=False
     bCollideWorld=False
     bCollideActors=False
     bCanBeBase=False
     bHighlight=False
     bFlammable=False
}
