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
package filters {
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.controls.Control;
	import onyx.controls.ControlInt;
	import onyx.controls.ControlNumber;
	import onyx.controls.ControlRange;
	import onyx.controls.Controls;
	import onyx.filter.Filter;
	import onyx.tween.*;
	import onyx.tween.easing.*;

	public final class FrameRND extends Filter {
		
		private var _timer:Timer;
		
		public var rndframe:Boolean = true;
		
		public var mindelay:Number	= .5;
		public var maxdelay:Number	= 2;
		public var minframe:Number	= .6;
		public var maxframe:Number	= 4;
		public var smooth:Boolean	= true;
		
		public function FrameRND():void {

			super(
				true,
				new ControlNumber('mindelay',	'Min Delay', .1, 50, .5),
				new ControlNumber('maxdelay',	'Min Delay', .1, 50, 2),
				new ControlRange('rndframe',	'RND Frame', [true, false], 0),
				new ControlNumber('minframe',	'min framerate', .2, 8, .6),
				new ControlNumber('maxframe',	'max framerate', .2, 8, 4)
			)
		}

		/**
		 * 	initialize
		 */		
		override public function initialize():void {
			_timer = new Timer(100);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
		}
		
		/**
		 * 	@private
		 */
		private function _onTimer(event:Event):void {

			var delay:int = (((maxdelay - mindelay) * Math.random()) + mindelay) * 1000;
			_timer.delay = delay;
			
			if (rndframe) {
				content.time = Math.random();
			}
			
			var framerate:Number = (((maxframe - minframe) * Math.random()) + minframe) * (Math.random() <= .5 ? 1 : -1);
			
			if (smooth) {
				if (Math.random() > .5) {
					new Tween(content, Math.min(delay, 200), new TweenProperty('framerate', 0, 1));
					return;
				}
			}
			
			content.framerate = framerate;
			
		}

		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			if (_timer) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				_timer = null;
			}
			super.dispose();
		}

	}
}