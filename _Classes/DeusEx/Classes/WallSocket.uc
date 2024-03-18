//=============================================================================
// WallSocket. CyberP:
//=============================================================================
class WallSocket extends DeusExDecoration;

var bool bUsing;

function Timer()
{
	bUsing = False;
}

function Frob(actor Frobber, Inventory frobWith)
{
local GMDXImpactSpark AST;

	Super.Frob(Frobber, frobWith);

	if (bUsing || !bHighlight)
		return;

	SetTimer(2.0, False);
	bUsing = True;

    AST=Spawn(class'GMDXImpactSpark');
          if (AST != None)
          {
          AST.LifeSpan=4.000000;
          AST.DrawScale=0.000001;
          AST.Velocity=vect(0,0,0);
          AST.AmbientSound=Sound'Ambient.Ambient.Electricity3';
          AST.SoundVolume=224;
          AST.SoundRadius=64;
          AST.SoundPitch=80;
		  }
	if (Frobber.IsA('Pawn'))
	    Pawn(Frobber).TakeDamage(4, Pawn(Frobber), vect(0,0,0), vect(0,0,0), 'Shocked');
	/*if (Frobber.IsA('DeusExPlayer'))
	{
        DeusExPlayer(Frobber).ClientFlash(0.1,vect(0,0,96));
        if (DeusExPlayer(Frobber).Energy < 100.000000)
        {
            DeusExPlayer(Frobber).Energy += 2;
            DeusExPlayer(Frobber).ClientMessage("Recharged 2 Bioelectrical Energy Units");
        }
    }*/
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
     Skin=Texture'GMDXSFX.2027Misc.SocketTex1'
     Mesh=LodMesh'DeusExItems.Credits'
     DrawScale=1.400000
     ScaleGlow=0.500000
     CollisionRadius=7.000000
     CollisionHeight=5.500000
     Mass=10.000000
     Buoyancy=30.000000
}
