//=============================================================================
// HUDHitDisplay
//=============================================================================
class HUDHitDisplay expands HUDBaseWindow;

struct BodyPart
{
	var Window partWindow;
	var int    lastHealth;
	var int    healHealth;
	var int    displayedHealth;
	var float  damageCounter;
	var float  healCounter;
   var float  refreshCounter;
};

var BodyPart head;
var BodyPart torso;
var BodyPart armLeft;
var BodyPart armRight;
var BodyPart legLeft;
var BodyPart legRight;
var BodyPart armor;

var Color    colArmor;
var Color    col02;
var Color    colRed;

var float    damageFlash;
var float    healFlash;

var Bool			bVisible;
var DeusExPlayer	player;

// Breathing underwater bar
var ProgressBarWindow winBreath;
var bool	bUnderwater;
var float	breathPercent;

// Energy bar
var ProgressBarWindow winEnergy;
var float	energyPercent;

// Used by DrawWindow
var Color colBar;
var int ypos;

// Defaults
var Texture texBackground;
var Texture texBorder;
//CyberP:
var localized string O2Text;
var localized string EnergyText;
var localized string noted;
var localized string walking;
var localized string crouching;
var localized string running;
var localized string leaning;
var localized string swimming;
var localized string tiptoes;
var localized string mantling;
var string percentTxt;
var Color colLight;
var color colLightDark;
var color colMult;

//LDDP, 10/27/21: Store this now, so we can change its texture on the fly!
var Window BodyWin;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	local window bodyWin;

	Super.InitWindow();

	bTickEnabled = True;

	Hide();

	player = DeusExPlayer(DeusExRootWindow(GetRootWindow()).parentPawn);

	SetSize(84, 106);

	CreateBodyPart(head,     Texture'HUDHitDisplay_Head',     39, 17,  4,  7);
	CreateBodyPart(torso,    Texture'HUDHitDisplay_Torso',    36, 25, 10,  23);
	CreateBodyPart(armLeft,  Texture'HUDHitDisplay_ArmLeft',  46, 27, 10,  23);
	CreateBodyPart(armRight, Texture'HUDHitDisplay_ArmRight', 26, 27, 10,  23);
	CreateBodyPart(legLeft,  Texture'HUDHitDisplay_LegLeft',  41, 44,  8,  36);
	CreateBodyPart(legRight, Texture'HUDHitDisplay_LegRight', 33, 44,  8,  36);

	bodyWin = NewChild(Class'Window');
	bodyWin.SetBackground(Texture'HUDHitDisplay_Body');
	bodyWin.SetBackgroundStyle(DSTY_Translucent);
	bodyWin.SetConfiguration(24, 15, 34, 68);
	bodyWin.SetTileColor(colArmor);
	bodyWin.Lower();

	damageFlash = 0.4;  // seconds
	healFlash   = 1.0;  // seconds
	
    winEnergy = CreateProgressBar(15, 20);
	winBreath = CreateProgressBar(61, 20);

    UpdateBars();
}

function UpdateBars()
{
    winEnergy.bSpecialFX = player.bAnimBar1;
    winBreath.bSpecialFX2 = player.bAnimBar2;
}

// ----------------------------------------------------------------------
// CreateProgressBar()
// ----------------------------------------------------------------------

function ProgressBarWindow CreateProgressBar(int posX, int posY)
{
	local ProgressBarWindow winProgress;

	winProgress = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));
	winProgress.UseScaledColor(True);
	winProgress.SetSize(5, 55);
	winProgress.SetPos(posX, posY);
	winProgress.SetValues(0, 100);
	winProgress.SetCurrentValue(0);
	winProgress.SetVertical(True);

	return winProgress;
}

// ----------------------------------------------------------------------
// CreateBodyPart()
// ----------------------------------------------------------------------

function CreateBodyPart(out BodyPart part, texture tx, float newX, float newY,
                        float newWidth, float newHeight)
{
	local window newWin;

	newWin = NewChild(Class'Window');
	newWin.SetBackground(tx);
	newWin.SetBackgroundStyle(DSTY_Translucent);
	newWin.SetConfiguration(newX, newY, newWidth, newHeight);
	newWin.SetTileColorRGB(0, 0, 0);

	part.partWindow      = newWin;
	part.displayedHealth = 0;
	part.lastHealth      = 0;
	part.healHealth      = 0;
	part.damageCounter   = 0;
	part.healCounter     = 0;
   part.refreshCounter  = 0;
}

