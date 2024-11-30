//=============================================================================
// Button1.
//=============================================================================
class Button1 extends DeusExDecoration;

enum EButtonType
{
	BT_Up,
	BT_Down,
	BT_1,
	BT_2,
	BT_3,
	BT_4,
	BT_5,
	BT_6,
	BT_7,
	BT_8,
	BT_9,
	BT_Blank
};

var() EButtonType ButtonType;
var() float buttonLitTime;
var() sound buttonSound1;
var() sound buttonSound2;
var() bool bLit;
var() bool bWaitForEvent;
var bool isPressed;
var() bool bInactiveUntilTriggered;
var Vector	lastLoc, rpcLocation;
var bool		bIsMoving;

replication
{
	reliable if ( Role == ROLE_Authority )
		rpcLocation;
}

// WOW! What a mess.  I wish you could convert strings to names!
function SetSkin(EButtonType type, bool lit)
{
	switch (type)
	{
		case BT_Up:			if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex2","DeusExDeco.Button1Tex2",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex1","DeusExDeco.Button1Tex1",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_Down:		if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex4","DeusExDeco.Button1Tex4",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex3","DeusExDeco.Button1Tex3",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_1:			if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex6","DeusExDeco.Button1Tex6",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex5","DeusExDeco.Button1Tex5",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_2:			if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex8","DeusExDeco.Button1Tex8",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex7","DeusExDeco.Button1Tex7",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_3:			if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex10","DeusExDeco.Button1Tex10",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex9","DeusExDeco.Button1Tex9",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_4:			if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex12","DeusExDeco.Button1Tex12",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex11","DeusExDeco.Button1Tex11",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_5:			if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex14","DeusExDeco.Button1Tex14",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex13","DeusExDeco.Button1Tex13",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_6:			if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex16","DeusExDeco.Button1Tex16",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex15","DeusExDeco.Button1Tex15",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_7:			if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex18","DeusExDeco.Button1Tex18",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex17","DeusExDeco.Button1Tex17",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_8:			if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex20","DeusExDeco.Button1Tex20",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex19","DeusExDeco.Button1Tex19",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_9:			if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex22","DeusExDeco.Button1Tex22",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex21","DeusExDeco.Button1Tex21",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_Blank:		if (lit)
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex24","DeusExDeco.Button1Tex24",IsHDTP());
								ScaleGlow = 3.0;
							}
							else
							{
                                Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPButton1Tex23","DeusExDeco.Button1Tex23",IsHDTP());
								ScaleGlow = Default.ScaleGlow;
							}
							break;
	}
}

function BeginPlay()
{
	Super.BeginPlay();

	if ( Level.NetMode != NM_Standalone )
		rpcLocation = Location;
}

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
	SetSkin(ButtonType, bLit);
}


function Trigger(Actor Other, Pawn Instigator)
{
	if (bWaitForEvent)
		Timer();
	if (bInactiveUntilTriggered)
    {
       bLit = True;
       bInactiveUntilTriggered = False;
    }
}

function Timer()
{
	PlaySound(buttonSound2, SLOT_None);
	if (bInactiveUntilTriggered)
	SetSkin(ButtonType, False);
	else
	SetSkin(ButtonType, bLit);
	isPressed = False;
}

function Frob(Actor Frobber, Inventory frobWith)
{
	if (!isPressed && !bInactiveUntilTriggered)
	{
		isPressed = True;
		PlaySound(buttonSound1, SLOT_None);
		SetSkin(ButtonType, !bLit);
		if (!bWaitForEvent)
			SetTimer(buttonLitTime, False);

		Super.Frob(Frobber, frobWith);
	}
	else if (bInactiveUntilTriggered)
	{
	      PlaySound(sound'Buzz1', SLOT_None);
	      SetSkin(ButtonType, True);
	      SetTimer(buttonLitTime, False);
	}
}

singular function SupportActor(Actor standingActor)
{
	// do nothing
}

function Bump(actor Other)
{
	// do nothing
}

simulated function Tick( float deltaTime )
{
	if ( Level.NetMode != NM_Standalone )
	{
		if ( Role == ROLE_Authority )
		{
			// Was moving, now at rest
			if ( bIsMoving && ( Location == lastLoc ))
				rpcLocation = Location;

			bIsMoving = ( Location != lastLoc );
			lastLoc = Location;
		}
		else
		{
			// Our replicated location changed which means the button has come to rest
			if ( lastLoc != rpcLocation )
			{
				SetLocation( rpcLocation );
				lastLoc = rpcLocation;
			}
		}
	}
	Super.Tick( deltaTime );
}

defaultproperties
{
     ButtonType=BT_Blank
     buttonLitTime=0.500000
     buttonSound1=Sound'DeusExSounds.Generic.Beep1'
     bInvincible=True
     ItemName="Button"
     bPushable=False
     Physics=PHYS_None
     RemoteRole=ROLE_SimulatedProxy
     Mesh=LodMesh'DeusExDeco.Button1'
     CollisionRadius=2.000000
     CollisionHeight=2.000000
     bCollideWorld=False
     bBlockActors=False
     Mass=5.000000
     Buoyancy=2.000000
	 bHDTPFailsafe=False
}
