package onyx.filter {
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	import onyx.core.onyx_internal;
	import onyx.events.FilterEvent;
	import onyx.layer.IColorObject;
	import onyx.layer.IContent;
	import onyx.controls.Controls;
	
	use namespace onyx_internal;
	
	/**
	 * 	The base Filter class
	 */
	public class Filter extends EventDispatcher {

		// this sets the name of the filter
		private var _name:String;
		
		// stores the layer
		protected var content:IContent;
		
		// create controls
		protected var _controls:Controls	= new Controls(this);
		
		// constructor
		final public function Filter(name:String):void {
			_name = name;
		}
		
		final public function get name():String {
			return _name;
		}
		
		// gets the current position of the filter within the layer
		final public function get index():int {
			return content.getFilterIndex(this);
		}

		// called by layer when a filter is added to it
		onyx_internal function setContent(content:IContent):void {
			this.content = content;
		}
		
		final public function get controls():Controls {
			return _controls;
		}
		
		public function initialize():void {
		}
		
		public function clone():Filter {
			return null;
		}
		
		final public function moveUp():void {
//			var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_MOVE_UP, this)
//			dispatchEvent(event);

			content.moveFilterUp(this);
//			content.moveFilter(this, true);
		}
		
		final public function moveDown():void {
//			var event:FilterEvent = new FilterEvent(FilterEvent.FILTER_MOVE_DOWN, this)
//			dispatchEvent(event);
			// content.moveFilter(this, false);
			content.moveFilterDown(this);
		}
		
		public function dispose():void {
			_controls.dispose();
			_controls = null;
		}
	}
}