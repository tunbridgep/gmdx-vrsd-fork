//=============================================================================
// UNATCOTroop.
//=============================================================================
class UNATCOTroop extends HumanMilitary;

function PostBeginPlay()
{
if (Multiskins[6]==Texture'DeusExCharacters.Skins.UNATCOTroopTex3')
         bHasHelmet = True;

super.PostBeginPlay();
}

function PopHead()
{
MultiSkins[3] = Texture'GMDXSFX.Skins.CopTexBeheaded';
MultiSkins[4] = Texture'DeusExItems.Skins.PinkMaskTex';
MultiSkins[6] = Texture'DeusExItems.Skins.PinkMaskTex';
CarcassType = Class'DeusEx.UNATCOTroopCarcassBeheaded';
}

defaultproperties
{
     CarcassType=Class'DeusEx.UNATCOTroopCarcass'
     WalkingSpeed=0.296000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     walkAnimMult=0.780000
     HDTPMeshName="HDTPCharacters.HDTPUNATCOTroop"
     HDTPMeshTex(0)="HDTPCharacters.Skins.HDTPUNATCOTroopTex0"
     HDTPMeshTex(1)="HDTPCharacters.Skins.HDTPUNATCOTroopTex1"
     HDTPMeshTex(2)="HDTPCharacters.Skins.HDTPUNATCOTroopTex2"
     HDTPMeshTex(3)="HDTPCharacters.Skins.HDTPUNATCOTroopTex3"
     HDTPMeshTex(4)="HDTPCharacters.Skins.HDTPUNATCOTroopTex4"
     HDTPMeshTex(5)="DeusExItems.Skins.PinkMaskTex"
     HDTPMeshTex(6)="DeusExItems.Skins.PinkMaskTex"
     HDTPMeshTex(7)="DeusExItems.Skins.PinkMaskTex"
     bGrenadier=True
     bCanPop=True
     GroundSpeed=220.000000
     Health=110
     HealthHead=110
     HealthTorso=110
     HealthLegLeft=110
     HealthLegRight=110
     HealthArmLeft=110
     HealthArmRight=110
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.MiscTex1'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.UNATCOTroopTex1'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.UNATCOTroopTex2'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.MiscTex1'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.MiscTex1'
     MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.UNATCOTroopTex3'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=49.000000
     BindName="UNATCOTroop"
     FamiliarName="UNATCO Troop"
     UnfamiliarName="UNATCO Troop"
}
