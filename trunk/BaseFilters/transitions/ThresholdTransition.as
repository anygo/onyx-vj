package transitions {

	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	import onyx.core.BLEND_MODES;
	import onyx.transition.Transition;
	import flash.geom.ColorTransform;

	public final class ThresholdTransition extends Transition {
		
		public function ThresholdTransition(duration:int = 2000):void {
			super('Go Crazy', duration);
		}
		
		override public function applyTransition(current:BitmapData, newContent:BitmapData, time:Number):void {
			
			var transform:ColorTransform = new ColorTransform();
			transform.alphaMultiplier = time;
			
			current.draw(newContent, null, transform, BLEND_MODES[int(Math.random() * BLEND_MODES.length)]);
		}
	}
}