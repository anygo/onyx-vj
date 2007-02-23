package ui.states {
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import onyx.constants.ROOT;
	import onyx.states.ApplicationState;
	
	import ui.core.UIManager;
	import ui.layer.UILayer;

	public final class KeyListenerState extends ApplicationState {
		
		public static var SELECT_PAGE_0:int	= 81;
		public static var SELECT_PAGE_1:int	= 87;
		public static var SELECT_PAGE_2:int	= 69;
		
		override public function initialize(... args:Array):void {
			
			// listen for keys
			ROOT.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyPress);
		}
		
		/**
		 * 	Terminates the keylistener
		 */
		override public function terminate():void {
			
			// remove listener
			ROOT.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyPress);

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
				case 52:
				case 53:
					UILayer.selectLayer(UILayer.layers[event.keyCode - 49]);
					break;
				case SELECT_PAGE_0:
				
					for each (layer in UILayer.layers) {
						layer.selectPage(0);
					}
					
					break;
				case SELECT_PAGE_1:
				
					for each (layer in UILayer.layers) {
						layer.selectPage(1);
					}
					
					break;
				case SELECT_PAGE_2:
				
					for each (layer in UILayer.layers) {
						layer.selectPage(2);
					}
					
					break;
				default:
					// trace(event.keyCode);
					// break;
			}
		}

	}
}