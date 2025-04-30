//=============================================================================
// ShellCasing2.
//=============================================================================
class ShellCasing2 extends GMDXShellCasing;

simulated function postbeginplay()
{
	super.postbeginplay();	

	if( IsHDTP() )
		DrawScale -= 0.16;
	else
		DrawScale -= 0.25;
}

simulated function spawnBulletSmoke()
{
	local Vector loc, loc2;
	
	super.spawnBulletSmoke();

	if (gen == None)
	{
		loc2.X += collisionradius*0.5;
		loc = loc2 >> rotation;
		loc += location;
		gen = Spawn(class'ParticleGenerator', Self,, Loc, rotation);
		if (gen != None)
		{
			gen.attachTag = Name;
			gen.SetBase(Self);
			gen.LifeSpan = frand()+1;
			gen.bRandomEject = true;
			gen.RandomEjectAmt = 0.05;
			gen.bParticlesUnlit = false;
			gen.ejectSpeed = 2;
			gen.riseRate = 5;
			gen.checkTime = 0.002;
			gen.particleLifeSpan = frand()+1;
			gen.particleDrawScale = 0.01+0.01*frand();
			gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		}
	}
}

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
	
    Fragments[0]=class'HDTPLoader'.static.GetMesh2("HDTPItems.HDTPShotguncasing","DeusExItems.ShellCasing2",IsHDTP());
}

defaultproperties
{
	smokeprob=0.400000
	HDTPMesh="HDTPItems.HDTPShotguncasing"
	elasticity=0.400000
	Mesh=LodMesh'DeusExItems.ShellCasing2'
	DrawScale=1.400000
	CollisionRadius=2.870000
	CollisionHeight=0.920000
}
