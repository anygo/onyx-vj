package onyx.external {
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.net.NetStream;

	public final class Stream extends NetStream {

		public var metadata:Object;
		private var _path:String;

		public function Stream(path:String):void {
			_path = path;
			
			super(Connection.DEFAULT_CONNECTION);

			play(path);
			pause();
		}
		
		public function get path():String {
			return _path;
		}
		
		private function _eventHandler(event:Event):void {
		}
		
		public function onMetaData(info:Object):void {
			metadata = info;
			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}