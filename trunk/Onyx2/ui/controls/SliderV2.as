/** 
 * Copyright (c) 2003-2006, www.onyx-vj.com
 * All rights reserved.	
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * -  Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 * 
 * -  Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 * 
 * -  Neither the name of the www.onyx-vj.com nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software without 
 *    specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
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