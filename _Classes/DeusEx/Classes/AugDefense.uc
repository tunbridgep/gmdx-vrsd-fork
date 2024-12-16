//=============================================================================
// AugDefense.
//=============================================================================
class AugDefense extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;
var bool bDefenseActive;

var float defenseSoundTime;
const defenseSoundDelay = 2;

// ----------------------------------------------------------------------------
// Networking Replication
// ----------------------------------------------------------------------------

replication
{
   //server to client variable propagation.
   reliable if (Role == ROLE_Authority)
      bDefenseActive;

   //server to client function call
   reliable if (Role == ROLE_Authority)
      TriggerDefenseAugHUD, SetDefenseAugStatus;
}

state Active
{
	function Timer()
	{
		local DeusExProjectile minproj;
		local float mindist;

		minproj = None;

      // DEUS_EX AMSD Multiplayer check
      if (Player == None)
      {
         SetTimer(0.1,False);
         return;
      }

		// In multiplayer propagate a sound that will let others know their in an aggressive defense field
		// with range slightly greater than the current level value of the aug
		if ( (Level.NetMode != NM_Standalone) && ( Level.Timeseconds > defenseSoundTime ))
		{
			Player.PlaySound(Sound'AugDefenseOn', SLOT_Interact, 1.0, ,(LevelValues[CurrentLevel]*1.33), 0.75);
			defenseSoundTime = Level.Timeseconds + defenseSoundDelay;
		}

        //DEUS_EX AMSD Exported to function call for duplication in multiplayer.
        
        if (player.Energy > GetAdjustedEnergyRate())
            minproj = FindNearestProjectile();
            
		// if we have a valid projectile, send it to the aug display window
		if (minproj != None)
		{
            bDefenseActive = True;
            mindist = VSize(Player.Location - minproj.Location);
                

			if (mindist < LevelValues[CurrentLevel])
			{
                minproj.bAggressiveExploded = True;
                minproj.aggressiveExploder = Player;
				minproj.Explode(minproj.Location, vect(0,0,1));
                player.Energy -= GetAdjustedEnergyRate();
				Player.PlaySound(sound'ProdFire', SLOT_None,,,, 2.0);
			}
            
            // play a warning sound
            //SARGE: prevent earrape by only beeping when a projectile is about to enter our range
			if (mindist < LevelValues[CurrentLevel] + 600)
                Player.PlaySound(sound'GEPGunLock', SLOT_None,0.6,,, 2.0);
            else
                minproj = None; //Dirty hack. Clear this so that nothing gets passed to the aug display window

            // DEUS_EX AMSD In multiplayer, let the client turn his HUD on here.
            // In singleplayer, turn it on normally.
            if (Level.Netmode != NM_Standalone)
                TriggerDefenseAugHUD();
            else
            {
                SetDefenseAugStatus(True,CurrentLevel,minproj);
            }
		}
		else
		{
         if ((Level.NetMode == NM_Standalone) || (bDefenseActive))
            SetDefenseAugStatus(False,CurrentLevel,None);
         bDefenseActive = false;
		}
	}

Begin:
	SetTimer(0.1, True);
        Player.PlaySound(Sound'AugDefenseOn', SLOT_Interact, 0.85, ,768,1.0); //CyberP: added sound
}

function Deactivate()
{
	Super.Deactivate();

	SetTimer(0.1, False);
   SetDefenseAugStatus(False,CurrentLevel,None);
}

// ------------------------------------------------------------------------------
// FindNearestProjectile()
// DEUS_EX AMSD Exported to a function since it also needs to exist in the client
// TriggerDefenseAugHUD;
// ------------------------------------------------------------------------------

