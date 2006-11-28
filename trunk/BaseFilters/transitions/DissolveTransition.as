package transitions {
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	
	import onyx.transition.Transition;

	public final class DissolveTransition extends Transition {
		
		public function DissolveTransition(duration:int = 2000):void {
			super('Dissolve', duration);
		}
		
		override public function applyTransition(current:BitmapData, newContent:BitmapData, time:Number):void {
			
			var transform:ColorTransform = new ColorTransform();
			transform.alphaMultiplier = time;
			current.draw(newContent, null, transform);
			
		}

	}
}