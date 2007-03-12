package ui.window {
	
	import flash.utils.Dictionary;
	
	import onyx.errors.*;
	
	import ui.controls.TextButton;
	import ui.styles.MENU_OPTIONS;
	import ui.controls.MenuButton;
	import flash.events.MouseEvent;
	
	/**
	 * 	Menu Window
	 */
	public final class MenuWindow extends Window {
		
		/**
		 * 	@private
		 */
		private static const windows:Array = [];
		
		/**
		 * 	@private
		 */
		private static const definition:Dictionary = new Dictionary(true);
		
		/**
		 * 	Registers windows
		 */
		public static function register(... args:Array):void {
			
			for each (var reg:WindowRegistration in args) {
				
				definition[reg.name] = reg;
				windows.push(reg);
				
				instance.createButton(reg);
			}
		}
		
		/**
		 * 	Returns the instance
		 */
		public static const instance:MenuWindow		= new MenuWindow();

		/**
		 * 	@constructor
		 */
		public function MenuWindow():void {
			
			// position and create window
			super(null, 100, 100, 200, 744);

		}
		
		/**
		 * 	@private
		 * 	Creates a button related to the window class
		 */
		private function createButton(reg:WindowRegistration):void {
			
			// get index
			var index:int = windows.indexOf(reg);
			
			// create control
			var control:MenuButton = new MenuButton(reg, MENU_OPTIONS);
			control.x = (index % 6) * (MENU_OPTIONS.width + 2);
			control.y = Math.floor(index / 6) * (MENU_OPTIONS.height + 2);

			addChild(control);
			
		}
	}
}