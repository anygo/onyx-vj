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
	import onyx.controls.ControlNumber;
	import onyx.events.ControlEvent;
	
	import ui.text.TextField;
	
	/**
	 * 	Slider
	 */
	public class SliderV extends UIControl {
		
		/**
		 * 	@private
		 */
		protected var _controlY:ControlNumber;
		
		/**
		 * 	@private
		 */
		protected var _multiplier:Number;
		
		/**
		 * 	@private
		 */
		protected var _factor:Number;
		
		/**
		 * 	@private
		 */
		protected var _tempY:Number;

		/**
		 * 	@private
		 */
		protected var _button:ButtonClear;
		
		/**
		 * 	@private
		 */
		protected var _value:TextField;
		
		/**
		 * 	@private
		 */
		protected var _mouseY:int;
		
		/**
		 * 	@constructor
		 */
		public function SliderV(options:UIOptions, controlY:Control):void {

			super(options, true, controlY.display);
			
			var width:int			= options.width;
			var height:int			= options.height;
			var multiplier:Number	= 1;
			var factor:Number		= 1;
			
			if (controlY.metadata) {
				var metadata:Object = controlY.metadata;
				multiplier	= (metadata.multiplier is Number) ? metadata.multiplier : multiplier;
				factor		= (metadata.factor is Number) ? metadata.factor : factor;
			}

			_button = new ButtonClear(width,	height);
			_value	= new TextField(width + 3,	height);

			_controlY = controlY as ControlNumber;
			_multiplier = multiplier;
			_factor = factor;

			_value.align	= 'center';
			_value.y		= 1;
			value			= Math.floor(_controlY.value * _multiplier).toString();
			
			addChild(_value);
			addChild(_button);
			
			doubleClickEnabled = true;

			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			addEventListener(MouseEvent.DOUBLE_CLICK, _onDoubleClick);
			addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
			
			_controlY.addEventListener(ControlEvent.CHANGE, _onControlChange);
		}
		
		/**
		 * 	@private
		 */
		protected function _onMouseWheel(event:MouseEvent):void {
			_controlY.value = _controlY.value + ((event.delta * 3) / _multiplier);
		}
		
		/**
		 * 	@private
		 */
		protected function _onDoubleClick(event:MouseEvent):void {
			_controlY.reset();
		}

		/**
		 * 	@private
		 */
		protected function _onMouseDown(event:MouseEvent):void {
			
			_mouseY = mouseY;
			_tempY = _controlY.value * _multiplier;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

		}
		
		/**
		 * 	@private
		 */
		protected function _onMouseMove(event:MouseEvent):void {
			
			var diff:int = (_mouseY - mouseY) / _factor;
			_controlY.value = (diff + _tempY) / _multiplier;
		}
		
		/**
		 * 	@private
		 */
		protected function _onMouseUp(event:MouseEvent):void {

			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

		}
		
		/**
		 * 	@private
		 */
		protected function _onControlChange(event:ControlEvent):void {
			value	= String(Math.floor(event.value * _multiplier))
		}
		
		/**
		 * 
		 */
		protected function set value(value:String):void {
			_value.text = value;
		}

		/**
		 * 	@method		cleans up references
		 */
		override public function dispose():void {

			// clean up events
			removeEventListener(MouseEvent.MOUSE_DOWN,		_onMouseDown);
			removeEventListener(MouseEvent.DOUBLE_CLICK,	_onDoubleClick);
			removeEventListener(MouseEvent.MOUSE_WHEEL,	_onMouseWheel);
			
			_controlY.removeEventListener(ControlEvent.CHANGE, _onControlChange);

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