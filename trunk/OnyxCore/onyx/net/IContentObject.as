package onyx.net {
	
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import onyx.content.IContent;
	import onyx.core.IDisposable;
	
	public interface IContentObject extends IDisposable {
		
		function initialize(stage:Stage, content:IContent):void
		function render(source:BitmapData, matrix:Matrix, clipRect:Rectangle):void;
		
	}
}