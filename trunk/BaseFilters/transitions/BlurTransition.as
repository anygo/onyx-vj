package transitions {
	
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Transform;
	
	import onyx.transition.Transition;
	
	public final class BlurTransition extends Transition {
		
		public function BlurTransition(duration:int = 2000):void {
			super('Blur', duration);
		}
		
		override public function applyTransition(current:BitmapData, newContent:BitmapData, time:Number):void {
			
			var amount:Number = (time > .5) ? 1 - time : time;
			var filter:BlurFilter = new BlurFilter(Math.floor(amount * 40) * 2, Math.floor(amount * 40) * 2);

			if (time > .5) {
				current.copyPixels(newContent, current.rect, new Point(0,0));
			}
			
			current.applyFilter(current, current.rect, new Point(0,0), filter);
		
		}

	}
}