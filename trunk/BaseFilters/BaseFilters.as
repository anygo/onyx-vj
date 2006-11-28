package {
	
	import filters.*;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	import onyx.external.IFilterLoader;
	import onyx.external.ITransitionLoader;
	import onyx.filter.Filter;
	import onyx.filter.Filter;
	
	import transitions.*;
	
	public class BaseFilters extends Sprite implements IFilterLoader, ITransitionLoader {

		public function BaseFilters():void {
			
			Security.allowDomain('www.onyx-vj.com');

		}		
		/**
		 * 	Tells the onyx engine which filter classes to load
		 */
		public function registerFilters():Array {
			return [Blur, NoiseFilter, FrameRND, Repeater, EchoFilter, BitmapScrollFilter];
		}
		
		/**
		 * 
		 */
		public function registerTransitions():Array {
			return [BlurTransition, DissolveTransition, ThresholdTransition];
		}
	}
}
