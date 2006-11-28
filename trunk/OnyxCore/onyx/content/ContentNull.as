package onyx.content {

	import flash.display.BitmapData;
	
	import onyx.filter.Filter;
	import onyx.layer.IColorObject;
	import onyx.layer.IContent;
	import flash.geom.Rectangle;
	import onyx.layer.Layer;
	import flash.display.Sprite;

	[ExcludeClass]
	public final class ContentNull implements IContent, IColorObject
	{
		
		private var _layer:Layer;
		private var _loader:Sprite;
		
		include 'ContentShared.as'
		
		public function get totalTime():Number
		{
			return 0;
		}
		
		public function set timePercent(value:Number):void {
		}
		
		public function get timePercent():Number
		{
			return 0;
		}
		
		public function get time():Number
		{
			return 0;
		}
		
		public function set time(value:Number):void
		{
		}
		
		public function get framerate():Number
		{
			return 0;
		}
		
		public function set framerate(value:Number):void
		{
		}
		
		public function get framernd():Number
		{
			return 0;
		}
		
		public function set framernd(value:Number):void
		{
		}
		public function get markerRight():Number
		{
			return 0;
		}
		
		public function set markerRight(value:Number):void
		{
		}
		
		public function pause(b:Boolean=true):void
		{
		}
		
		public function get path():String
		{
			return null;
		}
		
		public function set markerLeft(value:Number):void
		{
		}
		
		public function get markerLeft():Number
		{
			return 0;
		}
		
		public function dispose():void
		{
		}
		public function get blendMode():String
		{
			return null;
		}
		
		public function set blendMode(value:String):void
		{
		}
		
	}
}