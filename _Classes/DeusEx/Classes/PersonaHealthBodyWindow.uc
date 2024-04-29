//=============================================================================
// PersonaHealthBodyWindow
//=============================================================================

class PersonaHealthBodyWindow extends Window;

var Texture BodyTextures[2], BodyTexturesFemale[2]; //LDDP, 10/28/21: Also these.

var bool bFemale; //LDDP, 10/28/21: Store this so we can render the right one as needed.

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

//LDDP
event InitWindow()
{
	local Texture TTex;
	local DeusExPlayer DXP;
	
	Super.InitWindow();
	
	DXP = DeusExPlayer(GetPlayerPawn());
	if ((DXP != None) && (DXP.FlagBase != None) && (DXP.FlagBase.GetBool('LDDPJCIsFemale')))
	{
		bFemale = true;
	}
	
	//LDDP, 10/28/21: Emergency fallback.
	BodyTexturesFemale[0] = BodyTextures[0];
	BodyTexturesFemale[1] = BodyTextures[1];
	
	TTex = Texture(DynamicLoadObject("FemJC.HealthBody_1Fem", class'Texture', false));
	if (TTex != None) BodyTexturesFemale[0] = TTex;
	TTex = Texture(DynamicLoadObject("FemJC.HealthBody_2Fem", class'Texture', false));
	if (TTex != None) BodyTexturesFemale[1] = TTex;
	
	SetSize(219, 357);
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
		gc.DrawTexture(0,   0, 219, 256, 0, 0, BodyTexturesFemale[0]);
		gc.DrawTexture(0, 256, 219, 101, 0, 0, BodyTexturesFemale[1]);
	}
	else
	{
		gc.DrawTexture(0,   0, 219, 256, 0, 0, BodyTextures[0]);
		gc.DrawTexture(0, 256, 219, 101, 0, 0, BodyTextures[1]);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bodyTextures(0)=Texture'DeusExUI.UserInterface.HealthBody_1'
     bodyTextures(1)=Texture'DeusExUI.UserInterface.HealthBody_2'
}
