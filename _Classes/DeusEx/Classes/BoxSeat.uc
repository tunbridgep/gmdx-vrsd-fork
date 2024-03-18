//=============================================================================
// BoxSeat //CyberP: a box that pawns can sit on.
//=============================================================================
class BoxSeat extends Seat;

defaultproperties
{
     sitPoint(0)=(X=0.000000,Y=-7.000000,Z=12.000000)
     HitPoints=10
     ItemName="Wooden Box"
     Skin=Texture'GMDXSFX.Skins.WoodBoxTex'
     Mesh=LodMesh'DeusExItems.DXMPAmmobox'
     DrawScale=0.750000
     CollisionRadius=16.875000
     CollisionHeight=11.000000
     Mass=30.000000
     Buoyancy=5.000000
}
