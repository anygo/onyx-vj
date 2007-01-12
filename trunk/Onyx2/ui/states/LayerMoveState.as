package ui.states {
	
	import flash.events.MouseEvent;
	
	import onyx.states.ApplicationState;
	import onyx.states.StateManager;
	import onyx.layer.Layer;
	
	import ui.layer.UILayer;
	import onyx.controls.Control;

	/**
	 * 	When a layer is clicked and dragged, this state allows the layer to be moved by dragging
	 */
	public final class LayerMoveState extends ApplicationState {

		/**
		 * 	@private
		 */		
		private var origin:UILayer;
		
		/**
		 * 
		 */
		override public function initialize(... args:Array):void {

			origin = args[0];

			// listen for rollover events for all layers except the one that originated the layer
			for each (var layer:UILayer in UILayer.layers) {
				if (layer !== origin) {
					layer.addEventListener(MouseEvent.MOUSE_OVER, _onLayerOver);
				}
			}

			// listen for mouse up
			origin.stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		/**
		 * 	@private
		 * 	When mouse is hovered over another layer
		 */
		private function _onLayerOver(event:MouseEvent):void {
			var layer:UILayer = event.currentTarget as UILayer;
			origin.moveLayer(layer.index);

			// if control key is down, swap the blendModes			
			if (event.shiftKey) {
				var originBlend:String	= origin.blendMode;
				var newBlend:String		= layer.blendMode;
				
				var originControl:Control = origin.layer.properties.blendMode;
				var newControl:Control = layer.layer.properties.blendMode;
				
				originControl.value = newBlend;
				newControl.value = originBlend;
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseUp(event:MouseEvent):void {
			StateManager.removeState(this);
		}

		/**
		 * 	Terminates state
		 */
		override public function terminate():void {
			if (origin) {
				origin.stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			}

			for each (var layer:UILayer in UILayer.layers) {
				layer.removeEventListener(MouseEvent.MOUSE_OVER, _onLayerOver);
			}
			
			origin = null;
		}
	}
}