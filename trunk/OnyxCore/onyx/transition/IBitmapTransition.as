package onyx.transition {

	import flash.display.BitmapData;
	
	import onyx.core.RenderTransform;
	
	public interface IBitmapTransition {
		
		function render(source:BitmapData, ratio:Number):void;
		
	}
}