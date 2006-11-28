package onyx.controls {

	import flash.events.EventDispatcher;
	
	import onyx.events.ControlEvent;
	
	public class Control extends EventDispatcher {

		// set by Controls
		public var target:Object;

		// stores the display name		
		public var displayName:String;

		// name of the property to affect
		internal var property:String;
		
		/**
		 * @constructor
		 */
		public function Control(property:String, displayName:String = ''):void {
			this.property = property;
			this.displayName = displayName;
		}
		
		/**
		 * @public
		 */
		public function get value():* {
			return target[property];
		}
		
		public function set value(v:*):void {
			target[property] = v;
			
			dispatchEvent(new ControlEvent(v));
		}
		
		public function update():void {
			dispatchEvent(new ControlEvent(target[property]));
		}
		
		public function reset():void {
			// trace('reset');
		}
		
	}
}