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
package ui.window {

	import flash.events.MouseEvent;
	import flash.system.System;
	
	import onyx.controls.*;
	import onyx.core.Onyx;
	import onyx.display.*;
	
	import ui.controls.*;
	import ui.core.UIObject;

	public final class SettingsWindow extends Window {
		
		/**
		 * 	@private
		 */
		private var _controlXY:SliderV2;

		/**
		 * 	@private
		 */
		private var _controlScale:SliderV2;

		/**
		 * 	@private
		 */
		private var _controlColor:ColorPicker;

		/**
		 * 	@private
		 */
		private var _controlXML:TextButton;

		/**
		 * 	@private
		 */
		private var _controlSize:DropDown;
		
		/**
		 * 	@constructor
		 */
		public function SettingsWindow(display:IDisplay):void {
			
			super('SETTINGS WINDOW', 202, 100, 200, 522);
			
			var options:UIOptions	= new UIOptions();
			options.width			= 50;
			
			var controls:Controls	= display.controls;

			_controlXY		= new SliderV2(options, controls.getControl('position'));

			_controlColor	= new ColorPicker(options, controls.getControl('backgroundColor'));
			_controlXML		= new TextButton(options, 'save layers');
			
			var control:Control = new ControlRange('size', 'size', DisplaySize.SIZES, 0, 'name');
			control.target		= display;

			_controlSize	= new DropDown(options, control, 'left');
			
			_controlXY.y	= 24;
			_controlColor.y = 70;
			_controlXY.x	= 2;
			_controlColor.x = 2;
			_controlXML.x	= 2;
			_controlXML.y	= 83;
			_controlSize.x	= 60;
			_controlSize.y	= 24;
			
			addChild(_controlXY);
			addChild(_controlColor);
			addChild(_controlXML);
			addChild(_controlSize);
			
			_controlXML.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown)
		}
		
		/**
		 * 	@private
		 */
		private function _onMouseDown(event:MouseEvent):void {
			var display:Display = Onyx.displays[0];
			var text:String		= display.toXML().normalize();
			
			var popup:TextControlPopUp = new TextControlPopUp(this, 200, 200, 'Copied to clipboard\n\n' + text);

			// saves breaks
			var arr:Array = text.split(String.fromCharCode(10));
			text		= arr.join(String.fromCharCode(13,10));
			
			System.setClipboard(text);
			
			event.stopPropagation();
		}
	}
}