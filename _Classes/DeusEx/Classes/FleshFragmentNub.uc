//=============================================================================
// FleshFragment.
//=============================================================================
class FleshFragmentNub extends DeusExDecoration;

function BeginPlay()
	{
       local Vector HitLocation, HitNormal, EndTrace;
		local Actor hit;
		local BloodPool pool;

		DrawScale=0.95;

     	if (!Region.Zone.bWaterZone)
			{
				EndTrace = Location - vect(0,0,320);
				hit = Trace(HitLocation, HitNormal, EndTrace, Location, False);

			   spawn(class'BloodPool',,, HitLocation+HitNormal, Rotator(HitNormal));
				if (pool != None)
					pool.maxDrawScale = 3;  //hah! Found you you bastard..was making HUUUGE decals. -DDL
			}
    }

defaultproperties
{
     Physics=PHYS_None
     Mesh=LodMesh'DeusExItems.FleshFragment1'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideActors=False
     bCollideWorld=False
}
