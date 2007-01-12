package onyx.core {
	
	import flash.display.BitmapData;
	
	import onyx.content.IContent;
	
	public interface IRenderable extends IContent {
		
		function render(bitmapData:BitmapData):void;
		
	}
}