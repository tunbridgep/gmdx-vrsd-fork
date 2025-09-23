//=============================================================================
// SARGE: Spawn Utils
// Functions to assist with spawning objects so that they fail less.
//=============================================================================
class SpawnUtils extends Object abstract;

//Spawns an object in a safe manner
//If it can't initially spawn, it sets the class to not collide with actors,
//then spawns it again.
static function Actor SpawnSafe(class<Actor> spawnType, Actor owner, optional name Tag, optional vector Location, optional rotator Rotation)
{
    local Actor spawned;
    
    spawned = owner.Spawn(spawnType, owner, tag, location, rotation);
    if (spawned == None && spawnType.default.bCollideActors)
    {
        spawnType.default.bCollideWorld = false;
        spawned = owner.Spawn(spawnType, owner, tag, location, rotation);
        spawnType.default.bCollideWorld = true;
    }

    return spawned;
}

//SARGE: Proper version of DropFrom that actually returns a value.
static function bool CheckDropFrom(Inventory item, vector StartLocation, optional vector fallback)
{
    local vector loc;

    loc = StartLocation;

	if (!item.SetLocation(loc))
    {
        if (fallback == Vect(0,0,0))
            return false;

        loc = fallback;
        if (!item.SetLocation(loc))
            return false;
    }

     item.DropFrom(loc);
     return true;
}
