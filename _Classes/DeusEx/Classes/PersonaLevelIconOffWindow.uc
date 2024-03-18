class PersonaLevelIconOffWindow extends PersonaLevelIconWindow;

event InitWindow()
{
	//a: override the default texLevel texture of our parent
	texLevel = Texture(DynamicLoadObject("GMDXSFX.Icons.SkillsOffChicklet", Class'Texture', True));

	Super.InitWindow();
}

event DrawWindow(GC gc)
{
	local int levelCount;
	local Color colIcon;

	//a: if for some reasont the user didn't install our UI package, then just don't draw the icons.
	//done and done.
	if (texLevel == None)
	return;

	gc.SetTileColor(colText);

	//a: we needed to change this. the DSTY_Masked that our parent uses looks awful with our disabled icon
	gc.SetStyle(DSTY_Translucent);

	for(levelCount=0; levelCount<=currentLevel; levelCount++)
	{
		gc.DrawTexture(levelCount * (iconSizeX + 1), 0, iconSizeX, iconSizeY,
			0, 0, texLevel);
	}
}

defaultproperties
{
}
