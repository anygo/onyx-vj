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
package onyx.sound {
	
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import onyx.events.SpectrumEvent;

	public final class SpectrumTrigger extends EventDispatcher {
		
		internal var start:int; // 0 - 255
		internal var end:int	// 0 - 255
		
		private var _lowPeak:Number		= 0;
		private var _lowSample:Number	= 0;
		private var _highPeak:Number	= 0;
		private var _highSample:Number	= 0;
		
		public function SpectrumTrigger(start:int, end:int):void {
			
			this.start = start;
			this.end = end;
			
		}
		
		internal function analyze(analysis:Array):void {
			
			var currentTime:int = getTimer();
			var amplitude:Number = 0;

			var itemcount:Number = 1;
			
			for (var count:int = start; count < end; count++) {

				// only count numbers that are greater then 0
				amplitude += analysis[count];
			}
			
			amplitude /= (end - start);

			// these are for hits
			if (amplitude > _highPeak || currentTime - _highSample > 300) {
				
				// before settings, let's check the amount
				if (amplitude - _highPeak > .14)  {
					
//					TBD: dispatch PEAK

				}
				
				_highPeak = amplitude;
				_highSample = currentTime;
				
			}
			
		}
	}
}