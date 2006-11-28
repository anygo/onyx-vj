package filters {
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import onyx.core.getBaseBitmap;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;
	
	public final class EchoFilter extends Filter implements IBitmapFilter {
		
		private var _bmp:BitmapData = getBaseBitmap();
		
		public function EchoFilter():void {
			super('Echo Filter');
		}
		
		override public function initialize():void {
			var source:BitmapData = content.source;
			_bmp.copyPixels(source, source.rect, new Point(0,0));
		}
		
		public function applyFilter(bitmapData:BitmapData, bounds:Rectangle):BitmapData {
			
			var transform:ColorTransform = new ColorTransform();
			transform.alphaMultiplier = .09;
			
			_bmp.draw(bitmapData, null, transform);
			
			bitmapData.copyPixels(_bmp, bitmapData.rect, new Point(bounds.x,bounds.y));
			
			return _bmp;
		}
		
		override public function clone():Filter {
			return new EchoFilter();
		}
		
		override public function dispose():void {
			_bmp.dispose();
			super.dispose();
		}
	}
}