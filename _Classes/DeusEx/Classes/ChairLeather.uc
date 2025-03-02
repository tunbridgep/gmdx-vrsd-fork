//=============================================================================
// ChairLeather.
//=============================================================================
class ChairLeather extends Seat;

var int skinColor;

function UpdateHDTPSettings()
{
    local Texture sk;
	Super.UpdateHDTPSettings();

	switch (skinColor)
	{
		case 0:		sk = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPChairLeatherTex1","DeusExDeco.ChairLeatherTex1",IsHDTP()); break; //CyberP: HDTP update
		case 1:		sk = Texture'ChairLeatherTex2'; break;
		case 2:		sk = Texture'ChairLeatherTex3'; break;
		case 3: 	sk = Texture'ChairLeatherTex4'; break;
		case 4:		sk = Texture'ChairLeatherTex5'; break;
	}

    skin = sk;
    //log("Chair skin is " $ SkinColor); 
    //texture = sk;
}

defaultproperties
{
     sitPoint(0)=(X=0.000000,Y=-8.000000,Z=0.000000)
     HitPoints=55
     ItemName="Comfy Chair"
     Mesh=LodMesh'DeusExDeco.ChairLeather'
     CollisionRadius=33.500000
     CollisionHeight=23.250000
     Mass=139.000000
     Buoyancy=110.000000
	 bHDTPFailsafe=False
}
