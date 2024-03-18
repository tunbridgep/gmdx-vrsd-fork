//=============================================================================
// JCDouble.
//=============================================================================
class JCDouble extends HumanMilitary;

//
// JC's cinematic stunt double!
//

function UpdateHDTPSettings()
{
	local int i;
	local texture newtex; //preload these? Not sure if necessary, but hey
	local string texstr;

	super.UpdateHDTPsettings();

	for(i=1;i<5;i++)
	{
		texstr = "HDTPCharacters.Skins.HDTPJCFaceTex";
		texstr = texstr $ i;
		newtex = texture(dynamicloadobject(texstr,class'texture'));

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
				case 0:	MultiSkins[0] = Texture'HDTPCharacters.Skins.HDTPJCFaceTex0'; MultiSkins[3] = Texture'HDTPCharacters.Skins.HDTPJCHandsTex0'; break;
				case 1:	MultiSkins[0] = Texture'HDTPCharacters.Skins.HDTPJCFaceTex1'; MultiSkins[3] = Texture'HDTPCharacters.Skins.HDTPJCHandsTex1'; break;
				case 2:	MultiSkins[0] = Texture'HDTPCharacters.Skins.HDTPJCFaceTex2'; MultiSkins[3] = Texture'HDTPCharacters.Skins.HDTPJCHandsTex2'; break;
				case 3:	MultiSkins[0] = Texture'HDTPCharacters.Skins.HDTPJCFaceTex3'; MultiSkins[3] = Texture'HDTPCharacters.Skins.HDTPJCHandsTex3'; break;
				case 4:	MultiSkins[0] = Texture'HDTPCharacters.Skins.HDTPJCFaceTex4'; MultiSkins[3] = Texture'HDTPCharacters.Skins.HDTPJCHandsTex4'; break;
			}
		}
		else
		{
			switch(player.PlayerSkin)
			{
				case 0:	MultiSkins[0] = Texture'JCDentonTex0'; break;
				case 1:	MultiSkins[0] = Texture'JCDentonTex4'; break;
				case 2:	MultiSkins[0] = Texture'JCDentonTex5'; break;
				case 3:	MultiSkins[0] = Texture'JCDentonTex6'; break;
				case 4:	MultiSkins[0] = Texture'JCDentonTex7'; break;
			}
		}
	}
}

function ImpartMomentum(Vector momentum, Pawn instigatedBy)
{
	// to ensure JC's understudy doesn't get impact momentum from damage...
}

function AddVelocity( vector NewVelocity)
{
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WalkingSpeed=0.120000
     bInvincible=True
     BaseAssHeight=-23.000000
     HDTPMeshName="HDTPCharacters.HDTPGM_Trench"
     HDTPMeshTex(0)="HDTPCharacters.Skins.HDTPJCFaceTex0"
     HDTPMeshTex(1)="HDTPCharacters.Skins.HDTPJCDentonTex1"
     HDTPMeshTex(2)="HDTPCharacters.Skins.HDTPJCDentonTex2"
     HDTPMeshTex(3)="HDTPCharacters.Skins.HDTPJCHandsTex0"
     HDTPMeshTex(4)="HDTPCharacters.Skins.HDTPJCDentonTex4"
     HDTPMeshTex(5)="HDTPCharacters.Skins.HDTPJCDentonTex5"
     HDTPMeshTex(6)="HDTPCharacters.Skins.HDTPJCDentonTex6"
     HDTPMeshTex(7)="deusexitems.skins.blackmasktex"
     Mesh=LodMesh'DeusExCharacters.GM_Trench'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.JCDentonTex3'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.JCDentonTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.FramesTex4'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.LensesTex5'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="JCDouble"
     FamiliarName="JC Denton"
     UnfamiliarName="JC Denton"
}
