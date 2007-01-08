package onyx.net {
	
	import flash.display.Stage;
	import flash.display.BitmapData;
	import onyx.content.IContent;
	import onyx.core.IDisposable;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public interface IContentObject extends IDisposable {
		
		function initialize(stage:Stage, content:IContent):void
		function render(source:BitmapData, matrix:Matrix, clipRect:Rectangle):void;
		
	}
}