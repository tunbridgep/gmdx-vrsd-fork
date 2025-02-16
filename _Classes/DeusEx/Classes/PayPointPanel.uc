//=============================================================================
// PayPointPanel.
//=============================================================================
class PayPointPanel extends DeusExDecoration;

var string PassedItemName;
var bool bConfirmPurchase;
var bool bPaidFor;
var() int price;

function Timer()
{
   itemName = default.ItemName @ "(" $ Price $ " credits)";
   bConfirmPurchase = False;
}

function PostBeginPlay()
{
   itemName = ItemName @ "(" $ Price $ " credits)";
}

function Frob(Actor Frobber, Inventory frobWith)
{
  local string deductedMsg;

  if (Frobber.IsA('DeusExPlayer'))
  {
   if (DeusExPlayer(Frobber).Credits < Price && !bPaidFor)
   {
      if (PassedItemName != "Insufficient Credits")
         PassedItemName = ItemName;
      ItemName = "insufficient credits " $ "(" $ Price $ ")";
      SetTimer(3.0,false);
   }

   if (DeusExPlayer(Frobber).Credits < Price || bPaidFor)
       return;

   if (bConfirmPurchase)
   {
    deductedMsg = Price $ " credits deducted from your account";
    DeusExPlayer(Frobber).Credits -= Price;
    bPaidFor = True;
    DeusExPlayer(Frobber).ClientMessage(deductedMsg,,true);
    ToggleLock(DeusExPlayer(Frobber));
    ItemName = "Confirmed";
    PassedItemName = "Confirmed";
    PlaySound(sound'Switch3ClickOn',SLOT_None);
   }
   else if (!bConfirmPurchase)
   {
    PassedItemName = ItemName;
    ItemName = "Are You Sure? " $ "(" $ Price $ " credits)";
    SetTimer(5.0,false);
    bConfirmPurchase = True;
   }
  }
}

function ToggleLock(DeusExPlayer Player)
{
   local Actor A;

   if (Event != '')
   {
      foreach AllActors(class 'Actor', A, Event)
         if (A.IsA('DeusExMover'))
            DeusExMover(A).bLocked = !DeusExMover(A).bLocked;
   }
}


//Base it off SubwayControlPanel
function bool IsHDTP()
{
    return DeusExPlayer(GetPlayerPawn()).IsHDTPInstalled() && class'SubwayControlPanel'.default.iHDTPModelToggle > 0;
}


defaultproperties
{
     bInvincible=True
     ItemName="Insert Credits"
     bPushable=False
     Physics=PHYS_None
     HDTPSkin="HDTPanim.Animated.SubwayControlPanel01"
     Mesh=LodMesh'DeusExDeco.SubwayControlPanel'
     DrawScale=0.750000
     CollisionRadius=4.900000
     CollisionHeight=6.300000
     bCollideWorld=False
     Mass=40.000000
     Buoyancy=30.000000
}
