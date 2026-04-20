//=============================================================================
// DeusExPickup.
//=============================================================================
class DeusExPickup extends Pickup
	abstract;

//#exec obj load file="..\DeusEx\Textures\GameEffects.utx" package=GameEffects

//struct SSkinProps
//{
//	var texture showskin;
//	var texture smallIconSkin;
//	var texture largeIconSkin;
//	var string description;
//};

var travel int PickUpList[50];
var bool bHasMultipleSkins;

var() travel int textureSet;




var bool            bBreakable;		// true if we can destroy this item
var class<Fragment> fragType;		// fragments created when pickup is destroyed
var int				maxCopies;		// 0 means unlimited copies

var localized String CountLabel;
var localized String msgTooMany;

//gmdx
var() bool bSimplePhysics;
var bool bAutoActivate;                                                         //Sarge: Auto activate with left click, rather than placing in the players hands                                                                                
var localized string StackSizeLabel;                                            //Sarge: Show the stack size in the description

var Texture handsTex;   //SARGE: Store the hand texture for performance. TODO: Use some sort of class/object to share this between SkilledTools and Weapons

//SARGE: HDTP Model toggles
var config int iHDTPModelToggle;
var string HDTPSkin;
var string HDTPTexture;
var string HDTPMesh;

//Lerp Aid
var float lerpAid;
const lerpAidSpeed = 7500;                   //SARGE: How far to lerp per second
var bool bCachedNearWall; //CyberP: emulating the weapon movement if player near wall //SARGE: Lets rename this because it's name is meaningless otherwise

//SARGE: Weapon inertia
var transient Vector cachedDrawOffset;
var transient float inertiaDelta;                        //SARGE: deltaTime for weapon inertia
var const float inertiaSpeed;                            //SARGE: How fast weapons move.

//SARGE: Use proper FOV scaling
var const bool bUseFOV;

var int totalSkins;                                                             //Sarge: How many total skins this object has. Used to select random skins
var(GMDX) bool dontRandomiseSkin;                                               //Sarge: Prevents individual items from having their skin randomised

//SARGE: Add "Item Stealing" mechanics
var(GMDX) bool bIsOwnedItem;                                                    //SARGE: Send a futz event when picking this up.

var(GMDX) bool bDontRemoveOnMissionComplete;                                    //SARGE: Don't remove this item on mission completion.

//SARGE: Icon Info.
//TODO: Use SSkinInfo above instead, and handle all the skins the same way you handle icons.
struct IconInfo
{
    var Texture icon;
    var Texture largeIcon;
    var localized string description;
};

//Objects can support up to 10 skins
var private transient IconInfo Icons[10];

//SARGE: MissionScript calls this on all objects on map start.
function RandomiseSkin(DeusExPlayer player)
{
    if (totalSkins <= 1 || dontRandomiseSkin)
        return;

    //Don't randomise the players items
    if (Owner != None && Owner == player)
        return;

    textureSet = player.Randomizer.GetRandomInt(totalSkins - 1);
    SetSkin();
    SetIcon();
}

//SARGE: Added "Left Click Frob" and "Right Click Frob" support
//Return true to use the default frobbing mechanism (right click), or false for custom behaviour
function bool DoLeftFrob(DeusExPlayer frobber)
{
    if (bAutoActivate)
    {
        //GotoState('Activated');
        Activate();
        return false;
    }
    else
    {
        return true;
    }
}
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    return true;
}

//Sarge: Update frob display to show item count
function string GetFrobString(DeusExPlayer player)
{
	if (numCopies > 1 && player.bShowItemPickupCounts)
		return itemName @ "(" $ numCopies $ ")"; //SARGE: Append number of copies, if more than 1
    return itemName;
}

static function bool IsHDTP(optional bool bAllowEffects)
{
    return class'DeusExPlayer'.static.IsHDTPInstalled() && (default.iHDTPModelToggle > 0 || (bAllowEffects && class'DeusExPlayer'.default.bHDTPEffects));
}

exec function UpdateHDTPsettings()                                              //SARGE: New function to update model meshes (specifics handled in each class)
{
    if (HDTPMesh != "")
    {
        if (PlayerViewMesh == Mesh || PlayerViewMesh == None)
            PlayerViewMesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),IsHDTP());
        if (PickupViewMesh == Mesh || PickupViewMesh == None)
            PickupViewMesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),isHDTP());
        if (ThirdPersonMesh == Mesh || ThirdPersonMesh == None)
            ThirdPersonMesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),IsHDTP());
        Mesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),IsHDTP());
    }
    if (HDTPSkin != "")
        Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),IsHDTP());
    if (HDTPTexture != "")
        Skin = class'HDTPLoader'.static.GetTexture2(HDTPTexture,string(default.Texture),IsHDTP());

    if (bCarriedItem)
        Mesh = PlayerViewMesh;
    else
        Mesh = PickupViewMesh;
    
    SetWeaponHandTex();
	SetSkin();
    SetIcon();
}

