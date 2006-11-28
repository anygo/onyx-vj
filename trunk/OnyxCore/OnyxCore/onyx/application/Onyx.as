package onyx.application {
	
	import flash.display.Stage;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.getQualifiedClassName;
	
	import onyx.controls.*;
	import onyx.core.Console;
	import onyx.core.onyx_internal;
	import onyx.display.Display;
	import onyx.events.*;
	import onyx.filter.*;
	import onyx.layer.*;
	import onyx.transition.*;
	
	use namespace onyx_internal;
	
	public final class Onyx {
		
		/**
		 * 	STATIC VARIABLES
		 **/
		public static const controls:Controls = new Controls(Onyx,
			new ControlInt(LayerProperties.PLAYHEAD_RATE,	null, 1, 30, 20)
		);
		
		/**
		 * 	Stores conversion for degrees to radians
		 */
		public static const RADIANS:Number = Math.PI / 180;
		
		/**
		 * 	Dispatcher
		 */
		onyx_internal static const dispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 * 	Stores reference to root
		 */
		onyx_internal static var root:Stage;
		
		/**
		 * 	Stores references to all the displays
		 */
		onyx_internal static var _displays:Array	= [];
		
		/**
		 * 	Stores definitions to all the filters
		 */
		internal static var _filters:Array		= [];
		
		/**
		 * 	Stores definitions for all the transitions
		 */
		internal static var _transitions:Array	= [];
		
		/**
		 * 	
		 */
		private static var _states:Array			= [];

		/**
		 * 	Application state
		 */		
		private static var _state:IApplicationState;

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
		 * 	Loads an application state
		 */
		internal static function loadApplicationState(state:IApplicationState, ... args:Array):void {

			if (_state) {
				_state.terminate();
			}

			_state = state;
			state.initialize.apply(state, args);
		}

		/**
		 * 	Adds an event listener
		 */
		public static function addEventListener(type:String, fn:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			dispatcher.addEventListener(type, fn, useCapture, priority, useWeakReference);
		}

		/**
		 * 	Removes an event listener
		 */
		public static function removeEventListener(type:String, fn:Function):void {
			dispatcher.removeEventListener(type, fn);
		}

		/**
		 * 	Tests for an event listener
		 */
		public static function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}

		/**
		 * 	Initializes the Onyx engine
		 */
		public static function initialize(root:Stage):void {
			
			Onyx.root = root;
			
			loadApplicationState(new InitializationState());
			
			root.addEventListener(Event.RESIZE, _onResize);

			controls.framerate.value = root.frameRate;

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
		 * 	Registers a transition class
		 */
		public static function registerTransition(... transitions:Array):void {
			
			for each (var transition:Class in transitions) {
				
				var instance:Transition = new transition();
				
				transition.index = _transitions.push(transition) - 1;
				transition['name'] = instance.name;
				
				var event:TransitionEvent = new TransitionEvent(TransitionEvent.TRANSITION_CREATED);
				event.definition = transition;
				
				dispatcher.dispatchEvent(event);
				
			}
		}
		
		/**
		 * 	Registers a filter
		 */
		public static function registerFilter(... filters:Array):void {
			
			for each (var filter:Class in filters) {
				
				if (filter) {

					// check for name					
					var instance:Filter = new filter();
					
					filter.index = _filters.push(filter) - 1;
					
					filter['name'] = instance.name;
				
					var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_CREATED, null);
					event.definition = filter;
			
					dispatcher.dispatchEvent(event);
					
					instance.dispose();
				}
			}
		}
		
		/**
		 * 	Returns the filter classes
		 */
		public static function get filters():Array {
			return _filters.concat();
		}

		/**
		 * 	Returns the filter classes
		 */
		public static function get transitions():Array {
			return _transitions.concat();
		}
		
		/**
		 * 	Returns all the displays
		 */
		public static function get displays():Array {
			return displays.concat();
		}

		/**
		 * 	Creates a display
		 */
		public static function createLocalDisplay(numLayers:int):Display {
			
			var display:Display = new Display();
			display.createLayers(numLayers);
			display._index = _displays.push(display);
			
			display.scaleX = 1;
			display.scaleY = 1;
			display.x = root.stageWidth - display.width;
			display.y = 525;

			_displays.push(display);
			root.addChild(display);

			var event:DisplayEvent = new DisplayEvent(DisplayEvent.DISPLAY_CREATED);
			event.display = display;
			dispatcher.dispatchEvent(event);
			
			return display;
		}
		
	}
}