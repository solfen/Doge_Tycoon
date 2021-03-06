package popin;
import popin.MyPopin;
import hud.HudManager;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.DisplayObjectContainer;
import buildings.Building;
import utils.events.Event;

//old popin that is no longer used, I didn't delete it because it was a child of building and it might be usefull to know how to do that later
//It will be deleted at the end though...
class PopinUpgrade extends MyPopin
{	
	private var buildingRef:Building;

	private function new(startX:Float,startY:Float,buildingAttached:Building) 
	{
		if(buildingAttached == null){
			trace('ERROR : NO BUILDING REF PASSED');
			return;
		}
		super(startX,startY, "assets/UI/HudBuildingContextBar.png");
		buildingRef = buildingAttached;
		addIcon(0.75, 0.05,'HudIconBuildNormal.png',"upgradeBtn",this,true,'HudIconBuildActive.png',true);
		icons['upgradeBtn'].scale.set(0.5,0.5);
	}

	// childClick is the function binded on all of the interactive icons (see MyPopin.hx)
	// pEvent is a Dynamic type since Interaction Data thinks pEvent.target is a Sprite while it's actually an IconPopin (ask mathieu if there's an another way)
	override private function childClick(pEvent:Dynamic){
		if(pEvent.target._name == "upgradeBtn"){
			if(GameInfo.ressources['fric'].userPossesion > 0){
				GameInfo.ressources['fric'].userPossesion--;
				buildingRef.upgrade();
				GameInfo.is_building_context_pop_open = false;
				PopinManager.getInstance().closeContextPopin();
			}
		}
	}
	override private function childUpOutside(pEvent:Dynamic){
		if(pEvent.target._name == "upgradeBtn"){
			icons["upgradeBtn"].setTextureToNormal();
		}		
	}
	override public function destroy(){
		Main.getInstance().removeEventListener(Event.GAME_LOOP, scroll);
		buildingRef.removeChild(this);
	}
}