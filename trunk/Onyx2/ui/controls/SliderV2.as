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
	import onyx.controls.ControlProxy;
	import onyx.events.ControlEvent;
	import onyx.net.Stream;
	
	import ui.text.Style;
	import ui.text.TextField;
	
	final public class SliderV2 extends UIControl {
		
		private var _controlY:Control;
		private var _controlX:Control;
		private var _tempY:Number;
		private var _tempX:Number;

		private var _multiplier:Number;
		private var _factor:Number;

		private var _button:ButtonClear;
		private var _value:TextField;
		
		/**
		 * 	@constructor
		 */
		public function SliderV2(options:UIOptions, control:Control):void {

			var proxy:ControlProxy = control as ControlProxy;
			var width:int	= options.width;
			var height:int	= options.height;
			var multiplier:Number	= 1;
			var factor:Number		= 1;
			var invert:Boolean		= false;
			
			if (proxy.metadata) {
				var metadata:Object = proxy.metadata;
				multiplier	= (metadata.multiplier is Number) ? metadata.multiplier : multiplier;
				factor		= (metadata.factor is Number) ? metadata.factor : factor;
				invert		= (metadata.invert is Boolean) ? metadata.invert : invert;
			}
			
			super(options, proxy.display);

			_button = new ButtonClear(width,	height);
			_value	= new TextField(width + 3,	height);

			_controlY = proxy.controlY;
			_controlX = proxy.controlX;
			
			_multiplier = multiplier;
			_factor = factor;

			_value.align	= 'center';
			_value.y		= 1;
			_value.text		= Math.floor(_controlY.value * _multiplier) + ':' + Math.floor(_controlX.value * _multiplier);	
			
			addChild(_value);
			addChild(_button);

			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, _onDoubleClick);

			_controlY.addEventListener(ControlEvent.CONTROL_CHANGED, _onControlChange);
			_controlX.addEventListener(ControlEvent.CONTROL_CHANGED, _onControlChange);
			
			addEventListener(MouseEvent.MOUSE_DOWN, (invert) ? _onMouseDownInvert : _onMouseDownNormal);

		}
		
		/**
		 * 	@private
		 */
		private function _onDoubleClick(event:MouseEvent):void {
			_controlY.reset();
			_controlX.reset();
		}

		/**
		 * 	@private
		 */
		private function _onMouseDownNormal(event:MouseEvent):void {
			
			_tempY = (_controlY.value) - (mouseY / _multiplier);
			_tempX = (_controlX.value) - (mouseX / _multiplier);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveNormal);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseMoveNormal(event:MouseEvent):void {
			
			if (event.shiftKey) {
				var x:Number = (mouseY + mouseX) / _multiplier / 2;
				var y:Number = x;
			} else {
				x = mouseY / _multiplier;
				y = mouseX / _multiplier;
			}
			
			_controlY.value = _tempY + x;
			_controlX.value = _tempY + y;
		}

		/**
		 * 	@private
		 */
		private function _onMouseDownInvert(event:MouseEvent):void {
			
			_tempY = (mouseY / _multiplier) - (_controlY.value * _multiplier);
			_tempX = (mouseX / _multiplier) - (_controlX.value * _multiplier);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveInvert);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

		}
		
		/**
		 * 	@private
		 */
		private function _onMouseMoveInvert(event:MouseEvent):void {
			
			if (event.shiftKey) {
				
				trace(mouseY, _tempY);
				trace(mouseX, _tempX);
				
			} else {
				_controlY.value = (mouseY - _tempY) / _multiplier;
				_controlX.value = (mouseX - _tempX) / _multiplier;
			}
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveInvert);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveNormal);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		/**
		 * 	@private
		 */
		private function _onControlChange(event:ControlEvent):void {
			
			var control:Control = event.currentTarget as Control;
			
			if (control === _controlY) {
				var x:Number = _controlX.value;
				var y:Number = event.value;
			} else {
				x = event.value;
				y = _controlY.value;
			}
			
			_value.text = String(Math.floor(x * _multiplier)) + ':' + String(Math.floor(y * _multiplier));
		}

	}
}