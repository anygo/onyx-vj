package ui.window {
	
	import onyx.controls.IControlObject;
	import flash.display.DisplayObject;
	
	/**
	 * 	Displays a patch
	 */
	public final class PatchWindow extends Window {
		
		/**
		 * 	@private
		 */
		private static var instance:PatchWindow;
		
		/**
		 * 
		 */
		public static function display(origin:DisplayObject, obj:IControlObject):void {
			instance.display(origin, obj);
		}
		
		/**
		 * 	@constructor
		 */
		public function PatchWindow():void {
			super('PATCH', 396, 200, 614, 318);
			instance = this;
		}
		
		/**
		 * 
		 */
		public function display(origin:DisplayObject, obj:IControlObject):void {
			trace(origin, obj.controls);
		}
	}
}