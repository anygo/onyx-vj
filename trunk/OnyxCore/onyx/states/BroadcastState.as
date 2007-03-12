package onyx.states {
	
	import flash.events.Event;
	
	import onyx.core.*;
	import onyx.display.*;
	import onyx.events.RenderEvent;
	import onyx.net.LocalHost;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	 * 	Broadcast
	 */
	public final class BroadcastState extends ApplicationState {
		
		/**
		 * 	Connection
		 */
		private var conn:LocalHost;
		
		/**
		 * 	Initialize
		 */
		override public function initialize(...args):void {
			
			conn = new LocalHost();
			conn.addEventListener(Event.CONNECT, _onClientConnect);
			
			conn.connect();
			
		}
		
		/**
		 * 	@private
		 */
		private function _onClientConnect(event:Event):void {
			var display:Display = Onyx.displays[0];
			display.addEventListener(RenderEvent.RENDER, _onDisplayRender);
		}
		
		/**
		 * 	@private
		 * 	Sends the display bitmap information over to the connected client
		 */
		private function _onDisplayRender(event:Event):void {
			var display:Display = event.currentTarget as Display;
			var bmp:BitmapData	= display.bitmapData;
			var bytes:ByteArray	= bmp.getPixels(bmp.rect);
			
			// conn.send('update', bytes);
		}
		
		override public function terminate():void {
		}
		
	}
}