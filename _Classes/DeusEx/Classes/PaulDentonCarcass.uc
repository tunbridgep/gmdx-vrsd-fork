//=============================================================================
// PaulDentonCarcass.
//=============================================================================
class PaulDentonCarcass extends DeusExCarcass;

// ----------------------------------------------------------------------
// PostPostBeginPlay()
// ----------------------------------------------------------------------

function PostPostBeginPlay()
{
	local DeusExPlayer player;

	Super.PostPostBeginPlay();

	foreach AllActors(class'DeusExPlayer', player)
		break;

	SetSkin(player);
}

// ----------------------------------------------------------------------
// SetSkin()
// ----------------------------------------------------------------------

function UpdateHDTPSettings()
{
	local int i;
	local texture newtex; //preload these? Not sure if necessary, but hey
	local string texstr;

	super.UpdateHDTPsettings();

	for(i=2;i<6;i++)
	{
		texstr = "HDTPCharacters.Skins.HDTPPaulDentonTex";
		texstr = texstr $ i;
		newtex = texture(dynamicloadobject(texstr,class'texture'));
	}
	for(i=1;i<5;i++)
	{
		texstr = "HDTPCharacters.Skins.HDTPJCHandsTex";
		texstr = texstr $ i;
		newtex = texture(dynamicloadobject(texstr,class'texture'));
	}

	setskin(deusexplayer(getplayerpawn()));
}

function SetSkin(DeusExPlayer player)
{
	if (player != None)
	{
		if(player.GetHDTPSettings(self))
		{
			switch(player.PlayerSkin)
			{
				case 0:	MultiSkins[0] = Texture'HDTPCharacters.Skins.HDTPPaulDentonTex0'; MultiSkins[3] = Texture'HDTPCharacters.Skins.HDTPJCHandsTex0'; break;
				case 1:	MultiSkins[0] = Texture'HDTPCharacters.Skins.HDTPPaulDentonTex2'; MultiSkins[3] = Texture'HDTPCharacters.Skins.HDTPJCHandsTex1'; break;
				case 2:	MultiSkins[0] = Texture'HDTPCharacters.Skins.HDTPPaulDentonTex3'; MultiSkins[3] = Texture'HDTPCharacters.Skins.HDTPJCHandsTex2'; break;
				case 3:	MultiSkins[0] = Texture'HDTPCharacters.Skins.HDTPPaulDentonTex4'; MultiSkins[3] = Texture'HDTPCharacters.Skins.HDTPJCHandsTex3'; break;
				case 4:	MultiSkins[0] = Texture'HDTPCharacters.Skins.HDTPPaulDentonTex5'; MultiSkins[3] = Texture'HDTPCharacters.Skins.HDTPJCHandsTex4'; break;
			}
		}
		else
		{
			switch(player.PlayerSkin)
			{
				case 0:	MultiSkins[0] = Texture'PaulDentonTex0';
						MultiSkins[3] = Texture'PaulDentonTex0';
						break;
				case 1:	MultiSkins[0] = Texture'PaulDentonTex4';
						MultiSkins[3] = Texture'PaulDentonTex4';
						break;
				case 2:	MultiSkins[0] = Texture'PaulDentonTex5';
						MultiSkins[3] = Texture'PaulDentonTex5';
						break;
				case 3:	MultiSkins[0] = Texture'PaulDentonTex6';
						MultiSkins[3] = Texture'PaulDentonTex6';
						break;
				case 4:	MultiSkins[0] = Texture'PaulDentonTex7';
						MultiSkins[3] = Texture'PaulDentonTex7';
						break;
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Mesh2=LodMesh'DeusExCharacters.GM_Trench_CarcassB'
     Mesh3=LodMesh'DeusExCharacters.GM_Trench_CarcassC'
     HDTPMeshName="HDTPCharacters.HDTPGM_TrenchCarcass"
     HDTPMesh2Name="HDTPCharacters.HDTPGM_TrenchCarcassB"
     HDTPMesh3Name="HDTPCharacters.HDTPGM_TrenchCarcassC"
     HDTPMeshTex(0)="HDTPCharacters.skins.HDTPPaulDentonTex0"
     HDTPMeshTex(1)="HDTPCharacters.skins.HDTPPaulDentonTex1"
     HDTPMeshTex(2)="HDTPCharacters.Skins.HDTPJCDentonTex2"
     HDTPMeshTex(3)="HDTPCharacters.Skins.HDTPJCDentonTex3"
     HDTPMeshTex(4)="HDTPCharacters.Skins.HDTPJCDentonTex4"
     HDTPMeshTex(5)="DeusExItems.Skins.PinkMaskTex"
     HDTPMeshTex(6)="DeusExItems.Skins.PinkMaskTex"
     HDTPMeshTex(7)="DeusExItems.Skins.PinkMaskTex"
     Mesh=LodMesh'DeusExCharacters.GM_Trench_Carcass'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.PaulDentonTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.PaulDentonTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.PantsTex8'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.PaulDentonTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.PaulDentonTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.PaulDentonTex2'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=40.000000
}
