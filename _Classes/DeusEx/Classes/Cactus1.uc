//=============================================================================
// Cactus1.
//=============================================================================
class Cactus1 extends OutdoorThings;

function Bump(actor Other)
{
	local DeusExPlayer player;

    super.Bump(Other);

	player = DeusExPlayer(Other);

	if (player != None)
	{
	    player.TakeDamage(2,player,vect(0,0,0),vect(0,0,0),'shot');
	}
}

defaultproperties
{
     Mesh=LodMesh'DeusExDeco.Cactus1'
     CollisionRadius=33.000000
     CollisionHeight=81.260002
     Mass=1000.000000
     Buoyancy=5.000000
}
