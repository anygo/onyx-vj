package onyx.net {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	import onyx.core.Console;
	import onyx.core.Onyx;
	
	internal class Client extends EventDispatcher {

		/**
		 * 	The LocalConnection string to try to connect on
		 */		
		protected static const BROADCAST:String		 = 'onxbroadcast';

		/**
		 * 	TBD, a better guid generator
		 */
		protected static function generateGUID():String {
			return 'onx' + Math.floor((Math.random() * 9999999)).toString();
		}

		/**
		 * 	@private
		 * 	The Local Connection to use
		 */
		protected var conn:LocalConnection			= new LocalConnection();
		
		/**
		 * 	@private
		 * 	The id of this connection
		 */
		protected var id:String						= generateGUID();
		
		/**
		 * 	@constructor
		 */
		public function Client():void {
			conn.client = this;
		}
		
		/**
		 * 	Disconnects
		 */
		public function disconnect():void {
			conn.close();
		}
		
	}
}