//Shorthand for accessing hands tex
function SetWeaponHandTex()
{
	local deusexplayer p;
	p = deusexplayer(owner);
	if(p != none)
        handsTex = p.GetWeaponHandTex(false);
    //p.clientMessage("handsTex: " $ handsTex);
}


// ----------------------------------------------------------------------
// Networking Replication
// ----------------------------------------------------------------------

replication
{
	//client to server function
	reliable if ((Role < ROLE_Authority) && (bNetOwner))
		UseOnce;
}

function DropFrom(vector StartLocation)
{
    Style = default.Style;
    ScaleGlow = default.ScaleGlow;                                              //RSD: Also reset ScaleGlow so we don't get dim/bright due to cloak/radar
    UpdateHDTPsettings();
	super.DropFrom(StartLocation);
}

//
// Used to determine if we are near (and facing) a wall for placing LAMs, etc.
//
simulated function bool NearWallCheck()
{
	local Vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor HitActor;

	// Scripted pawns can't place LAMs
	if (ScriptedPawn(Owner) != None || Owner == None)
		return False;

	// trace out one foot in front of the pawn
	StartTrace = Owner.Location;
	EndTrace = StartTrace + Vector(Pawn(Owner).ViewRotation) * 32; //CyberP: was 32

	StartTrace.Z += Pawn(Owner).BaseEyeHeight;
	EndTrace.Z += Pawn(Owner).BaseEyeHeight;

	HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace);
	if ((HitActor == Level) || ((HitActor != None) && HitActor.IsA('Mover')))
		return True;

	return False;
}

simulated function Tick(float deltaTime)                                        //RSD: Relevant portion taken from DeusExWeapon.uc for overhauled cloak/radar routines
{
    super.Tick(deltaTime);
    
    bCachedNearWall = NearWallCheck();

    //SARGE: Do near wall detection
    //Moved from CalcDrawOffset so that it can be done in Tick
    //This lets it be independent of framerate.
    //The actual view offset is adjusted in CalcDrawOffset.
    if (DeusExPlayer(Owner) != None)
    {
        if (DeusExPlayer(Owner).Physics != PHYS_Falling && bCachedNearWall)
        {
            lerpAid -= lerpAidSpeed*deltaTime;
            if (lerpAid < -1000)
                lerpAid = -1000;
        }
        else
        {
            lerpAid += lerpAidSpeed*deltaTime;
            if (lerpAid > 0)
                lerpAid = 0;
        }
    }
    
    //SARGE: Weapon Inertia
    inertiaDelta = deltaTime*inertiaSpeed;
}

//=============================================================================
// Weapon rendering
// Draw first person view of inventory
simulated event RenderOverlays( canvas Canvas )
{
	local DeusExPlayer PlayerOwner;
	PlayerOwner = DeusExPlayer(Owner);

    if ( PlayerOwner != None )
        PreDisplay(true);
    
    super.RenderOverlays(canvas);

    //Reset to standard display
    PreDisplay(false);
}

function PreDisplay(bool overlay)
{
    local int i;
    local DeusExPlayer OP;
    for (i = 0;i < 8;i++)
    {
        //SARGE: No HDTP models for these
        //if (IsHDTP())
        //    multiskins[i] = none;
        //else
            multiskins[i] = default.multiskins[i];
    }

    Skin = default.Skin;
    Texture = default.Texture;
    ScaleGlow = default.ScaleGlow;
    Style = default.Style;
    SetSkin();
    
    Display(overlay);

    //SARGE: Don't even bother checking for ScriptedPawns here, they never use this stuff.
    OP = DeusExPlayer(Owner);
    if (OP != None && OP.CloakManager != None && OP.CloakManager.IsInAnyState())
    {
        bNoSmooth=false;
        OP.CloakManager.UpdateSkin(self);
        ScaleGlow = OP.CloakManager.GetScaleGlow();
    }
    else
    {
        bNoSmooth=default.bNoSmooth;
    }
}

//Overwrite this for custom display functionality.
function Display(bool overlay)
{
}

