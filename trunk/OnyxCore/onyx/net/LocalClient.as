package onyx.net {
	
	import flash.net.LocalConnection;
	import flash.events.StatusEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public final class LocalClient extends Client {
		
		/**
		 * 	Store bytes
		 */
		public var bytes:ByteArray;
		
		/**
		 * 	@constructor
		 */
		public function LocalClient():void {
		}
		
		/**
		 * 	Connect to Broadcaster
		 */
		public function connect():void {

			// listen for errors
			conn.addEventListener(StatusEvent.STATUS, _onStatus);
			
			// send a registration
			conn.connect(id);
			
			// send a broadcast message to register
			conn.send(BROADCAST, 'register', id);

		}
		
		public function update(bytes:ByteArray):void {
			bytes.uncompress();
			this.bytes = bytes;
		}
		
		/**
		 * 	@private
		 */
		private function _onStatus(event:StatusEvent):void {
		}
	}
}