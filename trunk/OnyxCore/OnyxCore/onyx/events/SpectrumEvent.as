package onyx.events {
	
	import flash.events.Event;
	import onyx.sound.SpectrumTrigger;
	import onyx.sound.SpectrumAnalyzer;

	public final class SpectrumEvent extends Event {
		
		public static const SPECTRUM_ANALYZED:String		= 'sdone';
		public static const SPECTRUM_TRIGGER:String		= 'strigger';
		
		public var analysis:Array;
		public var range:SpectrumTrigger;
		
		public function SpectrumEvent(type:String):void {
			
			super(type);
			
		}
		
	}
}