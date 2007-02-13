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
package onyx.core {
	
	import flash.display.Stage;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import onyx.controls.*;
	import onyx.display.Display;
	import onyx.events.*;
	import onyx.filter.*;
	import onyx.layer.*;
	import onyx.plugin.Plugin;
	import onyx.sound.SpectrumAnalyzer;
	import onyx.states.*;
	import onyx.transition.*;
	import onyx.sound.Visualizer;
	
	use namespace onyx_ns;
	
	/**
	 * 	Core Application class that stores all layers, displays, and loaded plugins
	 */
	public final class Onyx extends EventDispatcher {
		
		/**
		 * 	@private
		 * 	Dispatcher
		 */
		onyx_ns static const instance:Onyx = new Onyx();
		
		/**
		 * 	@private
		 * 	Stores reference to root
		 */
		onyx_ns static var root:Stage;
		
		/**
		 * 	@private
		 * 	Stores references to all the displays
		 */
		onyx_ns static var _displays:Array	= [];
		
		/**
		 * 	Gets the framerate
		 */
		public static function get framerate():int {
			return root.frameRate;
		}

		/**
		 * 	Sets the framerate
		 */
		public static function set framerate(value:int):void {
			root.frameRate = value;
		}
		
		/**
		 * 	
		 */
		public static function getInstance():EventDispatcher {
			return instance;
		}
		
		/**
		 * 	Initializes the Onyx engine
		 */
		public static function initialize(root:Stage, connection:String = null):EventDispatcher {
			
			Onyx.root = root;
			
			// create a timer so that objects can listen for events
			var timer:Timer = new Timer(0);
			timer.addEventListener(TimerEvent.TIMER, _onInitialize);
			timer.start();

			return instance;
		}
		
		/**
		 * 	@private
		 */
		private static function _onInitialize(event:TimerEvent):void {
			
			var timer:Timer = event.currentTarget as Timer;
			timer.removeEventListener(TimerEvent.TIMER, _onInitialize);
			timer.stop();

			// start initialization
			StateManager.loadState(new InitializationState());
			
		}
		
		/**
		 * 	@private
		 * 	When resized change the display location
		 */		
		private static function _onResize(event:Event):void {
			for each (var display:Display in _displays) {
				display.y = 0;
				display.x = root.stageWidth - display.width;
			}
		}
		
		/**
		 * 	Registers plug-ins
		 */
		public static function registerPlugin(plugin:Plugin):void {
			
			if (plugin._definition) {
				
				// make sure it's uppercase
				plugin.name = plugin.name.toUpperCase();

				var object:IDisposable = plugin.getDefinition() as IDisposable;
				
				// test the type of object
				if (object is Filter) {
					
					Filter.registerPlugin(plugin);
					
				} else if (object is Transition) {
					
					Transition.registerPlugin(plugin);

				} else if (object is Visualizer) {
					
					Visualizer.registerPlugin(plugin);
				}
				
				object.dispose();
			}
		}

		/**
		 * 	Returns all the displays
		 */
		public static function get displays():Array {
			return _displays.concat();
		}

		/**
		 * 	Creates a display
		 * 	@param		The number of layers to create in the display
		 * 	@returns	Display
		 */
		public static function createLocalDisplay(numLayers:int, x:int = 0, y:int = 0, scaleX:Number = 1, scaleY:Number = 1):Display {
			
			var display:Display = new Display();
			_displays.push(display);

			display.createLayers(numLayers);
			display.x = x;
			display.y = y;
			display.scaleX = scaleX;
			display.scaleY = scaleY;
			
			root.addChild(display);

			var event:DisplayEvent = new DisplayEvent(DisplayEvent.DISPLAY_CREATED);
			event.display = display;
			instance.dispatchEvent(event);
			
			return display;
		}
	}
}