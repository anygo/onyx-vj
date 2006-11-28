package onyx.layer {
	
	import flash.events.EventDispatcher;
	
	import onyx.controls.Controls;
	import onyx.core.onyx_internal;
	import onyx.filter.Filter;
	
	use namespace onyx_internal;

	public class LayerSettings extends EventDispatcher {

		public var x:Number;
		public var y:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var rotation:Number;

		public var alpha:Number;
		public var brightness:Number;
		public var contrast:Number;
		public var saturation:Number;
		public var hue:Number;
		public var tint:Number;
		public var color:uint;
		public var threshold:Number;
		public var blendMode:String;
		
		public var timePercent:Number;
		public var framerate:Number;
		public var framernd:Number;

		public var filters:Array;
		public var markerLeft:Number;
		public var markerRight:Number;
		
		public function LayerSettings(layer:Layer = null):void {
			
			if (layer) {
				
				x			= layer.x;
				y			= layer.y;
				scaleX		= layer.scaleX;
				scaleY		= layer.scaleY;
				rotation	= layer.rotation;
				
				alpha		= layer.alpha;
				brightness	= layer.brightness;
				contrast	= layer.contrast;
				saturation	= layer.saturation;
				color		= layer.color;
				tint		= layer.tint;
				threshold	= layer.threshold;
				blendMode	= layer.blendMode;
				
				timePercent	= layer.timePercent;
				framerate	= layer.framerate;
				framernd	= layer.framernd;

				markerLeft	= layer.markerLeft;
				markerRight	= layer.markerRight;
				
				filters		= layer.filters.concat();
				
			}

		}
		
		public function loadFromXML(xml:XML):void {
		}
		
		public function apply(layer:Layer):void {
			
			layer.x = x;
			layer.y = y;
			layer.scaleX = scaleX;
			layer.scaleY = scaleY;
			layer.rotation = rotation;
			
			layer.alpha = alpha;
			layer.brightness = brightness;
			layer.contrast = contrast;
			layer.saturation = saturation;
			layer.color = color;
			layer.tint = tint;
			layer.threshold = threshold;
			layer.blendMode = blendMode;
			
			layer.timePercent = timePercent;
			layer.framerate = layer.framerate;
			layer.framernd = layer.framernd;
			layer.markerLeft = layer.markerLeft;
			layer.markerRight = layer.markerRight;
			
			for each (var filter:Filter in filters) {
				layer.addFilter(filter.clone());
			}
		}
	}
}