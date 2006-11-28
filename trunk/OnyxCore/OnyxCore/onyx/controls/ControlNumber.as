package onyx.controls {
	
	import onyx.controls.Control;
	
	public class ControlNumber extends Control {
		
		private var min:Number;
		private var max:Number;
		private var defaultvalue:Number;
		
		public function ControlNumber(name:String, display:String, min:Number, max:Number, defaultvalue:Number):void {
			
			super(name, display);
			
			this.min = min;
			this.max = max;
			this.defaultvalue = defaultvalue;
		}
		
		override public function get value():* {
			return Number(target[property]);
		}
		
		override public function set value(v:*):void {
			super.value = Math.min(Math.max(v, min), max) as Number;
		}
		
		override public function reset():void {
			super.value = defaultvalue;
		}

	}
}