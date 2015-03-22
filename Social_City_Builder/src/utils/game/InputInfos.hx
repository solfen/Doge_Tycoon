package utils.game;

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
	public static var clicked_mouse_x: Int;
	public static var clicked_mouse_y: Int;
	public static var is_mouse_down: Bool;


	public function new (listen_click: Bool, listen_mousemove: Bool): Void
	{
		singleton = this;
		mouse_x = 0;
		mouse_y = 0;
		clicked_mouse_x = 0;
		clicked_mouse_y = 0;
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
	}

	private function _on_mousedown (pData: Dynamic): Void
	{
		is_mouse_down = true;
	}

	private function _on_mouseup (pData: Dynamic): Void
	{
		is_mouse_down = false;
		clicked_mouse_x = pData.clientX;
		clicked_mouse_y = pData.clientY;
	}

	private function _on_mousemove (pData: Dynamic): Void
	{
		mouse_x = pData.clientX;
		mouse_y = pData.clientY;
	}

}