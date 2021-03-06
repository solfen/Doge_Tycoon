package utils.game;

import utils.system.DeviceCapabilities;
import js.Browser;

/**
 * ...
 * @author Lucien BOUDY
 */
class InputInfos
{
	public static var singleton: InputInfos;
	public static var mouse_x: Int;
	public static var mouse_y: Int;
	public static var last_mouse_down_x: Int;
	public static var last_mouse_down_y: Int;
	public static var last_mouse_up_x: Int;
	public static var last_mouse_up_y: Int;
	public static var mouse_wheel_dir: Int;
	public static var is_mouse_down: Bool;


	public function new (listen_click: Bool, listen_mousemove: Bool, listen_wheel: Bool): Void
	{
		singleton = this;
		mouse_x = 0;
		mouse_y = 0;
		last_mouse_down_x = 0;
		last_mouse_down_y = 0;
		last_mouse_up_x = 0;
		last_mouse_up_y = 0;
		mouse_wheel_dir = 0;
		is_mouse_down = false;

		if (listen_click)
		{
			Browser.window.onmousedown = _on_mousedown;
			Browser.window.onmouseup = _on_mouseup;
		}

		if (listen_mousemove)
		{
			Browser.window.onmousemove = _on_mousemove;
		}

		if (listen_wheel)
		{
			Browser.window.addEventListener('wheel', _on_wheel, false);
		}
	}

	private function _on_mousedown (pData: Dynamic): Void
	{
		pData.preventDefault();
		is_mouse_down = true;
		last_mouse_down_x = pData.clientX;
		last_mouse_down_y = pData.clientY;
	}

	private function _on_mouseup (pData: Dynamic): Void
	{
		is_mouse_down = false;
		last_mouse_up_x = pData.clientX;
		last_mouse_up_y = pData.clientY;
	}

	private function _on_mousemove (pData: Dynamic): Void
	{
		mouse_x = pData.clientX;
		mouse_y = pData.clientY;
	}
	private function _on_wheel (pData: Dynamic):Void
	{
		pData.preventDefault();
		//trace("wheel:", pData.deltaY); // multiple de 100 sur chrome, multiple de 3 sur firefox
		mouse_wheel_dir = pData.deltaY < 0 ? -1 : 1; // uniquement la direction


		// dirty, to try the zoom feature

		//IsoMap.singleton.scale.x -= mouse_wheel_dir * 0.1; // zoom
		//IsoMap.singleton.scale.y -= mouse_wheel_dir * 0.1;
		
		// 1/ redéfinir la taille des cellules isométriques

		// current cell

		// 2/ déplacer la map pour "recentrer" autour du curseur (sauvegarder l'ancienne position)


		//IsoMap.singleton.x += (mouse_x - DeviceCapabilities.width * 0.5) * 0.1;
		//IsoMap.singleton.y += (mouse_y - DeviceCapabilities.height * 0.5) * 0.1;

		//IsoMap.singleton.x += Std.int(128*64 * 0.05 + 0.5) * mouse_wheel_dir;
		//IsoMap.singleton.y += Std.int(64*64 * 0.05 + 0.5) * mouse_wheel_dir;

		//trace("zoom: ", IsoMap.singleton.scale.x);

	}

}