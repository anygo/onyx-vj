package onyx.plugin {
	
	import flash.display.BitmapData;
	
	import onyx.core.RenderTransform;
	
	public interface IRenderable {
		
		function render(source:BitmapData, transform:RenderTransform = null):void;
		
	}
}