//
// Modified to work better with scripted pawns
// SARGE: Copied wholesale from DeusExWeapon
//
simulated function vector CalcDrawOffset()
{
	local vector		DrawOffset, WeaponBob;
	local ScriptedPawn	SPOwner;
	local Pawn			PawnOwner;
	local vector unX,unY,unZ;
    local Rotator vr;                       //SARGE: Added viewrotation variable
    local Vector newOffset;
    local float diff;

	SPOwner = ScriptedPawn(Owner);
	if (SPOwner != None)
	{
		DrawOffset = ((0.9/SPOwner.FOVAngle * PlayerViewOffset) >> SPOwner.ViewRotation);
		DrawOffset += (SPOwner.BaseEyeHeight * vect(0,0,1));
	}
	else
	{
        //Apply lerp-aid
        PlayerViewOffset.X = default.PlayerViewOffset.X*100;
        PlayerViewOffset.X += lerpAid;

		PawnOwner = Pawn(Owner);

        vr = PawnOwner.ViewRotation;
        if (PawnOwner.isa('DeusExPlayer'))
            vr = DeusExPlayer(PawnOwner).GetCurrentViewRotation();

        if (class'DeusExPlayer'.default.bPickupsUseFOV && bUseFOV)
            DrawOffset = ((0.9/PawnOwner.Default.FOVAngle * PlayerViewOffset) >> vr);
        else
            DrawOffset = ((0.9/PawnOwner.FOVAngle * PlayerViewOffset) >> vr);

        newOffset = drawOffset;

        if (VSize(cachedDrawOffset) == 0)
            cachedDrawOffset = drawOffset;

        //SARGE: Handle Weapon Inertia
        if (DeusExPlayer(PawnOwner) != none /*&& DeusExPlayer(PawnOwner).Physics != PHYS_Falling*/ && DeusExPlayer(PawnOwner).bViewmodelInertia && inertiaSpeed > 0)
        {
            //diff = VSize(cachedDrawOffset - drawOffset);
            //Log("diff:" $ drawOffset @ cachedDrawOffset);
            //diff = FMax(-8.0,FMin(8.0,diff));
            //Log("diff:" $ diff);

            newOffset.X = lerp(inertiaDelta,cachedDrawOffset.X,drawOffset.X);
            newOffset.Y = lerp(inertiaDelta,cachedDrawOffset.Y,drawOffset.Y);
            newOffset.Z = lerp(inertiaDelta,cachedDrawOffset.Z,drawOffset.Z);
        }
    
        cachedDrawOffset = newOffset;

        DrawOffset = newOffset;
        DrawOffset += (PawnOwner.EyeHeight * vect(0,0,1));

		WeaponBob = BobDamping * PawnOwner.WalkBob;
		WeaponBob.Z = (0.45 + 0.55 * BobDamping) * PawnOwner.WalkBob.Z;

		DrawOffset += WeaponBob;
	}
	return DrawOffset;
}

function HandleMultipleSkins(inventory item, int startcopies)
{
	local int i;

	if(DeusexPickup(item).bHasMultipleSkins)
	{
		while(startcopies < numcopies) //spool through
		{
			i = findnextposition();

			PickUplist[i] = DeusexPickup(item).textureSet;
			textureset = DeusexPickup(item).textureSet;
			SetSkin();
            SetIcon();
			startcopies++;
		}

	}
}

function UpdateSkinStatus()
{
	if(bHasMultipleSkins)
	{
		if(NumCopies > 0)
			updatecurrentskin();
	}
}

function SupportActor( actor StandingActor )
{
   if (!standingActor.IsA('RubberBullet')) //CyberP:
	StandingActor.SetBase( self );
}

function PostPostBeginPlay()
{
    Super.PostPostBeginPlay();
    
    //Generate a list of skins for this class.
    GenerateIcons();

    if (totalSkins > 1)
        bHasMultipleSkins = true;

    if (!bUnlit && ScaleGlow > 0.5)
        ScaleGlow = 0.5;
}

// ----------------------------------------------------------------------
// by dasraiser for GMDX, replace all ref to maxCopies with this :)
// SARGE: Changed to default.maxCopies so that everything is always consistent
// ----------------------------------------------------------------------
function int RetMaxCopies()
{
	return default.maxCopies;
}

// ----------------------------------------------------------------------
// SARGE: DisplayPickupMessage()
//
// If this has multiple copies, we need to display them in brackets
// ----------------------------------------------------------------------

function DisplayPickupMessage(DeusExPlayer player,Inventory item,int count)
{
    local string extra;
    if (count > 1)
        extra = " (" $ count $ ")";
    player.ClientMessage(Item.PickupMessage @ Item.itemArticle @ Item.itemName $ extra, 'Pickup');
}

// ----------------------------------------------------------------------
// HandlePickupQuery()
//
// If the bCanHaveMultipleCopies variable is set to True, then we want
// to stack items of this type in the player's inventory.
// ----------------------------------------------------------------------

