//=============================================================================
// WaterZone
//=============================================================================
class WaterZone expands ZoneInfo;

// When an actor enters this zone.
event ActorEntered( actor Other )
{
	local actor A;
	local vector AddVelocity, offset;
    local int i;
    local WaterRing ring;

    offset = Other.Location;

    if (Other.IsA('Fireball') || Other.IsA('Cloud') || Other.Velocity.Z > -140)
        return;

    if ((Other.IsA('Tracer') || (Other.IsA('DeusExProjectile') && Other.Owner != None && !Other.Owner.Region.Zone.bWaterZone)) ||
    Other.IsA('Pawn') || Other.IsA('DeusExDecoration') || Other.IsA('Inventory')) //CyberP: Ha! No need to go to Yuki lengths.
    {
       if (Other.IsA('Fishes') || Other.IsA('Pawn') || (Other.IsA('Inventory') && Other.Owner != None))
          return;

       offset.Z += 10;
       ring = spawn(class'WaterRing',,,offset);
       if (ring != none)
       {
         if (Other.IsA('Tracer') || Other.IsA('DeusExProjectile'))
         {
         if (FRand() < 0.1)
         ring.PlaySound(sound'Bulletwater1',SLOT_None,1.5,,1024);
         else
         {
         ring.PlaySound(sound'Bulletwater4',SLOT_None,1.5,,1024);
         }
         }
         else
         ring.PlaySound(Sound'DeusExSounds.Generic.SplashMedium',SLOT_None,1.0,,1024);
         ring.bScaleOnce=True;
       }
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
         spawn(class'WaterSplash2',,,Other.Location);
         spawn(class'WaterSplash3',,,Other.Location);
    }

	if ( bNoInventory && Other.IsA('Inventory') && (Other.Owner == None) )
	{
		Other.LifeSpan = 1.5;
		return;
	}

	if( Pawn(Other)!=None && Pawn(Other).bIsPlayer )
		if( ++ZonePlayerCount==1 && ZonePlayerEvent!='' )
			foreach AllActors( class 'Actor', A, ZonePlayerEvent )
				A.Trigger( Self, Pawn(Other) );

	if ( bMoveProjectiles && (ZoneVelocity != vect(0,0,0)) )
	{
		if ( Other.Physics == PHYS_Projectile )
			Other.Velocity += ZoneVelocity;
		else if ( Other.IsA('Effects') && (Other.Physics == PHYS_None) )
		{
			Other.SetPhysics(PHYS_Projectile);
			Other.Velocity += ZoneVelocity;
		}
	}
}

defaultproperties
{
     ExitSound=Sound'DeusExSounds.Generic.WaterOut'
     ExitActor=Class'DeusEx.WaterRing'
     bWaterZone=True
     ViewFog=(Y=0.045000,Z=0.090000)
     SoundRadius=0
     AmbientSound=Sound'Ambient.Ambient.Underwater'
}
