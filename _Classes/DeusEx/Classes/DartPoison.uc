//=============================================================================
// DartPoison.
//=============================================================================
class DartPoison extends Dart;

var float mpDamage;

function LoadPoisonSmokeTexture(SFXExp puff)
{
	puff.Texture = Texture'RSDCrap.Skins.ef_PoisonSmoke001';

	puff.frames[0] = Texture'RSDCrap.Skins.ef_PoisonSmoke001';
	puff.frames[1] = Texture'RSDCrap.Skins.ef_PoisonSmoke002';
	puff.frames[2] = Texture'RSDCrap.Skins.ef_PoisonSmoke003';
	puff.frames[3] = Texture'RSDCrap.Skins.ef_PoisonSmoke004';
	puff.frames[4] = Texture'RSDCrap.Skins.ef_PoisonSmoke005';
	puff.frames[5] = Texture'RSDCrap.Skins.ef_PoisonSmoke006';
	puff.frames[6] = Texture'RSDCrap.Skins.ef_PoisonSmoke007';
	puff.frames[7] = Texture'RSDCrap.Skins.ef_PoisonSmoke008';
	puff.frames[8] = Texture'RSDCrap.Skins.ef_PoisonSmoke009';
	puff.frames[9] = Texture'RSDCrap.Skins.ef_PoisonSmoke010';
	puff.frames[10] = Texture'RSDCrap.Skins.ef_PoisonSmoke011';
	puff.frames[11] = Texture'RSDCrap.Skins.ef_PoisonSmoke012';
}

function CreatePoisonSmoke()
{
	local SFXExp puff;

	puff = spawn(class'SFXExp');

	if ( puff != None )
	{
		LoadPoisonSmokeTexture(puff);

		puff.scaleFactor = 0.06;
		puff.scaleFactor2 = 0.16;
		puff.GlowFactor = 0.2;
		puff.animSpeed = 0.24;	//Best value for a smooth animation not too long
		puff.RemoteRole = ROLE_None;
	}
}

simulated function DoProjectileHitEffects(bool bWallHit)
{
	Super.DoProjectileHitEffects(bWallHit);

	CreatePoisonSmoke();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
		Damage = mpDamage;
}

defaultproperties
{
     mpDamage=10.000000
     DamageType=Poison
     spawnAmmoClass=Class'DeusEx.AmmoDartPoison'
     ItemName="Tranquilizer Dart"
     Damage=13.000000
}
