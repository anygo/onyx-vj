package ui.controls.browser {

	import flash.display.DisplayObject;
	
	import ui.assets.AssetIconCamera;
	import ui.controls.*;
	import ui.core.UIObject;

	public final class BrowserCameras extends UIObject {

		/**
		 * 	@constsructor
		 */
		public function BrowserCameras(options:UIOptions, name:String):void {
			
			var width:int	= options.width;
			var height:int	= options.height;

			// create a background color			
			displayBackground(width, height);
			
			// add a label
			addLabel(name.toUpperCase(), width, height, 1);

			// add a button
			var sprite:DisplayObject = addChild(new AssetIconCamera());
			sprite.x = 3;
			sprite.y = 2;

			addChild(new ButtonClear(width, height));
		}
		
	}
}