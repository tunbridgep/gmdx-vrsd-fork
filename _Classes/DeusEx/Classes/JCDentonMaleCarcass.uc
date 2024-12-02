//=============================================================================
// JCDentonMaleCarcass.
//=============================================================================
class JCDentonMaleCarcass extends DeusExCarcass;

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

function SetSkin(DeusExPlayer player)
{
	local int i;
	local bool bFemale;
	local Texture TTex;
	
	if (Player != None)
	{	
		//LDDP, load and update our female flag accordingly.
		if ((Player.FlagBase != None) && (Player.FlagBase.GetBool('LDDPJCIsFemale')))
		{
			bFemale = true;
		}
		
		//LDDP, 10/26/21: A bunch of annoying bullshit with branching appearance for JC... But luckily, it works well.
		if (bFemale)
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
			if (Mesh == Mesh2)
			{
				Mesh = LodMesh'DeusExCharacters.GM_Trench_CarcassB';
			}
			else if (Mesh == Mesh3)
			{
				Mesh = LodMesh'DeusExCharacters.GM_Trench_CarcassC';
			}
			else
			{
				Mesh = LodMesh'DeusExCharacters.GM_Trench_Carcass';
			}
			
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

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
	 hdtpReference=class'DeusEx.DeusExPlayer'
     Mesh2=LodMesh'DeusExCharacters.GM_Trench_CarcassB'
     Mesh3=LodMesh'DeusExCharacters.GM_Trench_CarcassC'
     HDTPMesh="HDTPCharacters.HDTPGM_TrenchCarcass"
     HDTPMesh2="HDTPCharacters.HDTPGM_TrenchCarcassB"
     HDTPMesh3="HDTPCharacters.HDTPGM_TrenchCarcassC"
     HDTPMeshTex(0)="HDTPCharacters.Skins.HDTPJCFaceTex0"
     HDTPMeshTex(1)="HDTPCharacters.Skins.HDTPJCDentonTex1"
     HDTPMeshTex(2)="HDTPCharacters.Skins.HDTPJCDentonTex2"
     HDTPMeshTex(3)="HDTPCharacters.Skins.HDTPJCHandsTex0"
     HDTPMeshTex(4)="HDTPCharacters.Skins.HDTPJCDentonTex4"
     HDTPMeshTex(5)="HDTPCharacters.Skins.HDTPJCDentonTex5"
     HDTPMeshTex(6)="HDTPCharacters.Skins.HDTPJCDentonTex6"
     HDTPMeshTex(7)="deusexitems.skins.blackmasktex"
     Mesh=LodMesh'DeusExCharacters.GM_Trench_Carcass'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.JCDentonTex3'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.JCDentonTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.FramesTex4'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.LensesTex5'
     CollisionRadius=40.000000
}
