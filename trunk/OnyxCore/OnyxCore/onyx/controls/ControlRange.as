package onyx.controls {
	
	public final class ControlRange extends Control {
		
		public var data:Array;
		
		private var _defaultvalue:uint;
		
		public function ControlRange(name:String, display:String, data:Array, defaultvalue:uint):void {
			
			this.data = data;
			this._defaultvalue = defaultvalue;
			
			super(name, display);
			
		}
		
		override public function get value():* {
			return target[property];
		}
		
		override public function set value(v:*):void {
			var value:Number = (v is Number) ? v : data.indexOf(v);
			super.value = data[value];
		}
		
		override public function reset():void {
			target[property] = data[_defaultvalue];
		}
		

	}
	
}