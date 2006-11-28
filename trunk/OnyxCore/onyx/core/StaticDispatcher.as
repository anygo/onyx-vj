package onyx.core {
	
	import flash.events.EventDispatcher;

	[ExcludeClass]
	public class StaticDispatcher extends EventDispatcher {
		
		protected static const dispatcher:EventDispatcher = new EventDispatcher();
		
		public static function addEventListener(type:String, fn:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			dispatcher.addEventListener(type, fn, useCapture, priority, useWeakReference);
		}

		public static function removeEventListener(type:String, fn:Function):void {
			dispatcher.removeEventListener(type, fn);
		}

		public static function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}
		
		public function StaticDispatcher():void {
			throw ErrorDescription.INVALID_CLASS_CREATION;
		}
		
	}
}