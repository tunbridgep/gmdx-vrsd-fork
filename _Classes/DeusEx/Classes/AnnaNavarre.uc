//=============================================================================
// AnnaNavarre.
//=============================================================================
class AnnaNavarre extends HumanMilitary;

// ----------------------------------------------------------------------
// SpawnCarcass()
//
// Blow up instead of spawning a carcass
// ----------------------------------------------------------------------

function Carcass SpawnCarcass()
{
	if (bStunned)
		return Super.SpawnCarcass();

	Explode();

	return None;
}

function Explode()
{
	local SphereEffect sphere;
	local ScorchMark s;
	local ExplosionLight light;
	local int i;
	local float explosionDamage;
	local float explosionRadius;
	local vector loc;
    local FleshFragment chunk;

	explosionDamage = 110;
	explosionRadius = 288;

	// alert NPCs that I'm exploding
	AISendEvent('LoudNoise', EAITYPE_Audio, , explosionRadius*16);
	PlaySound(Sound'LargeExplosion1', SLOT_None,,, explosionRadius*16);

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, Location);
	if (light != None)
		light.size = 4;

	Spawn(class'ExplosionSmall',,, Location + 2*VRand()*CollisionRadius);
	Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);
	Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);


	sphere = Spawn(class'SphereEffect',,, Location);
	if (sphere != None)
		sphere.size = explosionRadius / 32.0;

	// spawn a mark
	s = spawn(class'ScorchMark', Base,, Location-vect(0,0,1)*CollisionHeight, Rotation+rot(16384,0,0));
	if (s != None)
	{
		s.DrawScaleMult = FClamp(explosionDamage/28, 0.1, 3.0);
		s.UpdateHDTPSettings();
	}

	for (i=0; i<22; i++) //CyberP: was /1.2
			{
				loc.X = (1-2*FRand()) * CollisionRadius;
				loc.Y = (1-2*FRand()) * CollisionRadius;
				loc.Z = (1-2*FRand()) * CollisionHeight;
				loc += Location;
				spawn(class'BloodDropFlying');
				chunk = spawn(class'FleshFragment', None,, loc);
                if (chunk != None)
				{
                    chunk.Velocity.Z = FRand() * 410 + 410;
					chunk.bFixedRotationDir = False;
					chunk.RotationRate = RotRand();
				}
             }
	HurtRadius(explosionDamage, explosionRadius, 'Exploded', explosionDamage*100, Location);
}

function Bool HasTwoHandedWeapon()
{
	return False;
}

function float ModifyDamage(int Damage, Pawn instigatedBy, Vector hitLocation,
							Vector offset, Name damageType)
{
	if ((damageType == 'Stunned') || (damageType == 'KnockedOut') || (damageType == 'Poison') || (damageType == 'PoisonEffect'))
		return 0;
	else if (damageType == 'EMP')
	{
	    if (bCloakOn)
	    {
	        CloakThreshold = 0;
	        EnableCloak(false);
	    }
        GotoState('Stunned');
        return Super.ModifyDamage(Damage, instigatedBy, hitLocation, offset, damageType);
	}
    else
		return Super.ModifyDamage(Damage, instigatedBy, hitLocation, offset, damageType);
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

defaultproperties
{
     CarcassType=Class'DeusEx.AnnaNavarreCarcass'
     WalkingSpeed=0.280000
     bImportant=True
     bInvincible=True
     CloseCombatMult=0.500000
     BaseAssHeight=-18.000000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     BurnPeriod=5.000000
     bHasCloak=True
     CloakThreshold=300
     walkAnimMult=1.000000
     runAnimMult=1.075000
     HDTPMesh="HDTPCharacters.HDTPAnna"
     HDTPMeshTex(0)="HDTPCharacters.Skins.HDTPAnnaTex0"
     HDTPMeshTex(1)="HDTPCharacters.Skins.HDTPAnnaTex1"
     HDTPMeshTex(2)="HDTPCharacters.Skins.HDTPAnnaTex2"
     HDTPMeshTex(3)="HDTPCharacters.Skins.HDTPAnnaTex3"
     HDTPMeshTex(4)="HDTPCharacters.Skins.HDTPAnnaTex4"
     HDTPMeshTex(5)="HDTPCharacters.Skins.HDTPAnnaTex5"
     HDTPMeshTex(6)="HDTPCharacters.Skins.HDTPAnnaTex6"
     bIsFemale=True
     GroundSpeed=250.000000
     BaseEyeHeight=38.000000
     Health=500
     HitSound1=Sound'GMDXSFX.Player.fem2grunt2'
     HitSound2=Sound'GMDXSFX.Player.fem2grunt1'
     Die=Sound'GMDXSFX.Player.fem2death'
     HealthHead=600
     HealthTorso=500
     HealthLegLeft=500
     HealthLegRight=500
     HealthArmLeft=500
     HealthArmRight=500
     Mesh=LodMesh'DeusExCharacters.GFM_TShirtPants'
     DrawScale=1.100000
     MultiSkins(0)=Texture'DeusExCharacters.Skins.AnnaNavarreTex0'
     MultiSkins(1)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(2)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(3)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(4)=Texture'DeusExItems.Skins.BlackMaskTex'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.AnnaNavarreTex0'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.PantsTex9'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.AnnaNavarreTex1'
     CollisionHeight=47.299999
     BindName="AnnaNavarre"
     FamiliarName="Anna Navarre"
     UnfamiliarName="Anna Navarre"
     bCanBlink=false                        //mechs blinking looks weird
     bRandomHeightAdjust=false
}