function bool HandlePickupQuery( inventory Item )
{
	local DeusExPlayer player;
	local Inventory anItem;
	local Bool bAlreadyHas;
	local Bool bResult, bSound;
	local int i, startcopies, tempCharge;                                       //RSD: Added tempCharge

	if ( Item.Class == Class )
	{
		player = DeusExPlayer(Owner);
		bResult = False;
        bSound = true;

		// Check to see if the player already has one of these in
		// his inventory
		anItem = player.FindInventoryType(Item.Class);

		if ((anItem != None) && (bCanHaveMultipleCopies))
		{
			startcopies = NumCopies;
			// don't actually put it in the hand, just add it to the count

			NumCopies += DeusExPickup(item).NumCopies;

			if ((RetMaxCopies()> 0) && (NumCopies > RetMaxCopies()))
			{
				NumCopies = RetMaxCopies();
				if (item.IsA('ChargedPickup') && anItem.Charge < anItem.default.Charge)
                {
                    //SARGE: Let us know we're charging the thing...
                    if (player.bItemRechargeSound) //SARGE: Rosodude asked for this to be an option.
                        player.PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);
                    else
                        player.PlaySound(Item.PickupSound, SLOT_None,,, 256);
                    
                    bSound = false;
                    
                    anItem.Charge += DeusExPickup(item).Charge;
                    if (anItem.Charge >= anItem.default.Charge)
                        anItem.Charge = anItem.default.Charge;

                    if (anItem.Charge > 0)
                    {
                        ChargedPickup(anItem).bActivatable=true;             //RSD: Since now you can hold one at 0%
                        ChargedPickup(anItem).bDrained=false;                //SARGE: Since now you can keep it equipped while empty
                        ChargedPickup(anItem).unDimIcon();
                    }
                }
                else
                {
                    if (NumCopies > startCopies)    //CyberP: bugfix
                    {
                        UpdateBeltText();
                        DisplayPickupMessage(player,Item,NumCopies - StartCopies);
                        DeusExPickup(item).NumCopies -= (NumCopies - startcopies);
                        Item.PlaySound(Item.PickupSound);
                    }
                    else //SARGE: Now only display a message if we actually pickup none of the things.
                        player.ClientMessage(msgTooMany);

                    // abort the pickup
                    return True;
                }
			}
            else if (item.IsA('ChargedPickup'))                                 //RSD: New branch to fix ChargedPickup stacking //RSD: why was this not else before??
			{
				tempCharge = DeusExPickup(item).Charge + anItem.Charge;         //RSD: Add ChargedPickup item charge to current charge
				if (tempCharge > anItem.default.Charge)
		  			tempCharge -= anItem.default.Charge;                        //RSD: Add one to the stack and put the leftover charge on top
 			    else
                {
                    //SARGE: Let us know we're charging the thing...
                    if (player.bItemRechargeSound) //SARGE: Rosodude asked for this to be an option.
                        player.PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);
                    else
                        player.PlaySound(Item.PickupSound, SLOT_None,,, 256);
                    
                    bSound = false;
                    
 			    	NumCopies--;                                                //RSD: Keep the stack number the same as before but add the pickup charge
                }

 			    anItem.Charge = tempCharge;
 			    if (anItem.Charge > 0)
 			    {
                    ChargedPickup(anItem).bActivatable=true;                    //RSD: Since now you can hold one at 0%
					
					//SARGE: Only automatically un-drain if we're picking up the first one.
					//Feels strange otherwise...
					if (NumCopies == 1)
						ChargedPickup(anItem).bDrained=false;                       //SARGE: Since now you can keep it equipped while empty
                    ChargedPickup(anItem).unDimIcon();
                }
            }

			HandleMultipleSkins(item,startcopies);
			bResult = True;
		}

		if (bResult)
		{
            DisplayPickupMessage(player,Item,DeusExPickup(item).NumCopies);
            
            if (bSound)
                Item.PlaySound(Item.PickupSound);

			// Destroy me!
			// DEUS_EX AMSD In multiplayer, we don't want to destroy the item, we want it to set to respawn
			if (Level.NetMode != NM_Standalone)
				Item.SetRespawn();
			else
				Item.Destroy();
		}
		else
		{
			bResult = Super.HandlePickupQuery(Item);
		}

		// Update object belt text
		if (bResult)
			UpdateBeltText();

		return bResult;
	}

	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

// ----------------------------------------------------------------------
// UseOnce()
//
// Subtract a use, then destroy if out of uses
// ----------------------------------------------------------------------

function UseOnce()
{
	local DeusExPlayer player;

	player = DeusExPlayer(GetPlayerPawn());                                     //RSD: Now GetPlayerPawn() instead of Owner so we still have hunger accounting
	/*if (Owner == None)                                                        //RSD: removing this check to enable generic LeftClick interact
	    return;*/
	NumCopies--;
	UpdateSkinStatus();

	if (!IsA('SkilledTool') && IsInState('Activated'))
		GotoState('DeActivated');

	if (NumCopies <= 0)
	{
		if (player.inHand == Self)
			player.PutInHand(None);
		DestroyMe();
	}
	else
	{
		UpdateBeltText();
	}
}

event Bump( Actor Other )
{
local float speed2, mult;
local DeusExPlayer player;

if (Physics == PHYS_None)
return;

player = DeusExPlayer(GetPlayerPawn());

mult = player.AugmentationSystem.GetAugLevelValue(class'AugMuscle');
if (mult == -1.0)
mult = 1.0;

speed2 = VSize(Velocity);

if (speed2 > 900 && !IsA('Flare'))
  if (Other.IsA('Pawn') || Other.IsA('DeusExDecoration') || Other.IsA('DeusExPickup'))
    Other.TakeDamage((1+Mass*0.1)*(mult*0.75),player,Other.Location,0.5*Velocity,'KnockedOut');
}

