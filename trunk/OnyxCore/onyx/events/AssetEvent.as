package onyx.events {
	
	import flash.events.Event;
	
	import onyx.core.onyx_internal;
	
	use namespace onyx_internal;

	public final class AssetEvent extends Event {
		
		public static const COMPLETE:String = Event.COMPLETE;
		
		public var classes:Array;
		public var path:String;
		
		public function AssetEvent(path:String, classes:Array):void {
			
			this.path = path;
			this.classes = classes;
			
			super(Event.COMPLETE);
		}
		
	}
}