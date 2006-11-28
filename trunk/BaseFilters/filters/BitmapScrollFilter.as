package filters {
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import onyx.core.getBaseBitmap;
	import onyx.filter.Filter;
	import onyx.filter.IBitmapFilter;
	
	public final class BitmapScrollFilter extends Filter implements IBitmapFilter {
		
//		private var _bmp:BitmapData = getBaseBitmap();
//		private var _sprite:TextField = new TextField();
		
		public function BitmapScrollFilter():void {
			super('Bitmap Scroll Filter');
		}
		
		override public function initialize():void {
		}
		
		public function applyFilter(bitmapData:BitmapData, bounds:Rectangle):BitmapData {
			
			bitmapData.scroll(5,0);
			
			return bitmapData;
		}
		
		override public function clone():Filter {
			return new BitmapScrollFilter();
		}
		
		override public function dispose():void {
			super.dispose();
		}
	}
}