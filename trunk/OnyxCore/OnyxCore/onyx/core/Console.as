package onyx.core {
	
	import flash.events.EventDispatcher;
	
	import onyx.display.Display;
	import onyx.events.ConsoleEvent;

	public final class Console extends StaticDispatcher {
		
		public static const MESSAGE_NONE:int	= 0;
		public static const MESSAGE_SYSTEM:int	= 1;
		
		public static const addEventListener:Function = StaticDispatcher.addEventListener;
		public static const removeEventListener:Function = StaticDispatcher.removeEventListener;
		public static const hasEventListener:Function = StaticDispatcher.hasEventListener;
		
		public static function trace(message:String, type:int = 0):void {
			
			dispatcher.dispatchEvent(
				new ConsoleEvent(message, type)
			);
		}
		
		public static function executeCommand(command:String):void {
			
			var command:String = command.toLowerCase();
			
			var commands:Array = command.split(' ');
			
			if (commands.length) {
				var firstcommand:String = commands.shift();
				
				if (Command[firstcommand]) {
					var fn:Function = Command[firstcommand];
					
					try {
						var message:String = fn.apply(null, commands);
						trace(message);
					} catch (e:Error) {
						trace(e.message);
					}
						
					
				}
			}
		}
		
		public function Console():void {
			throw ErrorDescription.INVALID_CLASS_CREATION;
		}

	}
}