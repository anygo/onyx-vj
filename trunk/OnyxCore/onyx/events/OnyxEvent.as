package onyx.events {
	import flash.events.Event;

	public final class OnyxEvent extends Event {
		
		public static const ONYX_STARTUP_START:String	= 'onyxstartstart';
		public static const ONYX_STARTUP_END:String		= 'onyxstartend';
		public static const ONYX_DISPLAY_CREATED:String	= 'displaycreate';
		public static const ONYX_DISPLAY_REMOVED:String	= 'displayremove';
		
		public function OnyxEvent(type:String):void {
			super(type);
		}
		
	}
}