//SARGE: Basic stub class to allow Precipitation to work.
class PrecipitationInfoBase extends Info;

var private transient class<PrecipitationInfoBase> infoClass;

static function private PrecipitationInfoBase GetBaseInfo()
{
    if (default.infoClass == None)
        default.infoClass = class<PrecipitationInfoBase>(DynamicLoadObject("Precipitation.PrecipitationInfo", class'Class'));
    if (default.infoClass == None)
        default.infoClass = class'PrecipitationInfoBase';
}

//SARGE: Static function to get an info for a given zeon
static function PrecipitationInfoBase GetBaseInfoFromZone(ZoneInfo Z)
{
    local PrecipitationInfoBase PI;

    GetBaseInfo();

	foreach Z.AllActors(class'PrecipitationInfoBase', PI )
    {
        if (PI.Region.Zone == Z)
            return PI;
    }
    return None;
}

function static float RainStep( Pawn P, name FloorMaterial, float volume, float range, float pitch )
{
    GetBaseInfo();
    if (default.infoClass != class'PrecipitationInfoBase') //Infinite recursion otherwise!
        return default.infoClass.static.RainStep(P,FloorMaterial,volume,range,pitch);
    else
        return 1.0;
}

event ActorEntered( Actor Other )
{
}

event ActorLeaving( Actor Other )
{
}
