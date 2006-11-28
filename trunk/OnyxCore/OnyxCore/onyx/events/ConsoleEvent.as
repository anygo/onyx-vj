package onyx.events
{
	import flash.events.Event;

	public class ConsoleEvent extends Event {

		public static const CONSOLE_TRACE:String = 'trace';
		
		public var message:String
		public var messageType:int;
		
		public function ConsoleEvent(message:String, messageType:int):void {
			
			this.message = message;
			this.messageType = messageType;
			
			super(CONSOLE_TRACE);
			
		}
	}
}