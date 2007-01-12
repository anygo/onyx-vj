package onyx.tween {
	
	public final class TweenProperty {
		
		public var property:String;
		public var easing:Function;
		public var start:Number;
		public var end:Number;
		
		public function TweenProperty(property:String, start:Number, end:Number, easing:Function = null):void {
			this.property = property;
			this.start = start;
			this.end = end;
			this.easing = easing;
		}
	}
}