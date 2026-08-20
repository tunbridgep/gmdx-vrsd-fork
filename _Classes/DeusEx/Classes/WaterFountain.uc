//=============================================================================
// WaterFountain.
//=============================================================================
class WaterFountain extends DeusExDecoration;

var bool bUsing;
var int numUses;
var localized String msgEmpty;

function Timer()
{
	bUsing = False;
	PlayAnim('Still');
	AmbientSound = None;
}

function Frob(Actor Frobber, Inventory frobWith)
{
    local string RestrictedMsg;
	Super.Frob(Frobber, frobWith);

	if (bUsing)
    {
		return;
    }
	else if (numUses <= 0)
	{
		if (Pawn(Frobber) != None)
			Pawn(Frobber).ClientMessage(msgEmpty);
		return;
	}
    
	if (DeusExPlayer(Frobber) != None && !DeusExPlayer(Frobber).HungerCheck(RestrictedMsg))
    {
        if (RestrictedMsg != "")
            DeusExPlayer(Frobber).clientMessage(RestrictedMsg);
        return;
    }

	SetTimer(2.0, False);
	bUsing = True;

	// heal the frobber a small bit
	if (DeusExPlayer(Frobber) != None)
	{
		DeusExPlayer(Frobber).HealPlayer(1);
		DeusExPlayer(Frobber).fullUp += 3;
		if (DeusExPlayer(Frobber).fullUp > 200)
    		DeusExPlayer(Frobber).fullUp = 200;
    }

	LoopAnim('Use');
	AmbientSound = sound'WaterBubbling';
	numUses--;
}

defaultproperties
{
     numUses=10
     msgEmpty="It's out of water"
     HitPoints=70
     bCanBeBase=True
     ItemName="Water Fountain"
     bPushable=False
     Physics=PHYS_None
     HDTPMesh="HDTPDecos.HDTPWaterFountain"
     Mesh=LodMesh'DeusExDeco.WaterFountain'
     CollisionRadius=20.000000
     CollisionHeight=24.360001
     Mass=70.000000
     Buoyancy=100.000000
}
