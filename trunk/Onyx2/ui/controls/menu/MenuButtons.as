package ui.controls.menu {
	
	import flash.display.Sprite;
	
	import ui.controls.UIControl;
	import ui.controls.UIOptions;
	import ui.core.UIObject;

	public final class MenuButtons extends UIControl {
		
		/**
		 * 	@constructor
		 */
		public function MenuButtons():void {
			
			var options:UIOptions	= new UIOptions();
			options.background		= true;
			
			super(options, true);
		}
		
	}
}