// ----------------------------------------------------------------------
// UpdateBeltText()
// ----------------------------------------------------------------------

function UpdateBeltText()
{
	local DeusExRootWindow root;

	if (DeusExPlayer(Owner) != None)
	{
		root = DeusExRootWindow(DeusExPlayer(Owner).rootWindow);

		// Update object belt text
		if ((bInObjectBelt) && (root != None) && (root.hud != None) && (root.hud.belt != None))
			root.hud.belt.UpdateObjectText(beltPos);
	}
}

// ----------------------------------------------------------------------
// BreakItSmashIt()
// ----------------------------------------------------------------------

simulated function BreakItSmashIt(class<fragment> FragType, float size)
{
	local int i;
	local DeusExFragment s;
	local DeusExPlayer player;   //CyberP: for screenflash if near extinguisher
    local float dist;            //CyberP: for screenflash if near extinguisher
    local Vector loc;             //CyberP: for extinguisher explode
    local Vector HitLocation, HitNormal, EndTrace;
	local Actor hit;
	local WaterPool pool;
	local SFXExp sr;
	local HalonGasLarge hgl;

    player = DeusExPlayer(GetPlayerPawn());

    if ((!Region.Zone.bWaterZone) && (IsA('Sodacan') || IsA('WineBottle') || IsA('Liquor40oz') || IsA('LiquorBottle')))
	{
		EndTrace = Location - vect(0,0,20);
		hit = Trace(HitLocation, HitNormal, EndTrace, Location, False);
		pool = spawn(class'WaterPool',,, HitLocation+HitNormal, Rotator(HitNormal));
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        spawn(class'WaterSplash');
        PlaySound(sound'SplashSmall', SLOT_None,3.0,, 1280);
        if (pool != None)
        {
			pool.SetMaxDrawScale(CollisionRadius / 16.0);
            pool.spreadTime = 0.5;
        }
	}

	for (i=0; i<Int(size)+8; i++)
	{
		s = DeusExFragment(Spawn(FragType, Owner));

		if (s != None)
		{
			s.Instigator = Instigator;
			s.CalcVelocity(Velocity,0);
			s.DrawScale = ((FRand() * 0.025) + 0.025) * size; //CyberP: both 0.5
			s.Skin = GetMeshTexture();
		if (IsA('FireExtinguisher') && !Region.Zone.bWaterZone)
		{
			loc = Location;
			loc.X += FRand() * 8;
			loc.Y += FRand() * 8;
			loc.Z += FRand() * 4;
			if (i==0)
            {
            PlaySound(sound'SmallExplosion2', SLOT_None,2.0,, 2048);
            AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 640);
			//SARGE: Increase radius and damage based on Firefighter perk
			if (player != None && player.PerkManager.GetPerkWithClass(class'DeusEx.PerkFirefighter').bPerkObtained)
            {
                //Do in a few bursts so that it doesn't affect movers
				HurtRadius(40,420,'KnockedOut',2000,Location);
				HurtRadius(40,420,'KnockedOut',2000,Location);
				HurtRadius(40,420,'KnockedOut',2000,Location);
				HurtRadius(40,420,'KnockedOut',2000,Location);
            }
			else
				HurtRadius(15,320,'KnockedOut',2000,Location);
            hgl = spawn(class'HalonGasLarge');
            if (hgl != None)
            {
               hgl.ScaleGlow = 0.00001;
               hgl.LifeSpan = 1.5;
               hgl.DrawScale += 2.0;
            }
            if (player!=none)
            {
   		        dist = Abs(VSize(player.Location - Location));
                if (dist < 128)
                player.ClientFlash(8, vect(224,224,192));
   		        if (dist < 1024)
                player.ClientFlash(1, vect(128,128,112));
            }
			}
            if (i < 4)
            {
                sr = spawn(class'SFXExp', None,, loc);
                if (sr != None)
                    sr.scaleFactor = 10.0;
            }
            //else if (i > 4)
            //    HurtRadius(1,256,'HalonGas',2000,Location);
            if (class'DeusExPlayer'.default.iPersistentDebris < 2)
                s.LifeSpan += 20.0;
		}
			if ((IsA('WineBottle') || IsA('Liquor40oz') || IsA('LiquorBottle')) && (!Region.Zone.bWaterZone))
			{
			spawn(class'WaterSplash2');
			spawn(class'WaterSplash');
            spawn(class'WaterSplash2');
			spawn(class'WaterSplash');
			if (i==1)
			    AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 640);
            }
            // play a good breaking sound for the first fragment
            if (i == 0 && !IsA('Candybar') && !IsA('SoyFood') && !IsA('Sodacan') && !IsA('Cigarettes') && !IsA('FireExtinguisher'))
				s.PlaySound(sound'GlassBreakSmall', SLOT_None,,, 768);
		}
	}

	DestroyMe();
}

