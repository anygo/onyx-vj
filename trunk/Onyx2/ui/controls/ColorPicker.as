package ui.controls {
	
	import flash.events.MouseEvent;
	import ui.assets.AssetColorPicker;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import onyx.controls.Control;
	import onyx.controls.ControlUInt;

	public final class ColorPicker extends UIControl {
		
		private static var _picker:AssetColorPicker;
		private static var _cursor:Shape;
		
		private var _control:ControlUInt;
		private var _preview:Shape	= new Shape();
		private var _lastX:int		= 0;
		private var _lastY:int		= 0;
		
		public function ColorPicker(control:ControlUInt, width:int = 37, height:int = 9):void {
			
			_control = control;
			
			_draw(width, height);
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			
		}
		
		private function _draw(width:int, height:int):void {
			
			_preview.graphics.beginFill(0x000000);
			_preview.graphics.drawRect(0, 0, width, height);
			_preview.graphics.endFill();

			addChild(_preview);
		}
		
		private function _onMouseDown(event:MouseEvent):void {
			
			_picker = new AssetColorPicker();
			_picker.x = -_lastX + event.localX;
			_picker.y = -_lastY + event.localY;
			
			_cursor = new Shape();
			_cursor.graphics.lineStyle(0, 0x000000);
			_cursor.graphics.drawRect(0,0,2,2);
			_cursor.x = event.localX;
			_cursor.y = event.localY;
			
			addChild(_picker);
			addChild(_cursor);
			
			addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

		}

		public function _onMouseMove(event:MouseEvent):void {
			
			_cursor.x = event.localX;
			_cursor.y = event.localY;
			
			var transform:ColorTransform = new ColorTransform();
			
			_lastX = Math.min(Math.max(_picker.mouseX,0),100);
			_lastY = Math.min(Math.max(_picker.mouseY,0),100);
			
			transform.color = _picker.bitmapData.getPixel(_lastX, _lastY);
			
			_control.value = transform.color;
			
			_preview.transform.colorTransform = transform;
		}

		public function _onMouseUp(event:MouseEvent):void {

			removeChild(_picker);
			removeChild(_cursor);
			
			_picker = null;
			_cursor = null;

			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
		}
		
		public function set color(c:int):void {
			var transform:ColorTransform = new ColorTransform();
			transform.color = c;
			_preview.transform.colorTransform = transform;
		}
	}
}