package popin;
import popin.MyPopin;
import hud.HudManager;
import popin.PopinManager;
import pixi.InteractionData;
import pixi.textures.Texture;
import pixi.display.DisplayObjectContainer;
import buildings.Building;
import utils.events.Event;

//PopinBuild is lauched on HudBuild click (and ambulance click right now)
//PopinBuild inherit form MyPopin who is the base class of all popin
//Basicly any Popin is just a configuration of Mypopin
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