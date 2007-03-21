package ui.window {
	
	import onyx.constants.ROOT;
	import onyx.core.Onyx;
	import onyx.display.*;
	import onyx.events.DisplayEvent;
	import onyx.layer.ILayer;
	
	import ui.controls.TextButton;
	import ui.layer.UILayer;
	import ui.styles.MENU_OPTIONS;
	
	/**
	 * 	Layer Window
	 */
	public final class LayerWindow extends Window {
		
		/**
		 * 	@constructor
		 */
		public function LayerWindow():void {
			
			// position and create window
			super(null, 0, 0);

			// listen and create layer controls
			var display:IDisplay = Display.getDisplay(0);
			display.addEventListener(DisplayEvent.LAYER_CREATED, _onLayerCreate);
			
			// create already created layers
			for each (var layer:ILayer in display.layers) {
				_onLayerCreate(null, layer);
			}

		}
		
		/**
		 * 	@private
		 */
		private function _onLayerCreate(event:DisplayEvent = null, layer:ILayer = null):void {
			
			var layer:ILayer = (event) ? event.layer : layer;
			
			var uilayer:UILayer = new UILayer(layer);
			uilayer.reOrderLayer();

			addChildAt(uilayer, 0);
		}
	}
}