simulated function DeusExProjectile FindNearestProjectile()
{
   local DeusExProjectile proj, minproj;
   local float dist, mindist;
   local bool bValidProj;

   minproj = None;
   mindist = 999999;
   foreach AllActors(class'DeusExProjectile', proj)
   {
      if (Level.NetMode != NM_Standalone)
         bValidProj = !proj.bIgnoresNanoDefense;
      else
         bValidProj = (!proj.IsA('Dart')&&!proj.IsA('PlasmaBolt')&&!proj.IsA('Cloud') && !proj.IsA('Tracer') && !proj.IsA('GreaselSpit') && !proj.IsA('GraySpit')
                   && !proj.IsA('Fireball') && !proj.IsA('Shuriken') && !proj.IsA('PlasmaRobot') && !proj.IsA('RubberBullet')); //RSD: Also not these

        //SARGE: Dirty hack to prevent scripted grenades from triggering it
        bValidProj = bValidProj && (!proj.IsA('GasGrenade') || !GasGrenade(proj).bScriptedGrenade);
        
        bValidProj = bValidProj && (!proj.IsA('ThrownProjectile') || !ThrownProjectile(proj).bProximityTriggered);

      if (bValidProj)
      {
         // make sure we don't own it
         if (proj.Owner != Player)
         {
			 // MBCODE : If team game, don't blow up teammates projectiles
			if (!((TeamDMGame(Player.DXGame) != None) && (TeamDMGame(Player.DXGame).ArePlayersAllied(DeusExPlayer(proj.Owner),Player))))
			{
				// make sure it's moving fast enough
				if (VSize(proj.Velocity) > 100)
				{
				   dist = VSize(Player.Location - proj.Location);
				   if (dist < mindist)
				   {
					  mindist = dist;
					  minproj = proj;
				   }
				}
			}
         }
      }
   }

   return minproj;
}

// ------------------------------------------------------------------------------
// TriggerDefenseAugHUD()
// ------------------------------------------------------------------------------

simulated function TriggerDefenseAugHUD()
{
   local DeusExProjectile minproj;

   minproj = None;

   minproj = FindNearestProjectile();

   // if we have a valid projectile, send it to the aug display window
   // That's all we do.
   if (minproj != None)
   {
      SetDefenseAugStatus(True,CurrentLevel,minproj);
   }
}

simulated function Tick(float DeltaTime)
{
   Super.Tick(DeltaTime);

   // DEUS_EX AMSD Make sure it gets turned off in multiplayer.
   if (Level.NetMode == NM_Client)
   {
      if (!bDefenseActive)
         SetDefenseAugStatus(False,CurrentLevel,None);
   }
}

// ------------------------------------------------------------------------------
// SetDefenseAugStatus()
// ------------------------------------------------------------------------------
simulated function SetDefenseAugStatus(bool bDefenseActive, int defenseLevel, DeusExProjectile defenseTarget)
{
   if (Player == None)
      return;
   if (Player.rootWindow == None)
      return;
   DeusExRootWindow(Player.rootWindow).hud.augDisplay.bDefenseActive = bDefenseActive;
   DeusExRootWindow(Player.rootWindow).hud.augDisplay.defenseLevel = defenseLevel;
   DeusExRootWindow(Player.rootWindow).hud.augDisplay.defenseTarget = defenseTarget;

}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
		defenseSoundTime=0;
	}
}

defaultproperties
{
     mpAugValue=500.000000
     mpEnergyDrain=35.000000
     EnergyRate=5.000000 //Was 40 when Active, now per projectile
     EnergyRateLabel="Energy Rate: %d Units/Projectile"
     Icon=Texture'DeusExUI.UserInterface.AugIconDefense'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconDefense_Small'
     AugmentationType=Aug_Automatic
     AugmentationName="Aggressive Defense System"
     Description="Aerosol nanoparticles are released upon the detection of objects fitting the electromagnetic threat profile of missiles and grenades; these nanoparticles will prematurely detonate such objects prior to reaching the agent. The particles will additionally shape the detonation away from the agent, resulting in a significant reduction in damage from detonated objects.|n|nTECH ONE: The range at which incoming rockets and grenades are detonated is short, and damage is reduced slightly.|n|nTECH TWO: The range at which detonation occurs is increased slightly and damage is reduced by a small amount.|n|nTECH THREE: The range at which detonation occurs is increased moderately and damage is reduced by a moderate amount.|n|nTECH FOUR: Rockets and grenades are detonated almost before they are fired and damage is reduces significantly."
     MPInfo="When active, enemy rockets detonate when they get close, doing reduced damage.  Some large rockets may still be close enough to do damage when they explode.  Energy Drain: Low"
     LevelValues(0)=400.000000
     LevelValues(1)=600.000000
     LevelValues(2)=800.000000
     LevelValues(3)=1000.000000
     MPConflictSlot=7
}
