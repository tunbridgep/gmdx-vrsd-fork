//=============================================================================
// Tracer.
//=============================================================================
class Tracer extends DeusExProjectile;

/*function PostBeginPlay()
{
	Super.PostBeginPlay();            //CyberP: uncomment this when you find a suitable SFX. For bullets whizzing past player's head.

    if (FRand() < 0.3)
	AmbientSound=Sound'Ambient.Ambient.SteamVent2';
}*/

defaultproperties
{
     AccurateRange=16000
     maxRange=16000
     bIgnoresNanoDefense=True
     speed=9000.000000
     MaxSpeed=9000.000000
     Mesh=LodMesh'DeusExItems.Tracer'
     ScaleGlow=2.000000
     bUnlit=True
}
