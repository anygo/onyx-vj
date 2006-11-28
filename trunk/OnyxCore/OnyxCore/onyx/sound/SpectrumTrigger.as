package onyx.sound {
	
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import onyx.events.SpectrumEvent;

	public final class SpectrumTrigger extends EventDispatcher {
		
		internal var start:int; // 0 - 255
		internal var end:int	// 0 - 255
		
		private var _lowPeak:Number		= 0;
		private var _lowSample:Number	= 0;
		private var _highPeak:Number	= 0;
		private var _highSample:Number	= 0;
		
		public function SpectrumTrigger(start:int, end:int):void {
			
			this.start = start;
			this.end = end;
			
		}
		
		internal function analyze(analysis:Array):void {
			
			var currentTime:int = getTimer();
			var amplitude:Number = 0;

			var itemcount:Number = 1;
			
			for (var count:int = start; count < end; count++) {

				// only count numbers that are greater then 0
				amplitude += analysis[count];
			}
			
			amplitude /= (end - start);

			// these are for hits
			if (amplitude > _highPeak || currentTime - _highSample > 300) {
				
				// before settings, let's check the amount
				if (amplitude - _highPeak > .14)  {
					
					trace('PEAK');

				}
				
				_highPeak = amplitude;
				_highSample = currentTime;
				
			}
			
		}
	}
}