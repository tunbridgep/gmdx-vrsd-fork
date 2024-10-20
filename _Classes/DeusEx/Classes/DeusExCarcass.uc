//=============================================================================
// DeusExCarcass.
//=============================================================================
class DeusExCarcass extends Carcass;

struct InventoryItemCarcass  {
	var() class<Inventory> Inventory;
	var() int              count;
};

var(Display) mesh Mesh2;		// mesh for secondary carcass
var(Display) mesh Mesh3;		// mesh for floating carcass
var(Inventory) InventoryItemCarcass InitialInventory[8];  // Initial inventory items held in the carcass
var() bool bHighlight;

var String			KillerBindName;		// what was the bind name of whoever killed me?
var Name			KillerAlliance;		// what alliance killed me?
var bool			bGenerateFlies;		// should we make flies?
var FlyGenerator	flyGen;
var Name			Alliance;			// this body's alliance
var Name			CarcassName;		// original name of carcass
var int			    MaxDamage;			// maximum amount of cumulative damage
var bool			bNotDead;			// this body is just unconscious
var() bool			bEmitCarcass;		// make other NPCs aware of this body
var bool		    bQueuedDestroy;	// For multiplayer, semaphore so you can't doublefrob bodies (since destroy is latent)

var bool			bInit;

// Used for Received Items window
var bool bSearchMsgPrinted;

var localized string msgSearching;
var localized string msgEmpty;
var localized string msgNotDead;
var localized string msgAnimalCarcass;
var localized string msgCannotPickup;
var localized String msgRecharged;
var localized string itemName;			// human readable name

var() bool bInvincible;
var bool bAnimalCarcass;

var bool bUsingHDTP;
var string HDTPMeshName, HDTPMesh2Name, HDTPMesh3Name;
var string HDTPMeshTex[8];

//GMDX:
var transient bool bDblClickStart;
var transient bool bDblClickFrob;
var transient float DblClickTimeout;
var bool            bPop;
var bool            bNotFirstFall;
var int             passedImpaleCount;
var bool            passedSkins;

//RSD
var int PickupAmmoCount;                                                        //RSD: Ammo count on loot. Initialized in MissionScript.uc on first map load (possibly passed through ScriptedPawn.uc)
var string savedName;                                                           //RSD: So we can use it again if we kill an unconscious corpse
var globalconfig bool bRandomModFix;                                            //RSD: Stupid config-level hack since PostBeginPlay() can't access player pawn

//Sarge: LDDP Stuff
var(GMDX) const bool requiresLDDP;                                              //Delete this character LDD is uninstalled
var(GMDX) const bool LDDPExtra;                                                 //Delete this character we don't have the "Extra LDDP Characters" playthrough modifier
var(GMDX) const bool deleteIfMale;                                              //Delete this character if we're male
var(GMDX) const bool deleteIfFemale;                                            //Delete this character if we're female


// ----------------------------------------------------------------------
// ShouldCreate()
// If this returns FALSE, the object will be deleted on it's first tick
// ----------------------------------------------------------------------

function bool ShouldCreate(DeusExPlayer player)
{
    local bool maleDelete;
    local bool femaleDelete;
    local bool extraDelete;

    maleDelete = !player.FlagBase.GetBool('LDDPJCIsFemale') && deleteIfMale;
    femaleDelete = player.FlagBase.GetBool('LDDPJCIsFemale') && deleteIfFemale;
    extraDelete = LDDPExtra && !player.bMoreLDDPNPCs;

    return !maleDelete && !femaleDelete && !extraDelete && (player.FemaleEnabled() || !requiresLDDP);
}


function UpdateHDTPsettings()
{
	local mesh tempmesh;
	local texture temptex;
	local int i, j;
	local deusexplayer p;
	local bool bSetHDTP;
	local bool bSuccess;

	if(mesh == mesh2)
		j=1;
	else if(mesh == mesh3)
		j=2;

	P = deusexplayer(getplayerpawn());

	if(P != none)
	{
		bSetHDTP = P.GetHDTPSettings(self);
	}

	if(bSetHDTP && !bUsingHDTP)
	{
		if(HDTPMeshname != "")
		{
			tempmesh = lodmesh(dynamicloadobject(HDTPMeshname,class'mesh',true));
			if(tempmesh != none)
			{
				mesh = tempmesh;
				bSuccess=true;
			}
		}
		if(HDTPMesh2name != "")
		{
			tempmesh = lodmesh(dynamicloadobject(HDTPMesh2name,class'mesh',true));
			if(tempmesh != none)
			{
				mesh2 = tempmesh;
				bSuccess=true;
			}
		}
		if(HDTPMesh3name != "")
		{
			tempmesh = lodmesh(dynamicloadobject(HDTPMesh3name,class'mesh',true));
			if(tempmesh != none)
			{
				mesh3 = tempmesh;
				bSuccess=true;
			}
		}

		if(bSuccess)
		{
			if(j==1)
				mesh = mesh2;
			else if(j==2)
				mesh = mesh3;
				texture=none;
			skin=none;
			for(i=0;i<=7;i++)
			{
				if(HDTPMeshtex[i] != "")
				{
					temptex = texture(dynamicloadobject(HDTPMeshtex[i],class'texture',true));
					if(temptex != none)
						multiskins[i] = temptex;
				}
			}
			bUsingHDTP=true;
		}
	}
	else if(!bSetHDTP && bUsingHDTP)
	{
		mesh = default.mesh;
		mesh2 = default.Mesh2;
		mesh3 = default.Mesh3;
		texture=default.texture;
		skin=default.skin;
		for(i=0; i<=7;i++)
		{
			multiskins[i]=default.multiskins[i];
		}
		if(j==1)  //safety check
			mesh = mesh2;
		else if(j==2)
			mesh = mesh3;
		bUsingHDTP=false;
	}
}

// ----------------------------------------------------------------------
// InitFor()
// ----------------------------------------------------------------------

