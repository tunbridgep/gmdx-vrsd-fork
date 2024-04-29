//=============================================================================
// JCDouble.
//=============================================================================
class JCDouble extends HumanMilitary;

//
// JC's cinematic stunt double!
//

//LDDP, 10/26/21: New skin swap code stuff.
var(LDDP) bool bMadeFemale;

function float GetDefaultCollisionHeight()
{
	if (bMadeFemale) return (Default.CollisionHeight-9.0);
	
	return (Default.CollisionHeight-4.5);
}

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

	//setskin(deusexplayer(getplayerpawn()));
}

// LDDP cinematic stunt double!
function SetSkin(DeusExPlayer player)
{
	local int i;
	local Texture TTex;
	local class<DeusExCarcass> TCarc;
	
	if (Player != None)
	{	
		//LDDP, load and update our female flag accordingly.
		if ((Player.FlagBase != None) && (Player.FlagBase.GetBool('LDDPJCIsFemale')))
		{
			bMadeFemale = true;
		}
		
		//LDDP, 10/26/21: A bunch of annoying bullshit with branching appearance for JC... But luckily, it works well.
		if (bMadeFemale)
		{
			TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex2", class'Texture', false));
			if (TTex != None) MultiSkins[1] = TTex;
			TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex3", class'Texture', false));
			if (TTex != None) MultiSkins[2] = TTex;
			TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex0", class'Texture', false));
			if (TTex != None) MultiSkins[3] = TTex;
			TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex1", class'Texture', false));
			if (TTex != None) MultiSkins[4] = TTex;
			TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex2", class'Texture', false));
			if (TTex != None) MultiSkins[5] = TTex;
			MultiSkins[6] = Texture'DeusExCharacters.Skins.FramesTex4';
			MultiSkins[7] = Texture'DeusExCharacters.Skins.LensesTex5';	
			Mesh = LodMesh'GFM_Trench';
			
			ResetBasedPawnSize();
			BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight) - 2.0;
			bIsFemale = true;
			
			TCarc = class<DeusExCarcass>(DynamicLoadObject("FemJC.JCDentonFemaleCarcass", class'Class', false));
			if (TCarc != None) CarcassType = TCarc;
			
			switch(Player.PlayerSkin)
			{
				case 0:
					TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex0", class'Texture', false));
					if (TTex != None) MultiSkins[0] = TTex;
				break;
				case 1:
					TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex4", class'Texture', false));
					if (TTex != None) MultiSkins[0] = TTex;
				break;
				case 2:
					TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex5", class'Texture', false));
					if (TTex != None) MultiSkins[0] = TTex;
				break;
				case 3:
					TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex6", class'Texture', false));
					if (TTex != None) MultiSkins[0] = TTex;
				break;
				case 4:
					TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex7", class'Texture', false));
					if (TTex != None) MultiSkins[0] = TTex;
				break;
			}
		}
		else
		{
			for (i=1; i<ArrayCount(Multiskins); i++)
			{
				MultiSkins[i] = Default.Multiskins[i];
			}
			Mesh = Default.Mesh;
			
			ResetBasedPawnSize();
			BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight);
			bIsFemale = false;
			CarcassType = Default.CarcassType;
			
			switch(Player.PlayerSkin)
			{
				case 0:
					MultiSkins[0] = Texture'JCDentonTex0';
				break;
				case 1:
					MultiSkins[0] = Texture'JCDentonTex4';
				break;
				case 2:
					MultiSkins[0] = Texture'JCDentonTex5';
				break;
				case 3:
					MultiSkins[0] = Texture'JCDentonTex6';
				break;
				case 4:
					MultiSkins[0] = Texture'JCDentonTex7';
				break;
			}
		}
	}
}
//Sarge: Disabled to make way for Lay-D Denton skins
/*
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
*/

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
