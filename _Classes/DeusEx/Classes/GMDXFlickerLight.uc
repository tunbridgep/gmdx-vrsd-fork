//=============================================================================
// GMDX:modified The ConLight class.
//=============================================================================
class GMDXFlickerLight extends Light;

var float actorDistance;

// ----------------------------------------------------------------------
// TurnOn()
// ----------------------------------------------------------------------

function TurnOn()
{
	//LightType = LT_Flicker; CyberP: commented out for now.
}

// ----------------------------------------------------------------------
// TurnOff()
// ----------------------------------------------------------------------

function TurnOff()
{
	LightType = LT_None;
}

// ----------------------------------------------------------------------
// UpdateLocation()
// ----------------------------------------------------------------------

function UpdateLocation(Actor lightActor)
{
	local Vector dirVect;
	local Vector eyeVect;
	local Float eyeHeight;

	if (lightActor == None)
	{
		TurnOff();
	}
	else
	{
		TurnOn();

//		if (lightActor.IsA('Pawn'))
//			dirVect = Vector(lightActor.Rotation + Pawn(lightActor).AIAddViewRotation) * actorDistance;
//		else

		dirVect = Vector(lightActor.Rotation) * actorDistance;

		if (lightActor.IsA('Pawn'))
			eyeHeight = Pawn(lightActor).baseEyeHeight;
		else if (lightActor.IsA('Decoration'))
			eyeHeight = Decoration(lightActor).baseEyeHeight;
		else
			eyeHeight = 0;

		eyeVect = Vect(0, 0, 1) * eyeHeight + lightActor.location;
		dirVect += eyeVect;

		SetLocation(dirVect);
		SetRotation(Rotator(eyeVect - dirVect));
	}
}

// ----------------------------------------------------------------------
// if bMovable = False, then the light causes actors to flash for some fucked up reason
// ----------------------------------------------------------------------

defaultproperties
{
     actorDistance=8.000000
     bStatic=False
     bNoDelete=False
     bMovable=True
     LightType=LT_None
     LightEffect=LE_Interference
     LightBrightness=8
     LightHue=16
     LightSaturation=160
     LightRadius=16
}
