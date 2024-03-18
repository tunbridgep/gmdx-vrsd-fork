//=============================================================================
// WaterCooler.
//=============================================================================
class WaterCooler extends DeusExDecoration;

var bool bUsing;
var int numUses;
var localized String msgEmpty;

function Timer()
{
	bUsing = False;
	AmbientSound = None;
}

function Frob(Actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	if (bUsing)
		return;

	if (numUses <= 0)
	{
		if (Pawn(Frobber) != None)
			Pawn(Frobber).ClientMessage(msgEmpty);
		return;
	}
	else if (Frobber.IsA('DeusExPlayer') && DeusExPlayer(Frobber).fullUp >= 100 && (DeusExPlayer(Frobber).bHardCoreMode || DeusExPlayer(Frobber).bRestrictedMetabolism)) //RSD: Added option stuff
	{
	    DeusExPlayer(Frobber).ClientMessage(DeusExPlayer(Frobber).fatty);
	    return;
	}

	SetTimer(2.0, False);
	bUsing = True;

	// heal the frobber a small bit
	if (DeusExPlayer(Frobber) != None)
	{
		DeusExPlayer(Frobber).HealPlayer(2); //CyberP:Extra HP
		DeusExPlayer(Frobber).fullUp += 3;
		if (DeusExPlayer(Frobber).fullUp > 100)                                 //RSD: Capped at 100
    		DeusExPlayer(Frobber).fullUp = 100;
    }
	PlayAnim('Bubble');
	//AmbientSound = sound'WaterBubbling';
	PlaySound(sound'WaterCooler',SLOT_None); //CyberP: new sound
	numUses--;
}

function Destroyed()
{
	local Vector HitLocation, HitNormal, EndTrace;
	local Actor hit;
	local WaterPool pool;

	// trace down about 20 feet if we're not in water
	if (!Region.Zone.bWaterZone && numUses >= 1)
	{
		EndTrace = Location - vect(0,0,320);
		hit = Trace(HitLocation, HitNormal, EndTrace, Location, False);
		pool = spawn(class'WaterPool',,, HitLocation+HitNormal, Rotator(HitNormal));
		spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        PlaySound(sound'SplashSmall', SLOT_None,3.0,, 1280);
        if (pool != None)
        {
			pool.maxDrawScale = CollisionRadius / 8.0; //CyberP: 20
            pool.spreadTime = 0.7;
        }
	}

	Super.Destroyed();
}

defaultproperties
{
     numUses=10
     msgEmpty="It's out of water"
     HitPoints=60
     FragType=Class'DeusEx.PlasticFragment'
     bCanBeBase=True
     ItemName="Water Cooler"
     bPushable=False
     Mesh=LodMesh'HDTPDecos.HDTPWaterCooler'
     CollisionRadius=14.070000
     CollisionHeight=41.570000
     Mass=70.000000
     Buoyancy=100.000000
}
