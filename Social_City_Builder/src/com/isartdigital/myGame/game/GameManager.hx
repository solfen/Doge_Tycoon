package com.isartdigital.myGame.game;


import com.isartdigital.myGame.game.sprites.Ambulance;
import com.isartdigital.myGame.ui.UIManager;
import com.isartdigital.utils.events.Event;
import com.isartdigital.utils.game.IsoTools;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.IAction;
import pixi.display.Sprite;
import pixi.textures.Texture;

/**
 * Manager (Singleton) en charge de gérer le déroulement d'une partie
 * @author Mathieu ANTHOINE
 */
class GameManager implements IAction
{
	
	/**
	 * instance unique de la classe GameManager
	 */
	private static var instance: GameManager;
	
	/**
	 * background temporaire 
	 */
	private var background:Sprite;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GameManager {
		if (instance == null) instance = new GameManager();
		return instance;
	}
	
	private function new() {
		background = new Sprite(Texture.fromImage("assets/game.png"));
		background.anchor.set(0.5, 0.5);
	}
	
	public function start (): Void {
		
		// background
		GameStage.getInstance().getGameContainer().addChild(background);
		
		// ambulance
		var lAmbulance:Ambulance = new Ambulance();
		GameStage.getInstance().getGameContainer().addChild(lAmbulance);

		lAmbulance.position.set(100, 100);
		
		UIManager.getInstance().startGame();
		
		Main.getInstance().addEventListener(Event.GAME_LOOP, doAction);
		
		var lTL:Sprite = new Sprite (Texture.fromImage("assets/alpha_bg.png"));
		lTL.anchor.set(0.5, 0.5);
		GameStage.getInstance().addChild(lTL);
		
		var lTR:Sprite = new Sprite (Texture.fromImage("assets/alpha_bg.png"));
		GameStage.getInstance().addChild(lTR);
		lTR.x = GameStage.getInstance().safeZone.width;
		
		var lBL:Sprite = new Sprite (Texture.fromImage("assets/alpha_bg.png"));
		lBL.anchor.set(0.5, 0.5);
		GameStage.getInstance().addChild(lBL);
		lBL.y = GameStage.getInstance().safeZone.height;
		
		var lBR:Sprite = new Sprite (Texture.fromImage("assets/alpha_bg.png"));
		lBR.anchor.set(0.5, 0.5);
		GameStage.getInstance().addChild(lBR);
		lBR.x = GameStage.getInstance().safeZone.width;
		lBR.y = GameStage.getInstance().safeZone.height;		
		
		
	}
	
	/**
	 * boucle de jeu (répétée à la cadence du jeu en fps)
	 */
	public function doAction (): Void {

	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		Main.getInstance().removeEventListener(Event.GAME_LOOP,doAction);
		instance = null;
	}

}