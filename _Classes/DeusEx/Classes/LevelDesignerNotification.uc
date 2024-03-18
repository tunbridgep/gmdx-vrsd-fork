//-----------------------------------------------------------
//  LevelDesignerNotification
//-----------------------------------------------------------
class LevelDesignerNotification expands Triggers;

var() string readMe;

//CyberP AKA Totalitarian: this is NOT a trigger. It's for level designers to place
//in maps to leave comments for other level designers in specific locations.
//Since I am both the level designer and programmer (and mostly everything else), I've coded this
//primarily so I can leave comments in maps for fans that want to mod GMDX in the future.

//Use the readMe string.

defaultproperties
{
     readMe="INSERT COMMENT HERE"
     Texture=Texture'Engine.ConsoleBack'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideActors=False
}
