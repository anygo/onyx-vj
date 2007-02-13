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

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
/*	import onyx.events.SpectrumEvent;
	import onyx.sound.SpectrumAnalyzer;
	import onyx.sound.SpectrumTrigger;
*/
	
	public class SoundEqualizer extends Window {
		
//		private var analyzer:SpectrumAnalyzer = SpectrumAnalyzer.getGlobal();
//		private var overlay:Sprite = new Sprite();
		
		public function SoundEqualizer():void {

			title = 'sound monitor';
			
			width = 200;
			
			x = 822;
			y = 2;
			
/*			
			overlay.x = 2;
			overlay.y = 13;

			addChild(overlay);
			
			analyzer.addEventListener(SpectrumEvent.SPECTRUM_ANALYZED, _analyzed);
			analyzer.addEventListener(SpectrumEvent.SPECTRUM_TRIGGER,	_triggered);
			analyzer.addTrigger(new SpectrumTrigger(192, 255))
			
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
*/
		}

/*		
		private function _onMouseDown(event:MouseEvent):void {
		}

		private function _analyzed(event:SpectrumEvent):void {
			
			var analysis:Array = event.analysis;
			
			overlay.graphics.clear();
			
			var amount:Number = 256 / 200;
			
			for (var count:int = 0; count < 256; count += amount) {
				
				var amplitude:Number = analysis[count];
				
				overlay.graphics.beginFill(0xFFFFFF);
				overlay.graphics.drawRect(count,0,0, amplitude * 120);
				overlay.graphics.endFill();
				
			}
		}
		
		private function _triggered(event:SpectrumEvent):void {
			// trace(event);
		}
*/
	}
}