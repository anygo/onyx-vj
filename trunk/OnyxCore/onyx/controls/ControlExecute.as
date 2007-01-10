package onyx.controls {
	
	import onyx.core.onyx_ns;
	
	use namespace onyx_ns;
	
	public final class ControlExecute extends Control {
		
		public function ControlExecute(name:String, display:String):void {
			
			super(name, display);
			
		}
		
		override public function get value():* {
			return null;
		}
		
		override public function setValue(i:*):* {
			if (super._target[name] is Function && i is Array) {
				var fn:Function = super._target[name];
				return fn.apply(super._target, i);
			}
			return null;
		}
			
	}
}