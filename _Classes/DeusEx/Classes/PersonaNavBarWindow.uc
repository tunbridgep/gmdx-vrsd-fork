//=============================================================================
// PersonaNavBarWindow
//=============================================================================
class PersonaNavBarWindow expands PersonaNavBarBaseWindow;

var PersonaNavButtonWindow btnInventory;
var PersonaNavButtonWindow btnHealth;
var PersonaNavButtonWindow btnAugs;
var PersonaNavButtonWindow btnSkills;
var PersonaNavButtonWindow btnGoals;
var PersonaNavButtonWindow btnCons;
var PersonaNavButtonWindow btnImages;
var PersonaNavButtonWindow btnLogs;

var localized String InventoryButtonLabel;
var localized String HealthButtonLabel;
var localized String AugsButtonLabel;
var localized String SkillsButtonLabel;
var localized String GoalsButtonLabel;
var localized String ConsButtonLabel;
var localized String ImagesButtonLabel;
var localized String LogsButtonLabel;

//Sarge: Outfits button
var PersonaNavButtonWindow btnOutfits;

var localized String OutfitsButtonLabel;
var localized String ImgButtonLabelShort; //Ygll: Added
var localized String LogButtonLabel;

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	btnLogs      = CreateNavButton(winNavButtons, LogsButtonLabel);
	btnImages    = CreateNavButton(winNavButtons, ImagesButtonLabel);
	btnCons      = CreateNavButton(winNavButtons, ConsButtonLabel);
    CreateOutfitsButton();                  //Sarge: Added
	btnGoals     = CreateNavButton(winNavButtons, GoalsButtonLabel);
	btnSkills    = CreateNavButton(winNavButtons, SkillsButtonLabel);
	btnAugs      = CreateNavButton(winNavButtons, AugsButtonLabel);
	btnHealth    = CreateNavButton(winNavButtons, HealthButtonLabel);
	btnInventory = CreateNavButton(winNavButtons, InventoryButtonLabel);

	Super.CreateButtons();
}

// ----------------------------------------------------------------------
// CreateOutfitsButton()
// Will shorten the Conversations button to fit it in
// ----------------------------------------------------------------------

function CreateOutfitsButton()
{
    local class<PersonaScreenBaseWindow> test;
    test = class<PersonaScreenBaseWindow>(DynamicLoadObject("Augmentique.PersonaScreenOutfits", class'Class'));

    //Only create the Outfits button if the outfits window is actually available
    if (test != None)
    {
		btnOutfits   = CreateNavButton(winNavButtons, OutfitsButtonLabel);
		btnImages.SetButtonText(ImgButtonLabelShort);
		btnLogs.SetButtonText(LogButtonLabel);
    }
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local Class<PersonaScreenBaseWindow> winClass;

	bHandled = True;

	switch(buttonPressed)
	{
		case btnInventory:
			winClass = Class'PersonaScreenInventory';
			break;

		case btnHealth:
			winClass = Class'PersonaScreenHealth';
			break;

		case btnAugs:
			winClass = Class'PersonaScreenAugmentations';
			break;

		case btnSkills:
			winClass = Class'PersonaScreenSkills';
			break;

		case btnGoals:
			winClass = Class'PersonaScreenGoals';
			break;

		case btnCons:
			winClass = Class'PersonaScreenConversations';
			break;

		case btnImages:
			winClass = Class'PersonaScreenImages';
			break;

		case btnLogs:
			winClass = Class'PersonaScreenLogs';
			break;

        //Sarge: Add new button for Outfits
		case btnOutfits:
            winClass = class<PersonaScreenBaseWindow>(DynamicLoadObject("Augmentique.PersonaScreenOutfits", class'Class'));
			break;

		default:
			bHandled = False;
			break;
	}

	if (bHandled)
	{
		PersonaScreenBaseWindow(GetParent()).SaveSettings();
		if (Player.bRealUI || Player.bHardCoreMode)    //CyberP: no pause
			root.InvokeUIScreen(winClass,true);
		else
			root.InvokeUIScreen(winClass);
		return bHandled;
	}
	else
	{
		return Super.ButtonActivated(buttonPressed);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     InventoryButtonLabel="|&Inventory"
     HealthButtonLabel="|&Health"
     AugsButtonLabel="|&Augs"
     SkillsButtonLabel="|&Skills"
     GoalsButtonLabel="|&Goals/Notes"
     ConsButtonLabel="|&Conversations"
     ImagesButtonLabel="I|&mages"
     LogsButtonLabel="|&Logs"
     OutfitsButtonLabel="|&Outfit"
     ImgButtonLabelShort="I|&mg."
     LogButtonLabel="|&Log"
}
