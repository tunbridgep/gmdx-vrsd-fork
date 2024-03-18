//=============================================================================
// Dog.
//=============================================================================
class Dog extends Animal
	abstract;

var float time;
var bool bStationary;

function PlayDogBark()
{
	// overridden in subclasses
}

function Tick(float deltaTime)
{
local DeusExPlayer player;
local actor  hitActor;
local Vector hitLocation, hitNormal;
local bool bSafe;

	Super.Tick(deltaTime);

	time += deltaTime;

	// check for random noises
	if (time > 0.3)
	{
		time = 0;
		if (IsInState('Attacking') && IsA('Doberman') && !bStationary)
		{
        if (enemy != None)
        {
		   if (FRand() < 0.25)
		   {
		   PlaySound(sound'DogLargeBark1', SLOT_None,2,,2048);
  		   enemy.AISendEvent('LoudNoise', EAITYPE_Audio,1, 756);
		   bSafe = FastTrace(enemy.Location, Location);
		   if (bSafe && enemy.IsA('DeusExPlayer'))
		      DeusExPlayer(enemy).AISendEvent('WeaponFire', EAITYPE_Audio,,1536);
		   }
		   else if (FRand() < 0.5)
		   {
		   PlaySound(sound'DogLargeBark2', SLOT_None,2,,2048);
		   enemy.AISendEvent('LoudNoise', EAITYPE_Audio,1, 756);
		   }
		   else if (FRand() < 0.75)
		   {
		   PlaySound(sound'DogLargeBark3', SLOT_None,2,,2048);
		   }
		   if (Health != default.Health || AnimSequence == 'Attack')
		   bStationary = True;
        }
        }
		else if (FRand() < 0.03)
			PlayDogBark();
	}
}

function PlayTakingHit(EHitLocation hitPos)
{
	// nil
}

function PlayAttack()
{
	PlayAnimPivot('Attack',2.2,); //CyberP: sped up bite by 1.2
}

function TweenToAttack(float tweentime)
{
	TweenAnimPivot('Attack', tweentime*0.3);
}

function PlayBarking()
{
	PlayAnimPivot('Bark');
}

defaultproperties
{
     bPlayDying=True
     MinHealth=4.000000
     InitialAlliances(7)=(AllianceName=Cat,AllianceLevel=-1.000000)
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponDogBite')
     BaseEyeHeight=12.500000
     Health=30
     Alliance=Dog
     Buoyancy=97.000000
}
