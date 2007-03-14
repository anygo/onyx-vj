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
package onyx.filter {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.controls.*;
	import onyx.core.Tempo;
	import onyx.core.onyx_ns;
	import onyx.events.TempoEvent;
	import onyx.tween.*;
	import onyx.tween.easing.*;
	
	use namespace onyx_ns;
	
	public class TempoFilter extends Filter {
		
		/**
		 * 	Store multiplier
		 */
		public static const DEFAULT_FACTOR:Object	= { 
			multiplier: .001,
			factor:		25,
			toFixed:	2
		};
		
		/**
		 * 	@private
		 */
		protected var timer:Timer;
		
		/**
		 * 	@private
		 */
		protected var _delay:int					= 100;
		
		/**
		 * 	@private
		 */
		private var _snapTempo:Boolean				= true;
		
		/**
		 * 	@private
		 */
		private var _snapControl:ControlBoolean		= new ControlBoolean('snapTempo', 'Use Tempo');

		
		/**
		 * 	@private
		 */
		private var _delayControl:ControlInt		= new ControlInt('delay', 'delay', 1, 5000, 0, DEFAULT_FACTOR);

		/**
		 * 	@constructor
		 */
		final public function TempoFilter(unique:Boolean, ... controls:Array):void {
			
			super(unique);
			controls.unshift(
				_snapControl,
				_delayControl
			);
			super.controls.addControl.apply(null, controls);
		}
		
		/**
		 * 
		 */
		final public function set delay(value:int):void {
			_delay = _delayControl.setValue(value);
			if (timer) {
				timer.delay = _delay;
			}
		}
		
		/**
		 * 	Sets delay
		 */
		final public function get delay():int {
			return _delay;
		}
		
		/**
		 * 	Whether or not the filter snaps to beat
		 */
		final public function set snapTempo(value:Boolean):void {
			
			// remove timer stuff
			if (timer) {
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer.stop();
				timer = null;
			}
			
			// remove tempo stuff
			var tempo:Tempo = Tempo.getInstance();
			tempo.removeEventListener(TempoEvent.CLICK, onTempo);
			
			// set value
			_snapTempo = _snapControl.setValue(value);
			
			// re-init
			if (content) {
				initialize();
			}
		}
		
		/**
		 * 
		 */
		final public function get snapTempo():Boolean {
			return _snapTempo;
		}
		
		/**
		 * 	initialize
		 */		
		override public function initialize():void {
			
			if (_snapTempo) {

				var tempo:Tempo = Tempo.getInstance();
				tempo.addEventListener(TempoEvent.CLICK, onTempo);
				
			} else {
				
				timer = new Timer(_delay);
				timer.start();
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				
			}
			
		}
		
		/**
		 * 	@private
		 */
		protected function onTempo(event:TempoEvent):void {
			onTrigger(event.beat, event);
		}
		
		/**
		 * 	@private
		 */
		protected function onTimer(event:TimerEvent):void {
			onTrigger((event.currentTarget as Timer).currentCount, event);
		}

		/**
		 * 
		 */
		protected function onTrigger(beat:int, event:Event):void {
			trace('BEAT');
		}

		/**
		 * 	Dispose
		 */
		override public function dispose():void {
			
			super.dispose();
			
			// stop the timer
			if (timer) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
			
			var tempo:Tempo = Tempo.getInstance();
			tempo.removeEventListener(TempoEvent.CLICK, onTempo);
			
			_snapControl	= null;
			_delayControl	= null;
		}
	}
}