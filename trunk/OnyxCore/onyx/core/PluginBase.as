package onyx.core {

	import flash.events.EventDispatcher;
	
	import onyx.controls.Control;
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	
	use namespace onyx_ns;

	public class PluginBase extends EventDispatcher implements IControlObject {
		
		onyx_ns var _name:String;
		
		/**
		 * 	@private
		 */
		private var _controls:Controls;
		
		/**
		 * 	@constructor
		 */
		public function PluginBase():void {
			_controls = new Controls(this);
		}
		
		final public function get controls():Controls {
			return _controls;
		}
		
		public function dispose():void {
			_controls.dispose();
			_controls = null;
		}
		
	}
}