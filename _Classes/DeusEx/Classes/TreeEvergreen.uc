//=============================================================================
// Tree1.
//=============================================================================
class TreeEvergreen extends Tree;

var travel vector HDTPPosition;
var travel vector VanillaPosition;

exec function UpdateHDTPsettings()
{
	Super.UpdateHDTPsettings();

    //Ugh, we have to move it down somewhat...
    if (HDTPPosition.x == 0 && HDTPPosition.y == 0 && HDTPPosition.z == 0)
    {
        HDTPPosition = Location;
        VanillaPosition = Location;
        VanillaPosition.z -= 100;
    }
    if (IsHDTP())
    {
        SetCollisionSize(Default.CollisionRadius, 1024);
        SetLocation(HDTPPosition);
    }
    else
    {
        SetCollisionSize(Default.CollisionRadius, 125);
        SetLocation(VanillaPosition);
    }

}

defaultproperties
{
     HDTPMesh="GameMedia.Evergreen"
     //Skin="GameMedia.Skins.Leaf3"
     Mesh=LodMesh'DeusExDeco.Tree3'
     //Mesh=LodMesh'GameMedia.Evergreen'
     CollisionRadius=10.000000
     CollisionHeight=125.000000
}
