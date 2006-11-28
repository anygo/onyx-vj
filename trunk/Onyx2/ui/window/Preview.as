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
package ui.windows {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Timer;
	import onyx.display.Display;
	import onyx.core.Engine;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	
	public final class Preview extends Window {
		
		private var _preview:Bitmap	= new Bitmap(new BitmapData(224,168, false));
		private var _timer:Timer		= new Timer(82);
		private var _matrix:Matrix	= new Matrix();
		private var _display:Display;
		
		public function Preview():void {
			
			// set display options

			title = 'output';

			width = 334;
			height = 220;

			x = 689;
			y = 545;

			_preview.x = 5;
			_preview.y = 30;
			
			// assign the display we're previewing
			_display = Engine.getDisplayAt(0);

			// assign the timer to update the preview
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
			
			// set the matrix width
			_matrix.scale(_preview.width / _display.width, _preview.height / _display.height);
			
			// add the preview bitmap
			addChild(_preview);
			
		}
		
		private function _onTimer(event:TimerEvent):void {

			var bmp:BitmapData = _preview.bitmapData;
			bmp.draw(_display, _matrix);
		}
		
	}
}