function InitFor(Actor Other)
{
local FleshFragmentNub nub;
local vector vec;
local rotator randRot;
local DeusExLevelInfo info;                                                     //RSD
local DeusExPlayer player;                                                      //RSD

    player = DeusExPlayer(GetPlayerPawn());                                     //RSD
    info = player.GetLevelInfo();                                               //RSD
	if (Other != None)
	{
		// set as unconscious or add the pawns name to the description
        if (!bAnimalCarcass)
        {
		    bEmitCarcass = true; //CyberP: AI is aware of carcasses whether dead or unconscious!
			if (Other.IsA('ScriptedPawn'))                                      //RSD
			{
            savedName = ScriptedPawn(Other).FamiliarName;
            if (bNotDead)
				itemName = msgNotDead $ " (" $ savedName $ ")";                 //RSD: use savedName
			else
				itemName = itemName $ " (" $ savedName $ ")";                   //RSD: use savedName
			}
		}
        else
        {
            if (Other.IsA('ScriptedPawn'))                                      //RSD
			{
            savedName = ScriptedPawn(Other).BindName;
            if (bNotDead)
                itemName = msgNotDead $ " (" $ savedName $ ")";                 //RSD: use savedName
            else
		        itemName = msgAnimalCarcass;
            }
        }

		Mass           = Other.Mass;
		Buoyancy       = Mass * 1.2;
		MaxDamage      = 0.8*Mass;
		if (ScriptedPawn(Other) != None)
			if (ScriptedPawn(Other).bBurnedToDeath)
				CumulativeDamage = MaxDamage-1;

		SetScaleGlow();

		// Will this carcass spawn flies?
		if (bAnimalCarcass && !bNotDead)
		{
		    MaxDamage      = Mass; //CyberP: less carc health for animals
			itemName = msgAnimalCarcass;
			if (FRand() < 0.2 && !(info != none && info.bNoSpawnFlies))         //RSD: Now check map for whether we should spawn flies
				bGenerateFlies = true;
		}
		else if (!Other.IsA('Robot') && !bNotDead)
		{
			if (FRand() < 0.1 && !(info != none && info.bNoSpawnFlies))         //RSD: Now check map for whether we should spawn flies
				bGenerateFlies = true;
		}

		if (Other.AnimSequence == 'DeathFront')
			Mesh = Mesh2;
/*if (bPop && (IsA('CopCarcassBeheaded') || IsA('ThugMale2CarcassBeheaded')))
{
if (Mesh == Mesh2)
{
vec = vect(0,0,0);
vec.X += CollisionRadius*0.87;
vec.Z -= 39;
vec.Y += 3.5;
vec = vec >> Rotation;
vec += Location;
randRot=Rotation;
	nub = Spawn(class'FleshFragmentNub', Self,, vec, randRot);
	if (nub != None)
	{
	nub.ScaleGlow=0.9;
    }
}
else
{
vec = vect(0,0,0);
vec.X -= CollisionRadius*0.93;
vec.Z -= 43;
vec.Y -= 0.25;
vec = vec >> Rotation;
vec += Location;
randRot=Rotation;
	nub = Spawn(class'FleshFragmentNub', Self,, vec, randRot);
	if (nub != None)
	{
	nub.ScaleGlow=0.9;
    }
}
}
else if (bPop && IsA('MJ12TroopCarcassBeheaded'))
{
if (Mesh == Mesh2)
{
vec = vect(0,0,0);
vec.X += CollisionRadius*0.9;
vec.Z -= 39.25;
vec.Y += 3.5;
vec = vec >> Rotation;
vec += Location;
randRot=Rotation;
	nub = Spawn(class'FleshFragmentNub', Self,, vec, randRot);
	if (nub != None)
	{
	nub.ScaleGlow=0.9;
    }
}
else
{
vec = vect(0,0,0);
vec.X -= CollisionRadius*1.22;
vec.Z -= 47.5;
vec.Y -= 0.25;
vec = vec >> Rotation;
vec += Location;
randRot=Rotation;
	nub = Spawn(class'FleshFragmentNub', Self,, vec, randRot);
	if (nub != None)
	{
	nub.ScaleGlow=0.9;
    }
}
}
else if (bPop && IsA('UNATCOTroopCarcassBeheaded'))
{
if (Mesh == Mesh2)
{
vec = vect(0,0,0);
vec.X += CollisionRadius*0.89;
vec.Z -= 39.25;
vec.Y += 3.5;
vec = vec >> Rotation;
vec += Location;
randRot=Rotation;
	nub = Spawn(class'FleshFragmentNub', Self,, vec, randRot);
	if (nub != None)
	{
	nub.ScaleGlow=0.9;
    }
}
else
{
vec = vect(0,0,0);
vec.X -= CollisionRadius*0.92;
vec.Z -= 42.5;
vec.Y -= 0.5;
vec = vec >> Rotation;
vec += Location;
randRot=Rotation;
	nub = Spawn(class'FleshFragmentNub', Self,, vec, randRot);
	if (nub != None)
	{
	nub.ScaleGlow=0.9;
    }
}
}
else if (bPop)
{
if (Mesh == Mesh2)
{
vec = vect(0,0,0);
vec.X += CollisionRadius * 1.77;
vec.Z -= 40.5;
vec.Y += 3.5;
vec = vec >> Rotation;
vec += Location;
randRot=Rotation;
	nub = Spawn(class'FleshFragmentNub', Self,, vec, randRot);
	if (nub != None)
	{
	nub.ScaleGlow=0.9;
    }
}
else
{
vec = vect(0,0,0);
vec.X -= CollisionRadius * 1.87;
vec.Z -= 43;
vec.Y -= 0.25;
vec = vec >> Rotation;
vec += Location;
randRot=Rotation;
	nub = Spawn(class'FleshFragmentNub', Self,, vec, randRot);
	if (nub != None)
	{
	nub.ScaleGlow=0.9;
    }
}
}*/
		// set the instigator and tag information
		if (Other.Instigator != None)
		{
			KillerBindName = Other.Instigator.BindName;
			KillerAlliance = Other.Instigator.Alliance;
		}
		else
		{
			KillerBindName = Other.BindName;
			KillerAlliance = '';
		}
		Tag = Other.Tag;
		Alliance = Pawn(Other).Alliance;
		CarcassName = Other.Name;
	}
}

// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------

function PostBeginPlay()
{
	local int i, j;
	local Inventory inv;
    local DeusExPlayer DXplayer;                                                //RSD

	bCollideWorld = true;

	// Use the carcass name by default
	CarcassName = Name;
	If (bAnimalCarcass && !bNotDead)
	   itemName = msgAnimalCarcass;

    //RSD: Before we do anything, check for random loot
    //DXplayer = DeusExPlayer(GetPlayerPawn());
    if (bRandomModFix)                                                          //RSD: Stupid config-level hack since PostBeginPlay() can't access player pawn
    	RandomizeMods();

	// Add initial inventory items
	for (i=0; i<8; i++)
	{
		if ((InitialInventory[i].inventory != None) && (InitialInventory[i].count > 0))
		{
			for (j=0; j<InitialInventory[i].count; j++)
			{
				inv = spawn(InitialInventory[i].inventory, self);
				if (inv != None)
				{
					inv.bHidden = True;
					inv.SetPhysics(PHYS_None);
					AddInventory(inv);
				}
			}
		}
	}

	// use the correct mesh
	if (Region.Zone.bWaterZone)
	{
		Mesh = Mesh3;
		bNotDead = False;		// you will die in water every time
	}

	MaxDamage = 0.8*Mass;
	SetScaleGlow();

	SetTimer(30.0, False);

	 UpdateHDTPSettings(); //ugly ugly function tiem

	Super.PostBeginPlay();
}

