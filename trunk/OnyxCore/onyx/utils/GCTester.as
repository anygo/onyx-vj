package onyx.utils {
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;

	/**
	 * 	Tests an object for it's garbage collection
	 */
	public final class GCTester extends EventDispatcher {

		/**
		 * 	@private
		 */		
		private var dict:Dictionary = new Dictionary(true);
		
		/**
		 * 	@private
		 */
		private var _timer:Timer = new Timer(150);
		
		/**
		 * 
		 */
		public var lastTrace:String;

		/**
		 * 	@constructor
		 */
		public function GCTester(obj:Object):void {
			
			dict[obj] = 1;
			
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
		}
		
		/**
		 * 	@private
		 */
		private function _onTimer(event:TimerEvent):void {
			for (var i:Object in dict) {
				lastTrace = i.toString();
				return;
			}
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			_timer.stop();
			trace('GC:', lastTrace);
		}
	}
}