package onyx.filter
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public interface IBitmapFilter {
		
		function applyFilter(bitmapData:BitmapData, bounds:Rectangle):BitmapData;
		
	}
}