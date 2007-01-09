package ui.controls {
	
	import ui.core.UIObject;
	
	public final class TextButton extends UIObject {
		
		public function TextButton(options:UIOptions, name:String):void {
			
			var width:int	= options.width;
			var height:int	= options.height;
			
			displayBackground(width, height);
			addLabel(name, 'center', width, height, 1);

			addChild(new ButtonClear(width, height));
		}
	}
}