// ----------------------------------------------------------------------
// ZoneChange()
// ----------------------------------------------------------------------

function ZoneChange(ZoneInfo NewZone)
{
	Super.ZoneChange(NewZone);

	// use the correct mesh for water
	if (NewZone.bWaterZone)
		{
        Mesh = Mesh3;
        if (!IsA('ScubaDiver'))
        {
        	KillUnconscious();                                                  //RSD: Proper kill
		}
        if (Velocity.Z < -70)         //CyberP: water splash effect. Needs updating
		{
		Spawn(class'WaterRing',,,Location+ CollisionHeight * vect(0,0,1));
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');

        }
      }
}

// ----------------------------------------------------------------------
// Destroyed()
// ----------------------------------------------------------------------

function Destroyed()
{
	if (flyGen != None)
	{
		flyGen.StopGenerator();
		flyGen = None;
	}

	Super.Destroyed();
}

function Touch(Actor Other)
{
if (Other.IsA('MilitaryBot') && Velocity == vect(0,0,0))
   TakeDamage(200, Instigator, Location, vect(0,0,0), 'Exploded');
}
// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaSeconds)
{
	if (!bInit)
	{
		bInit = true;
        //If we shouldn't be created, abort
        if (!ShouldCreate(DeusExPlayer(GetPlayerPawn())))
            Destroy();

        else if (bEmitCarcass)
		{
			//AIStartEvent('Carcass', EAITYPE_Visual);
			AIStartEvent('WeaponDrawn', EAITYPE_Visual);
		}

	} else
	  if (bDblClickStart)
	  {
			DblClickTimeout+=deltaSeconds;
			if (DblClickTimeout>0.4)
			{
				bDblClickStart=false;
				bDblClickFrob=false;
				DblClickTimeout=0;
			}
		}
	Super.Tick(deltaSeconds);
}

// ----------------------------------------------------------------------
// Timer()
// ----------------------------------------------------------------------

function Timer()
{
	if (bGenerateFlies)
	{
		flyGen = Spawn(Class'FlyGenerator', , , Location, Rotation);
		if (flyGen != None)
			flyGen.SetBase(self);
	}
}

// ----------------------------------------------------------------------
// ChunkUp()
// ----------------------------------------------------------------------

function ChunkUp(int Damage)
{
	local int i;
	local float size;
	local Vector loc;
	local BloodSpurt spur;
	local FleshFragment chunk;
    local DeusExPlayer player;   //CyberP: for screenflash if near gibs
    local float dist;            //CyberP: for screenflash if near gibs

	// gib the carcass
	size = (CollisionRadius + CollisionHeight) / 2;
	player = DeusExPlayer(GetPlayerPawn()); //CyberP: for screenflash if near gibs

    if (size < 14)
	{
	         loc.X = (1-2*FRand()) * CollisionRadius/8;
			loc.Y = (1-2*FRand()) * CollisionRadius/8;
			loc.Z = (1-2*FRand()) * CollisionHeight;
           loc += Location;
	       Spawn(class'FleshFragmentSmall',None,, loc);
           Spawn(class'FleshFragmentSmall',None,, loc);        //CyberP: For rats cats
	       Spawn(class'FleshFragmentSmall',None,, loc);
	       Spawn(class'FleshFragmentSmall',None,, loc);
	       Spawn(class'FleshFragmentSmall',None,, loc);
	       Spawn(class'FleshFragmentSmall',None,, loc);
	       Spawn(class'FleshFragmentSmall',None,, loc);
	       Spawn(class'FleshFragmentSmall',None,, loc);
	       Spawn(class'FleshFragmentSmall',None,, loc);
    }

    if (size > 14)
	{
        //spawn(class'BoneSkullBloody');
		if (player!=none)
        {
   		dist = Abs(VSize(player.Location - Location));
   		if (dist < 128)
   		     {
                player.ClientFlash(dist*4, vect(170,0,0));
                player.bloodTime = 5.000000;
             }
        }
		for (i=0; i<size/1.4; i++) //CyberP: was 2.0
		{
			loc.X = (1-2*FRand()) * CollisionRadius;
			loc.Y = (1-2*FRand()) * CollisionRadius;
			loc.Z = (1-2*FRand()) * CollisionHeight;
			loc += Location;
			Spawn(class'FleshFragmentSmall',None,, loc);
			chunk = spawn(class'FleshFragment', None,, loc);
            spur = spawn(class'BloodSpurt');
           if (spur!=none && i < 4)
           {
            spur.LifeSpan+=0.3;
            spur.DrawScale+=0.3;
           }
			if (chunk != None)
			{
				chunk.DrawScale = size / 22; //CyberP: was 12
				chunk.SetCollisionSize(chunk.CollisionRadius / chunk.DrawScale, chunk.CollisionHeight / chunk.DrawScale);
				chunk.bFixedRotationDir = False; //CyberP: was true
				chunk.RotationRate = RotRand()*200;
                chunk.Velocity = VRand()*180;
				chunk.bWasUnconscious=bNotDead;
			}
		}
	}
	if (!bAnimalCarcass)
       ExpelInventory();
	Super.ChunkUp(Damage);
}

