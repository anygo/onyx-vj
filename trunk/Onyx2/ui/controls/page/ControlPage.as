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
package ui.controls.page {
	
	import flash.utils.Dictionary;
	
	import onyx.controls.*;
	
	import ui.controls.*;
	import ui.core.UIObject;
	import ui.text.TextField;

	/**
	 * 	The pages
	 */
	public final class ControlPage extends UIObject {
		
		/**
		 * 	@private
		 */
		private static const DEFAULT:UIOptions = new UIOptions();
		DEFAULT.width = 48;

		/**	
		 * 	@private
		 */
		private var _controls:Array		= [];
		
		/**
		 * 	@constructor
		 */		
		public function ControlPage():void {
			super(true);
			mouseEnabled = false;
		}
		
		/**
		 * 	
		 */
		public function removeControls():void {
			for each (var uicontrol:UIControl in _controls) {
				uicontrol.dispose();
			}
			_controls = [];
		}
		
		/**
		 * 	
		 */
		public function addControls(controls:Array):void {
			
			var uicontrol:UIControl, x:int = 0, y:int = 0;
			var options:UIOptions	= DEFAULT;
			var width:int = 65;
			
			removeControls();

			for each (var control:Control in controls) {
				
				uicontrol = null;
				var metadata:Object = control.metadata || {};
				
				if (control is ControlNumber) {
					if (metadata.display === 'frame') {
						uicontrol = new SliderVFrameRate(options, control);
					}
					
					if (!uicontrol) {
						uicontrol = new SliderV(options, control);
					}
				} else if (control is ControlProxy) {
					uicontrol = new SliderV2(options, control);
				} else if (control is ControlRange) {
					uicontrol = new DropDown(options, control);
				} else if (control is ControlColor) {
					uicontrol = new ColorPicker(options, control);
				} else if (control is ControlColor) {
					uicontrol = new ColorPicker(options, control);
				} else if (control is ControlToggle) {
					uicontrol = new CheckBox(options, control);
				} else if (control is ControlString) {
					uicontrol = new TextControl(options, control);
				}
				
				uicontrol.x = metadata.x || x;
				uicontrol.y = metadata.y || y;
				
				_controls.push(uicontrol);
				
				x += options.width + 3;
				
				if (x > width) {
					x = 0;
					y += options.height + 10;
				}
				
				addChild(uicontrol);

			}
		}
	}
}