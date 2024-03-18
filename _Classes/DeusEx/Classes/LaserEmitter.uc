//=============================================================================
// LaserEmitter.
//=============================================================================
class LaserEmitter extends Effects;

#exec OBJ LOAD FILE=Effects

var LaserSpot spot[2];			// max of 2 reflections
var bool bIsOn;
var actor HitActor;
var bool bFrozen;				// are we out of the player's sight?
var bool bRandomBeam;
var bool bBlueBeam;				// is this beam blue?
var bool bHiddenBeam;			// is this beam hidden?

var LaserProxy proxy;

function CalcTrace(float deltaTime)
{
	local vector StartTrace, EndTrace, HitLocation, HitNormal, Reflection;
	local actor target;
	local int i, texFlags;
	local name texName, texGroup;
    local DeusExPlayer player;                                                  //RSD
    local Vector offset;                                                        //RSD

	StartTrace = Location;
	EndTrace = Location + 5000 * vector(Rotation);
	HitActor = None;

	// trace the path of the reflected beam and draw points at each hit
	for (i=0; i<ArrayCount(spot); i++)
	{
		foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace, StartTrace)
		{
			if ((target.DrawType == DT_None) || target.bHidden)
			{
				// do nothing - keep on tracing
			}
			else if ((target == Level) || target.IsA('Mover'))
			{
				break;
			}
			else
			{
				if ((target.IsA('DeusExPlayer') && DeusExPlayer(target).PerkNamesArray[18] == 1)) //RSD: Security Loophole Perk
				{
			    	//headOffsetZ = CollisionHeight * 0.78;
       	        	//headOffsetY = CollisionRadius * 0.35;
            		//armOffset = CollisionRadius * 0.35;
                	player = DeusExPlayer(target);
                	offset = (hitLocation - player.Location) << player.Rotation;
                	if (offset.z < 0.0) //|| offset.z > player.CollisionHeight*0.78) //RSD: Legs or Head, removing Head though
                		//|| abs(offset.y) > player.CollisionRadius*0.35)         //RSD: Arms, don't use because laser won't check through arms to the torso
                		break;
      			}

                HitActor = target;
				break;
			}
		}

		// draw first beam
		if (i == 0)
		{
			if (LaserIterator(RenderInterface) != None)
				LaserIterator(RenderInterface).AddBeam(i, Location, Rotation, VSize(Location - HitLocation));
		}
		else
		{
			if (LaserIterator(RenderInterface) != None)
				LaserIterator(RenderInterface).AddBeam(i, StartTrace - HitNormal, Rotator(Reflection), VSize(StartTrace - HitLocation - HitNormal));
		}

		if (spot[i] == None)
		{
			spot[i] = Spawn(class'LaserSpot', Self, , HitLocation, Rotator(HitNormal));
			if (spot[i] != None)
            {
                if (bHiddenBeam)
                {
                    spot[i].DrawScale = 0.150000;                               //RSD: Making this a bit bigger, was 0.130000
                }
                if (bBlueBeam)
				    spot[i].Skin = Texture'LaserSpot2';
			}
		}
		else
		{
			spot[i].SetLocation(HitLocation);
			spot[i].SetRotation(Rotator(HitNormal));
			if (bHiddenBeam)                                                    //RSD: scale spot size from 0.015-0.15 depending on distance
				spot[i].DrawScale = 0.015000+FMin(0.0001*VSize(StartTrace - HitLocation - HitNormal),0.135000);
		}

		// don't reflect any more if we don't hit a mirror
		// 0x08000000 is the PF_Mirrored flag from UnObj.h
		if ((texFlags & 0x08000000) == 0)
		{
			// kill all of the other spots after this one
			if (i < ArrayCount(spot)-1)
			{
				do
				{
					i++;
					if (spot[i] != None)
					{
						spot[i].Destroy();
						spot[i] = None;
						if (LaserIterator(RenderInterface) != None)
							LaserIterator(RenderInterface).DeleteBeam(i);
					}
				} until (i>=ArrayCount(spot)-1);
			}

			return;
		}

		Reflection = MirrorVectorByNormal(Normal(HitLocation - StartTrace), HitNormal);
		StartTrace = HitLocation + HitNormal;
		EndTrace = Reflection * 10000;
	}
}

function TurnOn()
{
	if (!bIsOn)
	{
		bIsOn = True;
		HitActor = None;
		CalcTrace(0.0);
		if (!bHiddenBeam)
			proxy.bHidden = False;
		SoundVolume = 80;
	}
}

function TurnOff()
{
	local int i;

	if (bIsOn)
	{
        for (i=0; i<ArrayCount(spot); i++)
			if (spot[i] != None)
			{
				spot[i].Destroy();
				spot[i].DrawScale = spot[i].default.DrawScale;                  //RSD
				spot[i] = None;
				//spot[i].DrawScale = spot[i].default.DrawScale;                //RSD: access none
				if (LaserIterator(RenderInterface) != None)
					LaserIterator(RenderInterface).DeleteBeam(i);
			}
		HitActor = None;
		bIsOn = False;
		if (!bHiddenBeam && proxy != None)
			proxy.bHidden = True;
		SoundVolume = 0;
	}
}

function Destroyed()
{
	TurnOff();

	if (proxy != None)
	{
		proxy.Destroy();
		proxy = None;
	}

	Super.Destroyed();
}

function Tick(float deltaTime)
{
	local DeusExPlayer player;

	// check for visibility
	player = DeusExPlayer(GetPlayerPawn());

	if (bIsOn)
	{
		// if we are a weapon's laser sight, do not freeze us
		if ((Owner != None) && (Owner.IsA('Weapon') || Owner.IsA('ScriptedPawn')))
			bFrozen = False;
		else if (proxy != None)
		{
			// if we are close, say 60 feet
			if (proxy.DistanceFromPlayer < 960)
				bFrozen = False;
			else
			{
				// can the player see the generator?
				if (proxy.LastRendered() <= 2.0)
					bFrozen = False;
				else
					bFrozen = True;
			}
		}
		else
			bFrozen = True;

		if (bFrozen)
			return;

		CalcTrace(deltaTime);
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// create our proxy laser beam
	if (proxy == None)
          		proxy = Spawn(class'LaserProxy',,, Location, Rotation);


}

function SetBlueBeam()
{
	bBlueBeam = True;
	if (proxy != None)
		proxy.Skin = Texture'LaserBeam2';
}

function SetHiddenBeam(bool bHide)
{
	bHiddenBeam = bHide;
	if (proxy != None)
		proxy.bHidden = bHide;
}

defaultproperties
{
     SoundRadius=16
     AmbientSound=Sound'Ambient.Ambient.Laser'
     CollisionRadius=40.000000
     CollisionHeight=40.000000
     RenderIteratorClass=Class'DeusEx.LaserIterator'
}
