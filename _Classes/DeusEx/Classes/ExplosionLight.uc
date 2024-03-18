//=============================================================================
// ExplosionLight
//=============================================================================
class ExplosionLight extends Light;

var int size;
var int delay;

function Timer()
{
	if (size > 0)
	{
		LightRadius = Clamp(size, 1, 40);
		size = -1;
	}
    delay++;
    if (delay > 3)
	   LightRadius-=2;

	if (LightRadius < 1)
		Destroy();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.1, True);
}

defaultproperties
{
     size=1
     bStatic=False
     bNoDelete=False
     bMovable=True
     RemoteRole=ROLE_SimulatedProxy
     LightEffect=LE_FireWaver
     LightBrightness=255
     LightHue=20
     LightSaturation=160
     LightRadius=1
     bVisionImportant=True
}
