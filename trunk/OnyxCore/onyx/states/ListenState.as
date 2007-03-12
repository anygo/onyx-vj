package onyx.states {

	import flash.events.Event;
	
	import onyx.display.Display;
	import onyx.net.LocalClient;
	import flash.display.BitmapData;
	
	/**
	 * 	Broadcast
	 */
	public final class ListenState extends ApplicationState {
		
		/**
		 * 	Connection
		 */
		private var conn:LocalClient;
		
		/**
		 * 
		 */
		private var display:Display;
		
		/**
		 * 	Initialize
		 */
		override public function initialize(...args):void {
			
			conn = new LocalClient();
			conn.connect();
			
			// save the display
			display = args[0];
			display.addEventListener(Event.ENTER_FRAME, _onFrame)
			
		}
		
		private function _onFrame(event:Event):void {
			if (conn.bytes) {
				conn.bytes.position = 0;
				var bmp:BitmapData = display.bitmapData;
				bmp.setPixels(bmp.rect, conn.bytes);
			}
		}
		
		override public function terminate():void {
		}
		
	}
}