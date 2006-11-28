package filters {
	
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.controls.ControlInt;
	import onyx.controls.Controls;
	import onyx.core.onyx_internal;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;
	
	use namespace onyx_internal;

	public final class Blur extends Filter implements IBitmapFilter {
		
		private var _filter:flash.filters.BlurFilter	= new flash.filters.BlurFilter();
		private var _blur:int;
		private var _quality:int;
		
		public function Blur():void {

			super('Blur');
			
			_controls.addControl(
				new ControlInt('blurX', 'blurX', 0, 42, 2),
				new ControlInt('blurY', 'blurY', 0, 42, 2)
			);
		}
		
		public function applyFilter(bitmapData:BitmapData, bounds:Rectangle):BitmapData {
			bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(0,0), _filter);
			return bitmapData;
		}
		
		public function terminate():void {
			_filter = null;
		}
		
		public function set blurX(x:int):void {
			_filter.blurX = x;
		}
		
		public function get blurX():int {
			return _filter.blurX;
		}
		
		public function set blurY(Y:int):void {
			_filter.blurY = Y;
		}
		
		public function get blurY():int {
			return _filter.blurY;
		}
		
		public function set quality(q:int):void {
			_filter.quality = q + 1;
		}
		
		public function get blur():int {
			return (_filter.blurX + _filter.blurY) / 2;
		}
		
		public function set blur(b:int):void {
			
			_filter.blurX = b;
			_filter.blurY = b;
		}

		public function get quality():int {
			return _filter.quality;
		}
		
		override public function clone():Filter {
			var filter:Blur = new Blur();
			filter.controls.blurX.value = _filter.blurX;
			filter.controls.blurY.value = _filter.blurY;
			
			return filter;
		}
	}
}