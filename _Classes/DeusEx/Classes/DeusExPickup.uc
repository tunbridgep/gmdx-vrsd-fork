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
var travel bool bIsCloaked;
var texture NormalPlayerViewSkins[10];
var texture CamoPlayerViewSkins[10];
var() bool bSimplePhysics;
var travel bool bIsRadar;                                                       //RSD: for splitting cloak/radar texture functionality
var bool bJustUncloaked;                                                        //RSD: for splitting cloak/radar texture functionality
var bool bJustUnRadar;                                                          //RSD: for splitting cloak/radar texture functionality
var bool bAutoActivate;                                                         //Sarge: Auto activate with left click, rather than placing in the players hands                                                                                
var Texture handsTex;   //SARGE: Store the hand texture for performance. TODO: Use some sort of class/object to share this between SkilledTools and Weapons

//SARGE: HDTP Model toggles
var config int iHDTPModelToggle;
var string HDTPSkin;
var string HDTPTexture;
var string HDTPMesh;

//SARGE: Added "Left Click Frob" and "Right Click Frob" support
//Return true to use the default frobbing mechanism (right click), or false for custom behaviour
function bool DoLeftFrob(DeusExPlayer frobber)
{
    if (bAutoActivate)
    {
        GotoState('Activated');
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

function bool IsHDTP()
{
    return DeusExPlayer(GetPlayerPawn()) != None && DeusExPlayer(GetPlayerPawn()).bHDTPInstalled && iHDTPModelToggle > 0;
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
}

//Shorthand for accessing hands tex
function SetWeaponHandTex()
{
	local deusexplayer p;
	p = deusexplayer(owner);
	if(p != none)
        handsTex = p.GetWeaponHandTex();
    p.clientMessage("handsTex: " $ handsTex);
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

//GMDX cloak weapon
/*function SetCloak(bool bEnableCloak,optional bool bForce)                     Overhauled cloak/radar routines
{
	if ((Owner==none)||(!Owner.IsA('DeusExPlayer'))) return;
	if (Owner!=none && Owner.IsA('DeusExPlayer'))
	{
	if (bEnableCloak && class'DeusExPlayer'.default.bRadarTran == True &&(!bIsCloaked||bForce))
	{
 	  ShowCamo();
	  bIsCloaked=true;
	  AmbientGlow=255;
      Style=STY_Normal;//STY_Translucent;                                       //RSD: Going for a solid texture here
	  ScaleGlow=1.000000;
	}
    else if (bEnableCloak&&(!bIsCloaked||bForce))
	{
	  bIsCloaked=true;
	  ShowCamo();
      Style=STY_Translucent;
	  ScaleGlow=0.500000;
	  //AmbientGlow=255;
	} else
	if(!bEnableCloak&&(bIsCloaked||bForce))
	{
	  class'DeusExPlayer'.default.bRadarTran=false;
	  AmbientGlow=default.AmbientGlow;
	  Style=default.Style;
	  ScaleGlow=default.ScaleGlow;
	  if (bIsCloaked)
	     HideCamo();
	  bIsCloaked=false;
	}
    }
}*/

//SARGE: TODO: Move this (and the version from DeusExWeapon) to a new object, and share it between SkilledTools and Weapons
function SetCloakRadar(bool bEnableCloak, bool bEnableRadar, optional bool bForce) //RSD: Overhauled cloak/radar routines
{
	local bool bCheckCloak, bCheckRadar;

    if ((Owner==none)||(!Owner.IsA('DeusExPlayer'))) return;
	if (Owner!=none && Owner.IsA('DeusExPlayer'))
	{
	//DeusExPlayer(Owner).BroadcastMessage("Owner");
	//DeusExPlayer(Owner).BroadcastMessage(bIsRadar);
	if(!bEnableCloak&&(bIsCloaked||bForce))
	{
 	  //if (ScaleGlow==10.500001)                                               //RSD: Bad implementation and also no longer needed
      //   Style=default.Style;

	  bJustUncloaked = True;
	  if (bIsCloaked)
	     HideCamo();
	  bIsCloaked=false;
	  bCheckRadar=true;
	  //DeusExPlayer(Owner).BroadcastMessage("Cloak Off");
	}
	if (!bEnableRadar&&(bIsRadar||bForce))
	{
 	  //if (ScaleGlow==10.500001)                                               //RSD: Bad implementation and also no longer needed
      //    Style=default.Style;

	  bJustUnradar = True;
	  if (bIsRadar)
	     HideCamo();
	  bIsRadar=false;
	  bCheckCloak=true;
	  //DeusExPlayer(Owner).BroadcastMessage("Radar Off");
	}
	if (bEnableRadar &&(!bIsRadar||bForce||bCheckRadar))
	{
	  //AmbientGlow=255;                                                        //RSD: Removed ambient glow for proper stacking effect
	  bIsRadar=true;
 	  ShowCamo();
 	  //DeusExPlayer(Owner).BroadcastMessage("Radar On");
	}
    if (bEnableCloak&&(!bIsCloaked||bForce||bCheckCloak))
	{
	  //AmbientGlow=255;
	  bIsCloaked=true;
	  ShowCamo();
	  //DeusExPlayer(Owner).BroadcastMessage("Cloak On");
	}
    }
}

function ShowCamo()
{
	local int     i;
	local texture curSkin;

		for (i=0; i<8; i++)
			NormalPlayerViewSkins[i] = MultiSkins[i];

		NormalPlayerViewSkins[8] = Skin;
		NormalPlayerViewSkins[9] = Texture;

		for (i=0; i<8; i++)
		{
			curSkin = GetMeshTexture(i);
			CamoPlayerViewSkins[i] = GetGridTexture(curSkin);
		}

		CamoPlayerViewSkins[8] = GetGridTexture(NormalPlayerViewSkins[8]);
		CamoPlayerViewSkins[9] = GetGridTexture(NormalPlayerViewSkins[9]);

		for (i=0; i<8; i++)
			MultiSkins[i] = CamoPlayerViewSkins[i];

        //RSD: Overhauled cloak/radar routines
        if (bIsCloaked && !bIsRadar)
        {
		    Skin = FireTexture'GameEffects.InvisibleTex';
		    Texture = FireTexture'GameEffects.InvisibleTex';
		    Style = STY_Translucent;
		    ScaleGlow=0.500000;                                                 //RSD: If only cloak on, use cloak ScaleGlow
        }
        else if (bIsRadar && !bIsCloaked)
        {
            Skin = Texture'Effects.Electricity.Xplsn_EMPG';
		    Texture = Texture'Effects.Electricity.Xplsn_EMPG';
		    Style = STY_Normal;                                                 //RSD: Going for a solid texture here
		    ScaleGlow=10.500001;                                                //RSD: If only radar on, use radar ScaleGlow
        }
        else
        {
            Skin = Texture'Effects.Electricity.Xplsn_EMPG';
		    Texture = Texture'Effects.Electricity.Xplsn_EMPG';
		    Style = STY_Translucent;                                            //RSD: But translucent if we have cloak + radar
		    ScaleGlow=default.ScaleGlow;                                        //RSD: If both are on, default to cloak ScaleGlow
        }
		//Style = STY_Translucent;
}

function HideCamo()
{
	local int i;
    local bool bSetFailure;

		for (i=0; i<8; i++)
			MultiSkins[i] = NormalPlayerViewSkins[i];

		Skin = NormalPlayerViewSkins[8];
		Texture = NormalPlayerViewSkins[9];

        //CyberP: failsafe                                                      //RSD: Taken from DeusExWeapon.uc
		for (i=0; i<8; i++)
		{
			if (MultiSkins[i] == Texture'Effects.Electricity.Xplsn_EMPG' || MultiSkins[i] == FireTexture'GameEffects.InvisibleTex')
			{
			  bSetFailure = True;
			  break;
			}
		}
		if (bSetFailure)
		{
		   for (i=0; i<8; i++)
			MultiSkins[i] = default.MultiSkins[i];
			Skin = default.Skin;
		    Texture = default.Texture;
		}

		//RSD: Overhauled cloak/radar routines:
		if (bJustUnradar && bIsCloaked)
		{
			Style=STY_Translucent;
			ScaleGlow=0.500000;                                                 //RSD: If only cloak on, use cloak ScaleGlow
		}
		else if (bJustUncloaked && bIsRadar)
		{
		    Style=STY_Normal;
		    ScaleGlow=10.500001;                                                //RSD: If only radar on, use radar ScaleGlow
        }
        else                                                                    //RSD: Note that Style normal is reset a bit after decloaking (and no radar) in Tick()
            ScaleGlow=default.ScaleGlow;                                        //RSD: If neither on, use default ScaleGlow (otherwise too bright after radar)
}

function Texture GetGridTexture(Texture tex)
{
	if (tex == None)
		return Texture'BlackMaskTex';
	else if (tex == Texture'BlackMaskTex')
		return Texture'BlackMaskTex';
	else if (tex == Texture'GrayMaskTex')
		return Texture'BlackMaskTex';
	else if (tex == Texture'PinkMaskTex')
		return Texture'BlackMaskTex';
	else if (class'DeusExPlayer'.default.bRadarTran==True)
        return Texture'Effects.Electricity.Xplsn_EMPG';
	else
		return FireTexture'GameEffects.InvisibleTex';
}

function DropFrom(vector StartLocation)
{
    if (bIsCloaked || bIsRadar)                                                 //RSD: Overhauled cloak/radar routines
	 SetCloakRadar(false,false,true);//SetCloak(false,true);
    ScaleGlow = default.ScaleGlow;                                              //RSD: Also reset ScaleGlow so we don't get dim/bright due to cloak/radar
    UpdateHDTPsettings();
	super.DropFrom(StartLocation);
}

simulated function Tick(float deltaTime)                                        //RSD: Relevant portion taken from DeusExWeapon.uc for overhauled cloak/radar routines
{
		if (bJustUncloaked && !bIsCloaked)
		{
		   ScaleGlow+=DeltaTime;
		   if (ScaleGlow >= default.ScaleGlow)
		   {
		       if (bIsRadar)                                                    //RSD: Need this so we still get gradual uncloaking but don't mess up ScaleGlow when Radar+Cloak-Cloak
		           ScaleGlow = 10.500001;
		       else
                   ScaleGlow = default.ScaleGlow;
		       bJustUncloaked = False;
		       Style = default.Style;
		       AmbientGlow=default.AmbientGlow;
		   }
		}
}

//=============================================================================
// Weapon rendering
// Draw first person view of inventory
simulated event RenderOverlays( canvas Canvas )
{
	/*if (class'DeusExPlayer'.default.bCloakEnabled&&!bIsCloaked)
	{
		SetCloak(true);
	} else
	if (!class'DeusExPlayer'.default.bCloakEnabled&&bIsCloaked)
	{
		SetCloak(false);
	}*/
	//RSD: Overhauled cloak/radar routines
	SetCloakRadar(class'DeusExPlayer'.default.bCloakEnabled,class'DeusExPlayer'.default.bRadarTran);
	super.RenderOverlays(Canvas);
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

    if (!bUnlit && ScaleGlow > 0.5)
        ScaleGlow = 0.5;
}

// ----------------------------------------------------------------------
// by dasraiser for GMDX, replace all ref to maxCopies with this :)
// ----------------------------------------------------------------------
function int RetMaxCopies()
{
	return maxCopies;
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
	local Bool bResult;
	local int i, startcopies, tempCharge;                                       //RSD: Added tempCharge

	if ( Item.Class == Class )
	{
		player = DeusExPlayer(Owner);
		bResult = False;

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
				if (item.IsA('ChargedPickup'))
                {
                   if (anItem.Charge < anItem.default.Charge)
                   {
                       anItem.Charge += DeusExPickup(item).Charge;
                       if (anItem.Charge >= anItem.default.Charge)
                           anItem.Charge = anItem.default.Charge;
                       item.Destroy();

                       if (anItem.Charge > 0)
                       {
                           ChargedPickup(anItem).bActivatable=true;             //RSD: Since now you can hold one at 0%
                           ChargedPickup(anItem).unDimIcon();
                       }
                       return true;
                   }
                }
				player.ClientMessage(msgTooMany);
				if (NumCopies > startCopies)    //CyberP: bugfix
				{
				    UpdateBeltText();
				    player.ClientMessage(Item.PickupMessage @ Item.itemArticle @ Item.itemName, 'Pickup');
                    DeusExPickup(item).NumCopies -= (NumCopies - startcopies);
                }
				// abort the pickup
				return True;
			}
            else if (item.IsA('ChargedPickup'))                                 //RSD: New branch to fix ChargedPickup stacking //RSD: why was this not else before??
			{
				tempCharge = DeusExPickup(item).Charge + anItem.Charge;         //RSD: Add ChargedPickup item charge to current charge
				if (tempCharge > anItem.default.Charge)
		  			tempCharge -= anItem.default.Charge;                        //RSD: Add one to the stack and put the leftover charge on top
 			    else
 			    	NumCopies--;                                                //RSD: Keep the stack number the same as before but add the pickup charge

 			    anItem.Charge = tempCharge;
 			    if (anItem.Charge > 0)
 			    {
                    ChargedPickup(anItem).bActivatable=true;                    //RSD: Since now you can hold one at 0%
                    ChargedPickup(anItem).unDimIcon();
                }
            }

			HandleMultipleSkins(item,startcopies);
			bResult = True;
		}

		if (bResult)
		{
			player.ClientMessage(Item.PickupMessage @ Item.itemArticle @ Item.itemName, 'Pickup');

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

	if (!IsA('SkilledTool'))
		GotoState('DeActivated');

	if (NumCopies <= 0)
	{
		if (player.inHand == Self)
			player.PutInHand(None);
		if (player.assignedWeapon == Self)                                      //RSD: Reset our assigned weapon
			player.assignedWeapon = None;
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
			pool.maxDrawScale = CollisionRadius / 16.0;
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
		pickuplist[0] = textureset;    //doublecheck

		super.Frob(other, frobwith);
	}
}

state DeActivated
{
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local string str;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.SetTitle(itemName);
	if (IsA('Binoculars')|| IsA('Flare'))                                       //RSD: Assign Binoculars and Flares as a secondary item
		winInfo.AddSecondaryButton(self);

    if (IsA('RSDEdible'))                                                       //Sarge: Allow edibles as secondaries (mainly used for drugs)
		winInfo.AddSecondaryButton(self);

	winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());

	if (bCanHaveMultipleCopies)
	{
		// Print the number of copies
		str = CountLabel @ String(NumCopies);
		winInfo.AppendText(str);
	}

	return True;
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
//}

function UpdateCurrentSkin()
{
	textureset = pickuplist[numcopies-1];
	pickuplist[numcopies] = -1;
	SetSkin();
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

    player.MakeBeltObjectPlaceholder(self);
    Destroy();
}

//SARGE: Called when the item is added to the players hands
function Draw(DeusExPlayer frobber)
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
     NumCopies=1
     PickupMessage="You found"
     ItemName="DEFAULT PICKUP NAME - REPORT THIS AS A BUG"
     RespawnTime=30.000000
     LandSound=Sound'DeusExSounds.Generic.PaperHit1'
     bProjTarget=True
     iHDTPModelToggle=1
}