// ----------------------------------------------------------------------
// TakeDamage()
// ----------------------------------------------------------------------

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitLocation, Vector momentum, name damageType)
{
	local int i;
    local BloodDrop drop;
    local vector vec;
    local DeusExPlayer player;

	if (bInvincible)
		return;

	// only take "gib" damage from these damage types
	if ((damageType == 'Shot') || (damageType == 'Sabot') || (damageType == 'Exploded') || (damageType == 'Munch') ||
	    (damageType == 'Tantalus') || (damageType=='throw') || (damageType == 'Burned'))  //Burned damage also
	{
		if (damageType != 'Tantalus' && FRand() < 0.4)
		{
		PlaySound(Sound'BodyHit', SLOT_Interact, 1, ,768,1.0);     //CyberP: sound for attacking carc
		 if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
		 {
		 }
		 else
		 {
		    vec = HitLocation;
		    vec.z += 2;
			for(i=0;i<18;i++)
            {
            spawn(class'BloodDrop',,, HitLocation);
            drop = spawn(class'BloodDrop',,,vec);
            if (drop!=none)
            {
             drop.Velocity *= 1.05;
             drop.Velocity.Z *= 1.3;
            }
            }
		 }
		}

		// this section copied from Carcass::TakeDamage() and modified a little
		if (!bDecorative)
		{
			bBobbing = false;
			SetPhysics(PHYS_Falling);
		}
		if ((Physics == PHYS_None) && (Momentum.Z < 0))
			Momentum.Z *= -1;
		Velocity += 3 * momentum/(Mass + 200);
		if (bNotDead && (FRand() < 0.4 || Damage > 18)) //CyberP: don't be lazy self, check for headshots...
		{
		    KillUnconscious();                                                  //RSD: Proper kill
			if (instigatedBy.IsA('DeusExPlayer'))
			    DeusExPlayer(instigatedBy).KillCount++;
		}
        if (DamageType == 'Exploded' || (DamageType == 'Burned' && Damage >= 10))
		    {
		    CumulativeDamage = 50000;
		    if (DamageType == 'Burned')
		    {
		    spawn(class'FleshFragmentBurned');
		    spawn(class'FleshFragmentBurned');
		    spawn(class'FleshFragmentBurned');
		    spawn(class'FleshFragmentBurned');
		    spawn(class'FleshFragmentBurned');
		    spawn(class'FleshFragmentBurned');
		    spawn(class'FleshFragmentBurned');
		    }
			spawn(class'FleshFragmentSmoking');  //CyberP: carcasses blown up spawn smoking gibs
			spawn(class'FleshFragmentSmoking');
			spawn(class'FleshFragmentSmoking');
			spawn(class'FleshFragmentSmoking');
			}
		player = DeusExPlayer(GetPlayerPawn());
		if ((player.bRealisticCarc || player.bHardCoreMode) && !bAnimalCarcass)  //CyberP: with this option enabled carcasses can only be damaged by explosions, plasma rifle and being eaten
        {
		  if ((damageType == 'Exploded') || (damageType == 'Munch') || (damageType == 'Burned'))
             CumulativeDamage += Damage;
        }
        else
        {
             CumulativeDamage += Damage;
        }
		if (CumulativeDamage >= MaxDamage)
			ChunkUp(Damage);
		if (bDecorative)
			Velocity = vect(0,0,0);
	}

	SetScaleGlow();
}

// ----------------------------------------------------------------------
// ExpelInventory()
// G-Flex: so when the corpse is gibbed, items won't be lost
// G-Flex: mostly a simplistic version of Frob()
// ----------------------------------------------------------------------

function ExpelInventory()
{
    local Inventory item, nextItem, startItem;
    local DeusExPlayer player;
    local Vector loc;

    //G-Flex: don't do this in multiplayer
    if (Level.Netmode != NM_Standalone)
        return;

    player = DeusExPlayer(GetPlayerPawn());

    if (Inventory != None)
    {
        //== Y|y: If by some chance we get items that belong to the player, skip them and move the Inventory
        //==  variable to something
        //G-Flex: not sure if this is needed in this function, but then again I don't know why it ever is
        while(Inventory.Owner == player)
        {
            Inventory = Inventory.Inventory;
            if(Inventory == None)
                break;
        }

        item = Inventory;
        startItem = item;

        do
        {
            //== Y|y: and now some stuff to make sure we don't wander into player inventory AGAIN
            if(item == None)
                break;

            while(item.Owner == player)
            {
                item = item.Inventory;
                if(item == None)
                    break;
            }

            if(item == None)
                break;

            nextItem = item.Inventory;

            if(nextItem != None)
            {
                while(nextItem.Owner == player)
                {
                    nextItem = nextItem.Inventory;
                    item.Inventory = nextItem; //== Relink to the appropriate, un-player-owned item
                    if(nextItem == None)
                        break;
                }
            }

            if (item.IsA('Ammo'))
            {
                // Only let the player pick up ammo that's already in a weapon
                DeleteInventory(item);
                item.Destroy();
                item = None;
            }

            if (item != None)
            {
                loc.X = (1-2*FRand()) * CollisionRadius;
                loc.Y = (1-2*FRand()) * CollisionRadius;
                loc.Z = CollisionHeight + 4 + (FRand() * 4); //CyberP: stop things spawning under the floor.
                loc += Location;
                DeleteInventory(item);
                item.DropFrom(loc);
                if ( (item.IsA('DeusExWeapon')) )
                {
                    // Any weapons have their ammo set to a random number of rounds (1-4)
                    // unless it's a grenade, in which case we only want to dole out one.
                    // DEUS_EX AMSD In multiplayer, give everything away.
                    //if (DeusExWeapon(item).PickupAmmoCount != 0)              //RSD: No need for this check
                        DeusExWeapon(item).SetDroppedAmmoCount(PickupAmmoCount);//RSD: Added PickupAmmoCount for initialization from MissionScript.uc
                }
            }

            item = nextItem;
        }
        until ((item == None) || (item == startItem));
    }
}
// ----------------------------------------------------------------------
// SetScaleGlow()
//
// sets the scale glow for the carcass, based on damage
// ----------------------------------------------------------------------

function SetScaleGlow()
{
	local float pct;

	// scaleglow based on damage
	pct = FClamp(1.0-float(CumulativeDamage)/MaxDamage, 0.1, 1.0);
	ScaleGlow = pct;
}

//Enable picking up corpses regardless of inventory using left-frob
function bool DoLeftFrob(DeusExPlayer frobber)
{
    //We can't pick up animal carcasses
    if (bAnimalCarcass)
        return;

    PickupCorpse(frobber);
    return false;
}

