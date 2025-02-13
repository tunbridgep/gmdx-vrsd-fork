//=============================================================================
// WallSocket. CyberP:
//=============================================================================
class WallSocket extends DeusExDecoration;

var bool bUsing;

var int breakUsages;                                        //Plugs can be used 3 times
var float breakSparkTime;                                   //When we break, spit out sparks constantly for a few seconds
var int soundID;

var const localized string DisabledText;

function Timer()
{
	bUsing = False;
    StopSound(soundID);
}

function Frob(actor Frobber, Inventory frobWith)
{
    local GMDXImpactSpark AST;
    local DeusExPlayer player;
    local Perk socketJockey;

    if (breakUsages <= 0)
        return;

	Super.Frob(Frobber, frobWith);

	if (bUsing || !bHighlight)
		return;

	SetTimer(0.25, False);
	bUsing = True;
	
    if (Frobber.IsA('Pawn'))
	    Pawn(Frobber).TakeDamage(5, Pawn(Frobber), vect(0,0,0), vect(0,0,0), 'Shocked');
	
    GenerateSparks(true);
    soundID = PlaySound(Sound'Ambient.Ambient.Electricity3');

    player = DeusExPlayer(frobber);
    if (player != None)
	{
        socketJockey = player.PerkManager.GetPerkWithClass(class'DeusEx.PerkSocketJockey');
        if (player.Energy < player.GetMaxEnergy() && socketJockey != None && socketJockey.bPerkObtained)
        {
            player.ChargePlayer(socketJockey.PerkValue,true);
        }

        player.ClientFlash(0.1,vect(0,0,96));
        breakUsages--;
        if (breakUsages <= 0)
        {
            Skin = Texture'RSDCrap.Skins.SocketTex1_broken';
            ItemName = ItemName @ DisabledText;
            GenerateSmoke();
            //bInvincible=False;
            //TakeDamage(9999,None,Location,vect(0,0,0),'Burned');
        }
    }
}

function GenerateSmoke()
{
	local ParticleGenerator gen;
    local Vector loc;
            
    loc = Location;
    loc.z += CollisionHeight/2;
    loc.y += (CollisionRadius / 4) - FRand() * CollisionRadius;
    loc.y += (CollisionRadius / 4) - FRand() * CollisionRadius;
    //PlaySound(Sound'Ambient.Ambient.Electricity3');
    gen = Spawn(class'ParticleGenerator', Self,, Location, rot(16384,0,0));
    if (gen != None)
    {
        gen.checkTime = 0.25;
        gen.LifeSpan = 6;
        gen.particleDrawScale = 0.3;
        gen.bRandomEject = True;
        gen.ejectSpeed = 10.0;
        gen.bGravity = False;
        gen.bParticlesUnlit = True;
        gen.frequency = 0.5;
        gen.riseRate = 10.0;
        gen.spawnSound = Sound'Spark2';
        gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
        gen.SetBase(Self);
    }
}

function GenerateSparks(optional bool playSound)
{
    local GMDXImpactSpark AST;
    local Vector loc;
    
    loc = Location;
    loc.z += CollisionHeight/2;
    loc.x += (CollisionRadius / 4) - FRand() * CollisionRadius;
    loc.y += (CollisionRadius / 4) - FRand() * CollisionRadius;

    AST=Spawn(class'GMDXImpactSpark', Self,, loc, rot(16384,0,0));
    if (AST != None)
    {
        AST.SetBase(Self);
        AST.LifeSpan=4.000000;
        AST.DrawScale=0.010000;
        //AST.Velocity=vect(0,0,0);
        if (playSound)
            AST.AmbientSound=Sound'Ambient.Ambient.Electricity3';
        AST.SoundVolume=224;
        AST.SoundRadius=64;
        AST.SoundPitch=80;
    }

}

//Spit out sparks constantly
simulated function Tick(float deltaTime)
{
    if (breakUsages <= 0 && breakSparkTime > 0)
    {
        GenerateSparks();
        breakSparkTime -= deltaTime;
    }
    else if (bUsing)
    {
        GenerateSparks();
    }
}

defaultproperties
{
     HitPoints=100
     bInvincible=True
     FragType=Class'DeusEx.PlasticFragment'
     ItemName="Plug Socket"
     bPushable=False
     Physics=PHYS_None
     Rotation=(Pitch=16352,Yaw=81904,Roll=16360)
     Skin=Texture'RSDCrap.Skins.SocketTex1'
     Mesh=LodMesh'DeusExItems.Credits'
     DrawScale=1.400000
     ScaleGlow=0.500000
     CollisionRadius=7.000000
     CollisionHeight=5.500000
     Mass=10.000000
     Buoyancy=30.000000
     breakUsages=3
     breakSparkTime=2
     DisabledText="(Broken)"
}
