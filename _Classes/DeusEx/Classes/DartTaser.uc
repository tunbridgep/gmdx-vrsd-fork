//=============================================================================
// DartPoison.
//=============================================================================
class DartTaser extends Dart;

function UpdateHDTPSettings()
{
    super.UpdateHDTPSettings();
    if (IsHDTP())
        Skin=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPAmmoProdTex1");
}

//Ygll: new utility function to create taser light effect on impact
function CreateTaserDartHitLight()
{
	local GMDXImpactSpark sparkEffect1;
	local GMDXImpactSpark2 sparkEffect2;
	local int i;

	for (i = 0; i < 8; i++)
	{
		sparkEffect1 = spawn(class'GMDXImpactSpark');
		sparkEffect2 = spawn(class'GMDXImpactSpark2');

		if( sparkEffect1 != none  )
		{
			//Ygll: change the value to advert some sound issue because it's starting too soon, previously at 1.
			if(i == 6)
			{
				sparkEffect1.AmbientSound = Sound'Ambient.Ambient.Electricity3';
				sparkEffect1.SoundRadius=64;
				sparkEffect1.SoundVolume=160;
				sparkEffect1.SoundPitch=64;
			}

			sparkEffect1.Texture = Texture'Effects.Fire.Spark_Electric';
			sparkEffect1.LifeSpan = FRand()*0.2;
			sparkEffect1.LightBrightness = 255;
			sparkEffect1.LightSaturation = 60;
			sparkEffect1.LightHue = 146;
			sparkEffect1.LightRadius = 1;
			sparkEffect1.LightType = LT_Steady;
		}

		if( sparkEffect2 != none )
		{
			sparkEffect2.Texture = Texture'Effects.Fire.Spark_Electric';
			sparkEffect2.LifeSpan = FRand()*0.4;
			sparkEffect2.LightBrightness = 200;
			sparkEffect2.LightSaturation = 60;
			sparkEffect2.LightHue = 146;
			sparkEffect2.LightRadius = 1;
			sparkEffect2.LightType = LT_Steady;
		}
	}
}

simulated function DoProjectileHitEffects(bool bWallHit)
{
	Super.DoProjectileHitEffects(bWallHit);

	CreateTaserDartHitLight();
}

defaultproperties
{
     mpDamage=10.000000
     DamageType=Stunned
     spawnAmmoClass=Class'DeusEx.AmmoDartTaser'
     ItemName="Taser Dart"
     Damage=10.000000
}
