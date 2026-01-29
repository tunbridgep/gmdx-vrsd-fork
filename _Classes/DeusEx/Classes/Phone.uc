//=============================================================================
// Phone.
//=============================================================================
class Phone extends ElectronicDevices;

enum ERingSound
{
	RS_Office1,
	RS_Office2,
    RS_None     //SARGE: Added.
};

enum EAnswerSound
{
	AS_Dialtone,
	AS_Busy,
	AS_NotRecognised,
	//AS_CircuitsBusy,   //SARGE: Has no associated sound, removed
    AS_Investigation,    //Locked pending Investigation
    AS_Authorisation,    //Awaiting Authorisation
    AS_ShutDownByUNATCO, //Shut down by UNATCO
	AS_None,             //SARGE: Added. The phone makes no sound at all.
    AS_Random,           //Special case. Plays a random sound. The default, since this is how it was in Vanilla.
};

var() ERingSound RingSound;
var() EAnswerSound AnswerSound;
var() float ringFreq;
var float ringTimer;
var float burstTimer;
var bool bUsing;
var() bool bUnatcoPhone;
var() bool bPayPhone;
var int pSoundID;

var() bool bAnsweringMachine;       //SARGE: If set, we will make no sound the first time we're frobbed, then switch to our AnswerSound.

var private int numRings;           //SARGE: Now, we ring in groups of 3-5 rings, to be more realistic, rather than 1 random ring every so often.

var private int ringBurst;          //SARGE: A bit of a hack to make phones ring in "burst", so they sound semi realistic.

//SARGE: Some of the phones in the game have weird bools set, instead of using the enum (stupid original devs!)
//Lets fix that!
function PostBeginPlay()
{
    if (bindName != "Phone")
        bAnsweringMachine = true;

    if (bUnatcoPhone)
    {
        AnswerSound = AS_Authorisation;
        ringFreq=0.1; //Ring lots and lots.
    }
    else if (bPayphone)
        AnswerSound = AS_ShutDownByUNATCO;
}

function bool InConversation(DeusExPlayer player)
{
    return player != None && player.InConversation();
}

function bool CanRing()
{
    return !bAnsweringMachine && AnswerSound != AS_Investigation && AnswerSound != AS_ShutDownByUNATCO;
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	ringTimer += deltaTime;
	burstTimer += deltaTime;
	
    if (burstTimer >= 1.0 && ringBurst > 0 && numRings > 0)
    {
        burstTimer -= 1.0;
        Ring();
    }

	if (ringTimer >= 2.5)
	{
		ringTimer -= 2.5;

        if (bUsing)
        {
            //do nothing
        }
        else if (numRings > 0 && ringBurst == 0)
            ringBurst = 2;
        else if (numRings == 0 && FRand() < ringFreq && !InConversation(DeusExPlayer(GetPlayerPawn())) && CanRing())
        {
            numRings = Rand(2)+5; //5 to 7 random rings
            ringBurst = 2;
        }
	}
}

function Ring()
{
    numRings--;
    ringBurst--;
    switch (RingSound)
    {
        case RS_Office1:	PlaySound(sound'PhoneRing1', SLOT_Misc,,, 256); break;
        case RS_Office2:	PlaySound(sound'PhoneRing2', SLOT_Misc,,, 256); break;
    }
}

function Timer()
{
	bUsing = False;
	if (bPayphone)
	   StopSound(pSoundID);
}

function Frob(actor Frobber, Inventory frobWith)
{
	local float rnd;

    //no re-frobbing in conversation
    if (Frobber.IsA('DeusExPlayer') && DeusExPlayer(Frobber).InConversation())
        return;

	Super.Frob(Frobber, frobWith);

	if (bUsing)
		return;

    SetTimer(3.0, False);
    numRings = 0;
    ringBurst = 0;
	bUsing = True;

    //If we have an answering machine, play it's custom sound, then allow normal phone use.
    //Make sure to clear the bind name too!
    if (bAnsweringMachine)
    {
        if (!InConversation(DeusExPlayer(Frobber)))
        {
            bAnsweringMachine = false;
            bindName = "";
            ConBindEvents();
        }
        return;
    }

    switch (AnswerSound)
    {
        case AS_DialTone:
            pSoundID = PlaySound(sound'PhoneDialtone', SLOT_Misc,,, 256);
            break;
        case AS_Busy:
            pSoundID = PlaySound(sound'PhoneBusy', SLOT_Misc,,, 256);
            break;
        case AS_NotRecognised:
            pSoundID = PlaySound(sound'PhoneVoice1', SLOT_Misc,,, 256); //Not a recognised user
            break;
        case AS_Investigation:
            pSoundID = PlaySound(sound'PhoneVoice2', SLOT_Misc,,, 256); //Locked pending investigation
            break;
        case AS_Authorisation:
            pSoundID = PlaySound(sound'PhoneVoice3', SLOT_Misc,,, 256); //Awaiting Authorisation
            break;
        case AS_ShutDownByUNATCO:
            pSoundID = PlaySound(sound'PhoneVoice4', SLOT_Misc,,, 256); //Shut down by order of UNATCO
            break;
        case AS_None:
            break;
        case AS_Random:
            rnd = FRand();
            if (rnd < 0.2)
                pSoundID = PlaySound(sound'PhoneBusy', SLOT_Misc,,, 256);
            else if (rnd < 0.4)
                pSoundID = PlaySound(sound'PhoneDialtone', SLOT_Misc,,, 256);
            else if (rnd < 0.6)
                pSoundID = PlaySound(sound'PhoneVoice1', SLOT_Misc,,, 256); //Not a recognised user
            //else if (rnd < 0.7)
                //pSoundID = PlaySound(sound'PhoneVoice2', SLOT_Misc,,, 256); //Locked pending investigation
            else
                pSoundID = PlaySound(sound'PhoneVoice3', SLOT_Misc,,, 256); //Awaiting Authorisation
            //else
                //pSoundID = PlaySound(sound'PhoneVoice4', SLOT_Misc,,, 256); //Shut down by order of Unatco
            break;
    }
}

defaultproperties
{
     ringFreq=0.040000
     bInvincible=False
     FragType=Class'DeusEx.MetalFragment'
     bCanBeBase=True
     ItemName="Telephone"
     Mesh=LodMesh'DeusExDeco.Phone'
     HDTPMesh="HDTPDecos.HDTPphone"
     CollisionRadius=11.870000
     CollisionHeight=3.780000
     Mass=20.000000
     Buoyancy=15.000000
     AnswerSound=AS_Random
}
