//=============================================================================
// TraceHitSpawner class so we can reduce nettraffic for hitspangs
//=============================================================================
class TraceHitSpawner extends Actor;

var float HitDamage;
var bool bPenetrating; // shot that hit was a penetrating shot
var bool bHandToHand;  // shot that hit was hand to hand
var bool bInstantHit;
var Name damageType;
var bool bForceBulletHole;

function bool IsHDTP()
{
    return class'HDTPLoader'.static.HDTPInstalled() && class'DeusExDecal'.default.iHDTPModelToggle > 0;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Owner == None)
	  SetOwner(Level);

	//GMDX:dasraiser argh :)
	HitDamage=class'TraceHitSpawner'.default.HitDamage;
	damageType=class'TraceHitSpawner'.default.damageType;

	SpawnEffects(Owner,HitDamage);
}

simulated function Timer()
{
	Destroy();
}

//
// we have to use an actor to play the hit sound at the correct location
//
simulated function PlayHitSound(actor destActor, Actor hitActor)
{
	local float rnd;
	local sound snd;
	local name texName,texGroup;

	// don't ricochet unless it's hit by a bullet
	if ((damageType != 'Shot') && (damageType != 'Sabot'))
		return;

	rnd = FRand();

	// CyberP: play a different ricochet sound dependant on surface texture

		if (GetFloorMaterial(texGroup) == 'Metal')
        {
		   if (rnd < 0.25)
		      snd = sound'HMETAL1';
	       else if (rnd < 0.5)
		      snd = sound'HMETAL2';
	       else if (rnd < 0.75)
	          snd = sound'HMETAL3';
       	   else
	    	  snd = sound'HMETAL4';
	    }
	    /*else if (GetFloorMaterial(texGroup) == 'Wood')
        {
		   if (FRand() < 0.5)
		      snd = sound'WoodH1';
	       else
		      snd = sound'WoodH2';
	    }
	    else if (GetFloorMaterial(texGroup) == 'Concrete' || GetFloorMaterial(texGroup) == 'Stone' || GetFloorMaterial(texGroup) == 'Brick' )
        {
		   if (rnd < 0.5)
		      snd = sound'BulletConcrete1';
	       else
		      snd = sound'BulletConcrete3';
	       //else
	       //   snd = sound'BulletConcrete4';
	    }
	    else if (GetFloorMaterial(texGroup) == 'Water')
        {
		   if (rnd < 0.5)
		      snd = sound'BulletWater1';
	       else
		      snd = sound'BulletWater4';
	    }
	    else if (GetFloorMaterial(texGroup) == 'Earth' || GetFloorMaterial(texGroup) == 'Foilage')
        {
		   if (rnd < 0.33)
		      snd = sound'BulletDirt1';
	       else if (rnd < 0.66)
		      snd = sound'BulletDirt2';
		   else
		      snd = sound'BulletDirt3';
	    } */ //cyberP: all these sounds based on surface are refusing to play except for metal...strange.
	    else
	    {
	    if (rnd < 0.25)
		snd = sound'Ricochet1';
	else if (rnd < 0.5)
		snd = sound'Ricochet2';
	else if (rnd < 0.75)
		snd = sound'Ricochet3';
	else
		snd = sound'Ricochet4';
	    }
	if (destActor != None)
		destActor.PlaySound(snd, SLOT_None,,, 2048, 1.1 - 0.2*FRand());
}

// ----------------------------------------------------------------------
// GetFloorMaterial() copied from dxPlayer, used here to kill some effects
//
// gets the name of the texture group that we are standing on
// ----------------------------------------------------------------------
function name GetFloorMaterial(optional out name Tname)
{
	local vector EndTrace,StartTrace, HitLocation, HitNormal;
	local actor target;
	local int texFlags;
	local name texName, texGroup;

	// trace down to our feet
	EndTrace = Location + Vector(Rotation)*-10;
   StartTrace = Location + Vector(Rotation)*16;

	foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace,StartTrace)
	{
		if ((target == Level) || target.IsA('Mover'))
			break;
	}

   //log("GRAB FLOOR "@texGroup@"."@texName);
   Tname=texName;
	return texGroup;
}

