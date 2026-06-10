//=============================================================================
// PlasmaBolt.
//=============================================================================
class RubberBullet extends DeusExProjectile;

#exec OBJ LOAD FILE=Effects

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
     speed=2500.000000
     Damage=18.000000
     SpawnSound=Sound'GMDXSFX.Weapons.ShotgunFire'
     ImpactSound=Sound'DeusExSounds.Generic.BasketballBounce'
     LifeSpan=0.000000
     HDTPSkin"HDTPDecos.Skins.HDTPPoolballtex16"
     Skin=Texture'DeusExDeco.Skins.Poolballtex16'
     Mesh=LodMesh'DeusExDeco.Basketball'
     DrawScale=0.180000
     CollisionRadius=1.650000
     CollisionHeight=1.650000
     bBlockActors=True
     bBounce=True
}
