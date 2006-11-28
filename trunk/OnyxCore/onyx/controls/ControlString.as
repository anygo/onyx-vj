package onyx.controls{
	
	public class ControlString extends Control {
		
		public function ControlString(name:String, display:String):void {
			
			super(name, display);
		}
		
		override public function get value():* {
			return String(target[property]);
		}
		
		override public function set value(v:*):void {
			super.value = v as String;
		}

	}
}