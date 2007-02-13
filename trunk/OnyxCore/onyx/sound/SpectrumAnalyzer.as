package onyx.sound {
	
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	import onyx.core.IDisposable;
	import onyx.core.Onyx;
	import onyx.core.PluginBase;
	import onyx.core.onyx_ns;
	import onyx.plugin.Plugin;
	
	use namespace onyx_ns;
	
	/**
	 * 	Plugin
	 */
	public class SpectrumAnalyzer extends PluginBase implements IControlObject {
		
		/**
		 * 	@private
		 */
		private static function _init():void {
			for (var count:int = 0; count < 127; count++) {
				BASE_ANALYSIS[count] = 0;
			}
		}
		
		_init();
		
		/**
		 * 	@private
		 */
		private static const BASE_ANALYSIS:Array	= new Array(127);
		
		/**
		 * 
		 */
		public static var useFFT:Boolean			= false;
		
		/**
		 * 	@private
		 */
		private static var _bytes:ByteArray;
		
		
		/**
		 * 	@private
		 */
		private static var _dict:Dictionary = new Dictionary(true);
		
		/**
		 * 	Stores the spectrum analysis
		 */
		onyx_ns static var spectrum:SpectrumAnalysis;

		/**
		 * 	Registers an object to be analyzed
		 */
		public static function register(obj:Object):void {
			Onyx.root.addEventListener(Event.ENTER_FRAME, _analyze, false, 10000);
			_dict[obj] = obj;
			
			_bytes = new ByteArray();
		}
		
		/**
		 * 	@private
		 * 	Does actual changing of bytearray to array
		 */
		private static function _analyze(event:Event):void {
			
			var analysis:SpectrumAnalysis = new SpectrumAnalysis();
			analysis.fft = useFFT;
			
			SoundMixer.computeSpectrum(_bytes, useFFT);
			
			var i:Number	= 128;
			var array:Array = BASE_ANALYSIS.concat();
			
			while ( --i > -1 ) {
				
				// move the pointer
				_bytes.position = i * 8;
				
				// get amplitude value
				array[i % 127] += (_bytes.readFloat() / 2);
				
			}
			
			analysis.analysis = array;
			spectrum = analysis;
		}
		
		/**
		 * 	Unregisters
		 */
		public static function unregister(obj:Object):void {
			delete _dict[obj];
			
			for each (var i:Object in _dict) {
				return;
			}
			
			Onyx.root.removeEventListener(Event.ENTER_FRAME, _analyze);
			spectrum = null;
		}
		
	}
}