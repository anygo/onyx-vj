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
	
	import onyx.application.Onyx;
	import onyx.controls.ControlColor;
	import onyx.controls.Controls;
	import onyx.display.Display;
	
	import ui.controls.ColorPicker;
	import ui.controls.SliderV2;
	import ui.controls.TextButton;
	import ui.controls.UIOptions;
	import ui.core.UIObject;
	import ui.controls.TextControlPopUp;

	public final class SettingsWindow extends Window {
		
		private var _controlXY:SliderV2;
		private var _controlScale:SliderV2;
		private var _controlColor:ColorPicker;
		private var _controlXML:TextButton;
		
		public function SettingsWindow(display:Display):void {
			
			title = 'SETTINGS WINDOW';
			
			var options:UIOptions	= new UIOptions();
			options.width			= 50;
			
			var controls:Controls	= display.controls;

			_controlXY		= new SliderV2(options, controls.getControl('position'));
			_controlScale	= new SliderV2(options, controls.getControl('scale'));
			_controlColor	= new ColorPicker(options, controls.getControl('backgroundColor'));
			_controlXML		= new TextButton(options, 'save layers');
			
			_controlXY.y	= 24;
			_controlScale.y = 47;
			_controlColor.y = 70;
			_controlXY.x	= 2;
			_controlScale.x = 2;
			_controlColor.x = 2;
			_controlXML.x	= 2;
			_controlXML.y	= 83;
			
			addChild(_controlXY);
			addChild(_controlScale);
			addChild(_controlColor);
			addChild(_controlXML);
			
			width = 190;
			
			x = 200;
			y = 542;
			
			_controlXML.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown)
		}
		
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