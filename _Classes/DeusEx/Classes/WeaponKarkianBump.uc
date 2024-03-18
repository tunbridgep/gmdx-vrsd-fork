//=============================================================================
// WeaponKarkianBump.
//=============================================================================
class WeaponKarkianBump extends WeaponNPCMelee;

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Owner != None && Owner.IsA('Doberman'))
    {
     Misc1Sound=Sound'DeusExSounds.Animal.DogAttack1';
     Misc2Sound=Sound'DeusExSounds.Animal.DogAttack1';
     Misc3Sound=Sound'DeusExSounds.Animal.DogAttack1';
    }
}

defaultproperties
{
     ShotTime=0.100000
     HitDamage=15
     maxRange=80
     AccurateRange=80
     BaseAccuracy=0.000000
     AITimeLimit=10.000000
     AIFireDelay=8.000000
     Misc1Sound=Sound'DeusExSounds.Animal.KarkianAttack'
     Misc2Sound=Sound'DeusExSounds.Animal.KarkianAttack'
     Misc3Sound=Sound'DeusExSounds.Animal.KarkianAttack'
}
