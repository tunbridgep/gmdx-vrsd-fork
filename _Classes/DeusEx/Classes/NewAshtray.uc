//=============================================================================
// Flask.
//=============================================================================
class NewAshtray extends DeusExDecoration;

var() bool bSmoker;
var ParticleGenerator smokeGen;

function Frob(Actor Frobber, Inventory frobWith)
{
	local Actor A;
	local Pawn P;
	local DeusExPlayer Player;

	P = Pawn(Frobber);
	Player = DeusExPlayer(Frobber);

    if (bSmoker)
    {
    Destroy();
    if (smokeGen != None)
     smokeGen.DelayedDestroy();
    return;
    }

	Super.Frob(Frobber, frobWith);
}

function DropThings()
{
 local int i;
 local RockChip chip;

 super.DropThings();

 spawn(class'NewCigaretteOld');
 if (smokeGen != None)
     smokeGen.DelayedDestroy();
 for(i=0;i<18;i++)
 {
 chip = spawn(class'RockChip');
 if (chip != None)
 {
   chip.drawScale *= 0.1;
   chip.ImpactSound = None;
 }
 }
}

Function PostBeginPlay()
{
  super.PostBeginPlay();

  if (bSmoker)
  {
  smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
	    smokeGen.RemoteRole = ROLE_None;
		smokeGen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		smokeGen.particleDrawScale = 0.02;
		smokeGen.checkTime = 0.035;
		smokeGen.frequency = 1.0;
		smokeGen.riseRate = 4.0;
		smokeGen.ejectSpeed = 0.0;
		smokeGen.particleLifeSpan = 3.0;
		smokeGen.bFade = True;
		smokeGen.bTranslucent = True;
		smokeGen.bRandomEject = True;
		smokeGen.bScale = True;
		smokeGen.SetBase(Self);
		smokeGen.SetLocation(Location+vect(0,0,1));
		smokeGen.Mass=4.000000;
	}
  }
}

defaultproperties
{
     HitPoints=2
     FragType=Class'DeusEx.GlassFragment'
     bCanBeBase=True
     ItemName="Ashtray"
     Mesh=LodMesh'GameMedia.Ashtray'
     CollisionRadius=3.400000
     CollisionHeight=2.000000
     Mass=4.000000
     Buoyancy=3.000000
}
