package onyx.tween {
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * 		Custom Tween Class
	 */
	public final class Tween extends EventDispatcher {
		
		private var _target:Object;
		private var _property:String;
		private var _fn:Function;
		private var _timer:Timer;
		private var _start:Number;
		private var _end:Number;
		private var _startTime:int;
		private var _ms:int;
		
		public function Tween(target:Object, property:String, fn:Function, start:Number, end:Number, ms:Number):void {
			
			_target = target;
			_property = property;
			_fn = fn;
			_start = start;
			_end = end;
			_ms = ms;
			
			target[property] = start;
			
			_timer = new Timer(15);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
			_startTime = getTimer();
		}
		
		private function _onTimer(event:TimerEvent):void {
			var curTime:int = getTimer() - _startTime;
			
			var args:Array = [Math.min(curTime, _ms), 0, _end - _start, _ms];
			var value:Number = _fn.apply(null, args) + _start;
			
			_target[_property] = value;
			
			if (curTime >= _ms) {
				dispose();
			}
		}
		
		public function stop():void {
		}
		
		private function dispose():void {
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			_timer = null;
			
			_start = NaN;
			_end = NaN;
			_target = null;
			_property = null;
		}
	}
}