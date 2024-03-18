//=============================================================================
// AIPrototype.
//=============================================================================
class GMDXUnatcoDamHelmet extends DeusExDecoration;

var() bool bProp;

function timer()
{
  SetCollisionSize(4.200000,3.300000);
}

function PostBeginPlay()
{
  if (bProp)
    SetCollisionSize(4.200000,3.300000);

  pushSound=None;
}

defaultproperties
{
     bInvincible=True
     bCanBeBase=True
     ItemName="Damaged Helmet"
     PushSound=None
     Mesh=LodMesh'GMDXSFX.UnatcoHelmet'
     MultiSkins(1)=Texture'GMDXSFX.Skins.hUNATCOTroopTex3'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     Mass=20.000000
}
