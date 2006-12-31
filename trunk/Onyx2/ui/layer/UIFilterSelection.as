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
package ui.layer {
	
	import flash.display.DisplayObject;
	
	import onyx.content.IContent;
	import onyx.controls.*;
	import onyx.filter.Filter;
	
	import ui.assets.AssetLayerFilterBackground;
	import ui.controls.DropDown;
	import ui.controls.SliderV;
	import ui.controls.UIControl;
	import ui.controls.filter.LayerFilter;
	import ui.core.UIObject;

	public final class UIFilterSelection extends UIObject {
		
		public var filter:Filter;
		private var _controls:Array = [];
		
		public function UIFilterSelection():void {
			
			var asset:DisplayObject = addChild(new AssetLayerFilterBackground());
			asset.alpha = .95;
			
		}
		
		public function removeControls():void {
			
			for each (var uicontrol:UIControl in _controls) {
				removeChild(uicontrol);
				uicontrol.dispose();
			}
			
			_controls = [];
		}
		
		public function addControls(filter:Filter):void {
			
			this.filter = filter;
			
			removeControls();
			
			var count:int = 0;
			
			for each (var control:Control in filter.controls) {
				
				var uicontrol:UIControl;

				if (control is ControlInt || control is ControlNumber) {
					
					uicontrol = new SliderV(control);
					
				} else if (control is ControlRange) {
					uicontrol = new DropDown(control as ControlRange);
				}
				
				if (uicontrol) {
	
					uicontrol.addLabel(control.displayName);
					uicontrol.x = count * 40 + 4;
					uicontrol.y = 14;
					uicontrol.background = true;
					
					addChild(uicontrol);
					_controls.push(uicontrol);
					
					count++;
				}
			}
			
		}
		
	}
}