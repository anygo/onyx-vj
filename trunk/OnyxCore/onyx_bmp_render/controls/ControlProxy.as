package onyx.controls {
	
	import onyx.core.onyx_ns;
	use namespace onyx_ns;
	
	public final class ControlProxy extends Control {
		
		public var controlY:Control;
		public var controlX:Control;
		
		public function ControlProxy(property:String, displayName:String, controlX:Control, controlY:Control, metadata:Object = null):void {
			
			this.controlY = controlY;
			this.controlX = controlX;
			
			controlY.metadata = metadata;
			controlX.metadata = metadata;
			
			super(property, displayName, metadata);
		}
		
		override public function setValue(v:*):* {
			if (v is Array) {
				controlX.value = v[0];
				controlY.value = v[1];
			}
		}
		
		override public function set value(v:*):void {
			setValue(v);
		}
		
		override public function get value():* {
			return [controlX.value, controlY.value];
		}

		override public function set target(value:IControlObject):void {
			controlY.target = value;
			controlX.target = value;
		}
	}
}