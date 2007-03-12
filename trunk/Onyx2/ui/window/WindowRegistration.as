package ui.window {
	
	import flash.display.DisplayObject;
	
	import onyx.constants.ROOT;
	
	/**
	 * 	Window Registration
	 */
	public final class WindowRegistration {
		
		public var name:String;
		
		/**
		 * 	@private
		 * 	The definition for the window type
		 */
		private var definition:Class;
		
		/**
		 * 	@private
		 * 	The actual window definition
		 */
		private var window:Window;
		
		/**
		 * 	@constructor
		 */
		public function WindowRegistration(name:String, definition:Class, enabled:Boolean = true):void {
			this.name			= name;
			this.definition		= definition;
			this.enabled		= enabled;
		}
		
		/**
		 * 	Creates windows, etc
		 */
		public function set enabled(value:Boolean):void {
			
			// create the window
			if (value && !window) {
				this.window = ROOT.addChild(new definition()) as Window;
				
			// remove the window
			} else if (!value && window) {

				window.parent.removeChild(window);
				window.dispose();
				window = null;

			}
		}
		
		/**
		 * 	Gets enabled
		 */
		public function get enabled():Boolean {
			return (window !== null);
		}
	}
}