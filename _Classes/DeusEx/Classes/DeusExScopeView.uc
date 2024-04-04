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

		/*
		if (bActive)
			cross.SetCrosshair(false);
		else
			cross.SetCrosshair(player.bCrosshairVisible);
		*/
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

		if ((player.bCrosshairVisible)&&(DeusExRootWindow(player.rootWindow)!=none))
		{
			bOldCrossHair=true;
			player.ToggleCrosshair();
		} else
		{
			bOldCrossHair=false;
			player.bCrosshairVisible=True;
		}

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

			if ((bOldCrossHair&&(!player.bCrosshairVisible))&&
				(DeusExRootWindow(player.rootWindow)!=none))
				{
					player.ToggleCrosshair();
					player.bCrosshairVisible=true;
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
		scopeWidth  = 1024;                                                     //RSD: 512
		scopeHeight = 512;                                                      //RSD: 256

		x = width/2;                                                   //RSD: For rangefinder text
		y = height/2;
		w = width/4;
		h = height/4;
	}
	else
	{
		scopeWidth  = 1024;   //512
		scopeHeight = 1024;   //512
	}

	fromX = (width-scopeWidth)/2;
	fromY = (height-scopeHeight)/2;
	toX   = fromX + scopeWidth;
	toY   = fromY + scopeHeight;


         // Draw the black borders
	gc.SetTileColorRGB(0, 0, 0);
	gc.SetStyle(DSTY_Normal);
	if ( Player.Level.NetMode == NM_Standalone )	// Only block out screen real estate in single player
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
		gc.DrawTexture(fromX,       fromY, 512, scopeHeight, 0, 0, Texture'GMDXSFX.UI.HUDBinocV1');
		gc.DrawTexture(fromX + 512, fromY, 512, scopeHeight, 0, 0, Texture'GMDXSFX.UI.HUDBinocV2');

		gc.SetTileColor(colLines);
		gc.SetStyle(DSTY_Masked);
		gc.DrawTexture(fromX,       fromY, 512, scopeHeight, 0, 0, Texture'GMDXSFX.UI.HUDBinocX1');
		gc.DrawTexture(fromX + 512, fromY, 512, scopeHeight, 0, 0, Texture'GMDXSFX.UI.HUDBinocX2');

        rangeStr = getBinocsTargetRangeString();                                //RSD: Rangefinder stuff


        gc.SetAlignments(HALIGN_Left, VALIGN_Center);
        gc.SetFont(Font'TechMedium');
        gc.SetTextColorRGB(0, 160, 16);
        gc.GetTextExtent(0, w, h, rangeStr);
        gc.DrawText(x-30, y+30, w, h, rangeStr);
	}
	else
	{
		// Crosshairs - Use new scope in multiplayer, keep the old in single player //CyberP: fuck multiplayer. Edit this 2 get unique scope view for snipe

		/*	if (DeusExWeapon(player.inHand).IsA('WeaponRifle'))
			{

			gc.SetStyle(DSTY_Modulated);
			gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HDTPHUDScopeView01');
			gc.DrawTexture(fromX+scopeWidth/2, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HDTPHUDScopeView02');
			gc.DrawTexture(fromX, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, Texture'HDTPHUDScopeView03');
			gc.DrawTexture(fromX+scopeWidth/2, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, Texture'HDTPHUDScopeView04');
			gc.SetTileColorRGB(255,255,255);
			gc.SetStyle(DSTY_Masked);
			gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HDTPHUDScopeCrosshair01');
			gc.DrawTexture(fromX+scopeWidth/2, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HDTPHUDScopeCrosshair02');
			gc.DrawTexture(fromX, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, Texture'HDTPHUDScopeCrosshair03');
			gc.DrawTexture(fromX+scopeWidth/2, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, Texture'HDTPHUDScopeCrosshair04');
			}

		else
		{ */
		if ( Player!=none )
		{
			gc.SetStyle(DSTY_Modulated);
			gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'scopeview01');
			gc.DrawTexture(fromX+scopeWidth/2, fromY, scopeWidth, scopeHeight, 0, 0, Texture'scopeview02');
			gc.DrawTexture(fromX, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, Texture'scopeview03');
			gc.DrawTexture(fromX+scopeWidth/2, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, Texture'scopeview04');
			gc.SetTileColorRGB(255,255,255);
			gc.SetStyle(DSTY_Masked);
			gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'scopecross01');
			gc.DrawTexture(fromX+scopeWidth/2, fromY, scopeWidth, scopeHeight, 0, 0, Texture'scopecross02');
			gc.DrawTexture(fromX, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, Texture'scopecross03');
			gc.DrawTexture(fromX+scopeWidth/2, fromY+scopeHeight/2, scopeWidth, scopeHeight, 0, 0, Texture'scopecross04');
                        }

		else
			{
				gc.SetStyle(DSTY_Modulated);
				gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView2');
			}
		//}
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
