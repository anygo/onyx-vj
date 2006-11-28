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
	
	import onyx.application.Onyx;
	import onyx.controls.ControlRange;
	import onyx.events.TransitionEvent;
	import onyx.layer.Layer;
	
	import ui.controls.DropDown;
	
	public final class TransitionWindow extends Window {

		private var data:Array = [{ name: 'None' }];
		private var dropdown:DropDown;
		
		private var control:ControlRange = new ControlRange('transition', 'Transition', data, 0);
		
		public function TransitionWindow():void {
			
			control.target = this;
			
			title = 'TRANSITIONS';
			x = 6;
			y = 526;
			width = 190;
			height = 50;
			
			Onyx.addEventListener(TransitionEvent.TRANSITION_CREATED, _onTransitionCreate);
			
			dropdown = new DropDown(control, true, 100, 18, 'left', 'name');
			dropdown.y = 14;
			addChild(dropdown);
		}
		
		public function get transition():* {
			return Layer.transitionClass;
		}
		
		public function set transition(value:*):void {
			Layer.transitionClass = (value is Class) ? value : null;
		}
		
		public function _onTransitionCreate(event:TransitionEvent):void {
			data.push(event.definition);
			
			if (Onyx.transitions.length === 1) {
				Layer.transitionClass = event.definition;
			}
		}
		
		override public function dispose():void {
			Onyx.removeEventListener(TransitionEvent.TRANSITION_CREATED, _onTransitionCreate);
		}
		
	}
}