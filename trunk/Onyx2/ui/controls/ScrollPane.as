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
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import onyx.core.IDisposable;
	
	import ui.core.UIObject;

	public class ScrollPane extends UIObject {
		
		private var _clickX:Number;
		private var _width:int;
		private var _height:int;
		
		public function ScrollPane(width:int, height:int):void {
			_width = width;
			_height = height;
			
			addEventListener(Event.ADDED, _onCalculate);
			addEventListener(Event.REMOVED, _onCalculate);
			addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			
			scrollRect = new Rectangle(0,0, width, height);
		}
		
		private function _onCalculate(event:Event):void {
			
			var bounds:Rectangle = getBounds(null);
			if (bounds.height > _height) {
				_displayScrollBar();
			}
		}
		
		private function _onMouseOver(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
		}
		
		private function _onMouseOut(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			removeEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
		}
		
		private function _onMouseWheel(event:MouseEvent):void {
			trace(1);
		}
		
		private function _displayScrollBar():void {
		}
		
		public function set backgroundColor(value:uint):void {
			graphics.clear();
			graphics.beginFill(value);
			graphics.lineStyle(0, 0x647789);
			graphics.drawRect(-4,-4,_width+4,_height+4);
			graphics.endFill();
		}
		
		override public function dispose():void {
			removeEventListener(Event.ADDED, _onCalculate);
			removeEventListener(Event.REMOVED, _onCalculate);
			removeEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			removeEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);

		}
		
	}
}

import flash.display.Sprite;

final class ScrollBar extends Sprite {
	
	public function ScrollBar():void {
	}
	
}