// ----------------------------------------------------------------------
// SetHitColor()
// ----------------------------------------------------------------------

function SetHitColor(out BodyPart part, float deltaSeconds, bool bHide, int hitValue)
{
	local Color col;
	local float mult;

	part.damageCounter -= deltaSeconds;
	if (part.damageCounter < 0)
		part.damageCounter = 0;
	part.healCounter -= deltaSeconds;
	if (part.healCounter < 0)
		part.healCounter = 0;

   part.refreshCounter -= deltaSeconds;

   if ((part.healCounter == 0) && (part.damageCounter == 0) && (part.lastHealth == hitValue) && (part.refreshCounter > 0))
      return;

   if (part.refreshCounter <= 0)
      part.refreshCounter = 0.5;

	if (hitValue < part.lastHealth)
	{
		part.damageCounter  = damageFlash;
		part.displayedHealth = hitValue;
	}
	else if (hitValue > part.lastHealth)
	{
		part.healCounter = healFlash;
		part.healHealth = part.displayedHealth;
	}
	part.lastHealth = hitValue;

	if (part.healCounter > 0)
	{
		mult = part.healCounter/healFlash;
		part.displayedHealth = hitValue + (part.healHealth-hitValue)*mult;
	}
	else
	{
		part.displayedHealth = hitValue;
	}

	hitValue = part.displayedHealth;
	col = winEnergy.GetColorScaled(hitValue/100.0);

	if (part.damageCounter > 0)
	{
		mult = part.damageCounter/damageFlash;
		col.r += (255-col.r)*mult;
		col.g += (255-col.g)*mult;
		col.b += (255-col.b)*mult;
	}


	if (part.partWindow != None)
	{
		part.partWindow.SetTileColor(col);
		if (bHide)
		{
			if (hitValue > 0)
				part.partWindow.Show();
			else
				part.partWindow.Hide();
		}
	}
}

