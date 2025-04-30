//=============================================================================
// ShellCasing.
//=============================================================================
class ShellCasing extends GMDXShellCasing;

simulated function postbeginplay()
{
	super.postbeginplay();	

	if( IsHDTP() )
		DrawScale += 0.5;
	else
		DrawScale -= 0.3;
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
			gen.frequency = 2.0;
			gen.particleLifeSpan = frand()+1.5;
			gen.particleDrawScale = 0.01+0.005*frand();
			gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		}
	}
}

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
	
    Fragments[0]=class'HDTPLoader'.static.GetMesh2("HDTPItems.HDTPShellcasing","DeusExItems.ShellCasing",IsHDTP());
}

defaultproperties
{
	smokeprob=0.600000
	HDTPMesh="HDTPItems.HDTPShellcasing"
	elasticity=0.700000
	Mesh=LodMesh'DeusExItems.ShellCasing'
	DrawScale=1.100000
	CollisionRadius=0.600000
	CollisionHeight=0.300000
}
