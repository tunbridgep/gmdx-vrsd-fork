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

defaultproperties
{
     mpDamage=10.000000
     DamageType=Stunned
     spawnAmmoClass=Class'DeusEx.AmmoDartTaser'
     ItemName="Taser Dart"
     Damage=10.000000
}
