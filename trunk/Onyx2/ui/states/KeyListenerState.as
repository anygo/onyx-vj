package ui.states {
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import onyx.states.ApplicationState;
	
	import ui.layer.UILayer;

	public final class KeyListenerState extends ApplicationState {
		
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
					UILayer.selectedLayer.selectFilterUp(true);
					break;
				case 40:
					UILayer.selectedLayer.selectFilterUp(false);
					break;
				case 49:
				case 50:
				case 51:
					for each (layer in UILayer.layers) {
						layer.selectPage(event.keyCode - 49);
					}
					break;
				default:
			}
		}

	}
}