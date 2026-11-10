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
static function Rotator GetRotationBetween(Rotator r1, Rotator r2)
{
    local Rotator result;

    //Normalize first
    r1 = NormalizeRotator(r1);
    r2 = NormalizeRotator(r2);
    
    //If the difference between them is > 180 degrees,
    //then we need to make sure we actually find the shortest angle.
    //This can happen because sometimes we cross a threshold.
    //For instance, going from 65535 (359*) to 5 (1*) is only a 1 degree change,
    //but the numbers look huge. So we need to adjust it...
    if (abs(r1.Pitch - r2.Pitch) > 32767)
    {
        if (r2.Pitch > 32767)
            r2.Pitch -= 65535;
        else
            r2.Pitch += 65535;
    }
    if (abs(r1.Yaw - r2.Yaw) > 32767)
    {
        if (r2.Yaw > 32767)
            r2.Yaw -= 65535;
        else
            r2.Yaw += 65535;
    }

    return r2;
}

//Clamps a rotator to 0-65535
static function Rotator NormalizeRotator(Rotator rot)
{
    //Fix wrapping past 360 degrees and remove negative values...
    rot.Pitch = rot.Pitch & 65535;
    rot.Yaw = rot.Yaw & 65535;
    rot.Roll = rot.Roll & 65535;

    return rot;
}
