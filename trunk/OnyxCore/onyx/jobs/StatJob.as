package onyx.jobs {
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import onyx.application.Onyx;
	import onyx.core.Console;
	import onyx.core.onyx_internal;
	
	use namespace onyx_internal;
	
	public final class StatJob extends Job {
		
		private var _start:uint = 0;
		private var _frames:uint = 0;
		
		public function StatJob(time:int):void {

			start(time);
			
			Console.output('starting stat job for ' + (time / 1000).toFixed(2) + ' seconds');
			
			Onyx.root.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame(event:Event):void {
			if (!_start) {
				_start = getTimer();
			} else {
				_frames++;
			}
		}
		
		override public function finished():void {
			
			Onyx.root.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			Console.output(
				'end of stat job:<br>' + 
				'average fps: ' + ((1000 / ((getTimer() - _start) / _frames) as Number).toFixed(2))
			);
		}
		
	}
}