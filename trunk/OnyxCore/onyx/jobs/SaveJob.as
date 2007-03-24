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
package onyx.jobs {
	
	import flash.events.Event;
	
	import onyx.display.IDisplay;
	import onyx.events.RenderEvent;
	import onyx.file.FileBrowser;
	import onyx.utils.bitmap.PNGEncoder;
	import flash.display.BitmapData;
	import onyx.utils.bitmap.JPGEncoder;
	
	public final class SaveJob extends Job {
		
		private var _maxFrames:int;
		private var _currentFrame:int;
		private var _display:IDisplay;
		private var _frames:Array		= [];
		
		public function SaveJob(display:IDisplay, frames:int):void {
			_display	= display;
			_maxFrames		= frames;
			
			_display.addEventListener(RenderEvent.RENDER, _onRender);
		}
		
		private function _onRender(event:Event):void {
			
			if (_currentFrame >= _maxFrames) {
				_display.removeEventListener(RenderEvent.RENDER, _onRender);
				save();
				return;
			}
			
			_frames.push(_display.rendered.clone());

			_currentFrame++;
		}
		
		private function save():void {
			
			var encoder:JPGEncoder = new JPGEncoder();
			
			for (var count:int = 0; count < _frames.length; count++) {
				var bmp:BitmapData = _frames[count];
				FileBrowser.save(count + '.jpg', encoder.encode(bmp), _onSave);
				bmp.dispose();
			}
		}
		
		private function _onSave():void {
			trace('frame saved');
		}
		
	}
}