singular function BaseChange()
{
	Super.BaseChange();

	// Make sure we fall if we don't have a base
	if ((base == None) && (Owner == None))
		{
        SetPhysics(PHYS_Falling);
        }
}

// ----------------------------------------------------------------------
// state Pickup
// ----------------------------------------------------------------------

auto state Pickup
{

    function HitWall(vector HitNormal, actor Wall)
	{
		if (VSize(Velocity) > 1200 && bBreakable)
			    TakeDamage((25+Mass),Pawn(Owner),Location,0.5*Velocity,'Shot');
        else if (bBreakable && !IsA('FireExtinguisher') && !IsA('Binoculars') && !IsA('SoyFood') && !IsA('Candybar') && !IsA('Sodacan') && !IsA('Cigarettes'))
			if (VSize(Velocity) > 350 && !IsA('SoftwareStop') && !IsA('SoftwareNuke'))
				BreakItSmashIt(fragType, (CollisionRadius + CollisionHeight) / 2);
	}
	// if we hit the ground fast enough, break it, smash it!!!
	function Landed(Vector HitNormal)
	{
	local Rotator rot;

		Super.Landed(HitNormal);

        if (VSize(Velocity) > 1200 && bBreakable)
			    TakeDamage((25+Mass),Pawn(Owner),Location,0.5*Velocity,'Shot');
        else if (bBreakable && !IsA('FireExtinguisher') && !IsA('Binoculars') && !IsA('SoyFood') && !IsA('Candybar') && !IsA('Sodacan') && !IsA('Cigarettes'))
			if (VSize(Velocity) > 400 && !IsA('SoftwareStop') && !IsA('SoftwareNuke'))
				BreakItSmashIt(fragType, (CollisionRadius + CollisionHeight) / 2);

		bFixedRotationDir = False;
	    rot = Rotation;
        rot.Pitch = 0;
	    rot.Roll = 0;
	    SetRotation(rot);
	}

	function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
        local float dammult, massmult;

		if ((DamageType == 'TearGas') || (DamageType == 'PoisonGas') || (DamageType == 'Radiation'))
			return;

		if ((DamageType == 'EMP') || (DamageType == 'NanoVirus') || (DamageType == 'Shocked'))
			return;

		if (DamageType == 'HalonGas' || IsA('Nanokey'))
			return;

        //if (IsA('VialCrack') || IsA('VialAmbrosia'))
        //{
        //PlaySound(sound'GlassBreakSmall', SLOT_None,,, 768);
        //DestroyMe();
        //}
    if (Owner == None && !bSimplePhysics)
    {
    if (bBreakable == False || (IsA('SodaCan') && Damage < 20 && FRand() > 0.1) || (IsA('FireExtinguisher') && Damage < 3)) //RSD: Added fire extinguisher damage threshold
    {
    dammult = damage*0.1;
    if (dammult < 1.1)
    dammult = 1.1;
    else if (dammult > 2.5)                                                     //RSD: Was 15
    dammult = 2.5;  //capped so objects do not fly about at light speed.        //RSD: Was 15

    if (mass < 10)
    massmult = 1.2;
    else if (mass < 20)
    massmult = 1.1;
    else if (mass < 30)
    massmult = 1;
    else if (mass < 50)
    massmult = 0.7;
    else if (mass < 80)
    massmult = 0.4;
    else
    massmult = 0.2;

    SetPhysics(PHYS_Falling);
    Velocity = (Momentum*0.25)*dammult*massmult;
    if (VSize(Momentum) > 1000)                                                 //RSD: Damp out super high momentum
      Velocity *= 1000/VSize(Momentum);
    if (Velocity.Z < 0)
    Velocity.Z = 120;
    bFixedRotationDir = True;
	RotationRate.Pitch = (32768 - Rand(65536)) * 4.0;
	RotationRate.Yaw = (32768 - Rand(65536)) * 4.0;
    }
    else
    {
   	   BreakItSmashIt(fragType, (CollisionRadius + CollisionHeight) / 2);
    }
    }
    }

	function Frob(Actor Other, Inventory frobWith)
	{
        local DeusExPickup copy;
		pickuplist[0] = textureset;    //doublecheck

        //SARGE: Fix picking up more than the max amount if empty
        //This is a hack because I'm too lazy to do it properly
        if (numCopies > RetMaxCopies())
            numCopies = RetMaxCopies();

        bDontRemoveOnMissionComplete = false;
        
        //SARGE: Last minute skin check.
        SetSkin();
        SetIcon();

        super.Frob(other, frobwith);
	}
}

//SARGE: OnActivate() and OnDeactivate() are called when we successfully enter each state.
//Used by child objects to define custom activation/deactivation behaviour
function OnActivate(DeusExPlayer player)
{
}
function OnDeActivate(DeusExPlayer player)
{
}

