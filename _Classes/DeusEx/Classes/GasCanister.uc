//=============================================================================
// GasCanister
// SARGE: A decodative, explosive item.
// Only used in the OceanLab mission.
// Was originally just a crate with a Napalm model,
// Now it's a fully fledged object
//=============================================================================
class GasCanister extends DeusExDecoration;

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
    if (IsHDTP())
        MultiSkins[1]=Texture'CoreTexMetal.Metal.MetlStorBarrl_E';
    else
		MultiSkins[1]=None;
}

defaultproperties
{
     bBlockSight=True
     HDTPMesh="HDTPItems.HDTPammoNapalm"
     Mesh=LodMesh'DeusExItems.AmmoNapalm'
	 Skin=Texture'CoreTexMetal.Metal.MetlStorBarrl_E'
     Buoyancy=90.000000
     minDamageThreshold=2
     bFlammable=True
     bCanBeBase=True
     FamiliarName="Gas Cannister"
     UnfamiliarName="Gas Cannister"
     DrawScale=4.000000
     CollisionRadius=14.000000
     CollisionHeight=38.000000
     Mass=160.000000
     Physics=PHYS_None
     HitPoints=1
     FragType=Class'DeusEx.MetalFragment'
     bExplosive=True
     explosionDamage=200
     explosionRadius=320.000000
}
