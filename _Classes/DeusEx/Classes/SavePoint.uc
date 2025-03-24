//=============================================================================
// SavePoint.
//=============================================================================
class SavePoint extends BoxLarge;

var bool bUsedSavePoint; //stop double trigger if destroy takes its time
var int Tcount;
var DeusExPlayer player;
var localized String msgDeducted;
var localized String msgNotEnough;
var localized String msgSaveName;

#exec OBJ LOAD FILE=Extras

//SARGE: Allow save points to activate themselves based on flags
var() Name requiredFlag;
var float flagCheckTimer;

//Called every 3 seconds or so
function CheckFlag()
{
    if (bHidden && player != None && player.FlagBase != None && player.FlagBase.GetBool(requiredFlag))
    {
        bHidden = false;
        LightRadius = default.LightRadius;
    }
}

function PostBeginPlay()
{
    super.PostBeginPlay();
    if (requiredFlag != '')
    {
        bHidden = true;
        LightRadius = 0;
    }
}

function Tick(float deltaTime)
{
    if (player == None)
        player = DeusExPlayer(GetPlayerPawn());

    if (requiredFlag == '')
        return;

    if (flagCheckTimer < 3)
        flagCheckTimer += deltaTime;
    else
        CheckFlag();
}

function Timer()
{
   Tcount--;
   if (Tcount<0)
   {
      Destroy();
   }
   DrawScale-=0.01;
}

//singular function Touch(Actor Other)
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
   local DeusExLevelInfo info;

    if (frobber == None)
        return true;

    info=frobber.GetLevelInfo();

    if (frobber.Credits < 100 && frobber.bExtraHardcore)
        frobber.ClientMessage(msgNotEnough);
    else if (!bUsedSavePoint && frobber.CanSave(true))
        GotoState('QuickSaver');
}

State QuickSaver
{
   function Timer()
   {
        if (player == None)
            return;

        if (player.bExtraHardcore)
        {
            player.Credits -= 100;
            player.ClientMessage(msgDeducted);
        }
        bUsedSavePoint=true;
        bHighlight=false;
        player.DoSaveGame(0,sprintf(msgSaveName,player.retInfo(),player.TruePlayerName));
        //player.QuickSave2(sprintf(msgSaveName,player.retInfo(),player.TruePlayerName),true);
        PlaySound(sound'CloakDown', SLOT_None,,,,0.5);
        GotoState('');
        Global.SetTimer(0.02,true);
   }

Begin:
   SetTimer(0.1,false);
}

defaultproperties
{
     Tcount=100
     msgDeducted="100 credits deducted from your account"
     msgNotEnough="100 credits required"
     msgSaveName="%s [%s]"
     numThings=0
     bFlammable=False
     bHighlight=False
     bCanBeBase=False
     ItemName="SavePoint"
     bPushable=False
     bOnlyTriggerable=True
     bBlockSight=False
     Physics=PHYS_None
     Style=STY_Translucent
     bUnlit=True
     Skin=Texture'Extras.Eggs.Matrix_A00';
     MultiSkins(1)=Texture'Extras.Eggs.Matrix_A00'
     MultiSkins(2)=Texture'Extras.Eggs.Matrix_A00'
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     LightType=LT_SubtlePulse
     LightBrightness=48
     LightHue=96
     LightSaturation=32
     LightRadius=3
     bHighlight=True
     ItemName="Save Point"
}