state Activated
{
	function Activate()
	{
		Super.Activate();
	}

	function BeginState()
	{
		local DeusExPlayer player;

		Super.BeginState();

		player = DeusExPlayer(Owner);
        if (player != None)
            OnActivate(player);
	}
Begin:
}

// ----------------------------------------------------------------------
// state DeActivated
// ----------------------------------------------------------------------

state DeActivated
{
	function BeginState()
	{
		local DeusExPlayer player;

		Super.BeginState();

		player = DeusExPlayer(Owner);
		if (player != None)
            OnDeActivate(player);
	}
}


// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local string str;
    local DeusExPlayer player;

    player = DeusExPlayer(Owner);

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None || player == None)
		return False;

    //Set title
	winInfo.SetTitle(GetTitle(player));

    if (player != None)
		winInfo.AddDeclineButton(class);

    if (player != None && CanAssignSecondary(player))
		winInfo.AddSecondaryButton(self);

	winInfo.SetText(GetDescription(player));
		
    winInfo.AppendText(winInfo.CR());

	winInfo.SetText(GetDescription2(player));

	return True;
}

// ----------------------------------------------------------------------
// AddLine()
// Adds a newlineline if we already have some text, otherwise adds nothing and returns the original
// ----------------------------------------------------------------------
function string AddLine(string str, string newStr)
{
    if (str != "")
        return str $ "|n" $ newStr;
    else
        return newStr;
}

// ----------------------------------------------------------------------
// CanAssignSecondary()
// ----------------------------------------------------------------------

//SARGE: Now each object can define it's own function for whether it can be a secondary or not.
function bool CanAssignSecondary(DeusExPlayer player)
{
    return false;
}

// ----------------------------------------------------------------------
// Get Description
// ----------------------------------------------------------------------

//SARGE: Now each object can define it's own title, description etc.
function string GetTitle(DeusExPlayer player)
{
    return itemName;
}

function string GetDescription(DeusExPlayer player)
{
    return Description;
}

//Added after a double line spacing on the Description panel.
//Usually used for stats and other things.
function string GetDescription2(DeusExPlayer player)
{
    local string str;

	if (bCanHaveMultipleCopies )//&& MaxCopies > 1)
		//return CountLabel @ String(NumCopies);
        str = AddLine(str,sprintf(StackSizeLabel,NumCopies,RetMaxCopies()));

    return str;
}

// ----------------------------------------------------------------------
// PlayLandingSound()
// ----------------------------------------------------------------------

function PlayLandingSound()
{
	if (LandSound != None)
	{
		if (Velocity.Z <= -170)
		{
			PlaySound(LandSound, SLOT_None, TransientSoundVolume,, 768);
			if (IsA('Flare') || IsA('Liquor40oz') || IsA('WineBottle') || IsA('LiquorBottle'))
			    AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 416+(Mass*2)); //CyberP: mass factors into radi
			else
			    AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 320+(Mass*2)); //CyberP: mass factors into radi
		}
	}
}


//function prebeginplay()
//{
//	local int i;
//	//initialise our list
//	if(bhasMultipleSkins)
//	{
//		pickupList[0] = textureset;
//		for(i=1;i<arraycount(pickuplist);i++)
//		{
//			pickuplist[i] = -1;
//		}
//
//	}
//
//
//	super.prebeginplay();
//}


//function AddtoPickupList(deusexpickup item, int startnum)
//{
//	local int i;
//
//	for(i=startnum;i<numcopies;i++)
//	{
//		pickupList[i] = item.Textureset;
//	}
//	textureset = pickupList[i];
//	//dumptexturelist();
//	SetSkin();
//  SetIcon();
//}

function UpdateCurrentSkin()
{
	textureset = pickuplist[numcopies-1];
	pickuplist[numcopies] = -1;
	SetSkin();
    SetIcon();
}

function int findNextPosition()
{
	local int i;

	for(i=0;i<arraycount(pickuplist);i++)
	{
		if(pickuplist[i] == -1)
			return i;
	}
	log("failed to find valid postion");
	return 0;
}


