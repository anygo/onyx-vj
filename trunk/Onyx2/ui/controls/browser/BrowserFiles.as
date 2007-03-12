package ui.controls.browser {
	
	import ui.assets.*;
	import ui.controls.*;
	import ui.core.UIObject;
	import flash.display.DisplayObject;

	public final class BrowserFiles extends UIObject {

		/**
		 * 	@constsructor
		 */
		public function BrowserFiles(options:UIOptions, name:String):void {
			
			var width:int	= options.width;
			var height:int	= options.height;

			// create a background color			
			displayBackground(width, height);
			
			// add a label
			addLabel(name.toUpperCase(), width, height, 1);

			// add a button
			var sprite:DisplayObject = addChild(new AssetFolder());
			sprite.x = 3;
			sprite.y = 2;
			addChild(new ButtonClear(width, height));
		}
		
	}
}