simulated function SpawnEffects(Actor Other, float Damage)
{
	local SmokeTrail puff2;
	local int i;
	local BulletHole hole;
	local RockChip chip;
	local Rotator rot;
	local DeusExMover mov;
	local GMDXSparkFade		spark;
	local SFXHitPuff plume;
	local SFXExp puff;
	local BurnMark ems_burn;
    local WoodFragment wf;
	local name texName,texGroup;

	//log("SpawnEffects Other="@Other@" Damage="@Damage@" damageType="@damageType@" bHandToHand="@bHandToHand@" bPenetrating="@bPenetrating@" HitDamage="@HitDamage@" bInstantHit="@bInstantHit);

	SetTimer(0.1,False);
	if (Level.NetMode == NM_DedicatedServer)
	  return;

   //texGroup=GetFloorMaterial(texName);
   //log("TRACE FLOOR Name:-"@texName@" Group:-"@texGroup);

	if (bPenetrating && !bHandToHand && Other != none)
	{
	    if (GetFloorMaterial(texGroup)=='Metal')
	    {
	      puff2 = spawn(class'SmokeTrail',,,Location+(Vector(Rotation)*1.75), Rotation);
			if ( puff2 != None )
			{
			puff2.DrawScale = 0.35; //1
			puff2.OrigScale = puff2.DrawScale;
			puff2.LifeSpan = 1.0;
	        puff2.OrigLifeSpan = puff2.LifeSpan;
	        }
	        else
		    {
			if (FRand() < 0.5)
			{
				puff2 = spawn(class'SmokeTrail',,,Location+Vector(Rotation), Rotation);
				if (puff2 != None)
				{
					puff2.DrawScale *= 0.2; //0.3
					puff2.OrigScale = puff2.DrawScale;
					puff2.LifeSpan = 0.25;
					puff2.OrigLifeSpan = puff2.LifeSpan;
			   puff2.RemoteRole = ROLE_None;
				}
			}
		 }
         }
         else
         {
		//	puff = spawn(class'SmokeTrail',,,Location+(Vector(Rotation)*1.75), Rotation);
		puff = spawn(class'SFXExp',,,Location+(Vector(Rotation)*1.75), Rotation);
			if ( puff != None )
			{
			//	puff.DrawScale = 0.35; //1
			//	puff.OrigScale = puff.DrawScale;
			//	puff.LifeSpan = 1.0;
		//		puff.OrigLifeSpan = puff.LifeSpan;
		        puff.scaleFactor=0.01;
		        puff.scaleFactor2=2.25;
		        puff.GlowFactor=0.2;
		        puff.animSpeed=0.015;
			    puff.RemoteRole = ROLE_None;
			}

		else
		{
			if (FRand() < 0.5)
			{
				puff = spawn(class'SFXExp',,,Location+Vector(Rotation), Rotation);
				if (puff != None)
				{
					//puff.DrawScale *= 0.2; //0.3
					//puff.OrigScale = puff.DrawScale;
					//puff.LifeSpan = 0.25;
					//puff.OrigLifeSpan = puff.LifeSpan;
			   //puff.RemoteRole = ROLE_None;
			   puff.scaleFactor=0.01;
		        puff.scaleFactor2=2.25;
		        puff.GlowFactor=0.2;
		        puff.animSpeed=0.015;
			    puff.RemoteRole = ROLE_None;
				}
			}
		 }
		}
	 if (!Other.IsA('DeusExMover'))
		 for (i=0; i<2+(Damage/10); i++)
			if (FRand() < 0.8)
			{
			   chip = spawn(class'Rockchip',,,Location+Vector(Rotation));
			   if (chip != None)
			   {
				  chip.RemoteRole = ROLE_None;
				  chip.Velocity*=(1+Damage*0.125); //CyberP: was *0.05
				  chip.LifeSpan*=0.5;
				  if (GetFloorMaterial(texGroup)=='Wood')
				  {
				  chip.Skin = Texture'GMDXSFX.Skins.WoodBoxTex';
				  chip.Velocity.Z+= 10;
				  if (i < 6)
				  {
				  wf = spawn(class'WoodFragment',,,Location+Vector(Rotation));
				  if (wf != None)
				  {
				  wf.DrawScale*= 0.1 + (FRand()*0.1);
				  wf.Velocity=VRand()*180;
				  wf.Velocity.Z+= 60;
				  wf.ImpactSound=None;
				  wf.MiscSound=None;
				  wf.RotationRate=RotRand();
				  }
				  }
				  }
				}
			}
	}
//dasraiser im surprised this works :) there is hope
if (Other != none)
{
	if (!bHandToHand && bInstantHit && bPenetrating)
	{
	  hole = spawn(class'BulletHole', Other,, Location/*+Vector(Rotation)*/, Rotation);
	  if (hole != None)
		 hole.RemoteRole = ROLE_None;

         if (GetFloorMaterial(texGroup)=='Glass' && hole != none)
         {
            hole.Texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXTex29","DeusExItems.Skins.FlatFXTex29",IsHDTP());
            if (IsHDTP())
            {
                hole.DrawScale = 0.05625;
                hole.drawscale *= 1.0 + frand()*0.2;
            }
            else
                hole.DrawScale = 0.1;
            hole.ReattachDecal();
        }
        else if (GetFloorMaterial(texGroup)=='Brick' && hole != none)
        {
          if (FRand() < 0.5)
              hole.Texture = Texture'GMDXSFX.Decals.FlatFXTex7a';
          else
              hole.Texture = Texture'GMDXSFX.Decals.FlatFXTex8a';
          hole.DrawScale = 0.06525;
	      hole.drawscale *= 1.0 + frand()*0.2;
	      hole.ReattachDecal();
        }

		if ( !Other.IsA('Pawn') && !Other.IsA('DeusExCarcass') )		// Sparks on people look bad
		{
         if (GetFloorMaterial(texGroup)!= '' && GetFloorMaterial(texGroup)!='Foliage' && GetFloorMaterial(texGroup)!='Earth'
         && GetFloorMaterial(texGroup)!='Wood' && GetFloorMaterial(texGroup)!='Glass')
         {
           spawn(class'GMDXImpactSpark');   //CyberP: we won't use a for loop as slower.
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
           spawn(class'GMDXImpactSpark2');
			spark = spawn(class'GMDXSparkFade',,,Location+Vector(Rotation)*2.0, Rotation); //cyberP: was *4.5
			if (spark != None)
			{
				spark.RemoteRole = ROLE_None;   PlayHitSound(spark, Other);
				if (damageType == 'Sabot')                                  //if ( Level.NetMode != NM_Standalone )
				{
                 spark.DrawScale=0.120000;
				 spark.Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPMuzzleflashLarge7","DeusExItems.Skins.FlatFXTex29",IsHDTP());
				 spark.LightRadius=3;
				 spark.LightBrightness=255;
                 spark.LightSaturation=192;
                 spark.LightHue=8;                       	        //else
				}                                 			//	spark.DrawScale = 0.2;
				                               				 //PlayHitSound(spark, Other);
			}
			}
			if (HitDamage >= 50)
			{
			plume=spawn(class'SFXHitPuff',,, Location/*+Vector(Rotation)*/, Rotation);//spawn(class'GMDXFireSmokeFade',,, Location/*+Vector(Rotation)*/, Rotation);
			if (plume!=none)
		   {
		      //plume.animSpeed=0.007000;
		      plume.DrawScale*=0.015;
		      //plume.LifeSpan=15;//plume.DrawScale;
		   }
		   }
		}
	}

	// draw the correct damage art for what we hit
	if (bPenetrating || bHandToHand)
	{
		if (Other.IsA('DeusExMover') || Other == Level)
		{
			mov = DeusExMover(Other);
			if (hole == None) //(mov != None) && (
            {
                hole = spawn(class'BulletHole', Other,, Location+Vector(Rotation), Rotation);
                if (hole != None)
                {
                    hole.remoteRole = ROLE_None;
                    hole.Texture = Texture'FlatFXTex8';
                }
            }

			if (hole != None)
			{
				if (mov != none )// && mov.bBreakable && mov.minDamageThreshold <= Damage) //SARGE: Allow glass-holes on glass objects always
				{
					// don't draw damage art on destroyed movers, or ones we can't damage
                    //SARGE: Always show it, the tooltip will tell us
					if (mov.bDestroyed)// || (mov.minDamageThreshold > Damage))
						hole.Destroy();
					else if (mov.FragmentClass == class'GlassFragment')
					{
						// glass hole
                        if (IsHDTP())
							hole.Texture = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPFlatFXTex29");
						else if (FRand() < 0.5)
						    hole.Texture = Texture'FlatFXTex29';
						else
							hole.Texture = Texture'FlatFXTex30';

                        if (IsHDTP())
                        {
                            hole.DrawScale = 0.05625;
                            hole.drawscale *= 1.0 + frand()*0.2;
                        }
                        else
                        {
                            hole.DrawScale = 0.1;
                        }
						hole.ReattachDecal();
					}
					else
					{
						// non-glass crack
						if (mov.FragmentClass == class'MetalFragment')
						{
	    					if (FRand() < 0.5)
							    hole.Texture = Texture'FlatFXTex7';
						    else
							    hole.Texture = Texture'FlatFXTex8';
							hole.DrawScale = 0.75;
						}
						else if (mov.FragmentClass == class'WoodFragment' || mov.FragmentClass == class'Rockchip')
						{
						    if (FRand() < 0.5)
							hole.Texture = Texture'FlatFXTex7b';
						    else
							hole.Texture = Texture'FlatFXTex8b';
							hole.DrawScale = 0.25;
						}
						else
						{
						if (FRand() < 0.5)
							hole.Texture = Texture'FlatFXTex7';
						else
							hole.Texture = Texture'FlatFXTex8';
							hole.DrawScale = 0.75;
                        }
						hole.ReattachDecal();
					}
				}
				else
				{
					if (!bPenetrating || bHandToHand)
					{
                    if (GetFloorMaterial(texGroup)!= '' && GetFloorMaterial(texGroup)!='Foliage' && GetFloorMaterial(texGroup)!='Earth' && GetFloorMaterial(texGroup)!='Glass'
                    && GetFloorMaterial(texGroup)!='Wood' && GetFloorMaterial(texGroup)!='Concrete' && GetFloorMaterial(texGroup)!='Stone')
						{
						if (GetFloorMaterial(texGroup)=='Metal')
						{
	    					if (FRand() < 0.5)
							    hole.Texture = Texture'FlatFXTex7';
						    else
							    hole.Texture = Texture'FlatFXTex8';
						}
						else
						{
                            if (FRand() < 0.5)
							    hole.Texture = Texture'FlatFXTex7';
						    else
							    hole.Texture = Texture'FlatFXTex8';
                        }
                        hole.DrawScale = 0.004500;
                        hole.ReattachDecal();//hole.Destroy();
                        }
                        else if (GetFloorMaterial(texGroup)=='Wood' || GetFloorMaterial(texGroup)=='Concrete' || GetFloorMaterial(texGroup)=='Stone')
                        {
                        if (FRand() < 0.5)
							hole.Texture = Texture'FlatFXTex7';
						else
							hole.Texture = Texture'FlatFXTex8';

						hole.DrawScale = 0.004500;
						hole.ReattachDecal();
                        }
                        else if (GetFloorMaterial(texGroup)=='Glass')
                        {
                        hole.Texture = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXTex29","DeusExItems.Skins.FlatFXTex29",IsHDTP());
						if (IsHDTP())
							hole.DrawScale = 0.05;
						else
							hole.DrawScale = 0.5;
	                    hole.drawscale *= 1.0 + frand()*0.2;
	                    hole.ReattachDecal();
                        }
                     }
				}
			}
		}
	}
	class'TraceHitSpawner'.default.bForceBulletHole=false; //dasraiser: wow this should not be how to ;)

	//GMDX:just do these too, incase
	class'TraceHitSpawner'.default.HitDamage=-1;
	class'TraceHitSpawner'.default.damageType='';

	//default.bForceBulletHole=false; dasraiser: surprised this didn't work!
}
}

defaultproperties
{
     HitDamage=-1.000000
     bPenetrating=True
     bInstantHit=True
     RemoteRole=ROLE_None
     DrawType=DT_None
     bGameRelevant=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
