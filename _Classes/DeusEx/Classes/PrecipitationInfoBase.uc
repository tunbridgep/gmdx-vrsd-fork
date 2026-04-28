//SARGE: Basic stub class to allow Precipitation to work.
class PrecipitationInfoBase extends Info;

// ----------------------------------------
// default properties for the mapper to set

// basic precipitation settings
var(Precipitation) bool bWeatherActive;
var(Precipitation) float        PrecipRad;         // radius around player where precipitation will be spawned
var(Precipitation) float        PrecipFreq;        // delay in seconds between batches of precipitation
var(Precipitation) byte         PrecipDensity;     // how many particles to spawn in each batch
var(Precipitation) bool         bSlanty;           // precipitation slants in the opposite direction of the player's velocity
var(Precipitation) bool         bImpactParticles;  // should precipitation make impact particles (eg rain drop splashes)?
var(Precipitation) vector       Wind;              // velocity added to precipitation
                                                   // bSlanty doesn't have to be true for precipitation to point
                                                   // in the direction it is falling if wind is on
var(Precipitation) class<Actor> PrecipClass;       // the class of the falling precipitation
var(Precipitation) class<Actor> AltPrecipClass;    // secondary precipitation type, e.g., hail to mix in with rain
var(Precipitation) float        AltPrecipRate;     // probability that an AltPrecipClass will be spawned instead of a PrecipClass
                                                   // 0=never, 1=always

// particle emitter settings for PrecipClass impact (a max of 64 can exist at once)
var(PrecipImpact) float   riseRate;           // how fast do the particles rise
var(PrecipImpact) float   ejectSpeed;         // how fast do the particles get ejected
var(PrecipImpact) int     numPerSpawn;        // max number of particles to spawn per puff
var(PrecipImpact) texture particleTexture;    // replacement texture to use
var(PrecipImpact) float   particleLifeSpan;   // how long each particle lives
var(PrecipImpact) float   particleDrawScale;  // draw scale for each particle
var(PrecipImpact) bool    bParticlesUnlit;    // is each particle unlit?
var(PrecipImpact) bool    bScale;             // scale each particle as it rises?
var(PrecipImpact) bool    bFade;              // fade each particle as it rises?
var(PrecipImpact) bool    bRandomEject;       // random eject velocity vector
var(PrecipImpact) bool    bTranslucent;       // are these particles translucent?
var(PrecipImpact) bool    bGravity;           // are these particles affected by gravity?
var(PrecipImpact) bool    bModulated;         // are these particles modulated?

// settings for impact effect used when precipitation hits water
var(PrecpWtrImpct) bool         bWaterParticles;       // use the same particle effect as solid impacts?
var(PrecpWtrImpct) class<Actor> WaterImpactClass;      // class to spawn when precipitation hits water
var(PrecpWtrImpct) float        WaterImpactSpawnProb;  // probability of spawning this when precipitation htis water
                                                       // 0 = never, 1 = always

// sound settings
var(PrecipSound) Sound PrecipNoise;   // sound that will follow the player
var(PrecipSound) byte  NoiseVolume;   // volume of each sound following the player
var(PrecipSound) int   NoiseMult;     // how many ambient sounds should follow the player
                                      // set this >1 if a single sound at 255 volume isn't loud enough
var(PrecipSound) byte  NoisePitch;    // pitch of each sound following the player
var(PrecipSound) bool  bSplashyFeet;  // is it wet enough to make the player's footsteps splashy?

// -------------------------------------------------
// internal variables that do not concern the mapper
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

function UpdatePrecipitationSettings() { } //SARGE: Update the precipitation settings instantly, no zone changing.
