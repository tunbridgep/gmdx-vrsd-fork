//=============================================================================
// DeusExScopeView.
//=============================================================================
class DeusExScopeView expands Window;

var bool bActive;		// is this view actually active?

var DeusExPlayer player;
var Color colLines;
var Bool  bBinocs;
var Bool  bViewVisible;
var int   desiredFOV;
var bool bOldCrossHair; //meh
//var int snapCount;
//var texture GEPOverlayTexture;
//var bool    bIsIronSight;
var localized String msgRange;                                                  //RSD
var localized String msgRangeUnits;                                             //RSD

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	bTickEnabled = true;

	StyleChanged();

	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	local Crosshair        cross;
	local DeusExRootWindow dxRoot;

	dxRoot = DeusExRootWindow(GetRootWindow());
	if (dxRoot != None)
	{
		cross = dxRoot.hud.cross;
	}
}

// ----------------------------------------------------------------------
// ActivateView()
// ----------------------------------------------------------------------
/*
Mesh          = PickupViewMesh;
	DrawScale     = PickupViewScale;

		Mesh          = PlayerViewMesh;
	DrawScale     = PlayerViewScale;
*/
function ActivateViewType(int newFOV, bool bNewBinocs, bool bInstant, bool bGEPScope)
{
	//bIsIronSight=!bGotScope;
	//if (bIsIronSight) newFov=60;
	//GMDX: draw and set up screen for GEP
	if (bGEPScope)
	{
	  player.SpawnGEPmounted(true);
	  player.GEPmounted.bFlipFlopCanvas=false;
	  player.bGEPzoomActive=true;

	  //SetBackground(texture'GMDXUI.Skins.GEPScopeOverlay');
	  //SetBackgroundStretching(False);
	  //SetBackgroundStyle(DSTY_Masked);
	  Show();

	  //TODO: draw render overlay here
//	  DeusExWeapon(player.inHand).Mesh=DeusExWeapon(player.inHand).PickupViewMesh;
	  //DeusExWeapon(player.inHand).DrawScale=DeusExWeapon(player.inHand).PickupViewScale;
	//  DeusExWeapon(player.inHand).PlayerViewOffset.X=3100;
//	  DeusExWeapon(player.inHand).PlayerViewOffset.Y=400;
//	  DeusExWeapon(player.inHand).PlayerViewOffset.Z=-500;
//(X=46.000000,Y=-22.000000,Z=-10.000000)

//		player.GEPtopX=width/2;
//		player.GEPtopY=height/2;
//		player.GEPwidth=width;
//		player.GEPheight=height;

		//DeusExWeapon(player.inHand).bHideWeapon=true;
		//Show();
	} else
	ActivateView(newFov,bNewBinocs,bInstant);
}

// ----------------------------------------------------------------------
// ActivateView()
// ----------------------------------------------------------------------

function ActivateView(int newFOV, bool bNewBinocs, bool bInstant)
{
	desiredFOV = newFOV;

	bBinocs = bNewBinocs;

	if (player != None)
	{
		if (bInstant)
			player.SetFOVAngle(desiredFOV);
		else
			player.desiredFOV = desiredFOV;
		bViewVisible = True;
		Show();
		/*if (!bIsIronSight)
		{
			bViewVisible = True;

		}*/
	}
	
	player.UpdateCrosshair();
}

// ----------------------------------------------------------------------
// DeactivateView()
// ----------------------------------------------------------------------

