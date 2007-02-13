package onyx.net {
	
	import flash.events.EventDispatcher;

	public final class Host extends EventDispatcher {
		
		private var connection:IConnection;
		
		public function connect(hostname:String, port:int):void {
			if (!connection) {
				connection = new LocalConnection();
				connection.connect('12345');
			}
		}	
	}
}