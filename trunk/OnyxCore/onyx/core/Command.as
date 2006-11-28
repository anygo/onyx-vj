package onyx.core {

	import onyx.display.Display;
	import onyx.layer.Layer;
	import onyx.application.Onyx;

	internal final class Command {
		
		private static var _display:Display;

		/*
		public static function display(num:int):String {
			var display:Display = Engine.getDisplayAt(num);
			
			if (!display) {
				return 'Display not found.';
			} else {
				_display = display;
				return 'Using Display #' + num;
			}
		}
		
		public static function layer(num:int, prop:String, value:Number):String {
			
			if (!_display) {
				return 'No display selected.  Use command "display 0" to select a display.';
			}
			
			var layer:Layer = _display.getLayerAt(0);
			layer[prop] = value;
			
			return 'setting ' + prop + ' to ' + value;
	
		}
		*/

	}

}