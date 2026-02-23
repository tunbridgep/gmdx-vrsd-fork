//SARGE: Basic stub class to allow Precipitation to work.
class PrecipitationInfoBase extends Info;

//SARGE: Static function to get an info for a given zeon
static function PrecipitationInfoBase GetBaseInfoFromZone(ZoneInfo Z)
{
    local PrecipitationInfoBase PI;
	foreach Z.AllActors( class'PrecipitationInfoBase', PI )
    {
        if (PI.Region.Zone == Z)
            return PI;
    }
    return None;
}

function float RainStep( Pawn P, name FloorMaterial, float volume, float range, float pitch )
{
    return 1.0;
}

event ActorEntered( Actor Other )
{
}

event ActorLeaving( Actor Other )
{
}
