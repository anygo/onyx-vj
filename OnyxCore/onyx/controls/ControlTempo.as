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
package onyx.controls {

	import onyx.core.Tempo;
	import onyx.core.TempoBeat;
	import onyx.core.onyx_ns;
	import onyx.events.ControlEvent;
	
	use namespace onyx_ns;

	/**
	 * 	Range Array Control
	 */
	public final class ControlTempo extends ControlRange {
		
		/**
		 * 	@private
		 */
		private var _data:Array;
		
		/**
		 * 	@private
		 */
		private var _defaultvalue:uint;

		/**
		 * 	@constructor
		 */
		public function ControlTempo(name:String, display:String, data:Array, defaultvalue:uint = 0, binding:String = null, options:Object = null):void {
			
			super(name, display, data, defaultvalue, binding, options);
			
		}

		/**
		 * 
		 */
		override public function setValue(v:*):* {
			dispatchEvent(new ControlEvent(v));
			return v;
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {
			dispatchEvent(new ControlEvent(v));
			_target[name] = v;
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ControlTempo;
		}
		
		/**
		 * 	Loads xml
		 */
		override public function loadXML(xml:XML):void {
			var beat:TempoBeat = TempoBeat.BEATS[xml.toString()];
			value = beat;
		}
	}
}