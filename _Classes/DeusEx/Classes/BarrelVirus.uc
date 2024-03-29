//=============================================================================
// BarrelVirus.
//=============================================================================
class BarrelVirus extends Containers;

defaultproperties
{
     HitPoints=30
     bInvincible=True
     bFlammable=False
     ItemName="NanoVirus Storage Container"
     bBlockSight=True
     Mesh=LodMesh'HDTPDecos.HDTPbarrelambrosia'
     MultiSkins(2)=FireTexture'Effects.liquid.Virus_SFX'
     CollisionRadius=16.000000
     CollisionHeight=28.770000
     LightType=LT_Steady
     LightEffect=LE_WateryShimmer
     LightBrightness=96
     LightRadius=4
     Mass=580.000000
     Buoyancy=90.000000
}
