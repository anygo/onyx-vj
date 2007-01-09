package onyx.controls {
	
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
		
		override public function get value():* {
			return null;
		}

		override public function set target(value:Object):void {
			controlY.target = value;
			controlX.target = value;
		}
	}
}