//Pick Up Corpse
//SARGE: Move this to an external function so we can do it with left-frob
function PickupCorpse(DeusExPlayer player)
{
	local POVCorpse corpse;
    local int j;

    bDblClickStart=false;
    bDblClickFrob=false;
    if (!bInvincible)
    {
        corpse = Spawn(class'POVCorpse');
        if (corpse != None)
        {
            // destroy the actual carcass and put the fake one
            // in the player's hands
            if (passedSkins)
            {
                for(j=0;j<arrayCount(Multiskins);j++)
                {
                    corpse.pMultitex[j] = Multiskins[j];
                    corpse.bHasSkins = true;
                }
            }
            corpse.carcClassString = String(Class);
            corpse.KillerAlliance = KillerAlliance;
            corpse.KillerBindName = KillerBindName;
            corpse.Alliance = Alliance;
            corpse.bNotDead = bNotDead;
            corpse.bEmitCarcass = bEmitCarcass;
            corpse.CumulativeDamage = CumulativeDamage;
            corpse.MaxDamage = MaxDamage;
            corpse.CorpseItemName = itemName;
            corpse.CarcassName = CarcassName;
            corpse.bEmitCarcass = False; //CyberP: don't emit carc when in player hand
            corpse.CarcassTag = Tag; //CyberP: don't wipe the tag
            corpse.Inv=Inventory; //GMDX:dbl click
            corpse.Frob(player, None);
            corpse.SetBase(player);
            player.PutInHand(corpse);
            bQueuedDestroy=True;
            Destroy();
        }
    }
}

// ----------------------------------------------------------------------
// Frob()
//
// search the body for inventory items and give them to the frobber
// ----------------------------------------------------------------------

