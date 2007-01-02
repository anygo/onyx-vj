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
		
		protected function _onDoubleClick(event:MouseEvent):void {
			_controlY.reset();
		}

		protected function _onMouseDown(event:MouseEvent):void {
			
			_tempY = mouseY + _controlY.value * _multiplier;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

		}
		
		protected function _onMouseMove(event:MouseEvent):void {
			_controlY.value = (Math.floor(_tempY - mouseY)) / _multiplier;
		}
		
		protected function _onMouseUp(event:MouseEvent):void {
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
		}
		
		protected function _onControlChange(event:ControlEvent = null):void {
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