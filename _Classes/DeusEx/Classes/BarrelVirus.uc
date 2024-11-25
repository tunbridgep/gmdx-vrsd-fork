//=============================================================================
// BarrelVirus.
//=============================================================================
class BarrelVirus extends Containers;

//Fix stupid HDTP Bug when switching models
exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
    if (iHDTPModelToggle > 0)
    {
        MultiSkins[2]=FireTexture'Effects.liquid.Virus_SFX';
        MultiSkins[1]=None;
    }
    else
    {
        MultiSkins[1]=FireTexture'Effects.liquid.Virus_SFX';
        MultiSkins[2]=None;
    }
        
}


defaultproperties
{
     HitPoints=30
     bInvincible=True
     bFlammable=False
     ItemName="NanoVirus Storage Container"
     bBlockSight=True
     HDTPMesh="HDTPDecos.HDTPbarrelambrosia"
     Mesh=LodMesh'DeusExDeco.BarrelAmbrosia'
     //MultiSkins(2)=FireTexture'Effects.liquid.Virus_SFX'
     CollisionRadius=16.000000
     CollisionHeight=28.770000
     LightType=LT_Steady
     LightEffect=LE_WateryShimmer
     LightBrightness=96
     LightRadius=4
     Mass=580.000000
     Buoyancy=90.000000
}