function Frob(Actor Frobber, Inventory frobWith)
{
	local Inventory item, nextItem, startItem;
	local Pawn P;
	local DeusExWeapon W;
	local bool bFoundSomething;
	local DeusExPlayer player;
	local ammo AmmoType;
	local bool bPickedItemUp;
	local DeusExPickup invItem;
	local int itemCount, startcopies, i,addedAmount;
    local int ammoCount, intj;                                                  //RSD: Added

//log("DeusExCarcass::Frob()--------------------------------");

	// Can we assume only the *PLAYER* would actually be frobbing carci?
	player = DeusExPlayer(Frobber);

	// No doublefrobbing in multiplayer.
	if (bQueuedDestroy)
		return;

	// if we've already been searched, let the player pick us up
	// don't pick up animal carcii
	if (!bAnimalCarcass)
	{
	  // DEUS_EX AMSD Since we don't have animations for carrying corpses, and since it has no real use in multiplayer,
	  // and since the PutInHand propagation doesn't just work, this is work we don't need to do.
	  // Were you to do it, you'd need to check the respawning issue, destroy the POVcorpse it creates and point to the
	  // one in inventory (like I did when giving the player starting inventory).

		if ((((bDblClickStart)&&(bDblClickFrob))||(Inventory==none))&&
		(player != None) && (player.inHand == None) && player.carriedDecoration == None)
		{
            PickupCorpse(player);
            return;
		}
		else if (player != None && player.inhand != none && player.bAutoHolster && !player.inHand.IsA('POVCorpse') && player.CarriedDecoration == None)
		{
		      if (Inventory == None && (bDblClickStart || !player.bDblClickHolster))
		          player.PutInHand(none);
		      else if (Inventory != None && bDblClickStart && player.bDblClickHolster)
                  player.PutInHand(none);
		}
	}

    if (PickupAmmoCount == 0)                                                   //RSD: If nothing was passed to us from the initialization from MissionScript.uc on first map load, use old random formula
    	PickupAmmoCount = Rand(4) + 1;

	bDblClickStart=True;
	DblClickTimeout=0;

	bFoundSomething = False;
	bSearchMsgPrinted = False;
	P = Pawn(Frobber);
	if (P != None)
	{
		// Make sure the "Received Items" display is cleared
	  // DEUS_EX AMSD Don't bother displaying in multiplayer.  For propagation
	  // reasons it is a lot more of a hassle than it is worth.
		if ( (player != None) && (Level.NetMode == NM_Standalone) )
		 DeusExRootWindow(player.rootWindow).hud.receivedItems.RemoveItems();

		if (Inventory != None)
		{

            while(Inventory.Owner == Frobber)
            {
                Inventory = Inventory.Inventory;
                if(Inventory == None)
                    break;
            }

			item = Inventory;
			startItem = item;

			do
			{
//log("===>DeusExCarcass:item="$item );

                //== Y|y: and now some stuff to make sure we don't wander into player inventory AGAIN
                if(item == None)
                    break;

                while(item.Owner == Frobber)
                {
                    item = item.Inventory;
                    if(item == None)
                        break;
                }

                if(item == None)
                    break;
                //== end
				nextItem = item.Inventory;
                //== start
                if(nextItem != None)
                {
                    while(nextItem.Owner == Frobber)
                    {
                        nextItem = nextItem.Inventory;
                        item.Inventory = nextItem; //== Relink to the appropriate, un-player-owned item
                        if(nextItem == None)
                            break;
                    }
                }
                //== end
				bPickedItemUp = False;
                if (item != none && item.IsA('WeaponCombatKnife') && player != none && player.bNoKnives) //RSD: Changed to player, added failsafes
                {
                 //if (FRand() < 0.85)                                          //RSD: Do it all the time
                 //{
                 DeleteInventory(item);
                 item.Destroy();
                 item = None;
                 //}
                }
				if (item != none && (item.IsA('Ammo') || (item.IsA('WeaponSpiderBotConstructor')) || (item.IsA('WeaponAssaultGunSpider')))) //CyberP: new type weapons exclusive to pawns //RSD: Failsafe
				{
					// Only let the player pick up ammo that's already in a weapon
					DeleteInventory(item);
					item.Destroy();
					item = None;
//log("IS AMMO<DESTROYED>");
				}
				else if (item != none && (item.IsA('DeusExWeapon')) )
				{
//log("IS A DXWEAPON");
			   // Any weapons have their ammo set to a random number of rounds (1-4)
			   // unless it's a grenade, in which case we only want to dole out one.
			   // DEUS_EX AMSD In multiplayer, give everything away.
			   W = DeusExWeapon(item);

			   // Grenades and LAMs always pickup 1
			   if (W.IsA('WeaponShuriken') && passedImpaleCount > 0)
			   {
			      if (passedImpaleCount > 4)
			          passedImpaleCount = 4;
			      w.PickupAmmoCount = passedImpaleCount;
			      if (w.PickupAmmoCount == 0)
			          w.PickupAmmoCount = 1;
			      PlaySound(Sound'DeusExSounds.Generic.FleshHit1',SLOT_None,,,,0.95 + (FRand() * 0.2));
			   }
			   else if (W.IsA('WeaponNanoVirusGrenade') ||
				  W.IsA('WeaponGasGrenade') ||
				  W.IsA('WeaponEMPGrenade') ||
				  W.IsA('WeaponLAM')  ||
                  W.IsA('WeaponHideAGun') && player.FindInventorySlot(item, True))  //CyberP: there we go. Now need to stop 1-4 rand for nades
				  W.PickupAmmoCount = 1;       //CyberP: I need to check if inventory is full and no nades
			   else if (W.IsA('WeaponAssaultGun'))
                  //W.PickupAmmoCount = Rand(5) + 1.5;                          //RSD
                  W.PickupAmmoCount = PickupAmmoCount + 1;                      //RSD: Now 2-5 rounds with initialization in MissionScript.uc on first map load
               else if (W.IsA('WeaponGepGun'))
                  W.PickupAmmoCount = 2;
			   else if (!W.IsA('WeaponNanoVirusGrenade') &&
				  !W.IsA('WeaponGasGrenade') &&
				  !W.IsA('WeaponEMPGrenade') &&
				  !W.IsA('WeaponLAM') &&
                  !W.IsA('WeaponHideAGun')) //CyberP: no grenades.
			    //W.PickupAmmoCount = Rand(4) + 1;                              //RSD
			    W.PickupAmmoCount = PickupAmmoCount;                            //RSD
                else if (W.Default.PickupAmmoCount != 0)
                W.PickupAmmoCount = 1; //CyberP: hmm
				}

				if (item != None)
				{
					bFoundSomething = True;

					if (item.IsA('NanoKey'))
					{
						if (player != None)
						{
							player.PickupNanoKey(NanoKey(item));
							AddReceivedItem(player, item, 1);
							DeleteInventory(item);
							item.Destroy();
							item = None;
						}
						bPickedItemUp = True;
					}
					else if (item.IsA('Credits'))		// I hate special cases
					{
						if (player != None)
						{
						    //if (player.PerkNamesArray[33]==1)                 //RSD: No more Neat Hack perk
			                //   Credits(item).numCredits *= 1.5;
							AddReceivedItem(player, item, Credits(item).numCredits);
							player.Credits += Credits(item).numCredits;
							P.ClientMessage(Sprintf(Credits(item).msgCreditsAdded, Credits(item).numCredits));
							DeleteInventory(item);
							item.Destroy();
							item = None;
						}
						bPickedItemUp = True;
					}
					else if (item.IsA('DeusExWeapon'))   // I *really* hate special cases
					{
//log("2nd WEAPON TEST");
						// Okay, check to see if the player already has this weapon.  If so,
						// then just give the ammo and not the weapon.  Otherwise give
						// the weapon normally.
						W = DeusExWeapon(player.FindInventoryType(item.Class));
//log("found? "@W);
						// If the player already has this item in his inventory, piece of cake,
						// we just give him the ammo.  However, if the Weapon is *not* in the
						// player's inventory, first check to see if there's room for it.  If so,
						// then we'll give it to him normally.  If there's *NO* room, then we
						// want to give the player the AMMO only (as if the player already had
						// the weapon).

						if ((W != None) || ((W == None) && (!player.FindInventorySlot(item, True))))
						{
//log("2nd WEAP is DUP?:-"@W@" Weapon(item).AmmoType="@Weapon(item).AmmoType@" Weapon(item).AmmoType.AmmoAmount="@Weapon(item).AmmoType.AmmoAmount);
							// Don't bother with this is there's no ammo
							if ((Weapon(item).AmmoType != None) && (Weapon(item).AmmoType.AmmoAmount > 0))
							{
								AmmoType = Ammo(player.FindInventoryType(Weapon(item).AmmoName));
//log("HAS AMMO TYPE");
						if ((AmmoType != None) && (AmmoType.AmmoAmount < DeusExPlayer(GetPlayerPawn()).GetAdjustedMaxAmmo(AmmoType))) //RSD: Replaced AmmoType.MaxAmmo with adjusted
								{
//log("IS AMMO TYPE:"@AmmoType);
						   AmmoCount = AmmoType.AmmoAmount;                     //RSD
                           AmmoType.AddAmmo(Weapon(item).PickupAmmoCount);
                           intj = AmmoType.AmmoAmount - AmmoCount;              //RSD
						   AddReceivedItem(player, AmmoType, intj);             //RSD: Fixed amount

									// Update the ammo display on the object belt
									player.UpdateAmmoBeltText(AmmoType);

									// if this is an illegal ammo type, use the weapon name to print the message
									if (AmmoType.PickupViewMesh == Mesh'TestBox')
										P.ClientMessage(item.PickupMessage @ item.itemArticle @ item.itemName, 'Pickup');
									else
										P.ClientMessage(AmmoType.PickupMessage @ AmmoType.itemArticle @ AmmoType.itemName $ " (" $ intj $ ")", 'Pickup'); //RSD: Added intj

									// Mark it as 0 to prevent it from being added twice
									Weapon(item).AmmoType.AmmoAmount = 0;
									Weapon(item).PickupAmmoCount = 0;
								}
							} else
							if ((W != None)&&(Weapon(item).AmmoType==none)) //GMDX Fix bug that makes level carcass with weapon just crap out as it has not got spawned ammotype
							{
								AmmoType = Ammo(player.FindInventoryType(Weapon(item).AmmoName));
								if (AmmoType!=none)
								{
									addedAmount=-AmmoType.AmmoAmount;
									AmmoType.AddAmmo(Weapon(item).PickupAmmoCount);
									addedAmount+=AmmoType.AmmoAmount;
									if (addedAmount>0)
									{
										player.UpdateAmmoBeltText(AmmoType);
										AddReceivedItem(player, AmmoType,addedAmount);
										Weapon(item).PickupAmmoCount=0;
										if (AmmoType.PickupViewMesh == Mesh'TestBox')
									      P.ClientMessage(item.PickupMessage @ item.itemArticle @ item.itemName, 'Pickup');
									      else
									         P.ClientMessage(AmmoType.PickupMessage @ AmmoType.itemArticle @ AmmoType.itemName, 'Pickup');
						         }
								}
							}
							// Print a message "Cannot pickup blah blah blah" if inventory is full
							// and the player can't pickup this weapon, so the player at least knows
							// if he empties some inventory he can get something potentially cooler
							// than he already has.

							if ((W == None) && (!player.FindInventorySlot(item, True)))
								P.ClientMessage(Sprintf(Player.InventoryFull, item.itemName));

							// Only destroy the weapon if the player already has it.
							if (W != None)
							{
//log("DESTROY WEAP");
								// Destroy the weapon, baby!
								DeleteInventory(item);
								item.Destroy();
								item = None;
							}

							bPickedItemUp = True;
						}
					}

					else if (item.IsA('DeusExAmmo'))
					{
//log("IS A DXAMMO");
						if (DeusExAmmo(item).AmmoAmount == 0)
							bPickedItemUp = True;
					}
//log("handled pickup "@bPickedItemUp);
					if (!bPickedItemUp)
					{
						// Special case if this is a DeusExPickup(), it can have multiple copies
						// and the player already has it.

						if ((item.IsA('DeusExPickup')) && (DeusExPickup(item).bCanHaveMultipleCopies) && (player.FindInventoryType(item.class) != None))
						{
							invItem   = DeusExPickup(player.FindInventoryType(item.class));
							itemCount = DeusExPickup(item).numCopies;
							startcopies = invitem.NumCopies;
//log("Is A PICKUP WITH MULTI COPIES "@invItem@" count "@itemCount@" startcopies "@startcopies);
							// Make sure the player doesn't have too many copies
							if ((invItem.RetMaxCopies() > 0) && (DeusExPickup(item).numCopies + invItem.numCopies > invItem.RetMaxCopies()))  //GMDX
							{
//log("Handle COPIES");
								// Give the player the max #
								if ((invItem.RetMaxCopies() - invItem.numCopies) > 0)  //GMDX
								{
//log("ADD MAX COPIES");
									itemCount = (invItem.RetMaxCopies() - invItem.numCopies);   //GMDX
									DeusExPickup(item).numCopies -= itemCount;
									invItem.numCopies = invItem.RetMaxCopies();  //GMDX
									if(invitem.bHasMultipleSkins)
									{
										while(startcopies < invitem.numcopies) //spool through
										{
											i = invItem.findnextposition();

											invItem.pickuplist[i] = deusexpickup(item).textureset;
											invItem.textureset = deusexpickup(item).textureset;
											invItem.SetSkin();
											startcopies++;
										}
									}

									P.ClientMessage(invItem.PickupMessage @ invItem.itemArticle @ invItem.itemName, 'Pickup');
									AddReceivedItem(player, invItem, itemCount);
								}
								else if (invItem.IsA('ChargedPickup') && invItem.Charge < invItem.default.Charge) //RSD: Charge up the player's wearable if they have max copies but are below max charge
								{
									invItem.Charge += DeusExPickup(item).Charge;
                       				if (invItem.Charge >= invItem.default.Charge)
                           				invItem.Charge = invItem.default.Charge;
                       				DeleteInventory(item);

                       				if (invItem.Charge > 0)
                       				{
                       					ChargedPickup(invItem).bActivatable=true;//RSD: Since now you can hold one at 0%
                      					ChargedPickup(invItem).unDimIcon();
                                    }

                       				P.ClientMessage(invItem.PickupMessage @ invItem.itemArticle @ invItem.itemName, 'Pickup');
                       				AddReceivedItem(player, invItem, itemCount);
//log("CHARGED MAX COPIES");                                                      //RSD: New log entry for it
								}
								else
								{
									P.ClientMessage(Sprintf(msgCannotPickup, invItem.itemName));
								}
							}
							else
							{
//log("ADD ITEMS DEFAULT");
								invItem.numCopies += itemCount;
								if(invitem.bHasMultipleSkins)
								{
									while(startcopies < invitem.numcopies) //spool through
									{
										i = invItem.findnextposition();

										invItem.pickuplist[i] = deusexpickup(item).textureset;
										invItem.textureset = deusexpickup(item).textureset;
										invItem.SetSkin();
										startcopies++;
									}
								}

								DeleteInventory(item);

								P.ClientMessage(invItem.PickupMessage @ invItem.itemArticle @ invItem.itemName, 'Pickup');
								AddReceivedItem(player, invItem, itemCount);
							}
						}
						else
						{
//log("NORMAL PICKUP");
							// check if the pawn is allowed to pick this up
							if ((P.Inventory == None) || (Level.Game.PickupQuery(P, item)))
							{
//log("CAN "@P@" HAVE");
								DeusExPlayer(P).FrobTarget = item;
								if (DeusExPlayer(P).HandleItemPickup(Item) != False)
								{
//log("HANDLED BY PLAYER");
						   DeleteInventory(item);

						   // DEUS_EX AMSD Belt info isn't always getting cleaned up.  Clean it up.
						   item.bInObjectBelt=False;
						   item.BeltPos=-1;

						   item.SpawnCopy(P);

									// Show the item received in the ReceivedItems window and also
									// display a line in the Log
									AddReceivedItem(player, item, 1);

									P.ClientMessage(Item.PickupMessage @ Item.itemArticle @ Item.itemName, 'Pickup');
									PlaySound(Item.PickupSound);
								}
							}
							else
							{
//log("JUST DESTROY");
								DeleteInventory(item);
								item.Destroy();
								item = None;
							}
						}
					}
				}

				item = nextItem;
			}
			until ((item == None) || (item == startItem));
		}

//log("  bFoundSomething = " $ bFoundSomething);

		if (!bFoundSomething)
			P.ClientMessage(msgEmpty);

//GMDX:
		if (Inventory!=None) bDblClickFrob=True;
	}
//log("DONE ITERATE");

	if ((player != None) && (Level.Netmode != NM_Standalone))
	{
	  player.ClientMessage(Sprintf(msgRecharged, 25));

	  PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);

	  player.Energy += 25;
	  if (player.Energy > player.EnergyMax)
		 player.Energy = player.EnergyMax;
	}

	Super.Frob(Frobber, frobWith);

	if ((Level.Netmode != NM_Standalone) && (Player != None))
	{
	   bQueuedDestroy = true;
	   Destroy();
	}
}

