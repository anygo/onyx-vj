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
	import ui.assets.AssetColorPicker;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import onyx.controls.Control;
	import onyx.controls.ControlUInt;

	public final class ColorPicker extends UIControl {
		
		private static var _picker:AssetColorPicker;
		private static var _cursor:Shape;
		
		private var _control:ControlUInt;
		private var _preview:Shape	= new Shape();
		private var _lastX:int		= 0;
		private var _lastY:int		= 0;
		
		public function ColorPicker(control:ControlUInt, width:int = 37, height:int = 9):void {
			
			_control = control;
			
			_draw(width, height);
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			
		}
		
		private function _draw(width:int, height:int):void {
			
			_preview.graphics.beginFill(0x000000);
			_preview.graphics.drawRect(0, 0, width, height);
			_preview.graphics.endFill();

			addChild(_preview);
		}
		
		private function _onMouseDown(event:MouseEvent):void {
			
			_picker = new AssetColorPicker();
			_picker.x = -_lastX + event.localX;
			_picker.y = -_lastY + event.localY;
			
			_cursor = new Shape();
			_cursor.graphics.lineStyle(0, 0x000000);
			_cursor.graphics.drawRect(0,0,2,2);
			_cursor.x = event.localX;
			_cursor.y = event.localY;
			
			addChild(_picker);
			addChild(_cursor);
			
			addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);

		}

		public function _onMouseMove(event:MouseEvent):void {
			
			_cursor.x = event.localX;
			_cursor.y = event.localY;
			
			var transform:ColorTransform = new ColorTransform();
			
			_lastX = Math.min(Math.max(_picker.mouseX,0),100);
			_lastY = Math.min(Math.max(_picker.mouseY,0),100);
			
			transform.color = _picker.bitmapData.getPixel(_lastX, _lastY);
			
			_control.value = transform.color;
			
			_preview.transform.colorTransform = transform;
		}

		public function _onMouseUp(event:MouseEvent):void {

			removeChild(_picker);
			removeChild(_cursor);
			
			_picker = null;
			_cursor = null;

			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
		}
		
		public function set color(c:int):void {
			var transform:ColorTransform = new ColorTransform();
			transform.color = c;
			_preview.transform.colorTransform = transform;
		}
	}
}