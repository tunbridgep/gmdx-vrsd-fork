//=============================================================================
// PaulDenton.
//=============================================================================
class PaulDenton extends HumanMilitary;

//
// Damage type table for Paul Denton:
//
// Shot			- 100%
// Sabot		- 100%
// Exploded		- 100%
// TearGas		- 10%
// PoisonGas	- 10%
// Poison		- 10%
// PoisonEffect	- 10%
// HalonGas		- 10%
// Radiation	- 10%
// Shocked		- 10%
// Stunned		- 0%
// KnockedOut   - 0%
// Flamed		- 0%
// Burned		- 0%
// NanoVirus	- 0%
// EMP			- 0%
//

function float ShieldDamage(name damageType)
{
	// handle special damage types
	if ((damageType == 'Flamed') || (damageType == 'Burned') || (damageType == 'Stunned') ||
	    (damageType == 'KnockedOut'))
		return 0.0;
	else if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'HalonGas') ||
			(damageType == 'Radiation') || (damageType == 'Shocked') || (damageType == 'Poison') ||
	        (damageType == 'PoisonEffect'))
		return 0.1;
	else
		return Super.ShieldDamage(damageType);
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

function UpdateHDTPSettings()
{
	super.UpdateHDTPsettings();

	setskin(deusexplayer(getplayerpawn()));
}


// ----------------------------------------------------------------------
// SetSkin()
// ----------------------------------------------------------------------

function SetSkin(DeusExPlayer player)
{
    local Texture tex1, tex2;
	if (player != None)
	{
		if(IsHDTP())
		{
            switch(player.PlayerSkin)
            {
                case 0:	tex1 = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPPaulDentonTex0"); tex2 = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPJCHandsTex0"); break;
                case 1:	tex1 = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPPaulDentonTex2"); tex2 = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPJCHandsTex1"); break;
                case 2:	tex1 = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPPaulDentonTex3"); tex2 = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPJCHandsTex2"); break;
                case 3:	tex1 = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPPaulDentonTex4"); tex2 = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPJCHandsTex3"); break;
                case 4:	tex1 = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPPaulDentonTex5"); tex2 = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPJCHandsTex4"); break;
            }
            multiskins[0] = tex1;
            multiskins[3] = tex2;
		}
		else
		{
			switch(player.PlayerSkin)
			{
				case 0:	MultiSkins[0] = Texture'PaulDentonTex0';
						MultiSkins[3] = Texture'PaulDentonTex0';
						break;
				case 1:	MultiSkins[0] = Texture'PaulDentonTex4';
						MultiSkins[3] = Texture'PaulDentonTex4';
						break;
				case 2:	MultiSkins[0] = Texture'PaulDentonTex5';
						MultiSkins[3] = Texture'PaulDentonTex5';
						break;
				case 3:	MultiSkins[0] = Texture'PaulDentonTex6';
						MultiSkins[3] = Texture'PaulDentonTex6';
						break;
				case 4:	MultiSkins[0] = Texture'PaulDentonTex7';
						MultiSkins[3] = Texture'PaulDentonTex7';
						break;
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     CarcassType=Class'DeusEx.PaulDentonCarcass'
     WalkingSpeed=0.120000
     bImportant=True
     bInvincible=True
     BaseAssHeight=-23.000000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponPlasmaRifle')
     InitialInventory(3)=(Inventory=Class'DeusEx.AmmoPlasma')
     InitialInventory(4)=(Inventory=Class'DeusEx.WeaponSword')
     BurnPeriod=0.000000
     bHasCloak=True
     CloakThreshold=100
     HDTPMeshName="HDTPCharacters.HDTPGM_Trench"
     HDTPMeshTex(0)="HDTPCharacters.skins.HDTPPaulDentonTex0"
     HDTPMeshTex(1)="HDTPCharacters.skins.HDTPPaulDentonTex1"
     HDTPMeshTex(2)="HDTPCharacters.Skins.HDTPJCDentonTex2"
     HDTPMeshTex(3)="HDTPCharacters.Skins.HDTPJCDentonTex3"
     HDTPMeshTex(4)="HDTPCharacters.Skins.HDTPJCDentonTex4"
     HDTPMeshTex(5)="DeusExItems.Skins.PinkMaskTex"
     HDTPMeshTex(6)="DeusExItems.Skins.PinkMaskTex"
     HDTPMeshTex(7)="DeusExItems.Skins.PinkMaskTex"
     Health=350
     HealthHead=350
     HealthTorso=350
     HealthLegLeft=350
     HealthLegRight=350
     HealthArmLeft=350
     HealthArmRight=350
     Mesh=LodMesh'DeusExCharacters.GM_Trench'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.PaulDentonTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.PaulDentonTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.PantsTex8'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.PaulDentonTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.PaulDentonTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.PaulDentonTex2'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="PaulDenton"
     FamiliarName="Paul Denton"
     UnfamiliarName="Paul Denton"
}
