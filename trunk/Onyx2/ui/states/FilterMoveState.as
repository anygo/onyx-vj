package ui.states {
	
	import flash.events.MouseEvent;
	
	import onyx.application.ApplicationState;
	import onyx.application.StateManager;
	
	import ui.controls.filter.LayerFilter;

	public final class FilterMoveState extends ApplicationState {
		
		private var _origin:LayerFilter;
		private var _filters:Array;
		
		override public function initialize(... args:Array):void {

			_origin = args[0];
			_filters = args[1];
			
			_origin.stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

			for each (var filter:LayerFilter in _filters) {
				if (filter !== _origin) {
					filter.addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
				}
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseOver(event:MouseEvent):void {
			var control:LayerFilter = event.currentTarget as LayerFilter;
			
			_origin.filter.moveFilter(control.filter.index);
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseUp(event:MouseEvent):void {
			StateManager.removeState(this);
		}
		
		override public function terminate():void {
			_origin.stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

			for each (var filter:LayerFilter in _filters) {
				filter.removeEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			}
			
			_origin = null;
			_filters = null;
		}
	}
}