// ----------------------------------------------------------------------
// AddReceivedItem()
// ----------------------------------------------------------------------

function AddReceivedItem(DeusExPlayer player, Inventory item, int count)
{
	local DeusExWeapon w;
	local Inventory altAmmo;

	if (!bSearchMsgPrinted)
	{
		player.ClientMessage(msgSearching);
		bSearchMsgPrinted = True;
	}

	DeusExRootWindow(player.rootWindow).hud.receivedItems.AddItem(item, count); //CyberP: count was 1

	// Make sure the object belt is updated
	if (item.IsA('Ammo'))
		player.UpdateAmmoBeltText(Ammo(item));
	else
		player.UpdateBeltText(item);

	// Deny 20mm and WP rockets off of bodies in multiplayer
	if ( Level.NetMode != NM_Standalone )
	{
		if ( item.IsA('WeaponAssaultGun') || item.IsA('WeaponGEPGun') )
		{
			w = DeusExWeapon(player.FindInventoryType(item.Class));
			if (( Ammo20mm(w.AmmoType) != None ) || ( AmmoRocketWP(w.AmmoType) != None ))
			{
				altAmmo = Spawn( w.AmmoNames[0] );
				DeusExAmmo(altAmmo).AmmoAmount = w.PickupAmmoCount;
				altAmmo.Frob(player,None);
				altAmmo.Destroy();
				w.AmmoType.Destroy();
				w.LoadAmmo( 0 );
			}
		}
	}
}

