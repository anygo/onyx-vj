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
	
	import flash.events.Event;
	import flash.utils.Timer;
	
	import onyx.content.IContent;
	import onyx.controls.Control;
	import onyx.controls.ControlInt;
	import onyx.controls.ControlToggle;
	import onyx.controls.Controls;
	import onyx.filter.Filter;

	public final class Blink extends Filter {
		
		private var _seed:Number	= 1;
		private var _smooth:Boolean	= false;
		private var _delay:int		= 1;
		private var _count:int		= 0;
		
		public function Blink():void {

			super('Blink', true);
			
			_controls.addControl(
				new ControlInt('delay',	'delay',	1,	10,	1),
				new ControlInt('seed',	'seed',		0,	1,	1),
				new ControlToggle('smooth',			'smooth')
			)
		}
		
		override public function initialize():void {
			stage.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame(event:Event):void {
			content.alpha = Math.random() * _seed;
		}
		
		public function get delay():int {
			return _delay;
		}
		
		public function set delay(value:int):void {
			_delay = value;
		}

		public function get seed():Number {
			return _seed;
		}
		
		public function set seed(value:Number):void {
			_seed = value;
		}
		
		public function get smooth():Boolean {
			return _smooth;
		}
		
		public function set smooth(value:Boolean):void {
			_smooth = value;
		}

		override public function dispose():void {

			super.dispose();
		}

	}
}