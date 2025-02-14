//=============================================================================
// BoxMedium.
//=============================================================================
class BoxMedium extends Containers;

enum ESkinType
{
    E_Standard,
    E_HongKong
};

var() ESkinType SkinType;

function UpdateHDTPSettings()
{
    local Texture tex;
	Super.UpdateHDTPSettings();

    switch (SkinType)
    {
        case E_Standard: break; //Do nothing.
        case E_HongKong: tex = class'HDTPLoader'.static.GetTexture("HK_Signs.HK_Sign_28");
    }

    if (tex != None)
    {
        Skin = tex;
        MultiSkins[0] = tex;
        MultiSkins[1] = tex;
    }
}

defaultproperties
{
	 bSelectMeleeWeapon=True
     FragType=Class'DeusEx.PaperFragment'
     ItemName="Cardboard Box"
     bBlockSight=True
     HDTPMesh="HDTPDecos.HDTPboxMedium"
     Mesh=LodMesh'DeusExDeco.BoxMedium'
     CollisionRadius=42.000000
     CollisionHeight=30.000000
     Mass=39.000000
     Buoyancy=60.000000
}
