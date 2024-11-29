//=============================================================================
// ShopLight.
//=============================================================================
class ShopLight extends DeusExDecoration;

var bool bUsing;

/*function Frob(actor Frobber, Inventory frobWith)
{
local vector armLoc;

	Super.Frob(Frobber, frobWith);

	if (bUsing || !bHighlight)
		return;

	SetTimer(2.0, False);
	bUsing = True;

	if (Frobber.IsA('Pawn'))
	{
	    armLoc.X = Pawn(Frobber).Location.X + (CollisionRadius*0.5);
        armLoc.Y = Pawn(Frobber).Location.Y + (CollisionRadius*0.75);
	    armLoc.Z = Pawn(Frobber).Location.Z;
	    Pawn(Frobber).TakeDamage(3, Pawn(Frobber), armLoc, vect(0,0,0), 'Burned');
	}
}*/

function Timer()
{
	bUsing = False;
}

defaultproperties
{
     HitPoints=3
     FragType=Class'DeusEx.GlassFragment'
     ItemName="Fluorescent Light"
     HDTPMesh="HDTPDecos.HDTPShoplight"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'HDTPDecos.HDTPShoplight'
     CollisionRadius=42.500000
     CollisionHeight=4.000000
     Mass=30.000000
     Buoyancy=25.000000
}
