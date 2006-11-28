package onyx.events {
	
	import flash.events.Event;
	import onyx.filter.Filter;
	import onyx.core.onyx_internal;
	
	use namespace onyx_internal;

	public final class FilterEvent extends Event {
		
		onyx_internal static const FILTER_MOVE_UP:String	= 'fmoveup';
		onyx_internal static const FILTER_MOVE_DOWN:String	= 'fmovedown';
		
		public static const FILTER_CREATED:String 	= 'fcreate';
		public static const FILTER_APPLIED:String	= 'fapply';
		public static const FILTER_REMOVED:String	= 'fremove';
		public static const FILTER_MOVED:String		= 'fmove';
		
		public var definition:Class;
		public var filter:Filter;
		public var index:int;
		
		public function FilterEvent(type:String, filter:Filter):void {
			this.filter = filter;
			super(type);
		}
	}
}