package onyx.net {
	
	import flash.net.LocalConnection;
	
	import onyx.core.*;
	import flash.events.StatusEvent;
	import flash.events.Event;
	
	public final class LocalHost extends Client {

		/**
		 * 	@private
		 * 	The list of clients connected to this LocalConnection Host
		 */		
		private var _clients:Array = [];
		
		/**
		 * 	@constructor
		 */
		public function LocalHost():void {
		}
		
		/**
		 * 	Connect
		 */
		public function connect():void {

			// listen for errors
			try {
				conn.addEventListener(StatusEvent.STATUS, _onStatus);
				conn.connect(BROADCAST);

				// output to console
				Console.output('BROADCASTER: LISTENING FOR LOCAL CLIENTS');
			} catch (e:Error) {
				// output to console
				Console.output('BROADCASTER ALREADY CONNECTED.');
			}

		}
		
		/**
		 * 
		 */
		public function get clients():Array {
			return _clients;
		}
		
		/**
		 * 	@private
		 */
		private function _onStatus(event:StatusEvent):void {
			// trace(event);
		}
		
		/**
		 * 	Sends a command to all clients
		 */
		public function send(name:String, ... args:Array):void {
			for each (var id:String in _clients) {
				conn.send.apply(conn, [id, name].concat(args)); 
			}
		}
		
		/**
		 * 
		 */
		public function register(id:String):void {
			
			// add the client
			clients.push(id);
			
			// output to console
			Console.output(id, 'CONNECTED.');

			// dispatch a connection event
			dispatchEvent(new Event(Event.CONNECT));
		}

		/**
		 * 	Dispose
		 */
		public function dispose():void {
			_clients = null;
		}
		
	}
}