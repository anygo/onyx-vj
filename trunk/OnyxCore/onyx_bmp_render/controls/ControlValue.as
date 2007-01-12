package onyx.controls {
	
	[ExcludeClass]
	
	/**
	 * 	This class is a proxy, and is only used when loading xml
	 */
	public final class ControlValue extends Control {
		
		private var _value:*;
		
		public function ControlValue(property:String, value:*):void {
			_value = value;
			super(property);
		}
		
		override public function get value():* {
			return _value;
		}
		
	}
}