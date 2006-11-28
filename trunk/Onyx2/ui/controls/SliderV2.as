package ui.controls {
	
	import flash.events.MouseEvent;
	
	import onyx.controls.Control;
	import onyx.events.ControlEvent;
	
	import ui.text.Style;
	import ui.text.TextField;
	
	final public class SliderV2 extends UIControl {
		
		private var _controlY:Control;
		private var _controlX:Control;
		private var _tempY:Number;
		private var _tempX:Number;

		private var _multiplier:Number;
		private var _factor:Number;

		private var _button:ButtonClear		= new ButtonClear(37,9);
		private var _value:TextField		= new TextField(40, 11);
		
		public function SliderV2(controlY:Control, controlX:Control, invert:Boolean = false, multiplier:Number = 1, factor:Number = 1):void {

			_controlY = controlY;
			_controlX = controlX;
			_multiplier = multiplier;
			_factor = factor;

			_value.align = 'center';
			_onControlChange();
			
			addChild(_value);
			addChild(_button);

			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, _onDoubleClick);

			_controlY.addEventListener(ControlEvent.CONTROL_CHANGED, _onControlChange);
			_controlX.addEventListener(ControlEvent.CONTROL_CHANGED, _onControlChange);
			
			addEventListener(MouseEvent.MOUSE_DOWN, (invert) ? _onMouseDownInvert : _onMouseDownNormal);

		}
		
		private function _onDoubleClick(event:MouseEvent):void {
			_controlY.reset();
			_controlX.reset();
		}

		private function _onMouseDownNormal(event:MouseEvent):void {
			
			_tempY = (_controlY.value) - (mouseY / _multiplier);
			_tempX = (_controlX.value) - (mouseX / _multiplier);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveNormal);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

		}
		
		private function _onMouseMoveNormal(event:MouseEvent):void {
			_controlY.value = _tempY + (mouseY / _multiplier);
			_controlX.value = _tempX + (mouseX / _multiplier);
		}

		private function _onMouseDownInvert(event:MouseEvent):void {
			
			_tempY = (mouseY / _multiplier) - (_controlY.value * _multiplier);
			_tempX = (mouseX / _multiplier) - (_controlX.value * _multiplier);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveInvert);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

		}
		
		private function _onMouseMoveInvert(event:MouseEvent):void {
			_controlY.value = (mouseY - _tempY) / _multiplier;
			_controlX.value = (mouseX - _tempX) / _multiplier;
		}
		
		private function _onMouseUp(event:MouseEvent):void {
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveInvert);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveNormal);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
		}
		
		private function _onControlChange(event:ControlEvent = null):void {
			_value.text = String(Math.floor(_controlX.value * _multiplier)) + ':' + String(Math.floor(_controlY.value * _multiplier));
		}

	}
}