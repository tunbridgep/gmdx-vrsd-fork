//=============================================================================
// RiotCop.
//=============================================================================
class RiotCop extends HumanMilitary;

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if ((damageType == 'TearGas') || (damageType == 'HalonGas'))
		GotoNextState();
	else if (damageType == 'Stunned')
		GotoState('Stunned');
	else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

defaultproperties
{
     CarcassType=Class'DeusEx.RiotCopCarcass'
     WalkingSpeed=0.296000
     walkAnimMult=0.780000
     HDTPMeshName="HDTPCharacters.HDTPRiotCop"
     HDTPMeshTex(0)="HDTPCharacters.Skins.HDTPRiotCopTex0"
     HDTPMeshTex(1)="HDTPCharacters.Skins.HDTPRiotCopTex1"
     HDTPMeshTex(2)="HDTPCharacters.Skins.HDTPRiotCopTex2"
     HDTPMeshTex(3)="HDTPCharacters.Skins.HDTPRiotCopTex3"
     HDTPMeshTex(4)="HDTPCharacters.Skins.HDTPRiotCopTex4"
     HDTPMeshTex(5)="HDTPCharacters.Skins.HDTPRiotCopTex5"
     HDTPMeshTex(6)="DeusExItems.Skins.PinkMaskTex"
     bGrenadier=True
     GroundSpeed=200.000000
     Health=150
     HealthHead=180
     HealthTorso=150
     HealthLegLeft=150
     HealthLegRight=150
     HealthArmLeft=150
     HealthArmRight=150
     Texture=Texture'DeusExCharacters.Skins.VisorTex1'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.MiscTex1'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.RiotCopTex1'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.RiotCopTex2'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.MiscTex1'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.MiscTex1'
     MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.RiotCopTex3'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="RiotCop"
     FamiliarName="Riot Cop"
     UnfamiliarName="Riot Cop"
}
