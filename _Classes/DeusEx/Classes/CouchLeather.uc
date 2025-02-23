//=============================================================================
// CouchLeather.
//=============================================================================
class CouchLeather extends Seat;

var int skinColor;

function UpdateHDTPsettings()
{
    local Texture sk;
	Super.UpdateHDTPsettings();

    if (!IsHDTP()) //The HDTP office chair skins are all the same
    {
        switch (SkinColor)
        {
            case 0:		sk = Texture'CouchLeatherTex1'; break;
            case 1:		sk = Texture'CouchLeatherTex2'; break;
            case 2:		sk = Texture'CouchLeatherTex3'; break;
            case 3:	    sk = Texture'CouchLeatherTex4'; break;
            case 4:		sk = Texture'CouchLeatherTex5'; break;
        }

        skin = sk;
        //log("Chair skin is " $ SkinColor); 
        //texture = sk;
    }

}

defaultproperties
{
     sitPoint(0)=(X=-18.000000,Y=-8.000000,Z=0.000000)
     sitPoint(1)=(X=18.000000,Y=-8.000000,Z=0.000000)
     HitPoints=75
     ItemName="Leather Couch"
     HDTPSkin="HDTPDecos.Skins.HDTPCouchLeatherTex1"
     HDTPMesh="HDTPDecos.HDTPcouchleather"
     Mesh=LodMesh'DeusExDeco.CouchLeather'
     Skin=Texture'DeusExDeco.Skins.CouchLeather1'
     CollisionRadius=47.880001
     CollisionHeight=23.250000
     Mass=218.000000
     Buoyancy=110.000000
}
