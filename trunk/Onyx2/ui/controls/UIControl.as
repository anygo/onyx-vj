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
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import onyx.controls.Control;
	import onyx.events.ControlEvent;
	
	import ui.core.UIObject;
	import ui.text.Style;
	import ui.text.TextField;
	import onyx.core.IDisposable;

	public class UIControl extends UIObject implements IDisposable {
		
		public function addLabel(name:String, align:String = 'center', width:int = -1, height:int = 7):void {
			
			var label:TextField = new TextField(width || super.width, height);
			label.align = align;
			label.text = name;
			label.y = -9;

			addChild(label);
			
		}
		
		public function set background(value:Boolean):void {
			if (value) {
				var shape:ControlShape = new ControlShape(super.width, super.height);
				addChildAt(shape, 0);
			}
		}
	}
}

import flash.display.Shape;

final class ControlShape extends Shape {
	
	public function ControlShape(width:int, height:int):void {

		graphics.lineStyle(0, 0x45525c);
		graphics.beginFill(0x192025);
		graphics.drawRect(0,0,width,height);
		graphics.endFill();
		
		cacheAsBitmap = true;

	}
	
}