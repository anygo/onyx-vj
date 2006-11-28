package ui.controls.layer {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import onyx.controls.Control;
	import onyx.events.ControlEvent;
	
	import ui.assets.AssetLeftArrow;
	import ui.controls.UIControl;
	import flash.display.DisplayObject;
	import ui.UIManager;
	import ui.layer.UILayer;

	public final class MarkerLeft extends Sprite {

		private var _control:Control;
		
		public function MarkerLeft(control:Control):void {
			
			_control = control;
			_control.addEventListener(ControlEvent.CONTROL_CHANGED, _onChanged);

			var sprite:DisplayObject = addChild(new AssetLeftArrow());
			sprite.x = -sprite.width;

			addEventListener(MouseEvent.MOUSE_DOWN, _onMarkerDown);
		}
		
		/**
		 * 	@private
		 */
		private function _onChanged(event:ControlEvent):void {
			x = event.value * 176 + 8;
		}

		/**
		 * 	@private
		 */
		private function _onMarkerDown(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMarkerMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMarkerUp);
			_onMarkerMove(event);
		}

		/**
		 * 	@private
		 */
		private function _onMarkerMove(event:MouseEvent):void {
			_control.value = (parent.mouseX - 8) / 176;
		}

		/**
		 * 	@private
		 */
		private function _onMarkerUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMarkerMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMarkerUp);
		}

	}
}