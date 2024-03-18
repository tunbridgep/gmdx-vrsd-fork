//=============================================================================
// EnterWorldTrigger.
//=============================================================================
class ScriptedGrenadeTrigger extends Trigger;

var ProjectileGenerator ProjGen;
var(Trigger) bool bNoMoverCheck;
var(Trigger) float CheckHumanRadius;
var(Trigger) float CheckMoverRadius;
var(Trigger) float CheckGasRadius;
//CyberP: Sends a unhide event when touched or triggered. Only works on pawns and vehicles, at least for now.
// Set bCollideActors to False to make it triggered

/*function Trigger(Actor Other, Pawn Instigator)
{
	local ScriptedPawn A;
    local Vehicles B;

	if(Event != '')
	{
		foreach AllActors(class 'ScriptedPawn', A, Event)
                    A.PutInWorld(true);
        foreach AllActors(class 'Vehicles', B, Event)
                    B.PutInWorld(true);
    }
}*/

function Touch(Actor Other)    //Scripted hackage!!!
{
	local GasGrenade GG, PG;
	local HumanMilitary HM;
    local DeusExMover DM;
    local DeusExPlayer player;
    local int i;

	if (IsRelevant(Other))
	{
		if(FRand() < 0.1)
		{
		    player = DeusExPlayer(GetPlayerPawn());
		    /*if (Player != None)
		    {
		        if (Player.aDrone != None || Player.AugmentationSystem.GetAugLevelValue(class'AugVision') >= 320 || (Player.UsingChargedPickup(class'TechGoggles') && Player.PerkNamesArray[28] == 1))
		            return;
		    }*/
            foreach RadiusActors(class'HumanMilitary', HM, CheckHumanRadius)
            {
                if (HM.IsInState('Attacking') && !HM.IsA('MJ12Commando'))
                {
                    if (bNoMoverCheck)
                    {
                        if (i < 1)
                            HM.PlayAnimPivot('Attack',,0.2);
                        if (HM.AnimSequence == 'Attack')
                            i++;
                        foreach RadiusActors(class'GasGrenade', GG, CheckGasRadius)
                        {
                        GG.bHidden = False;
                        GG.SetPhysics(PHYS_Falling);
                        GG.Velocity = 1200.0 * Vector(GG.Rotation);
                        GG.RotationRate = RotRand(True);
                        GG.SetTimer(3.0, False);
                        GG.SetCollision(True, True, True);
                        GG.bScriptedGrenade = False;
                        break;
                        }
                    }
                    else
                    {
                        ForEach RadiusActors(class'DeusExMover', DM, CheckMoverRadius)
                        {
                            if (DM.KeyNum == 1)
                            {
                                if (i < 1)
                                   HM.PlayAnimPivot('Attack',,0.2);
                                if (HM.AnimSequence == 'Attack')
                                   i++;
                                ForEach RadiusActors(class'GasGrenade', GG, CheckGasRadius)
                                {
                                GG.bHidden = False;
                                GG.SetPhysics(PHYS_Falling);
                                GG.Velocity = 1200.0 * Vector(GG.Rotation);
                                GG.RotationRate = RotRand(True);
                                GG.SetTimer(3.0, False);
                                GG.SetCollision(True, True, True);
                                GG.bScriptedGrenade = False;
                                break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

defaultproperties
{
     CheckHumanRadius=1256.000000
     CheckMoverRadius=512.000000
     CheckGasRadius=1024.000000
}
