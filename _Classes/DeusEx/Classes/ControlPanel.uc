//=============================================================================
// ControlPanel.
//=============================================================================
class ControlPanel extends HackableDevices;

function PostBeginPlay()
{
   super.PostBeginPlay();

   if (hackStrength == 0.0)
   bInvincible = True;
}

function StopHacking(optional bool aborted)
{
	Super.StopHacking(aborted);

	if (hackStrength == 0.0)
    {
        PlayAnim('Open');
		PlaySound(Sound'GarageDoorOpen', SLOT_Pain,,,768,1.5); //CyberP: added new sound
    }
}

function HackAction(Actor Hacker, bool bHacked)
{
	local Actor A;

	Super.HackAction(Hacker, bHacked);

	if (bHacked)
	{
		if (Event != '')
			foreach AllActors(class 'Actor', A, Event)
				A.Trigger(Self, Pawn(Hacker));
	}
}

auto state Active                //CyberP:
{
     function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
     {
     local int i;
     //local Actor A;

       if (bInvincible || hackStrength == 0.0)
       return;

       if (Damage > minDamageThreshold)
	   {
                     bInvincible=True;
                     bHighlight=False;
	                 hackStrength=0.0;
                     StopHacking();
                     HackAction(EventInstigator,true);

                     //for (i=0; i<ArrayCount(UnTriggerEvent); i++)
			          //if (UnTriggerEvent[i] != '')
				       // foreach AllActors(class'Actor', A, UnTriggerEvent[i])
					     // A.UnTrigger(player, player);
       }
    Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
    }

}

defaultproperties
{
     HitPoints=160
     minDamageThreshold=80
     bInvincible=False
     FragType=Class'DeusEx.MetalFragment'
     ItemName="Electronic Control Panel"
     Skin=Texture'HDTPDecos.Skins.HDTPControlPanelTex1'
     Mesh=LodMesh'DeusExDeco.ControlPanel'
     SoundRadius=12
     SoundVolume=255
     SoundPitch=96
     AmbientSound=Sound'DeusExSounds.Generic.ElectronicsHum'
     CollisionRadius=14.500000
     CollisionHeight=23.230000
     Mass=10.000000
     Buoyancy=5.000000
}
