package onyx.events
{
	import flash.events.Event;

	public final class ControlEvent extends Event {
		
		public static const CONTROL_CHANGED:String = 'control_change';
		
		public var value:*;
		
		public function ControlEvent(value:*):void {
			this.value = value;
			super(CONTROL_CHANGED);
		}
		
	}
}