//=============================================================================
// TechGoggles.
//=============================================================================
class TechGoggles extends ChargedPickup;

var() bool bVisionActive;
var() int visionLevel;
var() int visionLevelValue;

// ----------------------------------------------------------------------
// ChargedPickupBegin()
// ----------------------------------------------------------------------

function ChargedPickupBegin(DeusExPlayer Player)
{
	Super.ChargedPickupBegin(Player);

	DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount++;
	bVisionActive = DeusExRootWindow(Player.rootWindow).hud.augDisplay.bVisionActive;
	visionLevel = DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevel;
	visionLevelValue = DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevelValue;
	UpdateHUDDisplay(Player);
}

// ----------------------------------------------------------------------
// UpdateHUDDisplay()
// ----------------------------------------------------------------------

function UpdateHUDDisplay(DeusExPlayer Player)
{
	local int skillLevel, sonarDistance;

	if ((DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount == 0) && (IsActive()))
		DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount++;

	if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkThermalImaging').bPerkObtained == true)
	{
		sonarDistance = 512;                                                    //RSD: Was 500 (31.25ft), now 512 (32ft)
		skillLevel = 3;
    }
    else
    {
        sonarDistance = 0;
        SkillLevel = 1;
    }

	DeusExRootWindow(Player.rootWindow).hud.augDisplay.bVisionActive = True;
	//DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevel = 3;
	//DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevelValue = 300;
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevel = skillLevel;
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevelValue = sonarDistance;
}

// ----------------------------------------------------------------------
// ChargedPickupEnd()
// ----------------------------------------------------------------------

function ChargedPickupEnd(DeusExPlayer Player)
{
	Super.ChargedPickupEnd(Player);

	if (--DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount == 0)
		DeusExRootWindow(Player.rootWindow).hud.augDisplay.bVisionActive = False;

	DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevelValue = visionLevelValue;
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevel = visionLevel;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ActivateSound=Sound'RSDCrap.Pickup.NightVisionEnable'
     DeactivateSound=Sound'RSDCrap.Pickup.NightVisionDisable'
     skillNeeded=Class'DeusEx.SkillEnviro'
     LoopSound=Sound'DeusExSounds.Pickup.TechGogglesLoop'
     ChargedIcon=Texture'DeusExUI.Icons.ChargedIconGoggles'
     ExpireMessage="TechGoggles power supply used up"
     ItemName="Tech Goggles"
     ItemArticle="some"
     PlayerViewOffset=(X=20.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DeusExItems.GogglesIR'
     PickupViewMesh=LodMesh'DeusExItems.GogglesIR'
     ThirdPersonMesh=LodMesh'DeusExItems.GogglesIR'
     Charge=500
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconTechGoggles'
     largeIcon=Texture'DeusExUI.Icons.LargeIconTechGoggles'
     largeIconWidth=49
     largeIconHeight=36
     Description="Tech goggles are used by many special ops forces throughout the world under a number of different brand names, but they all provide some form of portable light amplification in a disposable package."
     beltDescription="GOGGLES"
     Mesh=LodMesh'DeusExItems.GogglesIR'
     CollisionRadius=8.000000
     CollisionHeight=2.800000
     Mass=10.000000
     Buoyancy=5.000000
}
