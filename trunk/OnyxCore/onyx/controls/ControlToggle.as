package onyx.controls {
	
	public final class ControlToggle extends Control {
		
		public function ControlToggle(name:String, display:String = null, metadata:Object = null):void {
			super(name, display, metadata);
		}
		
		override public function set value(i:*):void {
			var val:* = (i == 'false') ? false : i;
			super.value = val;
		}
	}
	
}