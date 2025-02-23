//=============================================================================
// OfficeChair.
//=============================================================================
class OfficeChair extends Seat;

var int skinColor;

function UpdateHDTPsettings()
{
    local Texture sk;
	Super.UpdateHDTPsettings();

    if (!IsHDTP()) //The HDTP office chair skins are all the same
    {
        switch (SkinColor)
        {
            case 0: sk = Texture'DeusExDeco.OfficeChairTex1'; break;
            case 1: sk = Texture'DeusExDeco.OfficeChairTex2'; break;
            case 2: sk = Texture'DeusExDeco.OfficeChairTex3'; break;
            case 3: sk = Texture'DeusExDeco.OfficeChairTex4'; break;
            case 4: sk = Texture'RSDCrap.Skins.OfficeChairTex5'; break; //New skin!
            case 5: sk = Texture'RSDCrap.Skins.OfficeChairTex6'; break; //New skin!
            //case 0:	Sk = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPOfficeChairTex1","DeusExDeco.OfficeChairTex1",IsHDTP()); break;
            //case 1:	Sk = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPOfficeChairTex2","DeusExDeco.OfficeChairTex2",IsHDTP()); break;
            //case 2:	Sk = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPOfficeChairTex3","DeusExDeco.OfficeChairTex3",IsHDTP()); break;
            //case 3:	Sk = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPOfficeChairTex4","DeusExDeco.OfficeChairTex4",IsHDTP()); break;
        }

        skin = sk;
        //log("Chair skin is " $ SkinColor); 
        //texture = sk;
    }

}

defaultproperties
{
     sitPoint(0)=(X=0.000000,Y=-4.000000,Z=0.000000)
     HitPoints=30
     ItemName="Swivel Chair"
     HDTPMesh="HDTPDecos.HDTPOfficeChair"
     Mesh=LodMesh'DeusExDeco.OfficeChair'
     CollisionRadius=16.000000
     CollisionHeight=25.549999
     Mass=40.000000
     Buoyancy=5.000000
	 bHDTPFailsafe=False
}
