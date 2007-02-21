package onyx.core {
	
	import flash.display.BitmapData;
	
	public interface IRenderObject {
		
		function render(stack:RenderStack):RenderTransform;
		
	}
}