function DeactivateView()
{
	if (player != None)
	{
		if (player.bGEPzoomActive)
		{
			player.bGEPzoomActive=false; //Hide GEP viewport
			player.GEPmounted.bFlipFlopCanvas=false;

			if(player.bGEPprojectileInflight)
			{
			   if (player.aGEPProjectile!=none)
			   {
					Rocket(player.aGEPProjectile).bGEPInFlight=false; //tear off rocket
					Rocket(player.aGEPProjectile).ParticleGenState(Rocket(player.aGEPProjectile).fireGen,true);
		         Rocket(player.aGEPProjectile).ParticleGenState(Rocket(player.aGEPProjectile).smokeGen,true);
               player.aGEPProjectile=none;
				}
				player.bGEPprojectileInflight=false;
				if ((player.InHand.IsA('WeaponGEPGun'))&&(player.bAutoReload))
					DeusExWeapon(player.InHand).ReloadAmmo();
			}

			if (DeusExWeapon(player.inHand).IsA('WeaponGEPGun'))
			{
			/*DeusExWeapon(player.inHand).Mesh=DeusExWeapon(player.inHand).PlayerViewMesh;
	      DeusExWeapon(player.inHand).DrawScale=DeusExWeapon(player.inHand).PlayerViewScale;
	      DeusExWeapon(player.inHand).PlayerViewOffset.X=46;//class'WeaponGEPGun'.default.PlayerViewOffset.X;
	      DeusExWeapon(player.inHand).PlayerViewOffset.Y=-22;//class'WeaponGEPGun'.default.PlayerViewOffset.Y;
	      DeusExWeapon(player.inHand).PlayerViewOffset.Z=-10;//class'WeaponGEPGun'.default.PlayerViewOffset.Z;*/
	     // DeusExWeapon(player.inHand).bHideWeapon=false;
	      if ((player.GEPmounted!=none)&&(player.GEPmounted.lightFlicker!=none))
	        player.GEPmounted.lightFlicker.TurnOff();

         player.SpawnGEPmounted(false);
         Player.DesiredFOV = Player.Default.DefaultFOV;                         //RSD: Make sure we do this too!
//	      SetBackgroundStyle(DSTY_None);
	      Hide();
	      }//(X=46.000000,Y=-22.000000,Z=-10.000000)
			//TODO: shutdown draw overlay
		} else
		{
			Player.DesiredFOV = Player.Default.DefaultFOV;
			bViewVisible = False;
			Hide();
		}
	}
	
	player.UpdateCrosshair();
}

// ----------------------------------------------------------------------
// HideView()
// ----------------------------------------------------------------------

function HideView()
{
	if (bViewVisible)
	{
		Hide();
		Player.DesiredFOV = Player.Default.DefaultFOV;
		//Player.SetFOVAngle(Player.Default.DefaultFOV);
	}
}

// ----------------------------------------------------------------------
// ShowView()
// ----------------------------------------------------------------------

