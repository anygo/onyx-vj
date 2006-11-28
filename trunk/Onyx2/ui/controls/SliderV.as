package ui.controls {
	
	import flash.events.MouseEvent;
	
	import onyx.controls.Control;
	import onyx.events.ControlEvent;
	
	import ui.text.Style;
	import ui.text.TextField;
	
	public class SliderV extends UIControl {
		
		private var _controlY:Control;
		private var _multiplier:Number;
		private var _factor:Number;
		private var _tempY:Number;

		private var _button:ButtonClear		= new ButtonClear(37, 9);
		private var _value:TextField		= new TextField(40,	11);
		
		public function SliderV(controlY:Control, multiplier:Number = 1, factor:Number = 1):void {

			_controlY = controlY;
			_multiplier = multiplier;
			_factor = factor;

			_value.align = 'center';
			_onControlChange();
			
			addChild(_value);
			addChild(_button);
			
			doubleClickEnabled = true;

			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			addEventListener(MouseEvent.DOUBLE_CLICK, _onDoubleClick);
			
			_controlY.addEventListener(ControlEvent.CONTROL_CHANGED, _onControlChange);
		}
		
		private function _onDoubleClick(event:MouseEvent):void {
			_controlY.reset();
		}

		private function _onMouseDown(event:MouseEvent):void {
			
			_tempY = mouseY + _controlY.value * _multiplier;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

		}
		
		private function _onMouseMove(event:MouseEvent):void {
			_controlY.value = (Math.floor(_tempY - mouseY)) / _multiplier;
		}
		
		private function _onMouseUp(event:MouseEvent):void {
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
		}
		
		private function _onControlChange(event:ControlEvent = null):void {
			_value.text = String(Math.floor(_controlY.value * _multiplier));
		}

		/**
		 * 	@method		cleans up references
		 */
		override public function dispose():void {

			// clean up events
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			removeEventListener(MouseEvent.DOUBLE_CLICK, _onDoubleClick);
			
			_controlY.removeEventListener(ControlEvent.CONTROL_CHANGED, _onControlChange);

			// remove display objects

			removeChild(_value);
			removeChild(_button);
			
			_controlY = null;
			_button = null;
			_value = null;
			
			super.dispose();
		}
	}
}