//Ygll: utility function to display the current player stance into hud
function DisplayStanceInfo(GC gc)
{
	local float alignX, alignY, alignH, alignW;
	
	gc.SetFont(Font'FontMenuSmall');
	gc.SetStyle(DSTY_Normal);		
	gc.SetTextColor(col02);
	
	alignH = 12.0;
	alignW = 75.0;
	if(player.bHUDBordersVisible)
	{
		alignX = 19.0;
		alignY = 95.0;
	}
	else
	{
		alignX = 12.0;
		alignY = 90.0;
	}
	
	if(player.iStanceHud == 1)
	{
		if( !player.IsCrouching() && !player.bIsTipToes && !player.IsLeaning() && !player.bIsMantlingStance )
		{
			if(player.bIsWalking)
				gc.DrawText(alignX, alignY, alignW, alignH, "[-" $ walking $ "-]");
			else if(!player.bIsWalking)
				gc.DrawText(alignX, alignY, alignW, alignH, "[-" $ running $ "-]");
		}
	}
	else
	{
		if(player.IsInState('PlayerSwimming'))
		{			
			gc.DrawText(alignX, alignY, alignW, alignH, "[-" $ swimming $ "-]");
		}
		else if(player.bIsTipToes)
		{			
			gc.DrawText(alignX, alignY, alignW, alignH, "[-" $ tiptoes $ "-]");
		}
		else if(player.IsLeaning())
		{			
			gc.DrawText(alignX, alignY, alignW, alignH, "[-" $ leaning $ "-]");
		}
		else if( player.bIsMantlingStance || player.IsInState('Mantling') )
		{			
			gc.DrawText(alignX, alignY, alignW, alignH, "[-" $ mantling $ "-]");
		}
		else if( !player.bCrouchHack && ( player.bCrouchOn || player.bForceDuck || player.bIsCrouching ))
		{			
			gc.DrawText(alignX, alignY, alignW, alignH, "[-" $ crouching $ "-]");
		}
		else if(player.bIsWalking)
		{
			if(player.iStanceHud == 3 || (player.iStanceHud == 2 && player.bAlwaysRun) )		
				gc.DrawText(alignX, alignY, alignW, alignH, "[-" $ walking $ "-]");
		}
		else if(!player.bIsWalking)
		{
			if(player.iStanceHud == 3 || (player.iStanceHud == 2 && !player.bAlwaysRun) )	
				gc.DrawText(alignX, alignY, alignW, alignH, "[-" $ running $ "-]");
		}	
	}
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------
event DrawWindow(GC gc)
{
	Super.DrawWindow(gc);

	// Draw energy bar
	gc.SetFont(Font'FontTiny');
	gc.SetTextColorRGB(128,128,128);  //gc.SetTextColor(winEnergy.GetBarColor());

    //SARGE: Draw the percentage
    if (int(player.Energy) == int(player.GetMaxEnergy(true)) || !player.bShowEnergyBarPercentages)
        gc.DrawText(13, 74, 8, 8, EnergyText);
    else
        gc.DrawText(13, 74, 8, 8, int(player.Energy));

	// If we're underwater draw the breathometer
	if ((bUnderwater && !Player.bStaminaSystem) || Player.bStaminaSystem || Player.bHardCoreMode)
	{
	    breathPercent = 100.0 * player.swimTimer / player.swimDuration;
	    breathPercent = FClamp(breathPercent, 0.0, 100.0);
        winBreath.SetCurrentValue(breathPercent);

        //SARGE: Show a red bar when we're stunted
        if (player.bStunted)
        {
            winBreath.UseScaledColor(false);
            winBreath.SetColors(colRed,colRed);
        }
        else
            winBreath.UseScaledColor(true);

		ypos = breathPercent * 0.55;

		// draw the breath bar
		colBar = winBreath.GetBarColor();

		// draw the O2 text and blink it if really low
		gc.SetFont(Font'FontTiny');
		if (breathPercent < 10)
		{
			if ((player.swimTimer % 0.5) > 0.25)
				colBar.r = 255;
			else
				colBar.r = 0;
		}
		gc.SetTextColor(col02);
        //SARGE: Draw the percentage
        if (int(breathPercent) > 99 || !player.bShowEnergyBarPercentages)
            gc.DrawText(61, 74, 8, 8, O2Text);
        else
            gc.DrawText(61, 74, 8, 8, int(breathPercent));
	}
	
	if (Player.LightLevelDisplay > -1)
	{
		noted = Player.LightLevelDisplay $ percentTxt;
		colMult.R = Player.LightLevelDisplay*5;
		colMult.G = Player.LightLevelDisplay*5;
		colMult.B = 0;
		if (Player.LightLevelDisplay > 50)
		{
            colMult.R = 255;
            colMult.G = 255;
        }
		else if (Player.LightLevelDisplay < 25)
		{
            colMult.R = 125;
            colMult.G = 125;
        }
        gc.SetFont(Font'FontConversationBold');
        gc.SetTextColor(colMult);
		gc.DrawText(31, 72, 36, 12, noted);
    }

	//Ygll: new tooltip feature to display the current player stance into hud
	if(player.iStanceHud > 0)
	{
		DisplayStanceInfo(gc);
	}
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawTexture(11, 11, 60, 76, 0, 0, texBackground);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		gc.SetStyle(borderDrawStyle);
		gc.SetTileColor(colBorder);
		gc.DrawTexture(0, 0, 84, 106, 0, 0, texBorder);
	}
}

// ----------------------------------------------------------------------
// Tick()
//
// Update the Energy and Breath displays
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
   // DEUS_EX AMSD Server doesn't need to do this.
   //if ((player.Level.NetMode != NM_Standalone)  && (!Player.PlayerIsClient()))
   //{
   //   Hide();
   //   return;
   //}

	if ((player != None) && ( bVisible ))
	{
		SetHitColor(head,     deltaSeconds, false, player.HealthHead);
		SetHitColor(torso,    deltaSeconds, false, player.HealthTorso);
		SetHitColor(armLeft,  deltaSeconds, false, player.HealthArmLeft);
		SetHitColor(armRight, deltaSeconds, false, player.HealthArmRight);
		SetHitColor(legLeft,  deltaSeconds, false, player.HealthLegLeft);
		SetHitColor(legRight, deltaSeconds, false, player.HealthLegRight);
        //if (!winBreath.IsVisible())
		//		winBreath.Show();
		// Calculate the energy bar percentage
		energyPercent = 100.0 * (player.Energy / player.GetMaxEnergy());
		winEnergy.SetCurrentValue(energyPercent);

        breathPercent = 100.0 * player.swimTimer / player.swimDuration;
	    breathPercent = FClamp(breathPercent, 0.0, 100.0);
		// If we're underwater, draw the breath bar
		if (bUnderwater)
		{
			// if we are already underwater
			if (player.HeadRegion.Zone.bWaterZone)
			{
				// if we are still underwater
				//breathPercent = 100.0 * player.swimTimer / player.swimDuration;
				//breathPercent = FClamp(breathPercent, 0.0, 100.0);
			}
			else
			{
				// if we are getting out of the water
				bUnderwater = False;
				//if (breathPercent != 100)
				//breathPercent += 0.2; //= 100;
			}
		}
		else if (player.HeadRegion.Zone.bWaterZone)
		{
			// if we just went underwater
			bUnderwater = True;
			//breathPercent = 100;
		}

		// Now show or hide the breath meter
		if (!Player.bStaminaSystem && !Player.bHardCoreMode)
		{
		if (bUnderwater)
		{
			if (!winBreath.IsVisible())
				winBreath.Show();

			winBreath.SetCurrentValue(breathPercent);
		}
		else
		{
		    Player.swimTimer = 90.0;
			if (winBreath.IsVisible())
				winBreath.Hide();
		}
		}
		else
		{
		    if (!winBreath.IsVisible())
				winBreath.Show();
		}
		
		Show();
	}
	else
		Hide();
}

