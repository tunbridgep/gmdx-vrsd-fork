//=============================================================================
// Pinball.
//=============================================================================
class Pinball extends ElectronicDevices;

var bool bUsing;

function Timer()
{
	bUsing = False;
}

function Frob(actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	if (bUsing)
		return;

	SetTimer(2.0, False);
	bUsing = True;

	PlaySound(sound'PinballMachine',,,, 256);
}

defaultproperties
{
     HitPoints=60
     minDamageThreshold=22
     bInvincible=False
     FragType=Class'DeusEx.MetalFragment'
     bCanBeBase=True
     ItemName="Pinball Machine"
     Mesh=LodMesh'HDTPDecos.HDTPpinball'
     CollisionRadius=37.000000
     CollisionHeight=45.000000
     Mass=100.000000
     Buoyancy=5.000000
}