function ShowView()
{
	if (bViewVisible)
	{
		//Player.SetFOVAngle(desiredFOV);
		Player.DesiredFOV = 30;
		Show();
	}
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	local float			fromX, toX;
	local float			fromY, toY;
	local float			scopeWidth, scopeHeight;
    local float x, y, w, h;                                                     //RSD: Added
    local string rangeStr;                                                      //RSD: Added
    local float offset;                                                         //SARGE: Added
    local Texture binocsTex[4];                                                 //SARGE: Added
    local Texture scopeTex[8];                                                 //SARGE: Added


	Super.DrawWindow(gc);

	//if (Player!=none&&Player.bGEPzoomActive) return;

	if (GetRootWindow().parentPawn != None)
	{
		if (player.IsInState('Dying'))
			return;
	}

	if (Player.bGEPzoomActive)
	{
	//	player.GEPtopX=width/2;
//		player.GEPtopY=height/2;
//		player.GEPwidth=width;
//		player.GEPheight=height;

  // gc.SetStyle(DSTY_Translucent);
//	gc.DrawStretchedTexture(width/4,height/4,width,height, 0, 0,64,64,GEPOverlayTexture);
//   Player.bDoingSnap=false;
return;
		fromX=(width/2)-248;
		fromY=(height/2)-240;

		gc.SetStyle(DSTY_Translucent);
		//gc.DrawTexture(fromX,       fromY, 512,512, 0, 0, Texture'GMDXUI.Skins.GEPTransOut');
		gc.SetStyle(DSTY_Modulated);
		//gc.DrawTexture(fromX,       fromY, 512,512, 0, 0, Texture'GMDXUI.Skins.GEPOverlayOut');

		return;
	}

	// Figure out where to put everything
	if (bBinocs)
	{
        if (player.bClassicScope && false) //SARGE: Added //SARGE: This is just a smaller, crappier version of the bigger one, so just use that instead
        {
            scopeWidth  = 512;                                                     //RSD: 512
            scopeHeight = 256;                                                      //RSD: 256
            offset = 256;
            binocsTex[0] = Texture'HUDBinocularView_1';
            binocsTex[1] = Texture'HUDBinocularView_2';
            binocsTex[2] = Texture'HUDBinocularCrosshair_1';
            binocsTex[3] = Texture'HUDBinocularCrosshair_2';
            y = height/2 - 16;                                                      //SARGE: Text is slightly higher in classic mode.
        }
        else
        {
            scopeWidth  = 1024;                                                     //RSD: 512
            scopeHeight = 512;                                                      //RSD: 256
            offset = 512;
            binocsTex[0] = Texture'GMDXSFX.UI.HUDBinocV1';
            binocsTex[1] = Texture'GMDXSFX.UI.HUDBinocV2';
            binocsTex[2] = Texture'GMDXSFX.UI.HUDBinocX1';
            binocsTex[3] = Texture'GMDXSFX.UI.HUDBinocX2';
            y = height/2;
        }

		x = width/2;                                                   //RSD: For rangefinder text
		w = width/4;
		h = height/4;
	}
	else if (player.bClassicScope) //SARGE: Added
	{
		scopeWidth  = 256;
		scopeHeight = 256;
        offset = 256;
	}
	else
	{
		scopeWidth  = 1024;
		scopeHeight = 1024;
        offset = 512;
	}

	fromX = (width-scopeWidth)/2;
	fromY = (height-scopeHeight)/2;
	toX   = fromX + scopeWidth;
	toY   = fromY + scopeHeight;


         // Draw the black borders
	gc.SetTileColorRGB(0, 0, 0);
	gc.SetStyle(DSTY_Normal);
	if ( Player.Level.NetMode == NM_Standalone && (!player.bClassicScope || bBinocs) )	// Only block out screen real estate in single player
	{
		gc.DrawPattern(0, 0, width, fromY, 0, 0, Texture'Solid');
		gc.DrawPattern(0, toY, width, fromY, 0, 0, Texture'Solid');
		gc.DrawPattern(0, fromY, fromX, scopeHeight, 0, 0, Texture'Solid');
		gc.DrawPattern(toX, fromY, fromX, scopeHeight, 0, 0, Texture'Solid');
	}

	// Draw the center scope bitmap
	// Use the Header Text color

//	gc.SetStyle(DSTY_Masked);
	if (bBinocs)
	{
		gc.SetStyle(DSTY_Modulated);
		gc.DrawTexture(fromX,       fromY, 512, scopeHeight, 0, 0, binocsTex[0]);
		gc.DrawTexture(fromX + offset, fromY, 512, scopeHeight, 0, 0, binocsTex[1]);

		gc.SetTileColor(colLines);
		gc.SetStyle(DSTY_Masked);
		gc.DrawTexture(fromX,       fromY, 512, scopeHeight, 0, 0, binocsTex[2]);
		gc.DrawTexture(fromX + offset, fromY, 512, scopeHeight, 0, 0, binocsTex[3]);

        rangeStr = getBinocsTargetRangeString();                                //RSD: Rangefinder stuff


        gc.SetAlignments(HALIGN_Left, VALIGN_Center);
        gc.SetFont(Font'TechMedium');
        gc.SetTextColorRGB(0, 160, 16);
        gc.GetTextExtent(0, w, h, rangeStr);
        gc.DrawText(x-30, y+30, w, h, rangeStr);
	}
	else if(!player.bClassicScope)
	{
        //Rifle has a unique scope
        //SARGE: Maybe not, it looks worse than the GMDX Scope
        /*
        if (DeusExWeapon(player.inHand).IsA('WeaponRifle') && player.IsHDTPInstalled())
        {
			scopeTex[0] = class'HDTPLoader'.static.GetTexture("HDTPItems.HDTPHUDScopeView01");
			scopeTex[1] = class'HDTPLoader'.static.GetTexture("HDTPItems.HDTPHUDScopeView02");
			scopeTex[2] = class'HDTPLoader'.static.GetTexture("HDTPItems.HDTPHUDScopeView03");
			scopeTex[3] = class'HDTPLoader'.static.GetTexture("HDTPItems.HDTPHUDScopeView04");
			
			scopeTex[4] = class'HDTPLoader'.static.GetTexture("HDTPItems.HDTPHUDScopeCrosshair01");
			scopeTex[5] = class'HDTPLoader'.static.GetTexture("HDTPItems.HDTPHUDScopeCrosshair02");
			scopeTex[6] = class'HDTPLoader'.static.GetTexture("HDTPItems.HDTPHUDScopeCrosshair03");
			scopeTex[7] = class'HDTPLoader'.static.GetTexture("HDTPItems.HDTPHUDScopeCrosshair04");
        }
        else
        {*/
			scopeTex[0] = Texture'scopeview01';
			scopeTex[1] = Texture'scopeview02';
			scopeTex[2] = Texture'scopeview03';
			scopeTex[3] = Texture'scopeview04';
			
            scopeTex[4] = Texture'scopecross01';
            scopeTex[5] = Texture'scopecross02';
            scopeTex[6] = Texture'scopecross03';
            scopeTex[7] = Texture'scopecross04';
        //}

		if ( Player!=none)
		{
			gc.SetStyle(DSTY_Modulated);
			gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, scopeTex[0]);
			gc.DrawTexture(fromX+scopeWidth/2, fromY, scopeWidth, scopeHeight, 0, 0, scopeTex[1]);
			gc.DrawTexture(fromX, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, scopeTex[2]);
			gc.DrawTexture(fromX+scopeWidth/2, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, scopeTex[3]);
			gc.SetTileColorRGB(255,255,255);
			gc.SetStyle(DSTY_Masked);
			gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, scopeTex[4]);
			gc.DrawTexture(fromX+scopeWidth/2, fromY, scopeWidth, scopeHeight, 0, 0, scopeTex[5]);
			gc.DrawTexture(fromX, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, scopeTex[6]);
			gc.DrawTexture(fromX+scopeWidth/2, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, scopeTex[7]);
        }
    }
    else //SARGE: Use the Multiplayer scope for the classic scope mode because it's bigger
    {
        gc.SetStyle(DSTY_Modulated);
        
        //if ( WeaponRifle(Player.inHand) != None )
        //    gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView3');
        //else
            gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView2');
    }
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colLines = theme.GetColorFromName('HUDColor_HeaderText');
}

function string getBinocsTargetRangeString()                                    //RSD: Logic stolen from AugmentationDisplayWindow's DrawTargetAugmentation() function
{
    local String str;
    local float range;
    local vector HitLocation, HitNormal, StartTrace, EndTrace;

    // check 1000 feet in front of the player
   	StartTrace = Player.Location;
	EndTrace = Player.Location + (Vector(Player.ViewRotation) * 160000);
	// adjust for the eye height
	StartTrace.Z += Player.BaseEyeHeight;
	EndTrace.Z += Player.BaseEyeHeight;
    player.Trace(HitLocation, HitNormal, EndTrace, StartTrace,true);

    range = VSize(HitLocation - Player.Location);
    str = msgRange @ Int(range/16) @ msgRangeUnits;

    return str;
}

defaultproperties
{
     msgRange="Range"
     msgRangeUnits="ft"
}
