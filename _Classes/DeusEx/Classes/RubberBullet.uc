//=============================================================================
// PlasmaBolt.
//=============================================================================
class RubberBullet extends DeusExProjectile;

#exec OBJ LOAD FILE=Effects

event Bump( Actor Other )
{
local float speed2;

speed2 = VSize(Velocity);
if (speed2 > 1000)
{
  if (Other.IsA('Pawn') || Other.IsA('DeusExDecoration') || Other.IsA('DeusExPickup'))
  {
       /*if (Owner != None && Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand != None && DeusExPlayer(Owner).inHand.IsA('WeaponSawedOffShotgun'))
         Other.TakeDamage(19,Pawn(Owner),Location,0.5*Velocity,'KnockedOut');
       else
         Other.TakeDamage(13,Pawn(Owner),Location,0.5*Velocity,'KnockedOut');*/
       //Other.TakeDamage(Damage,Pawn(Owner),Location,0.5*Velocity,'KnockedOut'); //RSD: No more hacks. Just do the actual damage. Christ // Trash: No more, it's instant!
  }
 }
}

defaultproperties
{
     blastRadius=6.000000
     DamageType=KnockedOut
     AccurateRange=14400
     maxRange=24000
     spawnAmmoClass=Class'DeusEx.AmmoRubber'
     bIgnoresNanoDefense=True
     ItemName="Rubber Bullet"
     ItemArticle="a"
     gravMult=0.500000
     speed=2000.000000
     Damage=18.000000
     SpawnSound=Sound'GMDXSFX.Weapons.ShotgunFire'
     ImpactSound=Sound'DeusExSounds.Generic.BasketballBounce'
     LifeSpan=0.000000
     Skin=Texture'HDTPDecos.Skins.HDTPPoolballtex16'
     Mesh=LodMesh'DeusExDeco.Basketball'
     DrawScale=0.200000
     CollisionRadius=1.650000
     CollisionHeight=1.650000
     bBlockActors=True
     bBounce=True
}
