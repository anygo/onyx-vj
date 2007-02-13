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
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import onyx.core.onyx_ns;
	
	use namespace onyx_ns;

	dynamic public class Controls extends Array {
		
		/**
		 * 	@private
		 */
		private var _definitions:Dictionary = new Dictionary(true);
		
		/**
		 * 	@private
		 */
		private var _target:IControlObject;
		
		/**
		 * 	@constructor
		 */
		public function Controls(target:IControlObject, ... controls:Array):void {
			
			_target = target;
			
			addControl.apply(this, controls);
		}
		
		/**
		 * 	Adds controls
		 */
		public function addControl(... controls:Array):void {
			
			for each (var control:Control in controls) {
				
				control.target = _target;
				
				_definitions[control.name] = control;
				
				if (control is ControlProxy) {
					var proxy:ControlProxy = control as ControlProxy;
					_definitions[proxy.controlY.name] = proxy.controlY;
					_definitions[proxy.controlX.name] = proxy.controlX;
				}

				super.push(control);
			}
		}
		
		/**
		 * 	
		 */
		public function getControl(name:String):Control {
			return _definitions[name];
		}
		
		/**
		 * 	@private
		 */
		onyx_ns function set target(value:IControlObject):void {
			for each (var control:Control in this) {
				control.target = value;
			}
		}
		
		/**
		 * 	Destroys
		 */
		public function dispose():void {
			_target			= null;
			_definitions	= null;
		}
	}
}