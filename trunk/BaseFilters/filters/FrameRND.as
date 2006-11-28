package filters {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import onyx.controls.Control;
	import onyx.controls.ControlInt;
	import onyx.controls.Controls;
	import onyx.filter.Filter;

	public final class FrameRND extends Filter {
		
		private var _timer:Timer	= new Timer(1000);
		
		public function FrameRND():void {

			super('Frame Rate');

			_controls.addControl(
				new ControlInt('delay', 'Delay', 1, 50, 5)
			)
		}
		
		override public function initialize():void {
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
		}
		
		public function get delay():int {
			return _timer.delay / 1000;
		}
		
		public function set delay(value:int):void {
			_timer.delay = value * 1000;
		}
		
		private function _onTimer(event:Event):void {
			content.time = Math.random();
			content.framerate = Math.random() * 10 - 5;
		}
		
		override public function clone():Filter {
			var filter:FrameRND = new FrameRND();
			filter.delay = _timer.delay;
			return filter;
		}

		override public function dispose():void {
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			super.dispose();
		}

	}
}