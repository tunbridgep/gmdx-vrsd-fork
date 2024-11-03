//=============================================================================
// JCDentonMale.
//=============================================================================
class JCDentonMale extends Human;

function UpdateHDTPSettings()
{
	local int i;
	local texture newtex; //preload these? Not sure if necessary, but hey
	local string texstr;

    //If we're femJC, abort
    if (FlagBase.GetBool('LDDPJCIsFemale'))
        return;

	super.UpdateHDTPsettings();

	for(i=2;i<6;i++)
	{
		texstr = "HDTPCharacters.Skins.HDTPJCFaceTex";
		texstr = texstr $ i;
		newtex = texture(dynamicloadobject(texstr,class'texture'));
	}
	for(i=1;i<5;i++)
	{
		texstr = "HDTPCharacters.Skins.HDTPJCHandsTex";
		texstr = texstr $ i;
		newtex = texture(dynamicloadobject(texstr,class'texture'));
	}

	SetSkin();
}

//Set HDTP Skin
function SetSkin()
{
    local LodMesh HDTPMesh;

    //If we're femJC, abort
    if (FlagBase.GetBool('LDDPJCIsFemale'))
        return;

	if(GetHDTPSettings(self))
	{
		switch(PlayerSkin)
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
		switch(PlayerSkin)
		{
			case 0:	MultiSkins[0] = Texture'JCDentonTex0'; break;
			case 1:	MultiSkins[0] = Texture'JCDentonTex4'; break;
			case 2:	MultiSkins[0] = Texture'JCDentonTex5'; break;
			case 3:	MultiSkins[0] = Texture'JCDentonTex6'; break;
			case 4:	MultiSkins[0] = Texture'JCDentonTex7'; break;
		}
	}
}

// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

event TravelPostAccept()
{
	local DeusExLevelInfo info;

    local int i;
	local bool bFemale;
	local Texture TTex;
	local Sound TSound;
	local class<DeusExCarcass> TCarc;
	
	Super.TravelPostAccept();
	
	//LDDP, load and update our female flag accordingly.
	if (FlagBase != None)
	{
		if (bMadeFemale)
		{
			FlagBase.SetBool('LDDPJCIsFemale', true);
			FlagBase.SetExpiration('LDDPJCIsFemale', FLAG_Bool, 0);
			bFemale = true;
		}
		else
		{
			FlagBase.SetBool('LDDPJCIsFemale', false);
			FlagBase.SetExpiration('LDDPJCIsFemale', FLAG_Bool, 0);
		}
		
		if (bRetroMorpheus)
		{
			FlagBase.SetBool('LDDPOGMorpheus', true);
			FlagBase.SetExpiration('LDDPOGMorpheus', FLAG_Bool, 0);
		}
		else
		{
			FlagBase.SetBool('LDDPOGMorpheus', false);
			FlagBase.SetExpiration('LDDPOGMorpheus', FLAG_Bool, 0);
		}

		if (bFemaleUsesMaleInteractions)
		{
			FlagBase.SetBool('LDDPMaleCont4FJC', true);
			FlagBase.SetExpiration('LDDPMaleCont4FJC', FLAG_Bool, 0);
		}
		else
		{
			FlagBase.SetBool('LDDPMaleCont4FJC', false);
			FlagBase.SetExpiration('LDDPMaleCont4FJC', FLAG_Bool, 0);
		}
		
		//LDDP, 10/26/21: This is now outdated due to methodology requirements. See Human.uc for more on this.
		/*if (FlagBase.GetBool('LDDPJCIsFemale'))
		{
			bFemale = true;
		}*/
	}
	
	//LDDP, 10/26/21: Update HUD elements.
	if ((DeusExRootWindow(RootWindow) != None) && (DeusExRootWindow(RootWindow).HUD != None) && (DeusExRootWindow(RootWindow).HUD.Hit != None))
	{
		DeusExRootWindow(RootWindow).HUD.Hit.UpdateAsFemale(bFemale);
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
		Mesh = LodMesh'GFM_Trench';
		
		BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight) - 2.0;
		
		TSound = Sound(DynamicLoadObject("FemJC.FJCLand", class'Sound', false));
		if (TSound != None) Land = TSound;
		
		TSound = Sound(DynamicLoadObject("FemJC.FJCJump", class'Sound', false));
		if (TSound != None) JumpSound = TSound;
		
		TSound = Sound(DynamicLoadObject("FemJC.FJCPainSmall", class'Sound', false));
    		if (TSound != None) HitSound1 = TSound;
		
		TSound = Sound(DynamicLoadObject("FemJC.FJCPainMedium", class'Sound', false));
    		if (TSound != None) HitSound2 = TSound;
		
		TSound = Sound(DynamicLoadObject("FemJC.FJCDeath", class'Sound', false));
    		if (TSound != None) Die = TSound;
		
		TCarc = class<DeusExCarcass>(DynamicLoadObject("FemJC.JCDentonFemaleCarcass", class'Class', false));
		if (TCarc != None) CarcassType = TCarc;
		
		switch(PlayerSkin)
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
		
		BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight);
		Land = Default.Land;
		JumpSound = Default.JumpSound;
    		HitSound1 = Default.HitSound1;
    		HitSound2 = Default.HitSound2;
    		Die = Default.Die;
		CarcassType = Default.CarcassType;
		
		switch(PlayerSkin)
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

    //SARGE: Setup outfit manager
    SetTimer(0.1,false);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// Timer()
