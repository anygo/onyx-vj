package onyx.layer {
	
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	
	import onyx.core.IDisposable;
	import onyx.filter.Filter;
	import flash.geom.Rectangle;
	import onyx.layer.ILayer;
	import flash.display.DisplayObject;
	
	public interface IContent extends IColorObject, IDisposable {
		
		function get time():Number;
		function set time(value:Number):void;

		function get totalTime():Number;

		function get framerate():Number;
		function set framerate(value:Number):void;
		
		function get framernd():Number;
		function set framernd(value:Number):void;
		
		function get markerLeft():Number;
		function set markerLeft(value:Number):void;

		function get markerRight():Number;
		function set markerRight(value:Number):void;
		
		function get path():String;
		
		function get timePercent():Number;
		function get filters():Array;
		
		function get source():BitmapData;
		function get rendered():BitmapData;
		
		function addFilter(filter:Filter):void;
		function removeFilter(filter:Filter):void;

		function draw():BitmapData;
		
		function applyFilters(render:BitmapData):void;
		
		function pause(b:Boolean = true):void;
		function getFilterIndex(filter:Filter):int;
		
		function moveFilterUp(filter:Filter):void;
		function moveFilterDown(filter:Filter):void;

	}
}