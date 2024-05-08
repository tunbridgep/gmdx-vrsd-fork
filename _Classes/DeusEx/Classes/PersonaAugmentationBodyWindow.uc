//=============================================================================
// PersonaAugmentationBodyWindow
//=============================================================================

class PersonaAugmentationBodyWindow extends Window;

var Texture bodyTextures[2], BodyTexturesFemale[2]; //LDDP, 10/28/21: Also these.

var bool bFemale; //LDDP, 10/28/21: Store this so we can render the right one as needed.

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

//LDDP
event InitWindow()
{
	local DeusExPlayer DXP;
	local Texture TTex;
	
	Super.InitWindow();
	
	DXP = DeusExPlayer(GetPlayerPawn());
	if ((DXP != None) && (DXP.FlagBase != None) && (DXP.FlagBase.GetBool('LDDPJCIsFemale')))
	{
		bFemale = true;
	}
	
	//LDDP, 10/28/21: Emergency fallback.
	BodyTexturesFemale[0] = BodyTextures[0];
	BodyTexturesFemale[1] = BodyTextures[1];
	
	TTex = Texture(DynamicLoadObject("FemJC.AugmentationsBody_1Fem", class'Texture', false));
	if (TTex != None) BodyTexturesFemale[0] = TTex;
	TTex = Texture(DynamicLoadObject("FemJC.AugmentationsBody_2Fem", class'Texture', false));
	if (TTex != None) BodyTexturesFemale[1] = TTex;
	
	SetSize(174, 359);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

//LDDP
event DrawWindow(GC gc)
{	
	// Draw window background
	gc.SetStyle(DSTY_Masked);
	
	if (bFemale)
	{
		gc.DrawTexture(0,   0, 174, 256, 0, 0, BodyTexturesFemale[0]);
		gc.DrawTexture(0, 256, 174, 103, 0, 0, BodyTexturesFemale[1]);
	}
	else
	{
		gc.DrawTexture(0,   0, 174, 256, 0, 0, BodyTextures[0]);
		gc.DrawTexture(0, 256, 174, 103, 0, 0, BodyTextures[1]);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bodyTextures(0)=Texture'DeusExUI.UserInterface.AugmentationsBody_1'
     bodyTextures(1)=Texture'DeusExUI.UserInterface.AugmentationsBody_2'
}
