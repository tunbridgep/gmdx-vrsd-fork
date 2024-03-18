//=============================================================================
// BoxSmall.
//=============================================================================
class BoxSmall extends Containers;

singular function SupportActor(Actor standingActor)  //CyberP: hack lazy patch
{
   if (HitPoints < 20)
      TakeDamage(20, None, Location, vect(0,0,0), 'Stomped');
   else
      super.SupportActor(standingActor);
}

defaultproperties
{
     HitPoints=12
     FragType=Class'DeusEx.PaperFragment'
     ItemName="Cardboard Box"
     bBlockSight=True
     Mesh=LodMesh'HDTPDecos.HDTPboxSmall'
     CollisionRadius=13.000000
     CollisionHeight=5.180000
     Mass=12.000000
     Buoyancy=20.000000
}
