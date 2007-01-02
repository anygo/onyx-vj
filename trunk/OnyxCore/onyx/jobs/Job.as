package onyx.jobs {
	
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Job extends EventDispatcher {
		
		private var _timer:Timer;
		
		final public function start(delay:int):void {
			_timer = new Timer(delay);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
		}

		private function _onTimer(event:TimerEvent):void {
			
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			_timer.stop();
			
			finished();
		}
		
		
		public function finished():void {
		}
		
		
	}
}