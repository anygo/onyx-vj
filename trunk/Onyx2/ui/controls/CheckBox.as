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

	import onyx.controls.Control;
	import flash.events.MouseEvent;
	import onyx.events.ControlEvent;
	import flash.geom.ColorTransform;
	import ui.text.TextField;
	
	public class CheckBox extends UIControl {

		private var _control:Control;
		private var _value:Boolean;
		private var _label:TextField;

		public function CheckBox(options:UIOptions, control:Control):void {

			_control = control;

			super(options, control.display);
			_value = control.value;

			_label			= new TextField(options.width + 3, options.height, 'center');
			_label.text		= _value.toString();
			_label.y		= 1;
			
			addChild(_label);

			_onChanged();
			
			_control.addEventListener(ControlEvent.CONTROL_CHANGED, _onChanged);
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		private function _onMouseDown(event:MouseEvent):void {
			_control.value = !_value;
		}
		
		private function _onChanged(event:ControlEvent = null):void {
			_value				= event ? event.value : _value;
			_label.textColor	= _value ? 0xFFFFFF : 0x999999;
			_label.text			= _value.toString();
		}
		
		override public function dispose():void {
			_control.removeEventListener(ControlEvent.CONTROL_CHANGED, _onChanged);
			_control = null;
			
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
	}
}