//=============================================================================
// AlarmLight.
//=============================================================================
class AlarmLight extends DeusExDecoration;

enum ESkinColor
{
	SC_Red,
	SC_Green,
	SC_Blue,
	SC_Amber
};

var() ESkinColor SkinColor;
var() bool bIsOn;

function SetLightColor(ESkinColor color)
{
	switch (SkinColor)
	{
		case SC_Red:		MultiSkins[1] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex2","DeusExDeco.AlarmLightTex2",IsHDTP());
		                    MultiSkins[2] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex3","DeusExDeco.AlarmLightTex3",IsHDTP());
		                    Texture = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex3","DeusExDeco.AlarmLightTex3",IsHDTP());
							LightHue = 0;
							break;
		case SC_Green:		MultiSkins[1] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex4","DeusExDeco.AlarmLightTex4",IsHDTP());
		                    MultiSkins[2] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex5","DeusExDeco.AlarmLightTex5",IsHDTP());
		                    Texture = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex5","DeusExDeco.AlarmLightTex5",IsHDTP());
							LightHue = 64;
							break;
		case SC_Blue:		MultiSkins[1] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex6","DeusExDeco.AlarmLightTex6",IsHDTP());
		                    MultiSkins[2] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex7","DeusExDeco.AlarmLightTex7",IsHDTP());
		                    Texture = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex7","DeusExDeco.AlarmLightTex7",IsHDTP());
							LightHue = 160;
							break;
		case SC_Amber:		MultiSkins[1] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex8","DeusExDeco.AlarmLightTex8",IsHDTP());
		                    MultiSkins[2] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex9","DeusExDeco.AlarmLightTex9",IsHDTP());
		                    Texture = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPAlarmLightTex9","DeusExDeco.AlarmLightTex9",IsHDTP());
							LightHue = 36;
							break;
	}

	if (!bIsOn)
	{
		MultiSkins[1] = Texture'BlackMaskTex';
		LightType = LT_None;
		bFixedRotationDir = False;
	}
}

function UpdateHDTPSettings()
{
	Super.UpdateHDTPSettings();

	SetLightColor(SkinColor);
}

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
	if (!bIsOn)
	{
		bIsOn = True;
		SetLightColor(SkinColor);
		LightType = LT_Steady;
		bFixedRotationDir = True;
	}

	Super.Trigger(Other, Instigator);
}

// if we are untriggered, turn us off
function UnTrigger(Actor Other, Pawn Instigator)
{
	if (bIsOn)
	{
		bIsOn = False;
		MultiSkins[1] = Texture'BlackMaskTex';
		LightType = LT_None;
		bFixedRotationDir = False;
	}

	Super.UnTrigger(Other, Instigator);
}

defaultproperties
{
     bIsOn=True
     HitPoints=4
     FragType=Class'DeusEx.PlasticFragment'
     ItemName="Alarm Light"
     bPushable=False
     Physics=PHYS_Rotating
     HDTPSkin="HDTPDecos.Skins.HDTPAlarmLightTex1"
     HDTPTexture="HDTPDecos.Skins.HDTPAlarmLightTex3"
     Texture=Texture'DeusExDeco.Skins.AlarmLightTex3'
     Mesh=LodMesh'DeusExDeco.AlarmLight'
     CollisionRadius=4.000000
     CollisionHeight=6.140000
     LightType=LT_Steady
     LightEffect=LE_Spotlight
     LightBrightness=255
     LightRadius=32
     LightCone=32
     bFixedRotationDir=True
     Mass=20.000000
     Buoyancy=15.000000
     RotationRate=(Yaw=98304)
	 bHDTPFailsafe=False

}
