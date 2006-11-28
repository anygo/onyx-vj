package onyx.controls {
	
	import onyx.controls.Control;
	
	public final class ControlInt extends Control {
	
		private var min:int;
		private var max:int;
		private var defaultvalue:int;
		
		public function ControlInt(	property:String,
									display:String,
									min:int,
									max:int,
									defaultvalue:int
		):void {
			
			super(property, display);
			
			this.min = min;
			this.max = max;
			this.defaultvalue = defaultvalue;
		}
		
		override public function get value():* {
			return target[property];
		}
		
		override public function set value(v:*):void {
			super.value = Math.min(Math.max(v, min), max) as Number;
		}
		
		override public function reset():void {
			value = defaultvalue;
		}
		
	}
}