package onyx.sound {
	
	import onyx.controls.Controls;
	import onyx.controls.IControlObject;
	import onyx.core.IDisposable;
	import onyx.core.PluginBase;
	import onyx.core.onyx_ns;
	
	use namespace onyx_ns;
	
	/**
	 * 	Plugin that is similar to filter
	 */
	public class SpectrumAnalyzer extends PluginBase implements IControlObject {
		
		/**
		 * 	@private
		 */
		onyx_ns static var _analysis:SpectrumAnalysis;
		
		/**
		 * 	Returns Analysis
		 */
		public static function getAnalysis():SpectrumAnalysis {
			return _analysis;
		}
		
		/**
		 * 	@private
		 * 	Hold controls for the analyzer
		 */
		private var _controls:Controls;
				
		/**
		 * 	@constructor
		 */
		public function SpectrumAnalyzer(...controls:Array):void {
			_controls = new Controls(this);
			_controls.addControl.apply(null, controls);
			
		}
		
		/**
		 * 	Returns the controls related to the analyzer
		 */
		final public function get controls():Controls {
			return _controls;
		}
		
		/**
		 * 	Disposes
		 */
		public function dispose():void {
		}
		
	}
}