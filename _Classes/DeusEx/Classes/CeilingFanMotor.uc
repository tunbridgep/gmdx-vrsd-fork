//=============================================================================
// CeilingFanMotor.
//=============================================================================
class CeilingFanMotor extends DeusExDecoration;

enum ESkinColor
{
	SC_WoodBrass,
	SC_DarkWoodIron,
	SC_White,
	SC_WoodBrassFancy,
	SC_WoodPlastic
};

var() ESkinColor SkinColor;

function UpdateHDTPSettings()
{
    local Texture tex;
	Super.UpdateHDTPSettings();

	switch (SkinColor)
	{
		case SC_WoodBrass:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPCeilingFanTex1","DeusExDeco.CeilingFanTex1",IsHDTP()); break;
		case SC_DarkWoodIron:	tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPCeilingFanTex2","DeusExDeco.CeilingFanTex2",IsHDTP()); break;
		case SC_White:      	tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPCeilingFanTex3","DeusExDeco.CeilingFanTex3",IsHDTP()); break;
		case SC_WoodBrassFancy: tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPCeilingFanTex4","DeusExDeco.CeilingFanTex4",IsHDTP()); break;
		case SC_WoodPlastic:    tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPCeilingFanTex5","DeusExDeco.CeilingFanTex5",IsHDTP()); break;
	}

    if (IsHDTP())
        Multiskins[1] = tex;
    else
        Skin = tex;
}

defaultproperties
{
     SkinColor=SC_DarkWoodIron
     bInvincible=True
     bHighlight=False
     bCanBeBase=True
     ItemName="Ceiling Fan Motor"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.CeilingFanMotor'
     HDTPMesh="HDTPDecos.HDTPceilingfanMotor"
     SoundRadius=12
     SoundVolume=160
     AmbientSound=Sound'DeusExSounds.Generic.MotorHum'
     CollisionRadius=12.000000
     CollisionHeight=4.420000
     bCollideWorld=False
     Mass=50.000000
     Buoyancy=30.000000
}
