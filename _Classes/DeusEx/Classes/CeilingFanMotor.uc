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

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_WoodBrass:		Multiskins[1] = Texture'HDTPCeilingFanTex1'; break;
		case SC_DarkWoodIron:	Multiskins[1] = Texture'HDTPCeilingFanTex2'; break;
		case SC_White:			Multiskins[1] = Texture'HDTPCeilingFanTex3'; break;
		case SC_WoodBrassFancy:	Multiskins[1] = Texture'HDTPCeilingFanTex4'; break;
		case SC_WoodPlastic:	Multiskins[1] = Texture'HDTPCeilingFanTex5'; break;
	}
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
     Mesh=LodMesh'HDTPDecos.HDTPceilingfanmotor'
     SoundRadius=12
     SoundVolume=160
     AmbientSound=Sound'DeusExSounds.Generic.MotorHum'
     CollisionRadius=12.000000
     CollisionHeight=4.420000
     bCollideWorld=False
     Mass=50.000000
     Buoyancy=30.000000
}
