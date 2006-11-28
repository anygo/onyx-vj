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
	
	public final class Toggle extends UIControl {
		
		private var _enabled:Boolean		= false;
		private var _toggle:ToggleState;

		public function Toggle(width:int = 36, height:int = 10):void {
			
			addChild(new ButtonClear(width,height));
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			
		}
		
		private function _onMouseDown(event:MouseEvent):void {
			enabled = !_enabled;
		}
		
		/**
		 * 	@method		Sets whether it's enabled or not
		 */
		public function set enabled(value:Boolean):void {
			
			if (value) {
				_toggle = new ToggleState();
				addChildAt(_toggle, 0);
				
			} else {
				if (_toggle) {
					removeChild(_toggle);
				}
			}
			
			_enabled = value;
			
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
	}
	
}


import flash.display.Shape;

final class ToggleState extends Shape {
	
	final public function ToggleState():void {
		
		graphics.beginFill(0xECE6CA, .3);
		graphics.drawRect(0,0,36,10);
		graphics.endFill();
		
		cacheAsBitmap = true;
	}

}