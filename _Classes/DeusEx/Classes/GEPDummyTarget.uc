//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GEPDummyTarget expands Actor;

//object may be classed as fallen out , don't want this
event FellOutOfWorld()
{
}
//bFixedRotationDir=true

defaultproperties
{
     bHidden=True
     bCanTeleport=True
     bDetectable=False
     bIgnore=True
     DrawType=DT_Mesh
     Style=STY_None
     Mesh=LodMesh'DeusExItems.TestBox'
     bUnlit=True
}