function dumptexturelist() //testing function coz I is teh STOOPID today. Or something. I blame stress :)   -DDL
{
	local int i;

	log("dumping list!",name);
	for(i=0;i<arraycount(pickuplist);i++)
	{
		if(pickuplist[i] != -1)
			log("My pickuplist"@i@"setting is"@pickuplist[i],name);
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
    UpdateHDTPSettings();                                                       //SARGE: Update HDTP
}

//If skinned icons are turned off, always use the default.
function private SetIcon()
{
    //Ugh. Hardcoded to get the default skin if we pass in index 0.
    //This isn't great but I can't think of a better way to do this...
    if (textureSet >= 0 && class'DeusExPlayer'.default.bSkinnedBeltIcons && textureSet < totalSkins)
    {
        Icon = GetIcon(textureSet).Icon;
        LargeIcon = GetIcon(textureSet).LargeIcon;
    }
    else
    {
        Icon = default.Icon;
        LargeIcon = default.LargeIcon;
    }
}

//Automatically generates icons for this object based on
//some predefined textures.
function GenerateIcons()
{
    local int i;
    local Texture T,T2;

    //Use the default for the first skin
    Icons[0].icon = default.Icon;
    Icons[0].largeIcon = default.LargeIcon;

    for (i = 1;i < totalSkins;i++)
    {
        //Log("RSDCrap.Icons.BeltIcon"$string(self.Class.Name)$"Tex"$(i+1));
        T = Texture(DynamicLoadObject("RSDCrap.Icons.BeltIcon"$string(self.Class.Name)$"Tex"$(i+1),class'Texture',false));
        T2 = Texture(DynamicLoadObject("RSDCrap.Icons.LargeIcon"$string(self.Class.Name)$"Tex"$(i+1),class'Texture',false));

        if (T == None)
            T = default.Icon;

        if (T2 == None)
            T2 = default.LargeIcon;

        Icons[i].icon = T;
        Icons[i].largeIcon = T2;
    }
}

function IconInfo GetIcon(int skinIndex)
{
    if (skinIndex > totalSkins || skinIndex >= 10)
        return Icons[0];

    return Icons[skinIndex];
}

//New function to set the belt and inventory icon for a given pickup.
function SetSkin()
{
//	if(bHasMultipleSkins)
//		dumptexturelist();
}

//SARGE: Destroys the object, and makes sure if it's in our belt, it becomes a placeholder
//I hate having to do this here, but I can't think of anywhere else to do it that doesn't suck equally as hard
//or works in a generic way.
function DestroyMe()
{
	local DeusExPlayer player;
	player = DeusExPlayer(GetPlayerPawn());

    if (owner != None && owner.IsA('DeusExPlayer') && DeusExPlayer(owner).iShifterWeaponSwitch > 2 && bInObjectBelt)
        DeusExPlayer(owner).ShifterSwitchAll(self,DeusExPlayer(owner).iShifterWeaponSwitch >= 4);

    player.RemoveObjectFromBelt(self);

    Destroy();
}

//SARGE: Called when the item is added to the players hands
function Draw(DeusExPlayer frobber)
{
    cachedDrawOffset = Vect(0,0,0);
    SetWeaponHandTex();
}

//SARGE: Set up the Shenanigans gameplay modifier for this entity
function Shenanigans(bool bEnabled)
{
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     PickUpList(0)=-1
     PickUpList(1)=-1
     PickUpList(2)=-1
     PickUpList(3)=-1
     PickUpList(4)=-1
     PickUpList(5)=-1
     PickUpList(6)=-1
     PickUpList(7)=-1
     PickUpList(8)=-1
     PickUpList(9)=-1
     PickUpList(10)=-1
     PickUpList(11)=-1
     PickUpList(12)=-1
     PickUpList(13)=-1
     PickUpList(14)=-1
     PickUpList(15)=-1
     PickUpList(16)=-1
     PickUpList(17)=-1
     PickUpList(18)=-1
     PickUpList(19)=-1
     PickUpList(20)=-1
     PickUpList(21)=-1
     PickUpList(22)=-1
     PickUpList(23)=-1
     PickUpList(24)=-1
     PickUpList(25)=-1
     PickUpList(26)=-1
     PickUpList(27)=-1
     PickUpList(28)=-1
     PickUpList(29)=-1
     PickUpList(30)=-1
     PickUpList(31)=-1
     PickUpList(32)=-1
     PickUpList(33)=-1
     PickUpList(34)=-1
     PickUpList(35)=-1
     PickUpList(36)=-1
     PickUpList(37)=-1
     PickUpList(38)=-1
     PickUpList(39)=-1
     PickUpList(40)=-1
     PickUpList(41)=-1
     PickUpList(42)=-1
     PickUpList(43)=-1
     PickUpList(44)=-1
     PickUpList(45)=-1
     PickUpList(46)=-1
     PickUpList(47)=-1
     PickUpList(48)=-1
     PickUpList(49)=-1
     FragType=Class'DeusEx.GlassFragment'
     CountLabel="x"
     msgTooMany="You can't carry any more of those"
     StackSizeLabel="Amount Held: %d/%d"
     NumCopies=1
     PickupMessage="You found"
     ItemName="DEFAULT PICKUP NAME - REPORT THIS AS A BUG"
     RespawnTime=30.000000
     LandSound=Sound'DeusExSounds.Generic.PaperHit1'
     bProjTarget=True
     iHDTPModelToggle=1
     //SARGE: Suppress the default Activation and Deactivation messages, we will handle them ourselves
     M_Activated=""
     M_Deactivated=""
     bVisionImportant=true
     inertiaSpeed=0
     bUseFOV=false
}