// SARGE: We need to delay slightly before setting models, to allow mods like LDDP to work properly
// ----------------------------------------------------------------------

function Timer()
{
    Super.Timer();

    //load HDTP Skin
    UpdateHDTPSettings();

    //load outfit
    SetupOutfitManager();
}

// ----------------------------------------------------------------------
// ResetPlayerToDefaults()
// SARGE: When we start a new game, throw away our outfit manager
// ----------------------------------------------------------------------
function ResetPlayerToDefaults()
{
    outfitManager = None;
    Super.ResetPlayerToDefaults();
}

// ----------------------------------------------------------------------
// SetupOutfitManager()
// SARGE: Setup the outfit manager and restore current outfit
// ----------------------------------------------------------------------

function SetupOutfitManager()
{
    local class<OutfitManagerBase> managerBaseClass;

	// create the Outfit Manager if not found
	if (outfitManager == None)
    {
        managerBaseClass = class<OutfitManagerBase>(DynamicLoadObject("JCOutfits.OutfitManager", class'Class'));
        
        if (managerBaseClass == None)
            outfitManager = new(Self) class'OutfitManagerBase';
        else
            outfitManager = new(Self) managerBaseClass;
    }

    if (outfitManager != None)
    {
        //Call base setup code, required each map load
        outfitManager.Setup(Self);
        
        //Add additional outfits below this line
        //---------------------------------------
        //See docs/mod_integration.pdf for more info
        //---------------------------------------

        //Finish Outfit Setup
        outfitManager.CompleteSetup();
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HDTPMeshName="HDTPCharacters.HDTPGM_Trench"
     HDTPMeshTex(0)="HDTPCharacters.Skins.HDTPJCFaceTex0"
     HDTPMeshTex(1)="HDTPCharacters.Skins.HDTPJCDentonTex1"
     HDTPMeshTex(2)="HDTPCharacters.Skins.HDTPJCDentonTex2"
     HDTPMeshTex(3)="HDTPCharacters.Skins.HDTPJCHandsTex0"
     HDTPMeshTex(4)="HDTPCharacters.Skins.HDTPJCDentonTex4"
     HDTPMeshTex(5)="HDTPCharacters.Skins.HDTPJCDentonTex5"
     HDTPMeshTex(6)="HDTPCharacters.Skins.HDTPJCDentonTex6"
     HDTPMeshTex(7)="deusexitems.skins.blackmasktex"
     CarcassType=Class'DeusEx.JCDentonMaleCarcass'
     JumpSound=Sound'DeusExSounds.Player.MaleJump'
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
     Land=Sound'DeusExSounds.Player.MaleLand'
     Die=Sound'DeusExSounds.Player.MaleUnconscious'
     Mesh=LodMesh'DeusExCharacters.GM_Trench'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.JCDentonTex3'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.JCDentonTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.FramesTex4'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.LensesTex5'
}