// ----------------------------------------------------------------------
// SetVisibility()
// ----------------------------------------------------------------------

function SetVisibility( bool bNewVisibility )
{
	bVisible = bNewVisibility;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

//LDDP, 10/26/21: Update textures on the fly. Easy one.
function UpdateAsFemale(bool NewbFemale)
{
	local Texture TTex;
	
	if (NewbFemale)
	{
		TTex = Texture(DynamicLoadObject("FemJC.HUDHitDisplay_HeadFem", class'Texture', false));
		if (TTex != None) Head.PartWindow.SetBackground(TTex);
		TTex = Texture(DynamicLoadObject("FemJC.HUDHitDisplay_TorsoFem", class'Texture', false));
		if (TTex != None) Torso.PartWindow.SetBackground(TTex);
		TTex = Texture(DynamicLoadObject("FemJC.HUDHitDisplay_ArmLeftFem", class'Texture', false));
		if (TTex != None) ArmLeft.PartWindow.SetBackground(TTex);
		TTex = Texture(DynamicLoadObject("FemJC.HUDHitDisplay_ArmRightFem", class'Texture', false));
		if (TTex != None) ArmRight.PartWindow.SetBackground(TTex);
		TTex = Texture(DynamicLoadObject("FemJC.HUDHitDisplay_LegLeftFem", class'Texture', false));
		if (TTex != None) LegLeft.PartWindow.SetBackground(TTex);
		TTex = Texture(DynamicLoadObject("FemJC.HUDHitDisplay_LegRightFem", class'Texture', false));
		if (TTex != None) LegRight.PartWindow.SetBackground(TTex);
	}
	else
	{
		Head.PartWindow.SetBackground(Texture'HUDHitDisplay_Head');
		Torso.PartWindow.SetBackground(Texture'HUDHitDisplay_Torso');
		ArmLeft.PartWindow.SetBackground(Texture'HUDHitDisplay_ArmLeft');
		ArmRight.PartWindow.SetBackground(Texture'HUDHitDisplay_ArmRight');
		LegLeft.PartWindow.SetBackground(Texture'HUDHitDisplay_LegLeft');
		LegRight.PartWindow.SetBackground(Texture'HUDHitDisplay_LegRight');
	}
	
	if (NewbFemale)
	{
		TTex = Texture(DynamicLoadObject("FemJC.HUDHitDisplay_BodyFem", class'Texture', false));
		if (TTex != None) bodyWin.SetBackground(TTex);
	}
	else if (bodyWin != None)
	{
		bodyWin.SetBackground(Texture'HUDHitDisplay_Body');
	}
}

defaultproperties
{
     colArmor=(R=255,G=255,B=255);
     col02=(G=128,B=255);
     texBackground=Texture'DeusExUI.UserInterface.HUDHitDisplayBackground_1';
     texBorder=Texture'DeusExUI.UserInterface.HUDHitDisplayBorder_1';
     O2Text="O2";
     EnergyText="BE";
     percentTxt="%";	 
     colLight=(R=255,G=255);
     colLightDark=(R=140,G=140);
     colRed=(R=255);
	 crouching="Crouching";
	 walking="Walking";
	 running="Running";
	 leaning="Leaning";
	 swimming="Swimming";
	 tiptoes="Tiptoes";
	 mantling="Mantling";
}
