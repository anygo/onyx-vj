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
	
	import onyx.controls.ControlInt;
	import onyx.controls.ControlRange;
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	import onyx.core.Onyx;
	import onyx.events.TransitionEvent;
	import onyx.layer.Layer;
	import onyx.plugin.Plugin;
	import onyx.transition.Transition;
	
	import ui.UIManager;
	import ui.controls.DropDown;
	import ui.controls.SliderV;
	import ui.controls.UIOptions;
	
	public final class TransitionWindow extends Window implements IControlObject {
		
		/**
		 * 	@private
		 */
		private var dropdown:DropDown;

		/**
		 * 	Stores current transition plugin to use
		 */		
		public var plugin:Plugin;
		
		/**
		 * 	default duration
		 */
		public var duration:int	= 2;
		
		/**
		 * 	@private
		 * 	returns controls
		 */
		private var _controls:Controls;
		
		/**
		 * 	@Constructor
		 */
		public function TransitionWindow():void {

			// grab data, create a "none" object
			var data:Array = Transition.transitions;
			data.unshift(null);
			
			// init controls
			_controls = new Controls(this,
				new ControlRange('transition', 'Layer Transition', data, 0),
				new ControlInt('duration', 'Duration', 1, 5, 3, { factor: 10 })
			);
			
			var options:UIOptions	= new UIOptions();
			options.width			= 100;
			
 			dropdown				= new DropDown(options, _controls.getControl('transition'), 'left', 'name');
			dropdown.x = 2;
			dropdown.y = 20;
			
			var slider:SliderV		= new SliderV(UIOptions.DEFAULT, _controls.getControl('duration'));
			
			addChild(slider);
			
			slider.x	= 100;
			slider.y = 20;

			addChild(dropdown);
			
			title = 'TRANSITIONS';
			x = 6;
			y = 542;
			width = 190;
			height = 34;
		}
		
		public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 
		 */
		public function set transition(value:Plugin):void {
			
			plugin = value;

			// valid
			if (value)  {
				var transition:Transition = value.getDefinition() as Transition;
				transition.duration = duration * 1000;
	
				UIManager.transition = transition;
			}
		}
		
		/**
		 * 
		 */
		public function get transition():Plugin {
			return plugin;
		}
		
	}
}