package onyx.events {
	
	import flash.events.Event;
	
	import onyx.content.IContent;

	public final class ContentEvent extends Event {
		
		public static const CONTENT_STATUS:String	= Event.COMPLETE;

		public var content:Object;
		public var errorMessage:String;
		
		public function ContentEvent(type:String):void {
			super(type);
		}
		
	}
}