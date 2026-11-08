//=============================================================================
// SARGE: Math Utils
// Functions to assist with angles, vectors, and other shenanigans
//=============================================================================
class MathUtils extends Object abstract;

//Given 2 rotations, fix them so that we can use them to find the shortest
//distance between them. Since we can go from 0-65535 by moving 1 unit, we
//need to convert diffs that are further than 180 degrees, as it means we've
//crossed the point where we loop back around.
//This is hacky and shit 
//NOTE: Does not handle Roll at all!
static function Rotator GetRotationBetween(Rotator r1, Rotator r2, float distance, float max)
{
    local Rotator result;

    log("$1" @ r1.Pitch @ r1.Yaw);

    //First convert everything to the 1-32767 space
    if (r1.Pitch < 0)
        r1.Pitch += 65536;
    if (r2.Pitch < 0)
        r2.Pitch += 65536;
    
    if (r1.Yaw < 0)
        r1.Yaw += 65536;
    if (r2.Yaw < 0)
        r2.Yaw += 65536;
    
    log("$2" @ r1.Pitch @ r1.Yaw);

    //SARGE: Fix wrapping past 360 degrees...
    r1.Pitch = r1.Pitch % 65536;
    r1.Yaw = r1.Yaw % 65536;
    r2.Pitch = r2.Pitch % 65536;
    r2.Yaw = r2.Yaw % 65536;
    
    log("$3" @ r1.Pitch @ r1.Yaw);
    
    //If the difference between them is > 180 degrees,
    //then we need to make sure we actually find the shortest angle.
    //This can happen because sometimes we cross a threshold.
    //For instance, going from 65535 (359*) to 5 (1*) is only a 1 degree change,
    //but the numbers look huge. So we need to adjust it...
    if (abs(r1.Pitch - r2.Pitch) > 32768)
    {
        if (r2.Pitch > 32768)
            r2.Pitch -= 65536;
        else
            r2.Pitch += 65536;
    }
    if (abs(r1.Yaw - r2.Yaw) > 32768)
    {
        if (r2.Yaw > 32768)
            r2.Yaw -= 65536;
        else
            r2.Yaw += 65536;
    }

    result = r1;

    //Now that it's all fixed up, get the actual new position
    if (r1.Pitch < r2.Pitch)
    {
        result.Pitch = r2.Pitch - distance;
        result.Pitch = FMAX(r1.Pitch,result.Pitch);
        result.Pitch = FMIN(result.Pitch,r1.Pitch + max);
    }
    else if (r1.Pitch > r2.Pitch)
    {
        result.Pitch = r2.Pitch + distance;
        result.Pitch = FMIN(r1.Pitch,result.Pitch);
        result.Pitch = FMAX(result.Pitch,r1.Pitch - max);
    }
    
    if (r1.Yaw < r2.Yaw)
    {
        result.Yaw = r2.Yaw - distance;
        result.Yaw = FMAX(r1.Yaw,result.Yaw);
        result.Yaw = FMIN(result.Yaw,r1.Yaw + max);
    }
    else if (r1.Yaw > r2.Yaw)
    {
        result.Yaw = r2.Yaw + distance;
        result.Yaw = FMIN(r1.Yaw,result.Yaw);
        result.Yaw = FMAX(result.Yaw,r1.Yaw - max);
    }

    return result;
}
