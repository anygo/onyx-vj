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
package onyx.application {
	
	import flash.display.Stage;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	import onyx.controls.*;
	import onyx.core.Console;
	import onyx.core.onyx_ns;
	import onyx.display.Display;
	import onyx.events.*;
	import onyx.filter.*;
	import onyx.layer.*;
	import onyx.net.Plugin;
	import onyx.transition.*;
	import onyx.core.IDisposable;
	import flash.utils.Dictionary;
	
	use namespace onyx_ns;
	
	/**
	 * 	Core Application class that stores all layers, displays, and loaded plugins
	 */
	public final class Onyx {
		
		/**
		 * 	STATIC VARIABLES
		 **/
		public static const controls:Controls = new Controls(Onyx,
			new ControlInt(LayerProperties.FRAMERATE, null, 1, 30, 20)
		);
		
		/**
		 * 	@private
		 * 	Dispatcher
		 */
		internal static const instance:EventDispatcher = new EventDispatcher();
		
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
		 * 	@private
		 * 	Stores definitions to all the filters
		 */
		onyx_ns static var _filters:Array			= [];
		
		/**
		 * 	@private
		 * 	stores definitions by name for fast reference
		 */
		private static var _definition:Dictionary	= new Dictionary(true);
		
		/**
		 * 	@private
		 * 	Stores definitions for all the transitions
		 */
		onyx_ns static var _transitions:Array		= [];

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
		public static function initialize(root:Stage):EventDispatcher {
			
			Onyx.root = root;
			
			// root.addEventListener(Event.RESIZE, _onResize);

			controls.getControl('framerate').value = root.frameRate;
			
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
			
			if (plugin.definition) {

				var object:IDisposable = new plugin.definition();
				
				// test the type of object
				if (object is Filter) {
					var type:Class = Filter;
					_filters.push(plugin);
					_definition[(object as Filter).name] = plugin;

				} else if (object is Transition) {
					type = Transition;
					_transitions.push(plugin);

					_definition[(object as Transition).name] = plugin;
				}
				
				object.dispose();
			}
		}
		
		/**
		 * 	Returns class definition from filter type
		 */
		public static function getDefinition(name:String):Plugin {
			return _definition[name];
		}
	
		/**
		 * 	Returns an array of Plugins that contain filter definitions
		 * 	@see onyx.net.Plugin
		 */
		public static function get filters():Array {
			return _filters.concat();
		}

		/**
		 * 	Returns an array of Plugins that contain transition definitions
		 * 	@see onyx.net.Plugin
		 */
		public static function get transitions():Array {
			return _transitions.concat();
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
		public static function createLocalDisplay(numLayers:int):Display {
			
			var display:Display = new Display();
			_displays.push(display);

			display.createLayers(numLayers);
			
			display.scaleX = 1;
			display.scaleY = 1;
			display.x = root.stageWidth - display.width;
			display.y = 525;

			root.addChild(display);

			var event:DisplayEvent = new DisplayEvent(DisplayEvent.DISPLAY_CREATED);
			event.display = display;
			instance.dispatchEvent(event);
			
			return display;
		}
		
	}
}