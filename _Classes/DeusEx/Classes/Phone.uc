//=============================================================================
// Phone.
//=============================================================================
class Phone extends ElectronicDevices;

enum ERingSound
{
	RS_Office1,
	RS_Office2
};

enum EAnswerSound
{
	AS_Dialtone,
	AS_Busy,
	AS_OutOfService,
	AS_CircuitsBusy
};

var() ERingSound RingSound;
var() EAnswerSound AnswerSound;
var() float ringFreq;
var float ringTimer;
var bool bUsing;
var() bool bUnatcoPhone;
var() bool bPayPhone;
var int pSoundID;

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	ringTimer += deltaTime;

	if (ringTimer >= 1.0)
	{
		ringTimer -= 1.0;

		if (FRand() < ringFreq)
		{
			switch (RingSound)
			{
				case RS_Office1:	PlaySound(sound'PhoneRing1', SLOT_Misc,,, 256); break;
				case RS_Office2:	PlaySound(sound'PhoneRing2', SLOT_Misc,,, 256); break;
			}
		}
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

	Super.Frob(Frobber, frobWith);

	if (bUsing)
		return;

    SetTimer(3.0, False);
	bUsing = True;
    rnd = FRand();
    if (bUnatcoPhone)
    {
		PlaySound(sound'PhoneVoice3', SLOT_Misc,,, 256);
    }
    else if (bPayphone)
    {
        pSoundID = PlaySound(sound'PhoneVoice4',SLOT_Misc,,, 256);
    }
    else
    {
	if (rnd < 0.1)
		PlaySound(sound'PhoneBusy', SLOT_Misc,,, 256);
	else if (rnd < 0.2)
		PlaySound(sound'PhoneDialtone', SLOT_Misc,,, 256);
	else if (rnd < 0.4)
		PlaySound(sound'PhoneVoice1', SLOT_Misc,,, 256);
	else if (rnd < 0.6)
		PlaySound(sound'PhoneVoice2', SLOT_Misc,,, 256);
	else if (rnd < 0.8)
		PlaySound(sound'PhoneVoice3', SLOT_Misc,,, 256);
	else
		PlaySound(sound'PhoneVoice4', SLOT_Misc,,, 256);
    }
}

defaultproperties
{
     ringFreq=0.010000
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
}
