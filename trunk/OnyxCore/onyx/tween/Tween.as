package onyx.tween {
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import onyx.tween.easing.*;

	/**
	 * 		Custom Tween Class
	 */
	public final class Tween {
		
		protected static var _definition:Dictionary	= new Dictionary(true);
		
		public static function stopTweens(target:Object):void {
			var existing:Array = _definition[target];
			
			if (existing) {
				for each (var tween:Tween in existing) {
					tween.dispose();
				}
				
				_definition[target] = null;
			}
		}
		
		private var _target:Object;
		private var _timer:Timer;
		private var _props:Array;

		private var _start:Number;
		private var _end:Number;
		private var _startTime:int;
		private var _ms:int;
		
		public function Tween(target:Object, ms:int, ... args:Array):void {
			
			// register the tween to the _definitions array
			var existing:Array = _definition[target];
			if (existing) {
				existing.push(this);
			} else {
				_definition[target] = [this];
			}
			
			_target = target;
			_ms = ms;
			_props = args;
			
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
			_startTime = getTimer();
		}
		
		private function _onTimer(event:TimerEvent):void {
			
			var curTime:int = getTimer() - _startTime;
			
			for each (var prop:TweenProperty in _props) {
				var args:Array		= [Math.min(curTime, _ms), 0, prop.end - prop.start, _ms];
				var fn:Function		= prop.easing || Linear.easeIn;
				var value:Number 	= fn.apply(null, args) + prop.start;
			
				_target[prop.property] = value;
			}
			
			if (curTime >= _ms) {
				stop();
			}
		}
		
		public function stop():void {
			var existing:Array = _definition[_target];
			
			if (existing) {
				existing.splice(existing.indexOf(this), 1);
			}
			
			dispose();
		}
		
		private function dispose():void {
			if (_timer) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				_timer = null;
			}

			_props = null;			
			_target = null;
		}
	}
}