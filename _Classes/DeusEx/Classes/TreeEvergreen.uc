//=============================================================================
// Tree1.
//=============================================================================
class TreeEvergreen extends Tree;

var travel vector HDTPPosition;
var travel vector VanillaPosition;

exec function UpdateHDTPsettings()
{
	Super.UpdateHDTPsettings();

    //Ugh, we have to move it up somewhat...
    if (VanillaPosition.x == 0 && VanillaPosition.y == 0 && VanillaPosition.z == 0)
    {
        HDTPPosition = Location;
        VanillaPosition = Location;
        HDTPPosition.z += 50;
    }
    if (IsHDTP() && closeEnough)
    {
        SetCollisionSize(Default.CollisionRadius, 1024);
        SetLocation(HDTPPosition);
        MultiSkins[0]=Texture'GameMedia.Skins.LeafTex3';
    }
    else
    {
        SetCollisionSize(Default.CollisionRadius, 125);
        SetLocation(VanillaPosition);
        MultiSkins[0]=None;
    }
}

defaultproperties
{
     HDTPMesh="GameMedia.Evergreen"
     //Skin="GameMedia.Skins.Leaf3"
     Mesh=LodMesh'DeusExDeco.Tree3'
     CollisionRadius=10.000000
     CollisionHeight=125.000000
}
