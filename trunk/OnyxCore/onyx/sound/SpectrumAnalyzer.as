package onyx.sound {
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import onyx.events.SpectrumEvent;

	public final class SpectrumAnalyzer extends EventDispatcher {
		
		// this stores our global spectrum analyzer
		private static var _analyzer:SpectrumAnalyzer	= new SpectrumAnalyzer();

		// gets the global analyzer - use this if you want to sync to the main
		public static function getGlobal():SpectrumAnalyzer {
			return _analyzer;
		}
		
		// sample at 11.025 khz
		private var _sampleRate:int						= 2;
		
		// resolution (number of bands to skip when analyzing) -- 1:1 is checking every band ... 8 skips bands
		private var _resolution:int						= 1;
		
		// stores our bytearray
		private var _bytes:ByteArray					= new ByteArray();
		
		// saves the ranges of which spectrums we're going to analyze
		private var _ranges:Array						= [];
		
		// stores our timer for analysis (10 frames per second)
		private var _timer:Timer						= new Timer(40);
		
		// stores the combined channels
		private var _analysis:Array;
		
		/**
		 * 	@constructor
		 **/
		public function SpectrumAnalyzer():void {
			
		}
		
		// adds a spectrum trigger
		public function addTrigger(trigger:SpectrumTrigger):void {
			_ranges.push(trigger);
			
			if (!_timer.running) {
				start();
			}
		}
		
		// removes a spectrum trigger
		public function removeTrigger(trigger:SpectrumTrigger):void {
			
			// if nothing is listening for the analyzing event, stop it
			if (!_ranges.length && !this.hasEventListener(SpectrumEvent.SPECTRUM_ANALYZED)) {
				stop();
			}
		}

		// starts the analyzing
		public function start():void {
//			_timer.addEventListener(TimerEvent.TIMER, _analyzeSpectrum);
//			_timer.start();
		}
		
		// stops the analyzing
		public function stop():void {
		}

		// analyze all our stuff!
		private function _analyzeSpectrum(event:TimerEvent):void {
			
			trace('analyzing');
			
			var start:int = getTimer(), i:int;
			
			// grab our bytes
			SoundMixer.computeSpectrum(_bytes, true, 2);

			_analysis = [];
			
			_bytes.position = 0;

			// loop through the left channel
			for (i = 0; i < 256; i++) {
			 	analysis[i] = _bytes.readFloat();
			}

			// loop through the right channel
//			for (i = 0; i < 256; i++) {
//			 	analysis[i] = Math.max(_bytes.readFloat(), analysis[i]);
//			}
	        
			for each (var trigger:SpectrumTrigger in _ranges) {
				trigger.analyze(analysis);
			}
	        
			// dispatch an event
			var spectrumEvent:SpectrumEvent = new SpectrumEvent(SpectrumEvent.SPECTRUM_ANALYZED);
			spectrumEvent.analysis = analysis;
			
			// dispatch that we've analyzed the bytes
			dispatchEvent(spectrumEvent);
			
			// trace(getTimer() - start);
			
		}
		
		// adds a listener
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);

			if (this.hasEventListener(SpectrumEvent.SPECTRUM_ANALYZED) && !_timer.running) {
				start();
			}
		}

		// returns our bytes
		public function get bytes():ByteArray {
			return _bytes;
		}
		
		// sets the rate
		public function set rate(r:int):void {
			_timer.delay = r;
		}
		
		// gets the rate of the timer (for analysis)
		public function get rate():int {
			return _timer.delay;
		}
		
		// returns the analysis array
		public function get analysis():Array {
			return _analysis;
		}
		
	}
}