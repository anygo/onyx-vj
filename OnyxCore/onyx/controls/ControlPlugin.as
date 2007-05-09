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
	
	import onyx.core.*;
	import onyx.events.ControlEvent;
	import onyx.plugin.*;
	
	use namespace onyx_ns;
	
	/**
	 * 	Returns plugins based on type passed in
	 */
	public final class ControlPlugin extends ControlRange {
		
		/**
		 * 	Use Filters
		 */
		public static const FILTERS:int		= 0;

		/**
		 * 	Use Macros
		 */
		public static const MACROS:int		= 1;

		/**
		 * 	Use Transitions
		 */
		public static const TRANSITIONS:int	= 2;

		/**
		 * 	Use Visualizers
		 */
		public static const VISUALIZERS:int	= 3;
		
		/**
		 * 	@constructor
		 */
		public function ControlPlugin(name:String, display:String, type:int = 0, defaultValue:int = 0):void {
			
			var data:Array;
			
			switch (type) {
				case FILTERS:
					data = Filter.filters;
					break;
				case MACROS:
					data = Macro.macros;
					break;
				case TRANSITIONS:
					data = Transition.transitions;
					break;
				case VISUALIZERS:
					data = Visualizer.visualizers;
					break;
			}
			
			data.unshift(null);
			
			super(name, display, data, defaultValue, 'name');
		}
		
		/**
		 * 
		 */
		override public function get value():* {
			var type:PluginBase = _target[name];
			return type ? type._plugin : null;
		}
		
		/**
		 * 
		 */
		override public function set value(v:*):void {
			var plugin:Plugin = v as Plugin;
			dispatchEvent(new ControlEvent(v));
			_target[name] = plugin ? plugin.getDefinition() : null;
		}
		
		/**
		 * 
		 */
		override public function setValue(v:*):* {
			var plugin:Plugin = v as Plugin;
			dispatchEvent(new ControlEvent(v));
			return plugin ? plugin.getDefinition() : null;
		}
		
		/**
		 * 	TBD: This needs to store data
		 * 	Returns xml representation of the control
		 */
		override public function toXML():XML {
			return <{name}>{_target[name].toString()}</{name}>;
		}
		
		/**
		 * 	Faster reflection method (rather than using getDefinition)
		 */
		override public function reflect():Class {
			return ControlPlugin;
		}
	}
}