// ----------------------------------------------------------------------
// AddInventory()
//
// copied from Engine.Pawn
// Add Item to this carcasses inventory.
// Returns true if successfully added, false if not.
// ----------------------------------------------------------------------

function bool AddInventory( inventory NewItem )
{
	// Skip if already in the inventory.
	local inventory Inv;

	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
		if( Inv == NewItem )
			return false;

	// The item should not have been destroyed if we get here.
	assert(NewItem!=None);

	// Add to front of inventory chain.
	NewItem.SetOwner(Self);
	NewItem.Inventory = Inventory;
	NewItem.InitialState = 'Idle2';
	Inventory = NewItem;

	return true;
}

// ----------------------------------------------------------------------
// DeleteInventory()
//
// copied from Engine.Pawn
// Remove Item from this pawn's inventory, if it exists.
// Returns true if it existed and was deleted, false if it did not exist.
// ----------------------------------------------------------------------

function bool DeleteInventory( inventory Item )
{
	// If this item is in our inventory chain, unlink it.
	local actor Link;

	for( Link = Self; Link!=None; Link=Link.Inventory )
	{
		if( Link.Inventory == Item )
		{
			Link.Inventory = Item.Inventory;
			break;
		}
	}
	Item.SetOwner(None);
}

function RandomizeMods()                                                        //RSD: swap weapon mods in inventory
{
	local bool bMatchFound;
    local int i, invCount, weightCount, rnd;
    local class<Inventory> itemClass;
    local LootTableModGeneral LT;
    LT = Spawn(class'LootTableModGeneral');
log("DeusExCarcass RandomizeMods()");
    for (invCount=0;invCount<8;invCount++)
    {
    	bMatchFound = false;
        itemClass = InitialInventory[invCount].Inventory;

    	weightCount = 0;
    	for (i=0;i<ArrayCount(LT.entries);i++)
    	{
    	    weightCount += LT.entries[i].weight;
    	    if (itemClass != None && itemClass == LT.entries[i].item)
    	        bMatchFound = true;
    	}
    	if (bMatchFound)
    	{
    	    if (FRand() > LT.slotChance)
    	        break;
    	    rnd = Rand(weightCount);
    	    weightCount = 0;
    	    for (i=0;i<ArrayCount(LT.entries);i++)
    	    {
    	        weightCount += LT.entries[i].weight;
    	        if (rnd < weightCount)
    	        {
    	           InitialInventory[invCount].Inventory = LT.entries[i].item;
     	           break;
     	       }
    	    }
    	}
    }

    LT.Destroy();
}

// ----------------------------------------------------------------------
// auto state Dead
// ----------------------------------------------------------------------

auto state Dead
{
	function Timer()
	{
		// overrides goddamned lifespan crap
	  // DEUS_EX AMSD In multiplayer, we want corpses to have lifespans.
	  if (Level.NetMode == NM_Standalone)
		 Global.Timer();
	  else
		 Super.Timer();
	}

	function HandleLanding()
	{
		local Vector HitLocation, HitNormal, EndTrace;
		local Actor hit;
		local BloodPool pool;

		if (!bNotDead)
		{

			// trace down about 20 feet if we're not in water
			if (!Region.Zone.bWaterZone && !bNotFirstFall)
			{
				EndTrace = Location - vect(0,0,320);
				hit = Trace(HitLocation, HitNormal, EndTrace, Location, False);

			if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
			{
			   pool = None;
			}
			else
			{
			   pool = spawn(class'BloodPool',,, HitLocation+HitNormal, Rotator(HitNormal));
               //PlaySound(Sound'FleshHit1', SLOT_Interact, 1, ,768,1.0);     //CyberP: sound when thrown
			}
				if (pool != None)
					pool.maxDrawScale = CollisionRadius / 640.0;  //hah! Found you you bastard..was making HUUUGE decals. -DDL
			}

			// alert NPCs that I'm food
			AIStartEvent('Food', EAITYPE_Visual);
		}

		// by default, the collision radius is small so there won't be as
		// many problems spawning carcii
		// expand the collision radius back to where it's supposed to be
		// don't change animal carcass collisions
		if (!bAnimalCarcass)
			SetCollisionSize(40.0, Default.CollisionHeight);

		// alert NPCs that I'm really disgusting
		if (bEmitCarcass)
			AIStartEvent('Carcass', EAITYPE_Visual);

        if (bNotFirstFall && !bHidden)
        {
        PlaySound(sound'PaperHit2', SLOT_None,,,1024);
        AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 512); //CyberP: this applies to when corpses are thrown.
        }
        else
        {
        AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 96); //CyberP: this applies to when corpses are spawned upon pawn death/K.O.
        }
	}

Begin:
	while (Physics == PHYS_Falling)
	{

        Sleep(0.1);      //CyberP: was 1.0- took a while to handleLanding() at times, //which was problematic for a few reasons.
	}
	HandleLanding();

}

//Lork: Corpses take falling damage
function Landed(vector HitNormal)
{
    super.Landed(HitNormal);

    if (Velocity.Z < -1750)
        TakeDamage(1000, None, Location, Velocity, 'Exploded');
    else if (Velocity.Z < -1000)
        TakeDamage(5, None, Location, Velocity, 'Shot');
}
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function KillUnconscious()                                                      //RSD: To properly fix corpse names and trigger any other death effects like MIB explosion
{
        bNotDead = false;

        if (!bAnimalCarcass)
        {
            itemName = default.itemName;
            if (savedName != "")
				itemName = itemName $ " (" $ savedName $ ")";
		}
        else
		    itemName = msgAnimalCarcass;
}

defaultproperties
{
     bHighlight=True
     msgSearching="You found:"
     msgEmpty="You don't find anything"
     msgNotDead="Unconscious"
     msgAnimalCarcass="Animal Carcass"
     msgCannotPickup="You cannot pickup the %s"
     msgRecharged="Recharged %d points"
     ItemName="Dead Body"
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.000000
     CollisionRadius=20.000000
     CollisionHeight=7.000000
     bCollideWorld=False
     Mass=150.000000
     Buoyancy=170.000000
     BindName="DeadBody"
     bVisionImportant=True
}
