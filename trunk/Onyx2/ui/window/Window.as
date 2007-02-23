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
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import ui.core.UIObject;
	import ui.text.TextField;
	import ui.text.TextInput;
	
	public class Window extends UIObject {
		
		/**
		 * 	@private
		 */
		private static var _windows:Array		= [];
		
		/**
		 * 	@private
		 */
		private var _title:TextField			= new TextField(80, 16);
		
		/**
		 * 	@private
		 */
		private var _background:WindowAsset		= new WindowAsset();
		
		/**
		 * 	@constructor
		 */
		public function Window(text:String, width:int, height:int, x:int, y:int):void {
			
			_windows.push(this);
			
			_title.autoSize			= TextFieldAutoSize.LEFT;
			_title.x				= 2;
			_title.y				= 1;
			_title.text				= text;
			
			addChildAt(_background, 0);
			addChild(_title);
			
			_background.width	= width;
			_background.height	= height;
			
			this.x = x;
			this.y = y;
			
			super(true);	
		}
		
		public function set title(t:String):void {
			_title.text = t;
		}

		public function get title():String {
			return _title.text;
		}
		
		/**
		 * 	Allows window to be dragged
		 */
		public function set draggable(drag:Boolean):void {
			addEventListener(MouseEvent.MOUSE_DOWN, _dragMouseDown);
		}
		
		/**
		 * 
		 */
		private function _dragMouseDown(event:MouseEvent):void {
			/* check to see if thet mouse is hitting the title bar */
			if (mouseY < 13) {
				startDrag();
				addEventListener(MouseEvent.MOUSE_UP, _dragMouseUp);
			}
		}
		
		private function _dragMouseUp(event:MouseEvent):void {
			stopDrag();
			removeEventListener(MouseEvent.MOUSE_UP, _dragMouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN, _dragMouseDown);
		}

	}
}

/**
 * 
 * 	HELPER CLASS
 * 
 **/

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.display.Shape;

class WindowAsset extends Shape {
	
	public function WindowAsset():void {
		
		graphics.lineStyle(0, 0x384754, 1, true);

		graphics.beginFill(0x252e34);
		graphics.drawRoundRectComplex(0,10,100,90,0,0,2,2);
		graphics.endFill();
		
		graphics.beginFill(0x000000);
		graphics.drawRoundRectComplex(0,0,100,10,2,2,0,0);
		graphics.endFill();

		scale9Grid = new Rectangle(20,20,76,76);
		
	}
}