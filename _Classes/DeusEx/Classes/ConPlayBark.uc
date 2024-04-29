//=============================================================================
// ConPlayBark
//=============================================================================
class ConPlayBark expands Actor;

var Conversation con;

// ----------------------------------------------------------------------
// SetConversation()
// ----------------------------------------------------------------------

function SetConversation(Conversation newCon)
{
	con = newCon;
}

// ----------------------------------------------------------------------
// GetBarkSpeech()
// ----------------------------------------------------------------------

function ConSpeech GetBarkSpeech()
{
	local ConEvent event;
	local ConSpeech outSpeech;

	// Abort if we don't have a valid conversation
	if (con == None)
		return None;

	// Default return value
	outSpeech = None;

	// Loop through the events until we hit some speech
	event = con.eventList;

	while(event != None)
	{
		switch(event.eventType)
		{
			case ET_Speech:
				outSpeech = ConEventSpeech(event).conSpeech;
				event = None;
				break;
			
			case ET_Jump:
				event = ProcessEventJump(ConEventJump(event));
				break;

			// Transcended - Flag checks
			//LDDP, 10/25/21: Adding this note so you can find it by Ctrl+F. Howdy.
			case ET_CheckFlag:
				event = ProcessEventCheckFlag(ConEventCheckFlag(event));
				break;

			case ET_Random:
				event = ProcessEventRandomLabel(ConEventRandomLabel(event));
				break;

			case ET_End:
				event = None;
				break;

			default:
				event = event.nextEvent;
				break;
		}
	}

	return outSpeech;
}

// ----------------------------------------------------------------------
// ProcessEventJump()
// ----------------------------------------------------------------------

function ConEvent ProcessEventJump(ConEventJump event)
{
	local ConEvent nextEvent;

	// Check to see if the jump label is empty.  If so, then we just want
	// to fall through to the next event.  This can happen when jump
	// events get inserted during the import process.  ConEdit will not
	// allow the user to create events like this. 

	if (event.jumpLabel == "")
	{
		nextEvent = event.nextEvent;
	}
	else
	{
		if ((event.jumpCon != None) && (event.jumpCon != con))
			nextEvent = None;			// not yet supported
		else
			nextEvent = con.GetEventFromLabel(event.jumpLabel);
	}

	return nextEvent;
}

// ----------------------------------------------------------------------
// ProcessEventRandomLabel()
// ----------------------------------------------------------------------

function ConEvent ProcessEventRandomLabel(ConEventRandomLabel event)
{
	local String nextLabel;

	// Pick a random label
	nextLabel = event.GetRandomLabel();

	return con.GetEventFromLabel(nextLabel);
}

// ----------------------------------------------------------------------
// ProcessEventCheckFlag()
// ----------------------------------------------------------------------

function ConEvent ProcessEventCheckFlag(ConEventCheckFlag event)
{
	local ConFlagRef currentRef;
	local ConEventJump eventJump;
	local DeusExPlayer player;
	local ConEvent ret;
	
	player = DeusExPlayer(GetPlayerPawn());
	
	//If we can't get a hold of the player, just continue to the next event.
	if (player == None)
		return event.NextEvent;
	
	// Loop through our list of FlagRef's, checking the value of each.
	// If we hit a bad match, then we'll stop right away since there's
	// no point of continuing.
	for (currentRef = event.flagRef; currentRef != None; currentRef = currentRef.nextFlagRef)
	{
		if (player.flagBase.GetBool(currentRef.flagName) != currentRef.value)
			return event.nextEvent;
	}
	
	eventJump = new class'ConEventJump';
	eventJump.jumpLabel = event.setLabel;
	ret = ProcessEventJump(eventJump);
	CriticalDelete(eventJump); //Get rid of this now so we don't have to wait for gc.
	
	//If we've made it so far, it means all flags were checked successfully. Jump to the label.	
	return ret;
}

defaultproperties
{
}
