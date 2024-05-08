//=============================================================================
// DentonClone.
//=============================================================================
class DentonClone extends DeusExDecoration;

//LDDP, do some swoocey shit when configured to do so by the player.
function SetSkin(Human player)
{
	local DeusExLevelInfo info;
	local bool bFemale;
	
	//LDDP, 10/27/21: Don't swap out in A51, thank you.
	forEach AllActors(Class'DeusExLevelInfo', Info)
	{
		if (!(Info.MapName ~= "Intro"))
		{
			return;
		}
	}
	
	if (Player != None)
	{
		//LDDP, 10/26/21: A bunch of annoying bullshit with branching appearance for JC... But luckily, it works well.
		if (Player.bMadeFemale)
		{
			MultiSkins[0] = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex0Tube", class'Texture', false));
			
			Multiskins[1] = Texture'DeusExItems.Skins.PinkMaskTex';
			Multiskins[2] = Texture'DeusExItems.Skins.PinkMaskTex';
			Multiskins[3] = Texture'DeusExItems.Skins.GrayMaskTex';
			Multiskins[4] = Texture'DeusExItems.Skins.BlackMaskTex';
			Multiskins[5] = Texture'DeusExItems.Skins.PinkMaskTex';
			Multiskins[6] = Texture(DynamicLoadObject("FemJC.DentonCloneTex2Fem", class'Texture', false));
			Multiskins[7] = Texture(DynamicLoadObject("FemJC.DentonCloneTex3Fem", class'Texture', false));
			
			//LDDP, 10/27/21; Hack to make sure we're running things EXACTLY once.
			if (AnimSequence != 'Land')
			{
				SetRotation(Rotation - Rot(0, 16384, 0));
			}
			
			Mesh = LodMesh'DeusExCharacters.GFM_TShirtPants';
			AnimSequence = 'Land';
			AnimRate = 0.0;
		}
	}
}

defaultproperties
{
     bInvincible=True
     bHighlight=False
     ItemName="JC Denton Clone"
     bPushable=False
     bBlockSight=True
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.DentonClone'
     CollisionRadius=21.200001
     CollisionHeight=45.869999
     Mass=150.000000
     Buoyancy=145.000000
}
