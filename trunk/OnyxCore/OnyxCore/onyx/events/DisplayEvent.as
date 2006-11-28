package onyx.events {
	
	import flash.events.Event;
	
	import onyx.display.Display;

	public final class DisplayEvent extends Event {
		
		public static const DISPLAY_CREATED:String	= 'displaycreate';

		public var display:Display;
		
		public function DisplayEvent(type:String):void {
			super(type);
		}
		
	}
}