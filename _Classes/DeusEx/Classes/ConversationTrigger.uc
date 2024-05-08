//=============================================================================
// ConversationTrigger.
//=============================================================================
class ConversationTrigger extends Trigger;

//
// Triggers a conversation when touched
//
// * conversationTag is matched to the conversation file which has all of
//   the conversation events in it.
//

var() name conversationTag;
var() string BindName;
var() name checkFlag;
var() bool bCheckFalse;

//LDDP, 10/26/21: Trigger and Touch are BOTH modified with dynamic flag loading. Bear this in mind.
singular function Trigger(Actor Other, Pawn Instigator)
{
	local DeusExPlayer player;
	local bool bSuccess;
	local Actor A, conOwner;
	
	local name UseTag;

	player = DeusExPlayer(Instigator);
	bSuccess = True;

	// only works for DeusExPlayers
	if (player == None)
		return;

	if (checkFlag != '')
	{
		if (!player.flagBase.GetBool(checkFlag))
			bSuccess = bCheckFalse;
		else
			bSuccess = !bCheckFalse;
	}

	if ((BindName != "") && (conversationTag != ''))
	{
		UseTag = ConversationTag;
		if ((Player.FlagBase != None) && (Player.FlagBase.GetBool('LDDPJCIsFemale')))
		{
			UseTag = Player.FlagBase.StringToName("FemJC"$string(UseTag));
		}
		
		foreach AllActors(class'Actor', A)
		{
			if (A.BindName == BindName)
			{
				conOwner = A;
				break;
			}
		}
		
		if (bSuccess)
		{
			if (player.StartConversationByName(UseTag, conOwner))
			{
				Super.Trigger(Other, Instigator);
			}
		}
	}
}

singular function Touch(Actor Other)
{
	local DeusExPlayer player;
	local bool bSuccess;
	local Actor A, conOwner;
	
	local name UseTag;

	player = DeusExPlayer(Other);
	bSuccess = True;

	// only works for DeusExPlayers
	if (player == None)
		return;

	if (checkFlag != '')
	{
		if (!player.flagBase.GetBool(checkFlag))
			bSuccess = bCheckFalse;
		else
			bSuccess = !bCheckFalse;
	}

	if ((BindName != "") && (conversationTag != ''))
	{
		UseTag = ConversationTag;
		if ((Player.FlagBase != None) && (Player.FlagBase.GetBool('LDDPJCIsFemale')))
		{
			UseTag = Player.FlagBase.StringToName("FemJC"$string(UseTag));
		}
		
		foreach AllActors(class'Actor', A)
		{
			if (A.BindName == BindName)
			{
				conOwner = A;
				break;
			}
		}	
		
		if (bSuccess)
		{
			if (player.StartConversationByName(UseTag, conOwner))
			{
				Super.Touch(Other);
			}
		}
	}
}

defaultproperties
{
     bTriggerOnceOnly=True
     CollisionRadius=96.000000
}
