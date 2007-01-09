package ui.states {
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	import onyx.application.ApplicationState;
	
	import ui.layer.UILayer;

	public final class KeyListenerState extends ApplicationState
	{
		override public function initialize(... args:Array):void {
			var root:Stage = args[0];
			
			// listen for keys
			root.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyPress);
		}
		
		override public function terminate():void {
		}
		
		/**
		 * 	@private
		 */
		private static function _onKeyPress(event:KeyboardEvent):void {
			
			var layer:UILayer;
			
			switch (event.keyCode) {
				case 37:
					layer = UILayer.getLayerAt(UILayer.selectedLayer.index - 1);
					if (layer) {
						UILayer.selectLayer(layer);
					}
					
					break;
				case 39:
					layer = UILayer.getLayerAt(UILayer.selectedLayer.index + 1);
					if (layer) {
						UILayer.selectLayer(layer);
					}

					break;
				case 38:
				case 40:
					break;
			}
		}

	}
}