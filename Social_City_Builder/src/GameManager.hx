package;


import sprites.Ambulance;
import utils.events.Event;
import utils.game.IsoTools;
import Main;
import pixi.display.Sprite;
import pixi.textures.Texture;

/**
 * Manager (Singleton) en charge de gérer le déroulement d'une partie
 * @author Mathieu ANTHOINE
 */
class GameManager
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

			
	}
	
	public function start (): Void {
		
		
		
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