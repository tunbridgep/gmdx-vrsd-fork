//=============================================================================
// SkillAwardTrigger.
//=============================================================================
class SkillAwardTrigger expands Trigger;

// Gives the player skill points when touched or triggered
// Set bCollideActors to False to make it triggered

var() int skillPointsAdded;
var() localized String awardMessage;
var localized String totalMessage;

function Trigger(Actor Other, Pawn Instigator)
{
	local DeusExPlayer player;
	Super.Trigger(Other, Instigator);

	player = DeusExPlayer(Instigator);

	if (player != None)
	{
		player.SkillPointsAdd(skillPointsAdded);
		player.ClientMessage(awardMessage);
		if (player.bSkillMessage)
		   if (player.SkillPointsAvail > 2000 && FRand() < 0.1)
             player.ClientMessage(totalMessage @ player.SkillPointsAvail);
		//== Y|y: we need to ACTUALLY pay attention to the bTriggerOnceOnly variable
		if(bTriggerOnceOnly)
		{
			Tag = '';
			Destroy();
		}
	}
}

function Touch(Actor Other)
{
	local DeusExPlayer player;

	Super.Touch(Other);
	if (IsRelevant(Other))
	{
		player = DeusExPlayer(Other);

		if (player != None)
		{
			player.SkillPointsAdd(skillPointsAdded);
			SkillPointsAdded=0; //GMDX only give award once, if any situation fails and this is called again.
			player.ClientMessage(awardMessage);
			if (player.bSkillMessage)
			{
			if (player.SkillPointsAvail > 2000 && FRand() < 0.15)
                player.ClientMessage(totalMessage @ player.SkillPointsAvail);
            else if (player.SkillPointsAvail > 4000 && FRand() < 0.15) //CyberP: greater chance to display with more points
                player.ClientMessage(totalMessage @ player.SkillPointsAvail);
            }
            if(bTriggerOnceOnly)
			Tag = '';
		}
   }

}

defaultproperties
{
     skillPointsAdded=10
     awardMessage="DEFAULT SKILL AWARD MESSAGE - REPORT THIS AS A BUG"
     totalMessage="Total Skill Points Available:"
     bTriggerOnceOnly=True
}
